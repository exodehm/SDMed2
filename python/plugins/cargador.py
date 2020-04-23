#!/usr/bin/python
# -*- coding: utf-8 -*-

MainModule = "__init_odt__"

import sys
import imp
import os
#import runpy
import subprocess, platform
from PyQt5 import QtSql
from subprocess import Popen
from plantilla import Plantilla
import unoconv
from pathlib import Path
sys.path.append(Path(__file__).parent)
ruta_unoconv = str(Path(__file__).parent) + "/unoconv.py"


#establezco el locale para todos los numeros de los informes que usen la funciona formatear
import locale
if platform.system() == 'Windows':    # Windows
	locale.setlocale(locale.LC_ALL,'')
else:
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
			print ("ruta informe " + ruta_fichero)
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
				borrararchivo = False;
				#guardar el archivo
				if not nombreficheroguardar:
					nombreficheroguardar = "listado.odt"
					borrararchivo = True;
				nombre = nombreficheroguardar.rsplit(".",1)[0]
				extension = nombreficheroguardar.rsplit(".",1)[1]
				return Guardar(documento,nombre,extension,borrararchivo)
				#pasar a pdf
				#sys.argv = ['','-f','pdf',nombreficheroguardar]
				#runpy.run_path('/usr/bin/unoconv', run_name='__main__')
				#runpy.run_module('unoconv.py', run_name='__main__')
				#subprocess.call(('unoconv', '-f', 'pdf', nombreficheroguardar))
				#mostrar
				#mostrar(nombreficheroguardar)
			return ""
	else:
		return ""
		
def Guardar(documento, fichero, extension, borrar):
	Shell = False
	if platform.system() == 'Windows':
		Shell = True
	#Primer paso, guardar el odt 
	documento.save(fichero+".odt") #en todos los casos creo el odt	
	if (extension == "docx"):		
		subprocess.call((ruta_unoconv, '-f', 'docx', fichero + ".odt"),shell=Shell)
		subprocess.call((ruta_unoconv, '-f', 'pdf', fichero + ".docx"),shell=Shell)
		os.remove(fichero + ".odt")#borro el odt que en esta opcion solo sirve para hacer la conversion a docx	
	subprocess.call((ruta_unoconv, '-f', 'pdf', fichero + ".odt"),shell=Shell)
	if borrar: #si he usado un fichero auxiliar (listado.odt) para genera el pdf lo borro
		try:
			os.remove(fichero + ".odt")
		except:
			print ("El fichero no existe")		
	return fichero +".pdf"
	#return fichero +"."+extension
		
def mostrar(nombrefichero):	
	print ("ver PDF funcion " + nombrefichero)
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
		
			
if __name__ == "__main__":
	datos = ["sdmed", "localhost","5432","sdmed","sdmed","METRO","/home/david/.sdmed/python/plugins/C3/",""]
	iniciar(*datos)
