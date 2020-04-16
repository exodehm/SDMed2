from PyQt5 import QtSql
from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties, TabStop, TabStops
from odf.text import P,H,Span,LineBreak, PageNumber, SoftPageBreak
from odf import teletype
import locale
from datetime import datetime

from cargador import formatear

import importlib
from pathlib import Path
mod_path = Path(__file__).parent
MODULE_PATH = str(mod_path) + "/estilos.py"
MODULE_NAME = "Estilo"
import sys
spec = importlib.util.spec_from_file_location(MODULE_NAME, MODULE_PATH)
modulo = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = modulo 
spec.loader.exec_module(modulo)

def imprimir(conexion, obra, documento):
	consulta_conceptos = QtSql.QSqlQuery (conexion)
	consulta_mediciones = QtSql.QSqlQuery (conexion)
	#documento y estilos
	Instancia = modulo.Estilo()	
	s = documento.styles
	d = Instancia.ListaEstilos()
	for key in d:
		s.addElement(d[key])
	precision = "%.2f"
	Autor = ""
	Obra = ""
	Listado = u"PRESUPUESTOS Y MEDICIONES"
	cadena_consulta_texto = "WITH RECURSIVE tree AS(SELECT codpadre, codhijo, canpres, cancert, 1 AS depth, cast(posicion as text) AS camino, posicion FROM \"" + obra + "_Relacion\" \
		WHERE codpadre is NULL \
		UNION ALL \
		SELECT rel.codpadre, rel.codhijo, rel.canpres, rel.cancert, depth+1, concat(camino,'.',cast(rel.posicion as text)) , rel.posicion \
		FROM \"" + obra + "_Relacion\" rel \
		JOIN tree t ON rel.codpadre = t.codhijo) \
		SELECT C.codigo, C.naturaleza, C.ud, C.resumen, C.descripcion, tree.canpres,tree.cancert, C.preciocert/1 AS \"Porcentaje\", C.preciomed, C.preciocert, \
		C.preciomed*tree.canpres as \"Importe presupuesto\", C.preciocert*tree.cancert as \"Importe certifi.\", tree.depth, tree.camino \
		FROM tree, \"" + obra + "_Conceptos\" AS C \
		WHERE C.codigo=tree.codhijo \
		ORDER BY string_to_array(camino, '.')::int[]"
	contador_linea_total = 0 #se usa para empezar a poner las lineas de total de capitulos. Se pondran cuando hayan pasado dos capitulos.
	linea_total = ""
	tipo_partida_anterior = 0
	contador_capitulos = 0 #usado para descartar la primera partida que es el nodo 0 de la obra
	capitulo_anterior = ""
	resumen_anterior = ""
	precio_anterior = ""
	linea_cabecera_medicion = U"Comentario\tUd.\tLong.\tAnch.\tAlt.\tParc.\tCant.\tPrec.\tImpor."
	consulta_conceptos.exec(cadena_consulta_texto)
	while (consulta_conceptos.next()):
		if consulta_conceptos.value(1) == 6:
			if tipo_partida_anterior == 6 and contador_capitulos > 1:
				#un espacio
				salto = P()
				lb = LineBreak()
				salto.addElement(lb)
				documento.text.addElement(salto)
				#linea de total
				lineatotal = "TOTAL CAPÍTULO " + capitulo_anterior + " " + resumen_anterior + "\t" + precio_anterior
				print (lineatotal)
				parrafo = P(stylename = Instancia.Estilos("Tabuladores Linea Total Capitulo"))
				teletype.addTextToElement(parrafo, lineatotal)
				documento.text.addElement(parrafo)
				#salto de pagina
				linea = ""
				saltopagina = P(stylename = Instancia.Estilos("Salto de Pagina"))				
				teletype.addTextToElement(saltopagina, linea)
				documento.text.addElement(saltopagina)
				
			tipo_partida_anterior = consulta_conceptos.value(1)
			capitulo_anterior = consulta_conceptos.value(0)
			resumen_anterior = consulta_conceptos.value(3)
			precio_anterior = formatear(consulta_conceptos.value(8))
			contador_capitulos = contador_capitulos + 1			
			capitulo = consulta_conceptos.value(0)
		
		if consulta_conceptos.value(1) == 6 and contador_capitulos > 1:			
			linea = "CAPÍTULO " + consulta_conceptos.value(0) + " " +consulta_conceptos.value(3)
			parrafo = P(stylename = Instancia.Estilos("Capitulo"))
			teletype.addTextToElement(parrafo, linea)
			documento.text.addElement(parrafo)
			linea = consulta_conceptos.value(4)
			
		if consulta_conceptos.value(1) == 7: #PARTIDAS
			linea = consulta_conceptos.value(0) + "\t" + consulta_conceptos.value(2) + " " + consulta_conceptos.value(3)
			parrafo = P(stylename = Instancia.Estilos("Negritas"))
			teletype.addTextToElement(parrafo, linea)
			documento.text.addElement(parrafo)
			linea = consulta_conceptos.value(4)
			parrafo = P(stylename = Instancia.Estilos("Texto"))
			teletype.addTextToElement(parrafo, linea)
			documento.text.addElement(parrafo)
			linea = consulta_conceptos.value(4)
			#ahora las mediciones
			#primero un salto
			salto = P()
			lb = LineBreak()
			salto.addElement(lb)
			documento.text.addElement(salto)
			cadena_consulta_mediciones = "SELECT * FROM ver_medcert('" + obra + "','" + capitulo + "','" + consulta_conceptos.value(0) +"')"
			consulta_mediciones.exec(cadena_consulta_mediciones)
			subtotal = 0
			parrafomediciones = P(stylename = Instancia.Estilos("Tabuladores Hoja Listados Negritas"))
			teletype.addTextToElement(parrafomediciones, linea_cabecera_medicion)
			documento.text.addElement(parrafomediciones)
			while (consulta_mediciones.next()):
				linea_medicion = consulta_mediciones.value(1)+ "\t"+ formatear(consulta_mediciones.value(2),1)+ "\t" + \
								formatear(consulta_mediciones.value(3)) + "\t"+ formatear(consulta_mediciones.value(4))+ "\t" + \
								formatear(consulta_mediciones.value(5)) + "\t"+ formatear(consulta_mediciones.value(7))
				parrafomediciones = P(stylename = Instancia.Estilos("Tabuladores Lineas Medicion"))
				teletype.addTextToElement(parrafomediciones, linea_medicion)
				documento.text.addElement(parrafomediciones)
				subtotal = subtotal + consulta_mediciones.value(7)
			#linea de sumatoria
			lineasumatoria = " "
			parrafo = P(stylename = Instancia.Estilos("Linea horizontal sumatoria"))
			teletype.addTextToElement(parrafo, lineasumatoria)
			documento.text.addElement(parrafo)
			#cantidad sumatoria
			sumatoria = "\t\t\t\t\t\t" + formatear(consulta_conceptos.value(5))+ "\t" + formatear(consulta_conceptos.value(8)) + "\t" + formatear(consulta_conceptos.value(10))
			parrafo = P(stylename = Instancia.Estilos("Tabuladores Lineas Medicion"))
			teletype.addTextToElement(parrafo, sumatoria)
			documento.text.addElement(parrafo)
	#ultimo subtotal
	lineatotal = "TOTAL CAPÍTULO " + capitulo_anterior + " " + resumen_anterior + "\t" + precio_anterior
	print (lineatotal)
	parrafo = P(stylename = Instancia.Estilos("Tabuladores Linea Total Capitulo"))
	teletype.addTextToElement(parrafo, lineatotal)
	documento.text.addElement(parrafo)	
	
	return documento


if __name__ == "__main__":
	datos = ["sdmed", "localhost","5432","sdmed","sdmed","CENZANO","/home/david/.sdmed/python/plugins/C1/",""]	
	db = QtSql.QSqlDatabase('QPSQL')
	db.setDatabaseName(datos[0])
	db.setHostName(datos[1])
	db.setPort(int(datos[2]))
	db.setUserName(datos[3])
	db.setPassword(datos[4])
	obra = datos[5]
	location = datos[6]
	nombreficheroguardar = datos[7]
	if db.open():	
		imprimir(db,obra)#*datos
