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
    Dialogos/dialogotablaslistadoobras.cpp \
    Ficheros/abrirguardarbc3.cpp \
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
    Ficheros/exportarXLS.cpp \
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
    Modelos/PropiedadesModel.cpp

HEADERS  += mainwindow.h \
    Dialogos/dialogoabout.h \
    Dialogos/dialogolicencia.h \
    Dialogos/dialogocreditos.h \
    Dialogos/dialogodatoscodigoresumen.h \
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
    Dialogos/dialogotablaslistadoobras.h \
    Ficheros/abrirguardarbc3.h \
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
    Ficheros/exportarXLS.h \
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
    Modelos/PropiedadesModel.h

FORMS    += Ui/mainwindow.ui \
    Ui/dialogoabout.ui \
    Ui/dialogocreditos.ui \
    Ui/dialogolicencia.ui \
    Ui/dialogoprecio.ui \
    Ui/dialogosuprimirmedicion.ui \
    Ui/dialogodatoscodigoresumen.ui \
    Editor/editor.ui \
    Ui/dialogotablaslistadoobras.ui \
    Ui/dialogoadvertenciaborrarbbdd.ui \
    Ui/dialogocertificaciones.ui \
    Ui/dialogoajustar.ui \    
    Ui/dialogoeditorformulasmedicion.ui \    
    Ui/dialogoconexionbbdd.ui \
    Ui/dialogodatosgenerales.ui


QT += sql

CONFIG += c++11

RESOURCES += \
    recursos.qrc \
    Editor/iconosEditor.qrc \
    iconos.qrc

LIBS += -L /usr/local/lib/python3.6 -lpython3.6m
INCLUDEPATH += /usr/include/python3.6m
DEPENDPATH +=  /usr/include/python3.6m
