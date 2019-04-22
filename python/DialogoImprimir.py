#!/usr/bin/python
# -*- coding: utf-8 -*-

MainModule = "__init__"

import sys
import imp
import os

from PyQt5 import QtCore, QtGui, QtWidgets

class DialogoImprimir(QtWidgets.QDialog):
	def __init__(self, datos):
		QtWidgets.QDialog.__init__(self)
		self.datos = datos
		self.GeneraUI(datos)		
		
	def GeneraUI(self,datos):
		self.setObjectName("Dialog")
		self.resize(400, 293)
		self.verticalLayout_2 = QtWidgets.QVBoxLayout(self)
		self.verticalLayout_2.setObjectName("verticalLayout_2")
		self.verticalLayout = QtWidgets.QVBoxLayout()
		self.verticalLayout.setObjectName("verticalLayout")
		self.groupBox = QtWidgets.QGroupBox(self)
		self.groupBox.setObjectName("groupBox")
		self.horizontalLayout = QtWidgets.QVBoxLayout(self.groupBox)
		self.horizontalLayout.setObjectName("horizontalLayout")
		#ahora relleno el groupbox con los radiobuttons que salen de leer los datos
		self.arrayRadioButtons = []
		for diccionarios in datos:
			i=0
			self.radioButton = QtWidgets.QRadioButton(self.groupBox)
			self.radioButton.setObjectName("radioButton" + str(i))
			self.radioButton.setText(diccionarios.get('name'))
			self.radioButton.setToolTip(diccionarios.get('description'))
			self.horizontalLayout.addWidget(self.radioButton)
			self.arrayRadioButtons.append(self.radioButton)			
			i=i+1
		#sigo con la interfaz
		self.verticalLayout.addWidget(self.groupBox)
		spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
		self.verticalLayout.addItem(spacerItem)
		self.verticalLayout_2.addLayout(self.verticalLayout)
		#botones
		self.buttonBox = QtWidgets.QDialogButtonBox(self)
		self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
		self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
		self.buttonBox.setObjectName("buttonBox")
		self.verticalLayout_2.addWidget(self.buttonBox)
		
		self.buttonImprimir = QtWidgets.QPushButton(self)
		self.buttonImprimir.setObjectName("botonImprimir")
		self.verticalLayout.addWidget(self.buttonImprimir)
		
		self.retranslateUi()
		self.buttonImprimir.pressed.connect(self.cargaFuncion)
		self.buttonBox.accepted.connect(self.accept)
		self.buttonBox.rejected.connect(self.reject)
		QtCore.QMetaObject.connectSlotsByName(self)
	
	def retranslateUi(self):
		_translate = QtCore.QCoreApplication.translate
		self.setWindowTitle(_translate("Dialog", "Opciones de impresión"))
		self.groupBox.setTitle(_translate("Dialog", "Selecciona opcion:"))
		self.buttonImprimir.setText(_translate("Dialog", "Imprimir"))
	
	def cargaFuncion(self):
		print ("Cargar Funcion ")
		for i in range (0, len(self.arrayRadioButtons)):
			if self.arrayRadioButtons[i].isChecked():
				programa = self.datos[i]
				plugintito = imp.load_module(MainModule, *programa["info"])
				plugintito.run()
		
		

if __name__ == "__main__":
	getPlugins = []
	app = QtWidgets.QApplication(sys.argv)	
	myapp = DialogoImprimir(getPlugins)
	myapp.show()	
	sys.exit(app.exec_())
