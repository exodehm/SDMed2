#include "Python.h"
#include "./pyrun.h"

#include <QByteArray>
#include <QCoreApplication>
#include <QDebug>

namespace PyRun
{
static State state = PythonUninitialized;

static void cleanup()
{
    if (state > PythonUninitialized) {
        Py_Finalize();
        state = PythonUninitialized;
    }
}

QPair<int,QVariant> loadModule(const QString &modulePath, const QString &moduleName, const QString &functionName, const QStringList& args)
{
    qDebug()<<"modulepath"<<modulePath;
    QPair <int,QVariant>resultado;
    QVariant valor;
    qputenv("PYTHONPATH", modulePath.toLocal8Bit());
    if (init() != AppModuleLoaded)
    {
        resultado.first=CannotLoadModule;
        resultado.second=QVariant();
        return resultado;
    }
    PyObject *pName, *pModule, *pFunc;
    PyObject *pArgs, *pValue;
    pName = PyUnicode_DecodeFSDefault(moduleName.toLocal8Bit().constData());
    /* Error checking of pName left out */
    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    if (pModule)
    {
        pFunc = PyObject_GetAttrString(pModule, functionName.toLocal8Bit().constData());
        /* pFunc is a new reference */
        if (pFunc && PyCallable_Check(pFunc))
        {
            /* pValue reference stolen here: */
            pArgs = PyTuple_New(args.size());
            for (int i = 0;i<args.size();i++)
            {
                PyObject* arg_valor = Py_BuildValue("s",args.at(i).toLocal8Bit().constData());
                if (!arg_valor)
                {
                    Py_DECREF(pArgs);
                    Py_DECREF(pModule);
                    qWarning("Cannot convert argument\n");
                    resultado.first=CannotConvertArgument;
                    resultado.second=QVariant();
                    return resultado;
                }
                PyTuple_SetItem(pArgs, i, arg_valor);//meto los datos de conexion
            }
            pValue = PyObject_CallObject(pFunc, pArgs);
            Py_DECREF(pArgs);
            if (pValue){
                qWarning("Result of call: %ld\n", PyLong_AsLong(pValue));
                PyObject* repr = PyObject_Repr(pValue);
                PyObject* str = PyUnicode_AsEncodedString(repr, "utf-8", "strict");
                char* raw_result = PyBytes_AsString(str);
                QString result = QString(raw_result).remove('\'');
                qDebug()<<"result "<<result;
                valor = QVariant(result);
                Py_DECREF(pValue);
            }
            else
            {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
                PyErr_Print();
                qWarning("Call failed\n");
                resultado.first=CallFailed;
                resultado.second=QVariant();
                return resultado;
            }
        }
        else
        {
            if (PyErr_Occurred())
                PyErr_Print();
            qWarning("Cannot find function \"%s\"\n", functionName.toLocal8Bit().constData());
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }
    else
    {
        PyErr_Print();
        qWarning("Failed to load \"%s\"\n", moduleName.toLocal8Bit().constData());
        resultado.first=FailedToLoad;
        resultado.second=QVariant();
        return resultado;
    }
    resultado.first=Success;
    resultado.second=valor;
    return resultado;
}

State init()
{
    if (state > PythonUninitialized)
        return state;
    QByteArray virtualEnvPath = qgetenv("VIRTUAL_ENV");
    if (!virtualEnvPath.isEmpty())
        qputenv("PYTHONHOME", virtualEnvPath);
    Py_Initialize();
    qAddPostRoutine(cleanup);
    state = PythonInitialized;
    const bool pyErrorOccurred = PyErr_Occurred() != nullptr;
    if (!pyErrorOccurred) {
        state = AppModuleLoaded;
    } else {
        if (pyErrorOccurred)
            PyErr_Print();
        qWarning("Failed to initialize the module.");
    }
    return state;
}
}
