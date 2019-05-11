from PyQt5 import QtCore, QtGui, QtWidgets
from Ui_DialogoOpcionesPagina import Ui_DialogoOpcionesPagina
from openpyxl import Workbook

class DialogoOpcionesPagina(QtWidgets.QDialog):
	def __init__(self,informe):
		QtWidgets.QDialog.__init__(self)
		self.ui = Ui_DialogoOpcionesPagina()
		self.ui.setupUi(self)
		self.setModal(True)
		
		self.informe = informe
		
		LTamannoPagina = ['A4','A3']
		LOrientacion = ['Vertical','Horizontal']
		LEncabezado = ['Datos de proyecto','No','Definir']
		LFecha = ['Hoy','No','Definir']
		LNumeracion = ['Si','No']
		
		self.LDatosConfiguracion = [LTamannoPagina,LOrientacion,LEncabezado,LFecha,LNumeracion]
		self.datosConfiguracionPagina={'TamannoPagina':LTamannoPagina[0],'Orientacion':LOrientacion[0],'Encabezado':LEncabezado[0],'Fecha':LFecha[0],'Numeracion':LNumeracion[0]}
		
		self.ui.radioButtonNumeracionNo.clicked.connect(self.definirNumeracion)
		self.ui.radioButtonNumeracionSi.clicked.connect(self.definirNumeracion)
		self.ui.radioButtonFechaHoy.clicked.connect(self.definirFecha)
		self.ui.radioButtonFechaNo.clicked.connect(self.definirFecha)		
		self.ui.radioButtonFechaDefinir.clicked.connect(self.definirFecha)
		self.ui.radioButtonOrientacionHorizontal.clicked.connect(self.definirOrientacion)
		self.ui.radioButtonOrientacionVertical.clicked.connect(self.definirOrientacion)
						
	def definirNumeracion(self):
		if self.sender().objectName() == "radioButtonNumeracionNo":
			self.datosConfiguracionPagina['Numeracion']='No'
		else:
			self.datosConfiguracionPagina['Numeracion']='Si'
		
		print ("Se cabia la numeracion a " + self.datosConfiguracionPagina['Numeracion'])
		
	def definirFecha(self):
		if self.ui.radioButtonFechaNo.isChecked():
			self.datosConfiguracionPagina['Fecha']='No'
		elif self.ui.radioButtonFechaDefinir.isChecked():
			self.datosConfiguracionPagina['Fecha']='Definir'
		else:
			self.datosConfiguracionPagina['Fecha']='Hoy'
		print ("Se cabia la fecha a " + self.datosConfiguracionPagina['Fecha'])
		
	def definirOrientacion(self):
		if self.ui.radioButtonOrientacionHorizontal.isChecked():
			self.informe.page_setup.orientation = self.informe.ORIENTATION_LANDSCAPE			
		else:
			self.informe.page_setup.orientation = self.informe.ORIENTATION_PORTRAIT
		
	def DatosConfPagina(self):
		return self.informe
