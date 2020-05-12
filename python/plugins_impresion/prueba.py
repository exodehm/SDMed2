from odf.opendocument import OpenDocumentText
from odf.style import Style, TextProperties, ParagraphProperties, Footer, MasterPage,PageLayout
from odf.text import H, P, Span, PageNumber

textdoc = OpenDocumentText()
# Styles
s = textdoc.styles
f = Footer()
pl = PageLayout(name="pagelayout")
mp = MasterPage(name="Standard", pagelayoutname=pl)
h1style = Style(name="Heading 1", family="paragraph")
h1style.addElement(TextProperties(attributes={'fontsize':"24pt",'fontweight':"bold" }))
s.addElement(h1style)
# An automatic style
boldstyle = Style(name="Bold", family="text")
boldprop = TextProperties(fontweight="bold")
boldstyle.addElement(boldprop)
textdoc.automaticstyles.addElement(boldstyle)

algo = Style(name = "kk")
numeracion = ParagraphProperties(pagenumber = "2")
algo.addElement(numeracion)
textdoc.automaticstyles.addElement(algo)
# Text
h=H(outlinelevel=1, stylename=h1style, text="My first text")
textdoc.text.addElement(h)
p = P(text="Hello world. ")
boldpart = Span(stylename=boldstyle, text="This part is bold. ")
p.addElement(boldpart)
p.addText("This is after bold.")
textdoc.text.addElement(p)
fp = P(stylename=" foot")
pagina = Span(stylename="foot2", text="Página: ")
fp.addElement(pagina)
numero = PageNumber(selectpage="auto")
fp.addElement(numero)
f.addElement(fp)
mp.addElement(f)

textdoc.save("myfirstdocument.odt")
