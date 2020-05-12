from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties
from odf.text import P,H,Span,LineBreak, PageNumber
from odf import teletype, opendocument,text

class Plantilla():	
	def __init__(self,*datos):
		self.textDoc = OpenDocumentText()
		self.h = Header()
		self.f = Footer()
		self.s = self.textDoc.styles		
		self.pl = PageLayout(name="pagelayout")
		#datos para la cabecera
		Autor = datos[0]
		Obra = datos[1]		
		#margenes para la pagina (PageLayout)		
		layoutPagina = datos[2]
		print ("layoutPagina")
		print (layoutPagina)
		MRight  = str(layoutPagina[0])+"cm"
		print ("MRight " + MRight)
		MLeft  = str(layoutPagina[1])+"cm"
		MTop  = str(layoutPagina[2])+"cm"
		MBottom  = str(layoutPagina[3])+"cm"
		PaginaInicial = layoutPagina[4]
		#anadimos los datos a la pagina
		self.pl.addElement(PageLayoutProperties(margintop=MTop, marginbottom=MBottom,marginleft=MRight,marginright=MLeft))		
		self.textDoc.automaticstyles.addElement(self.pl)
		self.mp = MasterPage(name="Standard", pagelayoutname=self.pl)
		self.textDoc.masterstyles.addElement(self.mp)		
		#Cabecera estilos
		#Normal
		EstiloCabeceraNormal = "CabeceraNormal"
		estilo = Style(name=EstiloCabeceraNormal, family="text", parentstylename = "Standard")
		estilo.addElement(TextProperties(fontweight="light", fontfamily = "helvetica", fontsize = "9pt"))
		self.s.addElement(estilo)
		#Negritas
		EstiloCabeceraNegritas = "CabeceraNegritas"
		estilo = Style(name=EstiloCabeceraNegritas, family="text", parentstylename = EstiloCabeceraNormal)
		estilo.addElement(TextProperties(fontweight="bold"))
		self.s.addElement(estilo)
		#Normal centrado
		EstiloCabeceraNormalCentrado = "CabeceraNormalCentrado"
		estilo = Style(name=EstiloCabeceraNormalCentrado, family="paragraph",  parentstylename = EstiloCabeceraNormal)
		estilo.addElement(ParagraphProperties(textalign = "center", numberlines="true", linenumber="0"))
		self.s.addElement(estilo)
		#linea horizontal fina		
		linea_horizontal_fina = Style(name = "Lineahorizontalfina", displayname="Horizontal Line Thin", family="paragraph")
		linea_horizontal_fina.addElement(ParagraphProperties(margintop="0cm", marginbottom="0cm", marginright="0cm", marginleft="0cm", \
		contextualspacing="false", borderlinewidthbottom="0cm 0.030cm 0.02cm", padding="0cm", borderleft="none", borderright="none", \
		bordertop="none", borderbottom="0.06pt double #3a3b3d", numberlines="false", linenumber="0", joinborder="false"))
		self.s.addElement(linea_horizontal_fina)
		#numeracion
		numeracion = "Numeracion"
		estilo = Style(name = numeracion, family="paragraph")
		#estilo.addElement(PageNumber(selectpage="current"))
		#Cabecera contenidos
		hp = P()
		texto_cabecera = Span(stylename=EstiloCabeceraNegritas, text="Proyecto:\t")
		hp.addElement(texto_cabecera)
		texto_cabecera = Span(stylename=EstiloCabeceraNormal, text=Obra)
		hp.addElement(texto_cabecera)
		self.h.addElement(hp)
		hp = P()
		texto_cabecera = Span(stylename=EstiloCabeceraNegritas, text="Autor:\t")
		hp.addElement(texto_cabecera)
		texto_cabecera = Span(stylename=EstiloCabeceraNormal, text=Autor)
		hp.addElement(texto_cabecera)
		self.h.addElement(hp)
		hp = P(stylename=linea_horizontal_fina)
		self.h.addElement(hp)
		self.mp.addElement(self.h)
		#Pie de pagina
		fp = P(stylename=EstiloCabeceraNormalCentrado)
		pagina = Span(stylename=EstiloCabeceraNormal, text="Página: ")
		fp.addElement(pagina)
		numero = PageNumber(selectpage="auto", text=4)
		fp.addElement(numero)		
		self.f.addElement(fp)
		self.mp.addElement(self.f)
	def Documento(self):
		return self.textDoc	
	def Estilo(self,nombre):
		return self.estilos[nombre]
	def UpdateEstilos (self, nombre, estilo):
		self.s.addElement(estilo)
		self.estilos.update({nombre : estilo})
