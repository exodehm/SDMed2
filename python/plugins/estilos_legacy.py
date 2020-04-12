from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties, TabStop, TabStops
from odf.text import P,H,Span,LineBreak
from odf import teletype, opendocument,text

class Estilos():	
	def __init__(self):
		self.textDoc = OpenDocumentText()
		self.h = Header()
		self.f = Footer()
		self.s = self.textDoc.styles		
		self.pl = PageLayout(name="pagelayout")
		#margenes para la pagina (PageLayout)
		self.pl.addElement(PageLayoutProperties(margin="2cm"))
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
		estilo.addElement(ParagraphProperties(attributes={'textalign' : "Left", 'paddingtop' : "0cm"}))
		estilo.addElement(TextProperties(attributes={'fontsize':"14pt",'fontweight':"bold",'fontfamily' : "helvetica"}))
		self.UpdateEstilos(H1,estilo)
		#H2
		H2 = "Heading 2"
		estilo = Style(name=H2, family="paragraph", parentstylename = H1)
		estilo.addElement(TextProperties(attributes={"fontsize": "12pt"}))
		self.UpdateEstilos(H2,estilo)
		#Estilo para el header
		#normal
		normal = "Cabecera Py"
		estilo = Style(name = normal, family="text")
		estilo.addElement(TextProperties(fontsize = "8pt", color ="#3a3b3d"))
		self.UpdateEstilos(normal,estilo)
		#negritas
		negritas = "Negritas"
		estilo = Style(name = negritas, family="text")
		estilo.addElement(TextProperties(fontweight ="bold", color ="#6e7073"))
		self.UpdateEstilos(negritas,estilo)
		#Estilo para el pie de pagina
		footer = "Footer 1"
		estilo = Style(name="Pie", family="paragraph")
		estilo.addElement(ParagraphProperties(attributes={"textalign": "center", 'padding' : "0cm"}))
		estilo.addElement(TextProperties(fontsize = "9pt", color ="#3a3b3d"))
		self.UpdateEstilos(footer,estilo)
		#conjunto de tabuladores 1 (PARA LA HOJA DE LISTADOS)
		tabstops_list = TabStops()
		#Cada tabulador
		tabstop = TabStop(position="2.5cm")
		tabstops_list.addElement(tabstop)
		tabstop = TabStop(position="4.6cm")
		tabstops_list.addElement(tabstop)
		tabstop = TabStop(position="5.5cm")
		tabstops_list.addElement(tabstop)
		tabstop = TabStop(position="12.5cm")
		tabstops_list.addElement(tabstop)
		tabstop = TabStop(position="14.5cm")
		tabstops_list.addElement(tabstop)
		tabstoppar = ParagraphProperties()
		tabstoppar.addElement(tabstops_list)
		tabuladores_base = "Tabuladores Base"
		estilo = Style(name = tabuladores_base, family="paragraph", parentstylename = "Base")
		estilo.addElement(tabstoppar)
		self.UpdateEstilos(tabuladores_base,estilo)
		#conjunto de tabuladores 2 (PARA LA HOJA RESUMEN)
		tabstops_list_resumen = TabStops()
		#Cada tabulador
		tabstop2 = TabStop(position="1.2m")
		tabstops_list_resumen.addElement(tabstop2)
		tabstop2 = TabStop(position="12.5cm")
		tabstops_list_resumen.addElement(tabstop2)
		tabstoppar_resumen = ParagraphProperties()
		tabstoppar_resumen.addElement(tabstops_list_resumen)
		tabuladores_hoja_resumen = "Tabuladores Hoja Resumen"
		estilo = Style(name = tabuladores_hoja_resumen, family="paragraph")
		estilo.addElement(tabstoppar_resumen)
		self.UpdateEstilos(tabuladores_hoja_resumen,estilo)
		#negritas normales
		negritas_normales = "Negritas normales"
		estilo = Style(name = negritas_normales, family="paragraph")
		estilo.addElement(TextProperties(fontweight ="bold", fontfamily="helvetica"))
		self.UpdateEstilos(negritas_normales,estilo)
		#negritas con tabuladores
		negritas_con_tabuladores = "Negritas con tabuladores"
		estilo = Style(name=negritas_con_tabuladores, family="paragraph", parentstylename = tabuladores_base)
		estilo.addElement(TextProperties(fontweight ="bold", fontfamily="helvetica"))
		self.UpdateEstilos(negritas_con_tabuladores,estilo)
		#negritas con tabuladores y linea inferior
		negritas_con_tabuladores_y_linea_inferior = "Negritas con tabuladores y linea"
		estilo = Style(name = negritas_con_tabuladores_y_linea_inferior, family="paragraph", parentstylename = tabuladores_base)
		estilo.addElement(TextProperties(fontweight ="bold", fontfamily="helvetica"))
		estilo.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="0cm", \
			contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.06cm", padding="0cm", borderleft="none", borderright="none", \
			bordertop="none", borderbottom="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.UpdateEstilos(negritas_con_tabuladores_y_linea_inferior,estilo)
		#normal con tabuladores
		normal_con_tabuladores = "Normal con tabuladores"
		estilo = Style(name = normal_con_tabuladores, family="paragraph", parentstylename = tabuladores_base)
		estilo.addElement(TextProperties(fontweight ="light", fontfamily="helvetica", fontsize="10pt"))
		self.UpdateEstilos(normal_con_tabuladores,estilo)
		#normal con tabuladores hoja resumen
		normal_con_tabuladores_resumen = "Normal con tabuladores hoja resumen"
		estilo = Style(name = normal_con_tabuladores_resumen, family="paragraph", parentstylename = tabuladores_hoja_resumen)
		estilo.addElement(TextProperties(fontweight ="light", fontfamily="helvetica", fontsize="10pt"))
		self.UpdateEstilos(normal_con_tabuladores_resumen,estilo)
		#linea horizontal gruesa
		linea_horizontal_gruesa = "Linea horizontal gruesa"
		estilo = Style(name = linea_horizontal_gruesa, displayname="Horizontal Line Thick", family="paragraph", parentstylename="Standard")
		estilo.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="0cm", \
			contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.06cm", padding="0cm", borderleft="none", borderright="none", \
			bordertop="none", borderbottom="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.UpdateEstilos(linea_horizontal_gruesa,estilo)
		#linea horizontal fina
		linea_horizontal_fina = "Linea horizontal fina"
		estilo = Style(name = linea_horizontal_fina, displayname="Horizontal Line Thin", family="paragraph", parentstylename="Standard")
		estilo.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="0cm", \
		contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.02cm", padding="0cm", borderleft="none", borderright="none", \
		bordertop="none", borderbottom="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.UpdateEstilos(linea_horizontal_fina,estilo)
		#numeracion
		numeracion = "Numeracion"
		estilo = Style(name = numeracion, displayname="Numeracion", family="paragraph", parentstylename="Standard")
		#estilo.addElement(ParagraphProperties(attributes={"textalign": "center", 'padding' : "0cm"}))
		estilo.addElement(TextProperties(selectpage="current"))
		self.UpdateEstilos(numeracion,estilo)
	def Documento(self):
		return self.textDoc	
	def Estilo(self,nombre):
		return self.estilos[nombre]
	def UpdateEstilos (self, nombre, estilo):
		self.s.addElement(estilo)
		self.estilos.update({nombre : estilo})	
		
		
		
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
