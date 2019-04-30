#ifndef IMPRIMIR_H
#define IMPRIMIR_H

/*#pragma push_macro("slots")
#undef slots
#include "Python.h"
#pragma pop_macro("slots")*/

#include <QtSql>

class Imprimir
{
public:
    Imprimir(const char* ruta, const char* nombremodulo, const char* nombrefuncion, QSqlDatabase db);
    ~Imprimir();    

private:    
};

#endif // IMPRIMIR_H
