#!/usr/bin/python
# -*- coding: utf-8 -*-

import imp
import os
import sys
from PyQt5 import QtCore, QtGui, QtWidgets
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
			dict_datos.update(datosplugins)
			plugins.append(dict_datos)			
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
	app = QtWidgets.QApplication(sys.argv)
	#myapp = MiWidget()
	myapp = DialogoImprimir(plugins)
	myapp.show()	
	sys.exit(app.exec_())


def iniciar(ruta):
	print ("iniciar()")
	#import sys
	#sys.path.insert(0, ruta)
	#print(sys.path)
	#print ("iniciar python en la ruta: " + ruta)
	'''for i in getPlugins(ruta):
		print("Loading plugin " + i["name"])
		plugin = loadPlugin(i)
		plugin.run()'''
	if not hasattr(sys,'argv'):
		sys.argv = []
	app = QtWidgets.QApplication.instance()
	if app is None:
		app = QtWidgets.QApplication([])
	#myapp = MiWidget()
	myapp = DialogoImprimir(getPlugins(ruta))
	myapp.show()
	return myapp.exec_()
	#sys.exit(app.exec_())
