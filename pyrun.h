#ifndef PYRUN_H
#define PYRUN_H


//se crea un entorno para cargar modulos en python

#include <QString>
#include <QStringList>

namespace PyRun
{
enum State
{
    PythonUninitialized,
    PythonInitialized,
    AppModuleLoaded
};
bool loadModule(const QString &modulePath, const QString &moduleName, const QString &functionName, const QStringList &args=QStringList());
State init();
}
#endif // PYRUN_H
