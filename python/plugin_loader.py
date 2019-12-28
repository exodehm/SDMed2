#!/usr/bin/python
# -*- coding: utf-8 -*-

import imp
import os
import sys
import operator
from PyQt5 import QtCore, QtGui, QtWidgets, QtSql
from DialogoImprimir import DialogoImprimir


MainModule = "__init__"
ArchivoDatos = "metadata"
PluginFolder = "plugins"

def getPlugins(ruta):
	plugins = []
	possibleplugins = os.listdir(ruta + PluginFolder)
	for i in possibleplugins:
		location = os.path.join(ruta + PluginFolder, i)
		#location = ruta + location
		if not os.path.isdir(location) or not MainModule + ".py" in os.listdir(location):
			continue
		datosplugins = {}
		datosplugins =  checkMetadataFile(location, ArchivoDatos)
		if datosplugins:#solo añadire los plugins si hay una seccion [general] bien formada
			info = imp.find_module(MainModule, [location])
			dict_datos = {"name": i, "info": info}
			#print (dict_datos)
			dict_datos.update(datosplugins)
			plugins.append(dict_datos)
	plugins = sorted(plugins, key = lambda k:k['name']) #ordeno la lista antes de retornarla
	return plugins


def loadPlugin(plugin):	
	return imp.load_module(MainModule, *plugin["info"])
	
	
def checkMetadataFile(location, ficherometa):
	if not ficherometa + ".txt" in os.listdir(location):#si no existe el fichero metadata.txt
		return False
	metafile = os.path.join(location, ficherometa)
	with open(metafile + ".txt", 'r') as file:
			file_contents = file.read()			
			if file_contents.find("[general]") == -1:#si no existe la seccion [general]
				pass
			comienzo = file_contents.find("]")+1
			final = file_contents.find(";",file_contents.find("["))			
			bloque_datos_general = file_contents[comienzo : final]
			#si he llegado hasta aqui, creo un diccionario
			datosplugin = {}
			for linea in bloque_datos_general.splitlines():
				if '=' not in linea:
					continue
				key_value = linea.split('=')
				#print (key_value)
				datosplugin[key_value[0]] = key_value[1]
				#print ("key: " + key_value[0] + " - valor: " + key_value[1])				
			return datosplugin
	return False
    
class MiWidget(QtWidgets.QWidget):
	def __init__(self, parent=None):
		QtWidgets.QWidget.__init__(self, parent)		
		self.ui = Ui_Dialog()
		self.ui.setupUi(self)


if __name__ == "__main__":	
		for i in getPlugins("/home/david/programacion/Qt/SDMed2/SDMed2/python/"):
			print("Loading plugin " + i["name"])
			plugin = loadPlugin(i)
			plugin.run()
		plugins = getPlugins("/home/david/programacion/Qt/SDMed2/SDMed2/python/")
		conexion = QtSql.QSqlDatabase('QPSQL')
		obraActual = "PRUEBASCOMP"
		app = QtWidgets.QApplication(sys.argv)
		myapp = DialogoImprimir(plugins,conexion, obraActual)
		myapp.show()	
		sys.exit(app.exec_())


def iniciar(*datos):
	ruta = os.path.dirname(__file__) + "/"	
	conexion = QtSql.QSqlDatabase('QPSQL')
	conexion.setDatabaseName(datos[0])
	conexion.setHostName(datos[1])
	conexion.setPort(int(datos[2]))
	conexion.setUserName(datos[3])
	conexion.setPassword(datos[4])
	obraActual = datos[5]
	if conexion.open():
		print('Successful')
		app = QtWidgets.QApplication.instance()
		if app is None:
			app = QtWidgets.QApplication([])
		myapp = DialogoImprimir(getPlugins(ruta), conexion, obraActual)
		myapp.show()
		return myapp.exec_()		
	else:
		print ("error")
