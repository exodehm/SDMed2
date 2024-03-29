#-------------------------------------------------
#
# Project created by QtCreator 2018-07-14T00:01:04
#
#-------------------------------------------------

QT += core gui


greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = SDMed2
TEMPLATE = app

#CONFIG += static

SOURCES += main.cpp\
    Dialogos/dialogocontrasenna.cpp \
    Dialogos/dialogocredencialesconexionadmin.cpp \
    Dialogos/dialogodatosconexion.cpp \
    Dialogos/dialogotipoaperturabc3.cpp \
    Dialogos/lineeditip.cpp \
    codificacion.cpp \
    mainwindow.cpp \
    Delegados/delegadoarbol.cpp \
    Delegados/delegadobase.cpp \
    Delegados/delegadocodigos.cpp \
    Delegados/delegadocolumnasbloqueadas.cpp \
    Delegados/delegadoformulasmedicion.cpp \
    Delegados/delegadoiconos.cpp \
    Delegados/delegadonumerosbase.cpp \
    Delegados/delegadonumerostablamedcert.cpp \
    Delegados/delegadonumerostablaprincipal.cpp \
    Delegados/delegadotablapropiedades.cpp \        
    Dialogos/dialogoconfiguracion.cpp \    
    Dialogos/dialogogoopcionespagina.cpp \
    Dialogos/dialogolistadoimprimir.cpp \
    Dialogos/dialogomensajeconexioninicial.cpp \
    Dialogos/dialogosudo.cpp \
    Dialogos/dialogotablaopcionesimpresion.cpp \
    Dialogos/dialogoabout.cpp \
    Dialogos/dialogocreditos.cpp \
    Dialogos/dialogolicencia.cpp \
    Dialogos/dialogodatoscodigoresumen.cpp \
    Dialogos/dialogosuprimirmedicion.cpp \
    Dialogos/dialogoprecio.cpp \
    Dialogos/dialogoadvertenciaborrarbbdd.cpp \
    Dialogos/dialogocertificaciones.cpp \
    Dialogos/dialogoeditorformulasmedicion.cpp \
    Dialogos/dialogoajustar.cpp \
    Dialogos/dialogogestionobras.cpp \
    Dialogos/dialogodatosgenerales.cpp \
    Ficheros/importarBC3.cpp \
    Ficheros/exportarBC3.cpp \
    instancia.cpp \
    consultas.cpp \
    Tablas/tablaprincipal.cpp \
    Tablas/vistaarbol.cpp \
    Tablas/tablabase.cpp \
    Tablas/tablacert.cpp \
    Tablas/tablamed.cpp \
    Tablas/filtrotablabase.cpp \
    Tablas/filtrotablamediciones.cpp \
    Tablas/marca.cpp \
    Tablas/tablapropiedades.cpp \
    Editor/editor.cpp \    
    iconos.cpp \
    Modelos/treeitem.cpp \
    Modelos/TreeModel.cpp \    
    Modelos/Modelobase.cpp \
    Modelos/MedicionModel.cpp \
    Modelos/PrincipalModel.cpp \
    Modelos/PropiedadesModel.cpp \
    Undo/undoeditarprincipal.cpp \    
    Undo/undoinsertarprincipal.cpp \
    Undo/undoeditarmedicion.cpp \    
    pyrun.cpp \
    imprimir.cpp \
    Undo/undoajustar.cpp \    
    miundostack.cpp \
    Undo/undobase.cpp

