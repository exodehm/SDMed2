from PyQt5 import QtSql
from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties, TabStop, TabStops
from odf.text import P,H,Span,LineBreak, PageNumber
from odf import teletype

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
	consulta = QtSql.QSqlQuery (conexion)
	Autor = ""
	Obra = ""
	Listado = u"RESUMEN DE PRESUPUESTO"		
	Instancia = modulo.Estilo()		
	s = documento.styles
	d = Instancia.ListaEstilos()
	for key in d:
		s.addElement(d[key])
	precision = "%.2f"		
	###############
	###Contenido###
	###############
	#Titulo
	consulta.exec_("SELECT resumen FROM \"" + obra + "_Conceptos\" AS C, \"" + obra + "_Relacion\" AS R WHERE C.codigo = R.codhijo AND R.codpadre IS NULL")
	resumen = ""
	while consulta.next():
		resumen = consulta.value(0)
	linea = Listado
	parrafo = P(stylename=Instancia.Estilos("Heading 1"))
	teletype.addTextToElement(parrafo, linea)
	documento.text.addElement(parrafo)	
	titulo = P(stylename = Instancia.Estilos("Heading 2"))	
	teletype.addTextToElement(titulo, resumen)
	documento.text.addElement(titulo)
	#linea horizontal
	linea = " "
	lineahorizontal = P(stylename=Instancia.Estilos("Linea horizontal gruesa"))
	teletype.addTextToElement(lineahorizontal, linea)
	documento.text.addElement(lineahorizontal)
	#consulta
	consulta.exec_("SELECT * FROM ver_resumen_capitulos('" + obra + "')")
	#datos	de la consulta
	rec = consulta.record()
	codigo = rec.indexOf("codigo")
	resumen = rec.indexOf("resumen")
	cantidad = rec.indexOf("cantidad")
	euros = rec.indexOf("total")
	porcentaje = rec.indexOf("porcentaje")
	EM = 0.0
	while consulta.next():
		linea = consulta.value(codigo)+"\t"+consulta.value(resumen)+"\t"+formatear(consulta.value(euros))+"\t"+formatear(consulta.value(porcentaje))+ " %"
		print (linea)
		tabp = P(stylename=Instancia.Estilos("Normal con tabuladores capitulos"))
		teletype.addTextToElement(tabp, linea)
		documento.text.addElement(tabp)
		EM = EM + consulta.value(euros)		
	#EM
	salto = P()
	lb = LineBreak()
	salto.addElement(lb)
	documento.text.addElement(salto)
	lineaEM = "\tTotal Ejecución Material:\t" + formatear(EM)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen negritas"))
	teletype.addTextToElement(parrafo, lineaEM)
	documento.text.addElement(parrafo)
	#GG
	GG = 0.0
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Porcentajes') AS subdatos WHERE datos->>'Variable' = 'zPorGastosGenerales'")	
	while consulta.next():
		GG = float(consulta.value(0))
		print ("Gastos generales " + str(GG) + "\t")
	GastosGenerales = EM*GG/100
	lineaGG = "\t\t" + str(GG) + "% Gastos generales\t" + formatear(GastosGenerales)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen"))
	teletype.addTextToElement(parrafo, lineaGG)
	documento.text.addElement(parrafo)
	#BI
	BI = 0.0
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Porcentajes') AS subdatos WHERE datos->>'Variable' = 'zPorBenIndustrial'")
	while consulta.next():
		BI = float(consulta.value(0))
		print ("Gastos generales " + str(BI) + "\t")
	BeneficioIndustrial = EM*BI/100
	lineaBI = "\t\t" + str(BI) + "%Beneficio Industrial\t" + formatear(BeneficioIndustrial)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen"))
	teletype.addTextToElement(parrafo, lineaBI)
	documento.text.addElement(parrafo)
	#suma de GG+BI
	lineaGGBI = "\t\tSuma de G.G. + B.I.: \t" + formatear(GastosGenerales+BeneficioIndustrial)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen"))
	teletype.addTextToElement(parrafo, lineaGGBI)
	documento.text.addElement(parrafo)
	#PContrata
	importeTPC = EM+GastosGenerales+BeneficioIndustrial
	lineaTPC = "\tTOTAL PRESUPUESTO DE CONTRATA: \t" + formatear(importeTPC)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen negritas"))
	teletype.addTextToElement(parrafo, lineaTPC)
	documento.text.addElement(parrafo)
	#IVA
	IVA = 0
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Porcentajes') AS subdatos WHERE datos->>'Variable' = 'zPorIVAEjecucion'")	
	while consulta.next():
		IVA = float(consulta.value(0))
	importeIVA = importeTPC*IVA/100
	lineaIVA = "\t\t" + str(IVA) + "% IVA\t" + formatear(importeIVA)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen"))
	teletype.addTextToElement(parrafo, lineaIVA)
	documento.text.addElement(parrafo)
	#PGeneral
	importeTPG = importeTPC + (importeTPC*IVA/100)
	lineaTPC = "\tTOTAL PRESUPUESTO GENERAL: \t" + formatear(importeTPG)
	parrafo = P(stylename=Instancia.Estilos("Normal con tabuladores resumen negritas"))
	teletype.addTextToElement(parrafo, lineaTPC)
	documento.text.addElement(parrafo)
	#salto
	salto = P()
	lb = LineBreak()
	salto.addElement(lb)
	documento.text.addElement(salto)
	#cantidad en letra
	consulta.exec_("SELECT numero_en_euro("+str(importeTPG)+")")
	print (consulta.lastError().text())
	cantidadenletra=""
	while consulta.next():
		cantidadenletra = consulta.value(0)
	print ("cantidad en letras "+cantidadenletra)
	resumen = P()
	texto_resumen = Span(stylename=Instancia.Estilos("Normal"), text="Asciende el presupuesto general a la expresada cantidad de ")
	resumen.addElement(texto_resumen)
	texto_cantidad_letra = Span(stylename=Instancia.Estilos("Negritas"), text=cantidadenletra)
	resumen.addElement(texto_cantidad_letra)
	documento.text.addElement(resumen)
	#firmas-datos
	encabezado_firma_proyectista = ""
	nombre_proyectista1 = ""
	nombre_proyectista2 = ""
	encabezado_firma_promotor = ""
	nombre_promotor1 = ""
	nombre_promotor2 = ""
	ciudad = ""
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Proyectista') AS subdatos WHERE datos->>'Variable' = 'zPryEncabezamiento'")
	while consulta.next():
		encabezado_firma_proyectista = consulta.value(0)
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Proyectista') AS subdatos WHERE datos->>'Variable' = 'zPryNombre1'")
	while consulta.next():
		nombre_proyectista1 = consulta.value(0)
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Proyectista') AS subdatos WHERE datos->>'Variable' = 'zPryNombre2'")
	while consulta.next():
		nombre_proyectista2 = consulta.value(0)
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'El promotor') AS subdatos WHERE datos->>'Variable' = 'zProEncabezamiento'")
	while consulta.next():
		encabezado_firma_promotor = consulta.value(0)
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'El promotor') AS subdatos WHERE datos->>'Variable' = 'zProNombre1'")
	while consulta.next():
		nombre_promotor1 = consulta.value(0)
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'El promotor') AS subdatos WHERE datos->>'Variable' = 'zProNombre2'")
	while consulta.next():
		nombre_promotor2 = consulta.value(0)
	consulta.exec_("SELECT datos->>'Valor' FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS datos \
				FROM \"" + obra + "_Propiedades\" \
				WHERE propiedades->>'Propiedad' = 'Datos generales') AS subdatos WHERE datos->>'Variable' = 'zCiudad'")
	while consulta.next():
		ciudad = consulta.value(0)		
	#Linea ciudad y fecha
	#salto
	salto = P()
	lb = LineBreak()
	salto.addElement(lb)
	documento.text.addElement(salto)
	fecha= datetime.now()
	dia = fecha.strftime("%d")
	mes = fecha.strftime("%B")
	anno = fecha.strftime("%Y")
	lineaciudadfecha = "En "+ciudad+ ", a " + dia + " de " + mes + " de " + anno
	parrafo = P(stylename=Instancia.Estilos("NormalP"))
	teletype.addTextToElement(parrafo, lineaciudadfecha)
	documento.text.addElement(parrafo)
	#salto
	salto = P()
	lb = LineBreak()
	salto.addElement(lb)
	documento.text.addElement(salto)
	#linea 1 firmas
	linea1 = encabezado_firma_proyectista + "\t\t\t" + encabezado_firma_promotor
	parrafo = P(stylename=Instancia.Estilos("NegritasP"))
	teletype.addTextToElement(parrafo, linea1)
	documento.text.addElement(parrafo)
	#saltos de linea
	for n in range (0,2):
		salto = P()
		lb = LineBreak()
		salto.addElement(lb)
		documento.text.addElement(salto)
	#linea 2 firmas
	linea2 = nombre_proyectista1 + "\t\t\t" + nombre_promotor1
	parrafo = P(stylename=Instancia.Estilos("NormalP"))
	teletype.addTextToElement(parrafo, linea2)
	documento.text.addElement(parrafo)
	#linea 2 firmas
	linea3 = nombre_proyectista2 + "\t\t\t" + nombre_promotor2
	parrafo = P(stylename=Instancia.Estilos("NormalP"))
	teletype.addTextToElement(parrafo, linea3)
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
