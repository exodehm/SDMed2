#!/usr/bin/python
# -*- coding: utf-8 -*-

MainModule = "__init_odt__"

import sys
import imp
import os
import subprocess, platform
from PyQt5 import QtSql
from subprocess import Popen
from plantilla import Plantilla

#establezco el locale para todos los numeros de los informes que usen la funciona formatear
import locale
locale.setlocale(locale.LC_ALL, locale.getdefaultlocale())

def iniciar(*datos):	
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
		info = imp.find_module(MainModule, [location])
		if info:
			ruta_fichero = location + "/" + MainModule+".py"
			print ("ruta fichero " + ruta_fichero)
			fichero = open(ruta_fichero, "r+")
			if (fichero):
				print ("FICHERO " + nombreficheroguardar)
				fImprimir = imp.load_module(MainModule, *info)				
				datosCabecera = LeerDatosProyecto(obra, db)
				print (datosCabecera[0],datosCabecera[1])
				datosLayout=["1cm","1.5cm","2cm","2cm",datosCabecera[0],datosCabecera[1]]
				Instancia = Plantilla(*datosLayout)
				documento = Instancia.Documento()
				fImprimir.imprimir(db,obra,documento)				
				#guardar el archivo
				if not nombreficheroguardar:
					nombreficheroguardar = "dummy.odt"
				documento.save(nombreficheroguardar)
				#pasar a pdf
				#subprocess.call(('unoconv', '-f', 'odt', nombreficheroguardar))
				#mostrar
				#mostrar(nombreficheroguardar)
	else:
		return False
		
def LeerDatosProyecto(obra,db):
	Autor = ""
	Obra = ""
	consulta = QtSql.QSqlQuery (db)
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
	datosProyecto = [Autor,Obra]
	return datosProyecto
		
def mostrar(nombrefichero):
	print ("ver PDF funcion" + nombrefichero)
	extensionpdf = ".pdf"
	nombreficheropdf = nombrefichero + extensionpdf
	#abrir lector de pdf
	if platform.system() == 'Darwin':       # macOS
		subprocess.call(('open', nombreficheropdf))
	elif platform.system() == 'Windows':    # Windows
		os.startfile(nombreficheropdf)
	else:                                   # linux variants		
		subprocess.call(('xdg-open', nombreficheropdf))
		
		
def formatear(numero, precision=2, esmoneda=True):
	precision = "%."+str(precision)+"f"
	return str(locale.format(precision, numero, grouping=True, monetary=esmoneda))
		
			
if __name__ == "__main__":
	datos = ["sdmed", "localhost","5432","sdmed","sdmed","METRO","/home/david/.sdmed/python/plugins/C3/",""]
	iniciar(*datos)
