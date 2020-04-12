from estilos import Estilos
from odf.opendocument import OpenDocumentText
from odf.style import PageLayout, MasterPage, Header, Footer, Style, TextProperties, ParagraphProperties, PageLayoutProperties, TabStop, TabStops
from odf.text import P,H,Span,LineBreak
from odf import teletype

textDoc = OpenDocumentText()
h = Header()
f = Footer()
s = textDoc.styles
pl = PageLayout(name="pagelayout")
textDoc.automaticstyles.addElement(pl)
mp = MasterPage(name="Standard", pagelayoutname=pl)
textDoc.masterstyles.addElement(mp)
ContenedorEstilos = Estilos()
#################################
#s.addElement(ContenedorEstilos.LineaHorizontalGruesa())
'''parrafo = P(stylename = ContenedorEstilos.LineaHorizontalGruesa())	
teletype.addTextToElement(parrafo, " ")
textDoc.text.addElement(parrafo)'''

'''s.addElement(ContenedorEstilos.Colores())
parrafo = P(stylename = ContenedorEstilos.Colores())	
teletype.addTextToElement(parrafo, "ALGO")
textDoc.text.addElement(parrafo)'''
s.addElement(ContenedorEstilos.Colores())
texto_cabecera = P(stylename=ContenedorEstilos.Colores(), text="Proyecto:\t")
textDoc.text.addElement(texto_cabecera)



textDoc.save("probador.odt")


