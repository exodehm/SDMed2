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
	preciomed = rec.indexOf("preciomed");
	#abro una instancia de hoja de calculo	
	book = Workbook()
	sheet = book.active
	sheet.title = "Listado de Auxiliares"
	sheet.sheet_properties.tabColor = "ff0000"
	sheet.oddHeader.left.text = "Page &[Page] of &N"
	sheet.oddHeader.left.size = 14
	sheet.oddHeader.left.font = "Tahoma,Bold"
	sheet.oddHeader.left.color = "CC3366"
	#e inserto datos
	fila = 1
	print (consulta.size())	
	while consulta.next():
		print (consulta.value(codigo)+" - "+consulta.value(ud)+" - " +consulta.value(resumen)+" - "+consulta.value(descripcion)+" - "+ str(consulta.value(preciomed)))
		for i in range (1,rec.count()-4):
			sheet.cell(column = i, row = fila, value = consulta.value(i-1))
		fila = fila +1
	'''for row in range(1, consulta.size()+1):
		for col in range(1, rec.count()+1):
			--sheet.cell(column=col, row=row, value="kkBl")
			sheet.cell(column=col, row=row, value= consulta.value(col))
		consulta.next()'''
	
	book.save('appending.xlsx')
