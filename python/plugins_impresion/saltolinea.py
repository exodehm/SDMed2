from odf.opendocument import OpenDocumentText
from odf.text import P
from odf.style import Style, TextProperties, ParagraphProperties

def saltolinea(documento):
	withbreak = Style(name="WithBreak", parentstylename="Standard", family="paragraph")
	withbreak.addElement(ParagraphProperties(breakafter="page"))
	documento.automaticstyles.addElement(withbreak)
	p = P(stylename=withbreak)
	documento.text.addElement(p)
	return documento
