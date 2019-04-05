//#include "exportarXLS.h"
#include "/usr/include/python3.5m/Python.h"
#include <QDebug>
#include <QString>


void CrearXLS(PyObject* funcion, PyObject* argumentos);

#include <iostream>

namespace XLS
{
/*void CrearXLS(PyObject* funcion, PyObject* argumentos)
    {
        PyObject_CallObject(funcion,argumentos);
        Py_DECREF(funcion);
        Py_DECREF(argumentos);
    }*/

#include <setjmp.h>
#include <signal.h>

static sigjmp_buf env;
static void catch_segv(int func)
{
    siglongjmp(env, 1);
}

int crearFuncion(QString nombrefichero, const QList<QList<QString> > &datos)
{
    PyObject* fExportar = nullptr;
    PyObject* modulo = nullptr;
    PyObject* pName = nullptr;
    const char *scriptDirectoryName = "/home/david/programacion/Qt/SDMed2/SDMed2/python/ExportadorXLS/";
    Py_InitializeEx(1); // NOTE: skip signal handlers being registered - for embedding
    PyObject *sysPath = PySys_GetObject("path");
    PyObject *path = PyUnicode_FromString(scriptDirectoryName);
    int result = PyList_Insert(sysPath, 0, path);
    if (result == 0 )//0 if ok, -1 if error
    {
        pName = PyUnicode_FromString("exportarXLS");//exportarXLS.py
        modulo = PyImport_Import(pName);
        Py_DECREF(path);
        if (modulo)
        {
            fExportar = PyObject_GetAttrString(modulo, "exportar");//it crahs here
            Py_DECREF(modulo);
            if (fExportar)
            {
                PyObject *tupla = PyTuple_New(4);
                //for(Py_ssize_t i = 0; i < 4; i++)
                //PyObject *the_object = PyLong_FromSsize_t(i * tuple_length + j);
                PyObject* pValue1 = Py_BuildValue("s", "Hola ");
                PyObject* pValue2 = Py_BuildValue("s", "Pepito");
                PyObject* pValue3 = Py_BuildValue("s", "Juanito");
                PyObject* pValue4 = Py_BuildValue("s", "Anita");
                PyTuple_SET_ITEM(tupla, 0, pValue1);
                PyTuple_SET_ITEM(tupla, 1, pValue2);
                PyTuple_SET_ITEM(tupla, 2, pValue3);
                PyTuple_SET_ITEM(tupla, 3, pValue4);
                PyObject_CallObject(fExportar,tupla);
            }// redirect segv handler here:
            sig_t old = signal(SIGSEGV, catch_segv);
            // record an environment to return to with siglongjmp
            if (sigsetjmp(env, 1)) { // returns 0 on setting up, 1 when called with siglongjmp(env, 1)
                // handler called
                Py_Finalize();
                signal(SIGSEGV, old); // restore old handler
                return 1; // return to caller
            } else {
                // this triggers a segv (for the test)
                (reinterpret_cast<sig_t>(0))(1);
                fExportar = PyObject_GetAttrString(modulo, "exportar");//it crahs here
                Py_DECREF(modulo);
                if (fExportar)
                {
                    //call the function
                }
            }
            signal(SIGSEGV, old); // restore old handler
        }
    }
    else
    {
        PyErr_Print();
    }
    Py_Finalize();
    return 0; // return success.
}
}



