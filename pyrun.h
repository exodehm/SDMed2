#ifndef PYRUN_H
#define PYRUN_H

#include <QString>


class QString;

namespace PyRun
{
enum State
{
    PythonUninitialized,
    PythonInitialized,
    AppModuleLoaded
};
bool loadPlugins(const QString &modulePath, const QString &moduleName, const QString &function);
State init();
}
#endif // PYRUN_H
