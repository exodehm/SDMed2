#-------------------------------------------------
#
# Project created by QtCreator 2018-07-14T00:01:04
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = SDMed2
TEMPLATE = app


SOURCES += main.cpp\
    Delegados/delegadocodigos.cpp \
    Dialogos/dialogoconfiguracion.cpp \
    Dialogos/dialogogoopcionespagina.cpp \
    Dialogos/dialogolistadoimprimir.cpp \
    Dialogos/dialogomensajeconexioninicial.cpp \
    Dialogos/dialogooperacionesbbdd.cpp \
    Dialogos/dialogosudo.cpp \
    Dialogos/dialogotablaopcionesimpresion.cpp \
    Ficheros/importarBC3.cpp \
        mainwindow.cpp \
    Dialogos/dialogoabout.cpp \
    Dialogos/dialogocreditos.cpp \
    Dialogos/dialogolicencia.cpp \
    Dialogos/dialogodatoscodigoresumen.cpp \
    instancia.cpp \
    consultas.cpp \
    Tablas/tablaprincipal.cpp \
    Tablas/vistaarbol.cpp \
    Tablas/tablabase.cpp \
    Editor/editor.cpp \
    Delegados/delegadoarbol.cpp \
    Delegados/delegadobase.cpp \
    Delegados/delegadocolumnasbloqueadas.cpp \
    Delegados/delegadoiconos.cpp \
    Delegados/delegadonumerosbase.cpp \
    Delegados/delegadonumerostablamedcert.cpp \
    Delegados/delegadonumerostablaprincipal.cpp \
    iconos.cpp \
    Modelos/treeitem.cpp \
    Modelos/TreeModel.cpp \
    Dialogos/dialogoadvertenciaborrarbbdd.cpp \
    Modelos/Modelobase.cpp \
    Undo/undoeditarprincipal.cpp \
    Dialogos/dialogosuprimirmedicion.cpp \
    Dialogos/dialogoprecio.cpp \
    Undo/undoinsertarprincipal.cpp \
    Undo/undoeditarmedicion.cpp \
    Modelos/PrincipalModel.cpp \
    pyrun.cpp \    
    Dialogos/dialogocertificaciones.cpp \
    Modelos/MedicionModel.cpp \
    Tablas/tablacert.cpp \
    Tablas/tablamed.cpp \
    Ficheros/exportarBC3.cpp \
    imprimir.cpp \
    Undo/undoajustar.cpp \
    Dialogos/dialogoajustar.cpp \
    miundostack.cpp \
    Undo/undobase.cpp \
    Delegados/delegadoformulasmedicion.cpp \
    Dialogos/dialogoeditorformulasmedicion.cpp \
    Tablas/filtrotablabase.cpp \
    Tablas/filtrotablamediciones.cpp \
    Tablas/marca.cpp \
    Dialogos/dialogoconexionbbdd.cpp \
    Dialogos/dialogodatosgenerales.cpp \
    Tablas/tablapropiedades.cpp \
    Modelos/PropiedadesModel.cpp \
    Delegados/delegadotablapropiedades.cpp \
    Dialogos/dialogogestionobras.cpp

HEADERS  += mainwindow.h \
    Delegados/delegadocodigos.h \
    Dialogos/dialogoabout.h \
    Dialogos/dialogoconfiguracion.h \
    Dialogos/dialogogoopcionespagina.h \
    Dialogos/dialogolicencia.h \
    Dialogos/dialogocreditos.h \
    Dialogos/dialogodatoscodigoresumen.h \
    Dialogos/dialogolistadoimprimir.h \
    Dialogos/dialogomensajeconexioninicial.h \
    Dialogos/dialogooperacionesbbdd.h \
    Dialogos/dialogosudo.h \
    Dialogos/dialogotablaopcionesimpresion.h \
    Ficheros/importarBC3.h \
    instancia.h \
    consultas.h \
    Tablas/tablabase.h \
    Tablas/tablaprincipal.h \
    Tablas/vistaarbol.h \
    Editor/editor.h \
    Delegados/delegadoarbol.h \
    Delegados/delegadobase.h \
    Delegados/delegadocolumnasbloqueadas.h \
    Delegados/delegadoiconos.h \
    Delegados/delegadonumerosbase.h \
    Delegados/delegadonumerostablamedcert.h \
    Delegados/delegadonumerostablaprincipal.h \
    iconos.h \
    Modelos/treeitem.h \
    Modelos/TreeModel.h \
    defs.h \
    Dialogos/dialogoadvertenciaborrarbbdd.h \
    Modelos/Modelobase.h \
    Undo/undoeditarprincipal.h \
    Dialogos/dialogosuprimirmedicion.h \
    Dialogos/dialogoprecio.h \
    Undo/undoinsertarprincipal.h \
    Undo/undoeditarmedicion.h \
    Modelos/PrincipalModel.h \
    pyrun.h \    
    Dialogos/dialogocertificaciones.h \
    Modelos/MedicionModel.h \
    Tablas/tablacert.h \
    Tablas/tablamed.h \
    Ficheros/exportarBC3.h \
    imprimir.h \
    Undo/undoajustar.h \
    Dialogos/dialogoajustar.h \
    miundostack.h \
    Undo/undobase.h \
    Delegados/delegadoformulasmedicion.h \
    Dialogos/dialogoeditorformulasmedicion.h \
    Tablas/filtrotablabase.h \
    Tablas/filtrotablamediciones.h \
    Tablas/marca.h \
    Dialogos/dialogoconexionbbdd.h \
    Dialogos/dialogodatosgenerales.h \
    Tablas/tablapropiedades.h \
    Modelos/PropiedadesModel.h \
    Delegados/delegadotablapropiedades.h \
    Dialogos/dialogogestionobras.h

FORMS    += Ui/mainwindow.ui \
    Ui/dialogoabout.ui \
    Ui/dialogoconfiguracion.ui \
    Ui/dialogocreditos.ui \
    Ui/dialogogoopcionespagina.ui \
    Ui/dialogolicencia.ui \
    Ui/dialogolistadoimprimir.ui \
    Ui/dialogomensajeconexioninicial.ui \
    Ui/dialogooperacionesbbdd.ui \
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
    Ui/dialogoconexionbbdd.ui \
    Ui/dialogodatosgenerales.ui \
    Ui/dialogogestionobras.ui


QT += sql

CONFIG += c++11

RESOURCES += \
    fuentes.qrc \
    postgres_extension.qrc \
    recursos.qrc \
    Editor/iconosEditor.qrc \
    iconos.qrc


unix {
    INCLUDEPATH += /usr/include/python3.6m
    LIBS += -L /usr/local/lib/python3.6 -lpython3.6m
    DEPENDPATH +=  /usr/include/python3.6m
}

win32 {
    INCLUDEPATH += C:\Python\Python37\include
    LIBS += -L C:\Python\Python37\libs -lpython37
    DEPENDPATH += C:\Python\Python37\include
}

DISTFILES += \
    Fuentes/Comfortaa-Regular.ttf
