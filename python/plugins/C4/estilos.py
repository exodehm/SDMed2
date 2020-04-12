from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties, TabStop, TabStops
from odf.text import P,H,Span,LineBreak
from odf import teletype, opendocument,text

class Estilo():	
	def __init__(self):
		self.textDoc = OpenDocumentText()
		self.h = Header()
		self.f = Footer()
		self.s = self.textDoc.styles		
		self.pl = PageLayout(name="pagelayout")
		#margenes para la pagina (PageLayout)
		self.pl.addElement(PageLayoutProperties(margintop="1cm"))
		self.textDoc.automaticstyles.addElement(self.pl)
		self.mp = MasterPage(name="Standard", pagelayoutname=self.pl)
		self.textDoc.masterstyles.addElement(self.mp)
		self.estilos = {}		
		self.ConfigurarEstilos()
	def ConfigurarEstilos(self):
		nombre = "Linea horizontal gruesa"
		###############
		### Estilos ###
		###############		
		#H1
		H1 = "Heading 1"
		estilo = Style(name = H1, family="paragraph")		
		estilo.addElement(TextProperties(attributes={'fontsize':"14pt",'fontweight':"bold",'fontfamily' : "helvetica"}))
		estilo.addElement(ParagraphProperties(attributes={'textalign' : "Left", 'paddingtop' : "0cm"}))
		self.UpdateEstilos(H1,estilo)
		#H2
		H2 = "Heading 2"
		estilo = Style(name=H2, family="paragraph", parentstylename = H1)
		estilo.addElement(TextProperties(attributes={"fontsize": "12pt"}))
		self.UpdateEstilos(H2,estilo)
		#BASE
		base = "Base"
		estilo = Style(name=base, family="paragraph")
		estilo.addElement(ParagraphProperties(textalign = "justify", padding = "0cm", marginleft = "2cm",marginright = "5cm"))
		estilo.addElement(TextProperties(fontfamily = "helvetica", fontsize = "12pt"))
		self.UpdateEstilos(base,estilo)
		#Capitulo
		CAP = "Capitulo"
		estilo = Style(name=CAP, family="paragraph", parentstylename = base)
		estilo.addElement(TextProperties(attributes={'fontsize':"10pt",'fontweight':"bold",'fontfamily' : "helvetica", 'backgroundcolor' : '#a2f2f5'}))
		self.UpdateEstilos(CAP,estilo)
		#Subcapitulo
		SUBCAP = "SubCapitulo"
		estilo = Style(name=SUBCAP, family="paragraph", parentstylename = CAP)
		estilo.addElement(TextProperties(attributes={"fontsize": "10pt"}))
		self.UpdateEstilos(SUBCAP,estilo)		
		#normal
		normal = "Normal"
		estilo = Style(name = normal, family="paragraph", parentstylename = base)
		estilo.addElement(TextProperties(fontsize = "8pt"))
		self.UpdateEstilos(normal,estilo)
		#texto
		texto = "Texto"
		estilo = Style(name = texto, family="paragraph", parentstylename = base)
		estilo.addElement(ParagraphProperties(textalign = "justify"))
		estilo.addElement(TextProperties(fontsize = "8pt"))
		self.UpdateEstilos(texto,estilo)
		#negritas
		negritas = "Negritas"
		estilo = Style(name = negritas, family="paragraph", parentstylename = base)
		estilo.addElement(TextProperties(fontsize = "9pt",fontweight ="bold"))
		estilo.addElement(ParagraphProperties(marginleft = "cm"))
		self.UpdateEstilos(negritas,estilo)
		#normal parrafo
		normal_parrafo = "NormalP"
		estilo = Style(name = normal_parrafo, family="paragraph")
		estilo.addElement(TextProperties(fontfamily = "helvetica", fontsize = "10pt"))
		self.UpdateEstilos(normal_parrafo,estilo)		
		#negritas parrafo
		negritas_parrafo = "NegritasP"
		estilo = Style(name = negritas_parrafo, family="paragraph", parentstylename=normal_parrafo)
		estilo.addElement(TextProperties(fontweight ="bold"))
		self.UpdateEstilos(negritas_parrafo,estilo)			
		#conjunto de tabuladores 1 (PARA  EL LISTADO DE CAPITULOS)
		tabstops_list = TabStops()
		#Cada tabulador
		tabstop1 = TabStop(position="4.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="5.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="6.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="7.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="8.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="9.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="11.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="13.5cm")
		tabstops_list.addElement(tabstop1)
		tabstoppar_mediciones = ParagraphProperties()
		tabstoppar_mediciones.addElement(tabstops_list)
		#estilo tabuladores normal
		tabuladores_normal = "Tabuladores Lineas Medicion"
		estilo = Style(name = tabuladores_normal, family="paragraph",parentstylename = texto)
		estilo.addElement(tabstoppar_mediciones)
		estilo.addElement(ParagraphProperties(marginright = "0cm", marginleft = "2cm"))
		self.UpdateEstilos(tabuladores_normal,estilo)
		#estilo tabuladores negritas
		tabuladores_negritas = "Tabuladores Hoja Listados Negritas"
		estilo = Style(name = tabuladores_negritas, family="paragraph", parentstylename = tabuladores_normal)
		estilo.addElement(TextProperties(fontweight ="bold", fontstyle="italic"))
		self.UpdateEstilos(tabuladores_negritas,estilo)
		#tabuladores linea total capitulos
		tabstops_list_total_capitulos = TabStops()
		tabstop = TabStop(position="15.5cm", type = "char", char = ",", leaderstyle="dotted")
		tabstops_list_total_capitulos.addElement(tabstop)
		tabstoppar_total_capitulo = ParagraphProperties()
		tabstoppar_total_capitulo.addElement(tabstops_list_total_capitulos)
		tabuladores_total_capitulos = "Tabuladores Linea Total Capitulo"
		estilo = Style(name = tabuladores_total_capitulos, family="paragraph",parentstylename = negritas)
		estilo.addElement(tabstoppar_total_capitulo)
		estilo.addElement(ParagraphProperties(marginright = "0cm", marginleft = "0cm"))
		self.UpdateEstilos(tabuladores_total_capitulos,estilo)
		#linea horizontal gruesa
		linea_horizontal_gruesa = "Linea horizontal gruesa"
		estilo = Style(name = linea_horizontal_gruesa, displayname="Horizontal Line Thick", family="paragraph", parentstylename="Standard")
		estilo.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="0cm", \
			contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.06cm", padding="0cm", borderleft="none", borderright="none", \
			bordertop="none", borderbottom="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.UpdateEstilos(linea_horizontal_gruesa,estilo)
		#linea horizontal sumatoria
		linea_horizontal_sumatoria = "Linea horizontal sumatoria"
		estilo = Style(name = linea_horizontal_sumatoria, displayname="Horizontal Line Sumatory", family="paragraph")
		estilo.addElement(TextProperties(attributes={"fontsize": "8pt"}))
		estilo.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="10cm", \
			contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.01cm", padding="0cm", borderleft="none", borderright="none", \
			borderbottom="none", bordertop="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.UpdateEstilos(linea_horizontal_sumatoria,estilo)
		#salto de pagina
		salto_pagina = "Salto de Pagina"
		estilo = Style(name = salto_pagina, parentstylename="Standard", family="paragraph")
		estilo.addElement(ParagraphProperties(breakbefore="page"))
		self.UpdateEstilos(salto_pagina,estilo)		
	def Documento(self):
		return self.textDoc	
	def Estilos(self,nombre):
		return self.estilos[nombre]
	def UpdateEstilos (self, nombre, estilo):
		self.s.addElement(estilo)
		self.estilos.update({nombre : estilo})
	def ListaEstilos(self):
		return self.estilos
		
		
		
if __name__ == "__main__":
	Instancia = Estilos()
	doc = Instancia.Documento()
	linea = "La prueba definitiva"
	parrafo = P(stylename=Instancia.Estilo("Heading 1"))
	teletype.addTextToElement(parrafo, linea)
	doc.text.addElement(parrafo)
	
	linea1 = "La prueba definitiva 2"
	parrafo = P(stylename=Instancia.Estilo("Heading 2"))
	teletype.addTextToElement(parrafo, linea1)
	doc.text.addElement(parrafo)
	
	linea2 = "Hola\tEsto\tson\ttabuladores\taqui\tpuestos"
	parrafo = P(stylename=Instancia.Estilo("Negritas con tabuladores"))
	teletype.addTextToElement(parrafo, linea2)
	doc.text.addElement(parrafo)
	
	doc.save("kkk.odt")
