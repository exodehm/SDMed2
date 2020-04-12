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
		#normal
		normal = "Normal"
		estilo = Style(name = normal, family="text")
		estilo.addElement(TextProperties(fontfamily = "helvetica", fontsize = "10pt"))
		self.UpdateEstilos(normal,estilo)
		#negritas
		negritas = "Negritas"
		estilo = Style(name = negritas, family="text", parentstylename = normal)
		estilo.addElement(TextProperties(fontweight ="bold"))
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
		tabstop1 = TabStop(position="2.5cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="4.0cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="4.8cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="13.0cm")
		tabstops_list.addElement(tabstop1)
		tabstop1 = TabStop(position="15.0cm")
		tabstops_list.addElement(tabstop1)
		tabstoppar_capitulos = ParagraphProperties()
		tabstoppar_capitulos.addElement(tabstops_list)
		#estilo tabuladores normal
		tabuladores_normal = "Tabuladores Hoja Listados Normal"
		estilo = Style(name = tabuladores_normal, family="paragraph", parentstylename = normal_parrafo)
		estilo.addElement(tabstoppar_capitulos)
		self.UpdateEstilos(tabuladores_normal,estilo)
		#estilo tabuladores negritas
		tabuladores_negritas = "Tabuladores Hoja Listados Negritas"
		estilo = Style(name = tabuladores_negritas, family="paragraph", parentstylename = tabuladores_normal)
		#estilo.addElement(tabstoppar_capitulos)
		self.UpdateEstilos(tabuladores_negritas,estilo)		
		#linea horizontal gruesa
		linea_horizontal_gruesa = "Linea horizontal gruesa"
		estilo = Style(name = linea_horizontal_gruesa, displayname="Horizontal Line Thick", family="paragraph", parentstylename="Standard")
		estilo.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="0cm", \
			contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.06cm", padding="0cm", borderleft="none", borderright="none", \
			bordertop="none", borderbottom="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.UpdateEstilos(linea_horizontal_gruesa,estilo)		
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
