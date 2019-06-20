from PyQt5 import QtSql
from openpyxl import Workbook
from openpyxl.drawing import line
from openpyxl.utils import get_column_letter
from openpyxl.styles import Border, Side, PatternFill, Font, GradientFill, Alignment, Font
import datetime

def run():
    print("Plugin para imprimir resumen de presupuesto")
    
def imprimir(conexion, obra, book):
	consulta = QtSql.QSqlQuery("SELECT codigo,resumen,canpres*preciomed AS \"EUROS\" FROM \"" + obra + "_Conceptos\" AS C, \"" + obra + "_Relacion\" AS R WHERE C.codigo = R.codhijo AND R.codpadre = '" + obra + "' ORDER BY R.posicion", conexion)
	print (consulta.lastError().text())
	rec = consulta.record()
	codigo = rec.indexOf("codigo")
	resumen = rec.indexOf("resumen")
	euros = rec.indexOf("EUROS")
	#abro una instancia de hoja de calculo	
	sheet = book.active
	sheet.title = "RESUMEN DE PRESUPUESTO"
	#cabecera	
	sheet.oddHeader.left.size = 12
	sheet.oddHeader.left.font = "Tahoma,Bold"
	sheet.oddHeader.left.color = "CC3366"
	sheet.oddHeader.left.text = "RESUMEN DE PRESUPUESTO"	
	sheet.print_title_cols = 'A:F'
	sheet.print_title_rows = '1:2'
	#pie
	sheet.oddFooter.left.font = "Tahoma,Bold"
	hoy = datetime.date.today()
	sheet.oddFooter.left.text = str(hoy.strftime('%d de %b de %Y'))
	sheet.oddFooter.right.text = "Page &[Page] of &N"	
	#datos para situar filas y columnas
	fila_inicial = 0
	fila_final = 0
	fila = 1	
	offset_izquierdo = 1
	columna = offset_izquierdo
	columna_euros=5
	letra_columna_euros = get_column_letter(columna_euros)
	contador = 0
	cantidad = 0
	#fuentes
	ft_resaltada = Font(name='Arial', size=11, bold=True)
	ft_normal = Font(name='Arial', size=10, bold=False)
	#cabecera
	sheet.cell(column = columna, row = fila, value = "CAPITULO")
	sheet.cell(column = columna, row = fila).font = ft_normal
	sheet.cell(column = columna+1, row = fila, value = "RESUMEN")
	sheet.cell(column = columna+1, row = fila).font = ft_normal
	sheet.cell(column = columna_euros, row = fila, value = "EUROS")
	sheet.cell(column = columna_euros, row = fila).font = ft_normal
	sheet.cell(column = columna_euros+1, row = fila, value = "%")
	sheet.cell(column = columna_euros+1, row = fila).font = ft_normal
	#linea
	for i in range(offset_izquierdo,columna_euros+2):
		sheet.cell(column = i, row = fila).border = Border(bottom=Side(style='thick'))		
	#datos
	fila = fila +1
	while consulta.next():				
		#codigo
		sheet.cell(column = columna, row = fila, value = consulta.value(codigo))
		sheet.cell(column = columna, row = fila).font = ft_normal
		#resumen
		columna =  columna + 1
		sheet.cell(column = columna, row = fila, value = consulta.value(resumen))
		sheet.cell(column = columna, row = fila).font = ft_normal
		#euros
		columna =  columna_euros
		sheet.cell(column = columna, row = fila, value = consulta.value(euros))
		sheet.cell(column = columna, row = fila).font = ft_normal
		sheet.cell(column = columna, row = fila).number_format = '#,##0.00'
		cantidad = cantidad +consulta.value(euros)
				
		if contador == 0:
			fila_inicial = fila		
		if contador == consulta.size()-1:
			fila_final = fila
		
		fila = fila + 1
		contador = contador +1
		columna = offset_izquierdo
	#porcentajes (a la derecha de las cantidades de cada capitulo)
	for i in range(0,consulta.size()):
		sheet.cell(column = columna_euros+1, row = fila_inicial+i, value = (sheet.cell(row=fila_inicial+i, column=columna_euros).value)/cantidad)
		sheet.cell(column = columna_euros+1, row = fila_inicial+i).font = ft_normal
		sheet.cell(column = columna_euros+1, row = fila_inicial+i).number_format = '0.00%'
	#unir celdas entre resumen y precio y rellenar de punteado
	for i in range(0,consulta.size()):
		sheet.merge_cells(start_row=fila_inicial+i, start_column=offset_izquierdo+2, end_row=fila_inicial+i, end_column=columna_euros-1)		
		coordenada_punteado_CAP = get_column_letter(offset_izquierdo+2)+str(fila_inicial+i)#punteado
		sheet[coordenada_punteado_CAP].border = Border(bottom=Side(style='dotted'))#punteado
		
	#antes de seguir ajustamos el ancho
	#anchos
	for column_cells in sheet.columns:
		length = max(len(as_text(cell.value)) for cell in column_cells)
		sheet.column_dimensions[column_cells[0].column].width = length
	#EM
	fila = fila + 1;
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-1)
	coordenada_leyenda_EM = get_column_letter(1)+str(fila)
	celda_leyenda_Ejecucion_Material =sheet[coordenada_leyenda_EM]
	celda_leyenda_Ejecucion_Material.value = "Total Ejecución Material: "
	celda_leyenda_Ejecucion_Material.alignment = Alignment(horizontal="right", vertical="center")
	celda_leyenda_Ejecucion_Material.font = ft_resaltada #negritas	
	coordenadaEM = letra_columna_euros+str(fila)
	cadena_rango = letra_columna_euros+str(fila_inicial)+":"+letra_columna_euros+str(fila_final)	
	sheet[coordenadaEM]="=SUM("+cadena_rango+")"
	sheet[coordenadaEM].font = ft_resaltada #negritas
	sheet[coordenadaEM].border = Border(top=Side(style='thin'))#linea superior 
	sheet[coordenadaEM].number_format = '#,##0.00'
	#GG+BI
	gastos_generales = 13
	beneficio_industrial = 6
	#GG
	fila = fila +1
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-3)
	coordenada_leyenda_GG = get_column_letter(1)+str(fila)
	celda_leyenda_Gastos_Generales =sheet[coordenada_leyenda_GG]
	celda_leyenda_Gastos_Generales.value = str(gastos_generales)+"% Gastos Generales: "
	celda_leyenda_Gastos_Generales.alignment = Alignment(horizontal="right", vertical="center")
	celda_leyenda_Gastos_Generales.font = ft_normal
	coordenadaGG = get_column_letter(columna_euros-1)+str(fila)
	sheet[coordenadaGG]="="+coordenadaEM+"*"+str(gastos_generales)+"/"+str(100)
	sheet[coordenadaGG].font = ft_normal
	sheet[coordenadaGG].number_format = '#,##0.00'
	coordenada_punteado_GG = get_column_letter(columna_euros-2)+str(fila)#punteado
	sheet[coordenada_punteado_GG].border = Border(bottom=Side(style='dotted'))#punteado	
	#BI
	fila = fila +1
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-3)
	coordenada_leyenda_BI = get_column_letter(1)+str(fila)
	celda_leyenda_Beneficio_Industrial =sheet[coordenada_leyenda_BI]
	celda_leyenda_Beneficio_Industrial.value = str(beneficio_industrial)+"% Beneficio Industrial: "
	celda_leyenda_Beneficio_Industrial.alignment = Alignment(horizontal="right", vertical="center")
	celda_leyenda_Beneficio_Industrial.font = ft_normal
	coordenadaBI= get_column_letter(columna_euros-1)+str(fila)
	sheet[coordenadaBI]="="+coordenadaEM+"*"+str(beneficio_industrial)+"/"+str(100)
	sheet[coordenadaBI].font = ft_normal
	sheet[coordenadaBI].number_format = '#,##0.00'
	coordenada_punteado_BI = get_column_letter(columna_euros-2)+str(fila)#punteado
	sheet[coordenada_punteado_BI].border = Border(bottom=Side(style='dotted'))#punteado	
	
	cantidad = cantidad + cantidad*(gastos_generales+beneficio_industrial)/100
	#suma de GG+BI
	fila = fila +1
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-1)
	sheet.cell(column = 1,row = fila, value = "SUMA DE G.G. y B.I.: ")
	sheet.cell(column = 1,row = fila).alignment = Alignment(horizontal="right", vertical="center")
	sheet.cell(column = 1,row = fila).font = ft_normal
	sheet.cell(column = 1,row = fila).number_format = '#,##0.00'
	coordenadaGGMASBI= get_column_letter(columna_euros)+str(fila)
	sheet[coordenadaGGMASBI]="="+coordenadaGG+"+"+coordenadaBI
	sheet[coordenadaGGMASBI].border = Border(top=Side(style='thin'))#linea superior 
	sheet[coordenadaGGMASBI].font = ft_normal
	sheet[coordenadaGGMASBI].number_format = '#,##0.00'
	#presupuesto de contrata
	fila = fila +1
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-1)
	coordenada_leyenda_PC = get_column_letter(1)+str(fila)
	celda_leyenda_Presupuesto_Contrata =sheet[coordenada_leyenda_PC]
	celda_leyenda_Presupuesto_Contrata.value = "TOTAL PRESUPUESTO DE CONTRATA"
	celda_leyenda_Presupuesto_Contrata.alignment = Alignment(horizontal="right", vertical="center")
	celda_leyenda_Presupuesto_Contrata.font = ft_resaltada
	coordenadaPC= get_column_letter(columna_euros)+str(fila)
	sheet[coordenadaPC]="="+coordenadaEM+"+"+coordenadaGGMASBI
	sheet[coordenadaPC].border = Border(top=Side(style='thin'))#linea superior 
	sheet[coordenadaPC].font = ft_resaltada #negritas
	sheet[coordenadaPC].number_format = '#,##0.00'
	#iva
	IVA =21
	fila = fila +1
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-3)
	coordenada_leyenda_IVA = get_column_letter(1)+str(fila)
	celda_leyenda_IVA =sheet[coordenada_leyenda_IVA]
	celda_leyenda_IVA.value = str(IVA) + "% IVA"
	celda_leyenda_IVA.alignment = Alignment(horizontal="right", vertical="center")
	celda_leyenda_IVA.font = ft_normal
	coordenadaIVA= get_column_letter(columna_euros-1)+str(fila)
	sheet[coordenadaIVA]="="+coordenadaPC+"*"+str(IVA)+"/"+str(100)
	sheet[coordenadaIVA].font = ft_normal
	sheet[coordenadaIVA].number_format = '#,##0.00'
	coordenada_punteado_IVA = get_column_letter(columna_euros-2)+str(fila)#punteado
	sheet[coordenada_punteado_IVA].border = Border(bottom=Side(style='dotted'))#punteado	
	
	cantidad = cantidad + cantidad*IVA/100
	#total presupuesto
	fila = fila +1
	sheet.merge_cells(start_row=fila, start_column=offset_izquierdo, end_row=fila, end_column=columna_euros-1)
	coordenada_leyenda_TP = get_column_letter(1)+str(fila)
	celda_leyenda__Total_Presupuesto =sheet[coordenada_leyenda_TP]
	celda_leyenda__Total_Presupuesto.value = "TOTAL PRESUPUESTO GENERAL"
	celda_leyenda__Total_Presupuesto.alignment = Alignment(horizontal="right", vertical="center")
	celda_leyenda__Total_Presupuesto.font = ft_resaltada
	coordenadaTP= get_column_letter(columna_euros)+str(fila)
	sheet[coordenadaTP]="="+coordenadaPC+"+"+coordenadaIVA
	sheet[coordenadaTP].border = Border(top=Side(style='thin'))#linea superior
	sheet[coordenadaTP].font = ft_resaltada #negritas
	sheet[coordenadaTP].number_format = '#,##0.00'
	#linea texto con cantidad final
	print ("cantidad "+ str(cantidad))
	consulta.exec_("SELECT fx_letras("+str(cantidad)+")")
	print (consulta.lastError().text())
	cantidadenletra=""
	while consulta.next():
		cantidadenletra = consulta.value(0)
	print ("cantidad en letras "+cantidadenletra)
	fila = fila +1
	sheet.cell(column = 1,row = fila, value = "Asciende el presupuesto general a la expresada cantidad de " + str(cantidadenletra) + " EUROS")	
	sheet.cell(column = 1,row = fila).font = ft_normal
				
	book.save('appending.xlsx')
	
def as_text(value):
    if value is None:
        return ""
    return str(value)
	
	
