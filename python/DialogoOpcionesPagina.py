from PyQt5 import QtCore, QtGui, QtWidgets
from Ui_DialogoOpcionesPagina import Ui_DialogoOpcionesPagina

class DialogoOpcionesPagina(QtWidgets.QDialog):
	def __init__(self,datosConfiguracionPagina):
		QtWidgets.QDialog.__init__(self)
		self.ui = Ui_DialogoOpcionesPagina()
		self.ui.setupUi(self)
		self.setModal(True)
		print(datosConfiguracionPagina)
		self.datosConfiguracionPagina = datosConfiguracionPagina
		#self.ui.radioButtonNumeracionNo.clicked.connect(self.definirNumeracion)
		#self.ui.radioButtonNumeracionSi.clicked.connect(self.definirNumeracion)
		self.ui.groupBoxNumeracion.clicked.connect(self.definirNumeracion)
		
	def definirNumeracion(self):
		print("hola")
		
	def DatosConfPagina(self):
		return self.datosConfiguracionPagina
