#!/usr/bin/python
# -*- coding: utf-8 -*-

MainModule = "__init__"

import sys
import imp
import os
import subprocess, platform

from openpyxl import Workbook
from PyQt5 import QtSql
from subprocess import Popen

def iniciar(*datos):
	#db = QtSql.QSqlDatabase.database('QPSQL')
	db = QtSql.QSqlDatabase('QPSQL')
	db.setDatabaseName(datos[0])
	db.setHostName(datos[1])
	db.setPort(int(datos[2]))
	db.setUserName(datos[3])
	db.setPassword(datos[4])
	obra = datos[5]
	location = datos[6]
	print ("location" + location)
	nombreficheroguardar = datos[7]
	if db.open():	
		info = imp.find_module(MainModule, [location])
		if info:
			ruta_fichero = location + "/" + MainModule+".py"
			print ("ruta fichero " + ruta_fichero)
			fichero = open(ruta_fichero, "r+")
			if (fichero):
				fImprimir = imp.load_module(MainModule, *info)
				fImprimir.run()
				wb = Workbook()
				book = fImprimir.imprimir(db,obra,wb)
				#guardar el xls
				if not nombreficheroguardar:
					nombreficheroguardar = "dummy"
				ficheroxls = nombreficheroguardar + '.xlsx'					
				#book.save(ficheroxls)
				print ("ficheroxls " + ficheroxls)
				#pasar a pdf
				#subprocess.call(('odt2pdf', '-f', 'pdf', ficheroxls))
				#mostrar
				#mostrar(nombreficheroguardar)				
	else:
		return False
		
def mostrar(nombrefichero):
	extensionpdf = ".pdf"
	nombreficheropdf = nombrefichero + extensionpdf
	#abrir lector de pdf
	if platform.system() == 'Darwin':       # macOS
		subprocess.call(('open', nombreficheropdf))
	elif platform.system() == 'Windows':    # Windows
		os.startfile(nombreficheropdf)
	else:                                   # linux variants		
		subprocess.call(('xdg-open', nombreficheropdf))	
		
			
if __name__ == "__main__":
	datos = ["sdmed", "localhost","5432","sdmed","sdmed","CENZANO","/home/david/.sdmed/python/plugins/C1/",""]
	iniciar(*datos)
