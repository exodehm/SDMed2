#include "pyrun.h"
//#include <marshal.h>

#include <QDebug>
#include <QDir>
#include <QProcess>


PyRun::PyRun()
{
    qDebug()<<"Constructor pyRun";
    //const char *scriptDirectoryName = "/home/david/programacion/python/PlugingsAPI/";
    const char *scriptDirectoryName = "/home/david/programacion/Qt/SDMed2/SDMed2/python/";
    Py_Initialize();
    PyObject *sysPath = PySys_GetObject("path");
    PyObject *path = PyUnicode_FromString(scriptDirectoryName);
    int result = PyList_Insert(sysPath, 0, path);
    qDebug()<<"result: "<<result;
    PyObject* pluginModule = PyImport_Import(PyUnicode_FromString("mis_macros"));
    qDebug()<<"modulo: "<<pluginModule;
    Py_DECREF(path);
    if (!pluginModule)
    {
        PyErr_Print();
        //return "Error importing module";
    }
    PyObject* mimacro = PyObject_GetAttrString(pluginModule, "mimacro");
    Py_DECREF(pluginModule);
    if (!mimacro)
    {
        PyErr_Print();
        //return "Error importing module";
    }
    //PyObject* args = PyTuple_New(0);
    PyObject* args = Py_BuildValue("(s)","Pepe");
    PyObject_CallObject(mimacro,args);
    Py_DECREF(args);
    if (PyErr_Occurred())
    {
        PyErr_Print();
    }
    else
    {
        qDebug()<<"Todo Ok";
    }
}


PyRun::PyRun(QString execFile)
{
    this->execFile = execFile.toStdWString();

    QStringList pythonPath;
    pythonPath << QDir::toNativeSeparators(QFileInfo(QFileInfo(execFile).absoluteDir(), "libpy34.zip").canonicalFilePath());

    this->pythonPath = pythonPath.join(":").toStdWString();
    //qDebug()<<this->execFile;
    qDebug()<<QString::fromWCharArray( this->pythonPath.c_str() );
/*

    // Path of our executable
    Py_SetProgramName((wchar_t*) this->execFile.c_str());

    // Set module search path
    Py_SetPath(this->pythonPath.c_str());

    Py_NoSiteFlag = 1;

    // Initialize the Python interpreter
    //Py_InitializeEx(0);*/

    qDebug() << "Python interpreter version:" << QString(Py_GetVersion());
    qDebug() << "Python standard library path:" << QString::fromWCharArray(Py_GetPath());

    /*QFile f("://res/rcssmin.py.codeobj");

    if(f.open(QIODevice::ReadOnly))
    {
        QByteArray codeObj = f.readAll();
        f.close();
        importModule(codeObj, "rcssmin");
    }
*/
}

PyRun::~PyRun()
{
    Py_Finalize();
}

QString PyRun::cssmin(QString)
{

}

bool PyRun::hasError()
{
    bool error = false;
    if(PyErr_Occurred())
    {
        // Output error to stderr and clear error indicator
        PyErr_Print();
        error = true;
    }
    return error;
}

PyObject* PyRun::importModule(const QString& moduleName)
{
    PyObject *poModule = NULL;

    // Get reference to main module
    PyObject *mainModule = PyImport_AddModule("__main__");

    // De-serialize Python code object
    if(!hasError())
    {
        // Load module from code object
        //poModule = PyImport_ExecCodeModule(moduleName.toUtf8().data(), poCodeObj);

        if(!hasError())
        {
            // Add module to main module as moduleName
            PyModule_AddObject(mainModule, moduleName.toUtf8().data(), poModule);
        }

        // Release object reference (Python cannot track references automatically in C++!)
       // Py_XDECREF(poCodeObj);
    }

    return poModule;
}

PyObject *PyRun::callFunction(PyObject *poModule, QString funcName, PyObject *poArgs)
{
    PyObject *poRet = NULL;

    // Get reference to function funcName in module poModule
    PyObject *poFunc = PyObject_GetAttrString(poModule, funcName.toUtf8().data());

    if(!hasError())
    {
        // Call function with arguments poArgs
        poRet = PyObject_CallObject(poFunc, poArgs);

        if(hasError())
        {
            poRet = NULL;
        }

        // Release reference to function
        Py_XDECREF(poFunc);
    }

    // Release reference to arguments
    Py_XDECREF(poArgs);

    return poRet;
}

QString PyRun::ObjectToString(PyObject *poVal)
{
    QString val;
    if(poVal != NULL)
    {
        if(PyUnicode_Check(poVal))
        {
            // Convert Python Unicode object to UTF8 and return pointer to buffer
            char *str = PyUnicode_AsUTF8(poVal);
            if(!hasError())
            {
                val = QString(str);
            }
        }
        // Release reference to object
        Py_XDECREF(poVal);
    }
    return val;
}
