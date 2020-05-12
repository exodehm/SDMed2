from PyQt5 import QtSql
from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties, TabStop, TabStops
from odf.text import P,H,Span,LineBreak, PageNumber
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

def imprimir(conexion, obra, documento, propiedades = None):
	consulta = QtSql.QSqlQuery (conexion)
	Autor = ""
	Obra = ""
	Listado = u"LISTADO DE PRECIOS AUXILIARES"
	ListadoManoObra = u". MANO DE OBRA"
	ListadoMaquinaria = u".MAQUINARIA"
	ListadoMateriales = u". MATERIALES"
	TextoCodigo = u"Código"
	TextoUd = u"Ud"
	TextoCantidad=u"Cdad."
	TextoResumen=u"Resumen"
	TextoPrecio=u"Precio"
	TextoTotal=u"Total"
	tipo = 0
	if tipo == 1:
		Listado += ListadoManoObra
	elif tipo == 2:
		Listado += ListadoMateriales
	elif tipo == 3:
		Listado += ListadoMaquinaria
	#documento y estilos
	Instancia = modulo.Estilo()		
	s = documento.styles
	d = Instancia.ListaEstilos()
	for key in d:
		s.addElement(d[key])
	precision = "%.2f"
	#consultas para el encabezado
	consulta_nombre = "SELECT propiedad->>'Valor' AS \"Valor\" FROM (SELECT jsonb_array_elements(propiedades->'Valor') \
	AS propiedad FROM \""+obra+"_Propiedades\" \
	WHERE propiedades->>'Propiedad'= 'Proyectista') AS datos WHERE propiedad->>'Variable'='zPryNombre1'"
	consulta.exec_(consulta_nombre)
	while consulta.next():
		Autor = consulta.value(0)
	consulta_obra = "SELECT propiedad->>'Valor' AS \"Valor\" FROM (SELECT jsonb_array_elements(propiedades->'Valor') \
	AS propiedad FROM \"" + obra + "_Propiedades\"  \
	WHERE propiedades->>'Propiedad'= 'Datos generales') AS datos WHERE propiedad->>'Variable'='zNombre'"
	consulta.exec_(consulta_obra)
	while consulta.next():
		Obra = consulta.value(0)	
	###############
	###Contenido###
	###############	
	#Titulo
	titulo = P(stylename = Instancia.Estilos("Heading 1"))	
	teletype.addTextToElement(titulo, Listado)
	documento.text.addElement(titulo)
	#despues un salto de linea
	salto = P()
	lb = LineBreak()
	salto.addElement(lb)
	documento.text.addElement(salto)
	#encabezado
	linea = TextoCodigo+"\t"+TextoCantidad+"\t"+TextoUd+"\t"+TextoResumen+"\t"+TextoPrecio+"\t"+TextoTotal
	encabezado = P(stylename=Instancia.Estilos("Tabuladores Hoja Listados Negritas"))
	teletype.addTextToElement(encabezado, linea)
	documento.text.addElement(encabezado)
	#linea horizontal
	linea = " "
	lineahorizontal = P(stylename=Instancia.Estilos("Linea horizontal gruesa"))
	teletype.addTextToElement(lineahorizontal, linea)
	documento.text.addElement(lineahorizontal)
	#consulta
	consulta.exec_("SELECT * FROM ver_conceptos_unitarios('"+ obra+"','"+str(tipo)+"')")
	rec = consulta.record()
	codigo = rec.indexOf("codigo")
	cantidad = rec.indexOf("cantidad")
	ud = rec.indexOf("ud")
	resumen = rec.indexOf("resumen");
	precio = rec.indexOf("precio");
	#datos	de la consulta
	while consulta.next():
		linea = consulta.value(codigo)+"\t"+formatear(consulta.value(cantidad))+"\t"+\
			str(consulta.value(ud))+"\t"+consulta.value(resumen)+"\t"+formatear(consulta.value(precio))+"\t"+\
			formatear(consulta.value(cantidad)*consulta.value(precio))
		tabp = P(stylename=Instancia.Estilos("Tabuladores Hoja Listados Normal"))
		teletype.addTextToElement(tabp, linea)
		documento.text.addElement(tabp)
	
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
