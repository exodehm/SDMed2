from PyQt5 import QtSql
from openpyxl import Workbook

def run():
    print("Plugin para imprimir precios auxiliares de mano de obra, materiales y maquinaria")
    
def imprimir(conexion, obra):
	print ("Imprimir " + obra)
	consulta = QtSql.QSqlQuery("SELECT * FROM \"" + obra + "_Conceptos\" WHERE naturaleza = 1 OR naturaleza = 2 OR naturaleza = 3", conexion)
	print (consulta.lastError().text())
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
	sheet.oddHeader.left.text = "Page &[Page] of &N"
	sheet.oddHeader.left.size = 10
	sheet.oddHeader.left.font = "Tahoma,Bold"
	sheet.oddHeader.left.color = "CC3366"
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
