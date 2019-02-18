#ifndef PYRUN_H
#define PYRUN_H

#include "python_wrapper.h"

#include <QString>


class PyRun
{
public:
    PyRun();
    PyRun(QString execFile);
    ~PyRun();
    QString cssmin(QString);

private:
    std::wstring execFile;
    std::wstring pythonPath;
    bool hasError();
    PyObject* importModule(const QString&);
    PyObject* callFunction(PyObject*, QString, PyObject*);
    QString ObjectToString(PyObject*poVal);
};

#endif // PYRUN_H
