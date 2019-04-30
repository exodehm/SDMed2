#include "imprimir.h"
#include "pyrun.h"
#include <QDebug>
#include <QDir>

Imprimir::Imprimir(const char* ruta, const char* nombremodulo, const char* nombrefuncion, QSqlDatabase db)
{
    QStringList datosConexion;
    datosConexion<<db.databaseName()<<db.hostName()<<QString::number(db.port())<<db.userName()<<db.password();
    if(::PyRun::loadModule(QDir::current().absoluteFilePath(ruta), nombremodulo, nombrefuncion, datosConexion))
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

