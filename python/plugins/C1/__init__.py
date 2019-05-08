from PyQt5 import QtSql
from openpyxl import Workbook
from openpyxl.drawing import line
import datetime

def run():
    print("Plugin para imprimir precios auxiliares de mano de obra, materiales y maquinaria")
    
def imprimir(conexion, obra, datosconfiguracionpagina):
	print ("Imprimir " + obra)
	consulta = QtSql.QSqlQuery("SELECT * FROM \"" + obra + "_Conceptos\" WHERE naturaleza = 2", conexion)
	print (consulta.lastError().text())
	print (datosconfiguracionpagina)
	rec = consulta.record()
	codigo = rec.indexOf("codigo")
	resumen = rec.indexOf("resumen")
	descripcion = rec.indexOf("descripcion")
	ud = rec.indexOf("ud");
	fecha = rec.indexOf("fecha")
	preciomed = rec.indexOf("preciomed");
	#abro una instancia de hoja de calculo	
	book = Workbook()
	sheet = book.active
	sheet.title = "Listado de Auxiliares"
	sheet.sheet_properties.tabColor = "ff0000"
	#cabecera
	sheet.print_title_cols = 'A:B' # the first two cols
	sheet.print_title_rows = '1:1' # the first row	
	sheet.oddHeader.left.size = 12
	sheet.oddHeader.left.font = "Tahoma,Bold"
	sheet.oddHeader.left.color = "CC3366"
	sheet.oddHeader.left.text = "Listado de Auxiliares"	
	#pie
	sheet.oddFooter.left.font = "Tahoma,Bold"
	hoy = datetime.date.today()
	sheet.oddFooter.left.text = str(hoy.strftime('%d de %b de %Y'))
	sheet.oddFooter.right.text = "Page &[Page] of &N"
	#e inserto datos
	fila = 1
	columna = 1
	print (consulta.size())	
	while consulta.next():
		#print (consulta.value(codigo)+" - "+consulta.value(ud)+" - " +consulta.value(resumen)+" - "+consulta.value(descripcion)+" - "+ str(consulta.value(preciomed)))
		'''for i in range (1,rec.count()-4):
			sheet.cell(column = i, row = fila, value = consulta.value(i-1))'''
		#codigo
		sheet.cell(column = columna, row = fila, value = consulta.value(codigo))
		columna =  columna + 1
		sheet.cell(column = columna, row = fila, value = consulta.value(ud))
		columna =  columna + 1
		sheet.cell(column = columna, row = fila, value = consulta.value(resumen))
		columna =  columna + 1
		sheet.cell(column = columna, row = fila, value = consulta.value(descripcion))
		columna =  columna + 1
		sheet.cell(column = columna, row = fila, value = consulta.value(preciomed))
		columna =  columna + 1
		#sheet.cell(column = columna, row = fila, value = str(consulta.value(fecha)))
		columna = 1
		fila = fila +1
			
	book.save('appending.xlsx')
