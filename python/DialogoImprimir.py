#!/usr/bin/python
# -*- coding: utf-8 -*-

MainModule = "__init__"

import sys
import imp
import os

from PyQt5 import QtCore, QtGui, QtWidgets, QtSql

class DialogoImprimir(QtWidgets.QDialog):
	def __init__(self, plugins, conexion, obra):
		QtWidgets.QDialog.__init__(self)
		self.plugins = plugins
		self.conexion = conexion
		self.GeneraUI(plugins)
		self.obra = obra
		
	def GeneraUI(self,plugins):
		self.setObjectName("Dialog")
		self.resize(400, 293)
		#layouts
		self.LayoutPrincipal = QtWidgets.QVBoxLayout(self)
		self.LayoutPrincipal.setObjectName("LayoutPrincipal")
		self.LayoutGroupBox = QtWidgets.QVBoxLayout()
		self.LayoutGroupBox.setObjectName("LayoutGroupBox")
		self.LayoutBotones = QtWidgets.QHBoxLayout()
		self.LayoutBotones.setObjectName("LayoutBotones")
		
		self.groupBox = QtWidgets.QGroupBox(self)
		self.groupBox.setObjectName("groupBox")
		self.horizontalLayout = QtWidgets.QVBoxLayout(self.groupBox)
		self.horizontalLayout.setObjectName("horizontalLayout")
		#ahora relleno el groupbox con los radiobuttons que salen de leer los datos
		self.arrayRadioButtons = []
		for diccionarios in plugins:
			i=0
			self.radioButton = QtWidgets.QRadioButton(self.groupBox)
			self.radioButton.setObjectName("radioButton" + str(i))
			self.radioButton.setText(diccionarios.get('name'))
			self.radioButton.setToolTip(diccionarios.get('description'))
			self.horizontalLayout.addWidget(self.radioButton)
			self.arrayRadioButtons.append(self.radioButton)			
			i=i+1
		#sigo con la interfaz
		self.LayoutGroupBox.addWidget(self.groupBox)
		spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
		self.LayoutGroupBox.addItem(spacerItem)
		self.LayoutPrincipal.addLayout(self.LayoutGroupBox)
		#botones
		self.buttonImprimir = QtWidgets.QPushButton(self)
		self.buttonImprimir.setObjectName("botonImprimir")
		self.LayoutBotones.addWidget(self.buttonImprimir)
		
		self.buttonBox = QtWidgets.QDialogButtonBox(self)
		self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
		self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
		self.buttonBox.setObjectName("buttonBox")
		self.LayoutBotones.addWidget(self.buttonBox)		
		
		self.LayoutPrincipal.addLayout(self.LayoutBotones)
		
		self.retranslateUi()
		self.buttonImprimir.pressed.connect(self.Imprimir)
		self.buttonBox.accepted.connect(self.accept)
		self.buttonBox.rejected.connect(self.reject)
		QtCore.QMetaObject.connectSlotsByName(self)
	
	def retranslateUi(self):
		_translate = QtCore.QCoreApplication.translate
		self.setWindowTitle(_translate("Dialog", "Opciones de impresión"))
		self.groupBox.setTitle(_translate("Dialog", "Selecciona opcion:"))
		self.buttonImprimir.setText(_translate("Dialog", "Imprimir"))
	
	def Imprimir(self):
		print ("Cargar Funcion ")
		for i in range (0, len(self.arrayRadioButtons)):
			if self.arrayRadioButtons[i].isChecked():
				programa = self.plugins[i]
				funcionImprimir = imp.load_module(MainModule, *programa["info"])
				funcionImprimir.imprimir(self.conexion, self.obra)
		
		

if __name__ == "__main__":
	getPlugins = []
	conexion = QtSql.QSqlDatabase('QPSQL')
	app = QtWidgets.QApplication(sys.argv)	
	myapp = DialogoImprimir(getPlugins, conexion)
	myapp.show()	
	sys.exit(app.exec_())
