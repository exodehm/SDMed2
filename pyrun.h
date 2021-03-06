#ifndef PYRUN_H
#define PYRUN_H


//se crea un entorno para cargar modulos en python

#include <QString>
#include <QStringList>
#include <QVariant>

namespace PyRun
{
enum State
{
    PythonUninitialized,
    PythonInitialized,
    AppModuleLoaded
};
enum Resultado
{
    CannotLoadModule,
    CannotConvertArgument,
    CallFailed,
    CannotFindFunction,
    FailedToLoad,
    Success
};

//bool loadModule(const QString &modulePath, const QString &moduleName, const QString &functionName, const QStringList &args=QStringList());
QPair<int,QVariant> loadModule(const QString &modulePath, const QString &moduleName, const QString &functionName, const QStringList &args=QStringList());
State init();
}
#endif // PYRUN_H
