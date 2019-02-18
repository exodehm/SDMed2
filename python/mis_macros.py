import uno

def mimacro():
	doc = XSCRIPTCONTEXT.getDocument()
	text = doc.getText()
	text.setString("\"Hola mundo con python Uno\"")
	return
	
