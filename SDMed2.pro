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
    Tablas/tablamedcert.cpp \
    Tablas/tablaprincipal.cpp \
    Tablas/vistaarbol.cpp \
    Tablas/tablabase.cpp \
    Editor/editor.cpp \
    Editor/micustomtextedit.cpp \
    Delegados/delegadoarbol.cpp \
    Delegados/delegadobase.cpp \
    Delegados/delegadocolumnasbloqueadas.cpp \
    Delegados/delegadoiconos.cpp \
    Delegados/delegadonumerosbase.cpp \
    Delegados/delegadonumerostablamedcert.cpp \
    Delegados/delegadonumerostablaprincipal.cpp \
    iconos.cpp \
    filter.cpp \
    Modelos/MedCertModel.cpp \
    Modelos/PrincipalModel.cpp \
    Modelos/treeitem.cpp \
    Modelos/TreeModel.cpp \
    Modelos/tablaprincipalmodel.cpp \
    Dialogos/dialogotablaslistadoobras.cpp \
    Ficheros/abrirguardarbc3.cpp \
    metaobra.cpp

HEADERS  += mainwindow.h \
    Dialogos/dialogoabout.h \
    Dialogos/dialogolicencia.h \
    Dialogos/dialogocreditos.h \
    Dialogos/dialogodatoscodigoresumen.h \
    instancia.h \
    consultas.h \
    Tablas/tablabase.h \
    Tablas/tablamedcert.h \
    Tablas/tablaprincipal.h \
    Tablas/vistaarbol.h \
    Editor/editor.h \
    Editor/micustomtextedit.h \
    Delegados/delegadoarbol.h \
    Delegados/delegadobase.h \
    Delegados/delegadocolumnasbloqueadas.h \
    Delegados/delegadoiconos.h \
    Delegados/delegadonumerosbase.h \
    Delegados/delegadonumerostablamedcert.h \
    Delegados/delegadonumerostablaprincipal.h \
    iconos.h \
    filter.h \
    Modelos/MedCertModel.h \
    Modelos/PrincipalModel.h \
    Modelos/treeitem.h \
    Modelos/TreeModel.h \
    Modelos/tablaprincipalmodel.h \
    defs.h \
    Dialogos/dialogotablaslistadoobras.h \
    Ficheros/abrirguardarbc3.h \
    metaobra.h

FORMS    += Ui/mainwindow.ui \
    Ui/dialogoabout.ui \
    Ui/dialogoajustarprecio.ui \
    Ui/dialogocreditos.ui \
    Ui/dialogolicencia.ui \
    Ui/dialogoprecio.ui \
    Ui/dialogosuprimirmedicion.ui \
    Ui/dialogodatoscodigoresumen.ui \
    Editor/editor.ui \
    Ui/dialogotablaslistadoobras.ui

QT += sql

CONFIG += c++11

RESOURCES += \
    recursos.qrc \
    Editor/iconosEditor.qrc \
    iconos.qrc