HEADERS  += mainwindow.h \
    Delegados/delegadoarbol.h \
    Delegados/delegadobase.h \
    Delegados/delegadocodigos.h \
    Delegados/delegadocolumnasbloqueadas.h \
    Delegados/delegadoformulasmedicion.h \
    Delegados/delegadoiconos.h \
    Delegados/delegadonumerosbase.h \
    Delegados/delegadonumerostablamedcert.h \
    Delegados/delegadonumerostablaprincipal.h \
    Delegados/delegadotablapropiedades.h \
    Dialogos/dialogoabout.h \
    Dialogos/dialogoconfiguracion.h \
    Dialogos/dialogocontrasenna.h \
    Dialogos/dialogocredencialesconexionadmin.h \
    Dialogos/dialogodatosconexion.h \
    Dialogos/dialogogoopcionespagina.h \
    Dialogos/dialogolicencia.h \
    Dialogos/dialogocreditos.h \
    Dialogos/dialogodatoscodigoresumen.h \
    Dialogos/dialogolistadoimprimir.h \
    Dialogos/dialogomensajeconexioninicial.h \
    Dialogos/dialogosudo.h \
    Dialogos/dialogotablaopcionesimpresion.h \
    Dialogos/dialogogestionobras.h \
    Dialogos/dialogoadvertenciaborrarbbdd.h \
    Dialogos/dialogodatosgenerales.h \
    Dialogos/dialogoprecio.h \
    Dialogos/dialogosuprimirmedicion.h \
    Dialogos/dialogoajustar.h \
    Dialogos/dialogocertificaciones.h \
    Dialogos/dialogoeditorformulasmedicion.h \
    Dialogos/dialogotipoaperturabc3.h \
    Dialogos/lineeditip.h \
    Ficheros/importarBC3.h \
    Ficheros/exportarBC3.h \
    codificacion.h \
    instancia.h \
    consultas.h \
    Tablas/tablabase.h \
    Tablas/tablaprincipal.h \
    Tablas/tablacert.h \
    Tablas/tablamed.h \
    Tablas/vistaarbol.h \
    Tablas/filtrotablabase.h \
    Tablas/filtrotablamediciones.h \
    Tablas/marca.h \
    Tablas/tablapropiedades.h \
    Editor/editor.h \    
    iconos.h \    
    defs.h \    
    Modelos/Modelobase.h \
    Undo/undoeditarprincipal.h \
    Undo/undoinsertarprincipal.h \
    Undo/undoeditarmedicion.h \
    Modelos/PrincipalModel.h \
    pyrun.h \
    Modelos/MedicionModel.h \
    Modelos/PropiedadesModel.h \
    Modelos/treeitem.h \
    Modelos/TreeModel.h \
    imprimir.h \
    Undo/undoajustar.h \    
    miundostack.h \
    Undo/undobase.h \




FORMS    += Ui/mainwindow.ui \
    Ui/dialogoconfiguracion.ui \
    Ui/dialogocontrasenna.ui \
    Ui/dialogoabout.ui \    
    Ui/dialogocredencialesconexionadmin.ui \
    Ui/dialogocreditos.ui \
    Ui/dialogodatosconexion.ui \
    Ui/dialogogoopcionespagina.ui \
    Ui/dialogolicencia.ui \
    Ui/dialogolistadoimprimir.ui \
    Ui/dialogomensajeconexioninicial.ui \
    Ui/dialogoprecio.ui \
    Ui/dialogosudo.ui \
    Ui/dialogosuprimirmedicion.ui \
    Ui/dialogodatoscodigoresumen.ui \
    Editor/editor.ui \
    Ui/dialogoadvertenciaborrarbbdd.ui \
    Ui/dialogocertificaciones.ui \
    Ui/dialogoajustar.ui \
    Ui/dialogotablaopcionesimpresion.ui \
    Ui/dialogoeditorformulasmedicion.ui \
    Ui/dialogodatosgenerales.ui \
    Ui/dialogogestionobras.ui \
    Ui/dialogotipoaperturabc3.ui \
    Ui/lineeditip.ui

QT += sql

CONFIG += c++11

RESOURCES += \
    fuentes.qrc \
    postgres_extension.qrc \
    recursos.qrc \
    Editor/iconosEditor.qrc \
    iconos.qrc \
    scripts_python.qrc

unix {
    INCLUDEPATH += /usr/include/python3.10
    #LIBS += -L /usr/lib/python3.6m -lpython3.6m
    LIBS += -L/usr/lib/x86_64-linux-gnu/ -lpython3.10
    #LIBS += -lpython3.8
    #LIBS += -Wl,-Bstatic -lpython3.8 -Wl,-Bdynamic
    #LIBS += -lz
    #LIBS +=/usr/lib/x86_64-linux-gnu/libz.a
    #LIBS+= -L/usr/lib -L. -ldl /usr/lib/x86_64-linux-gnu/libelf.a $(PTHREAD_LIBS) -lz
    #DEPENDPATH +=  /usr/include/python3.6m
    #LIBS += -BStatic -L/usr/lib/x86_64-linux-gnu/ -licudata -licui18n -licuuc
    #LIBS += /usr/lib/x86_64-linux-gnu/libicuuc.a /usr/lib/x86_64-linux-gnu/libicudata.a /usr/lib/x86_64-linux-gnu/libicui18n.a
    #LIBS +=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/libpython3.6m.a
}

win32 {
    INCLUDEPATH += C:\Users\David\AppData\Local\Programs\Python\Python39\include
    #INCLUDEPATH += Python39\include
    LIBS += -L C:\Users\David\AppData\Local\Programs\Python\Python39\libs -lpython39
    #LIBS += -L Python39\libs -lpython39
    DEPENDPATH += C:\Users\David\AppData\Local\Programs\Python\Python39\include
    #DEPENDPATH += Python39\include
}

DISTFILES += \
    Fuentes/Comfortaa-Regular.ttf \
    python/instalador_scripts.zip
