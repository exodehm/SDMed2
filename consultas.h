#ifndef CONSULTAS_H
#define CONSULTAS_H

#include <QString>
class Consultas
{
public:
    Consultas();
    QString CrearObra(QString codigo, QString resumen);
    QString MostrarHijos(QString idpadre, QString idhijo);
    QString CabeceraTablaprincipal(QString idpadre, QString idhijo);
};

#endif // CONSULTAS_H
