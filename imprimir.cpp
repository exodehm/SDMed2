#include "imprimir.h"
#include "pyrun.h"
#include <QDebug>
#include <QDir>

Imprimir::Imprimir(const char* ruta, const char* nombremodulo, const char* nombrefuncion)
{
    if(::PyRun::loadPlugins(QDir::current().absoluteFilePath(ruta), nombremodulo, nombrefuncion))
    {
        qDebug()<< __PRETTY_FUNCTION__ << "successful";
    }
}

Imprimir::~Imprimir()
{
    /*Py_DECREF(pFuncion);
    Py_Finalize();*/
    qDebug()<<"Saliendo";
}

