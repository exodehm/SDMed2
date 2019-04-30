#ifndef UNDOEDITARMEDICION_H
#define UNDOEDITARMEDICION_H

#include "./defs.h"

#include <QUndoCommand>
#include <QVariant>
#include <QSqlQuery>

class UndoEditarMedicion : public QUndoCommand
{
public:
    UndoEditarMedicion(QString nombretabla, QString id_padre, QString id_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QString pos,
                       int nombrecolumna, int fase, QVariant descripcion);

    void undo();
    void redo();
    QString ObtenerIdPorPosicion();

private:
    QSqlQuery consulta;
    QString tabla,idpadre,idhijo, posicion;
    QVariant datoAntiguo, datoNuevo;
    int columna;
    int num_cert;
};

/*************BORRAR LINEA MEDICION******************/
class UndoBorrarLineasMedicion : public QUndoCommand
{
public:
    UndoBorrarLineasMedicion(const QString& nombretabla,const QList<QString>&idsborrar,int fase,QVariant descripcion);

    void undo();
    void redo();

private:    
    QString tabla, cadenaborrar;
    QList<QString>ids;
    QSqlQuery consulta;
    int num_certif;
};

/*************INSERTAR LINEA MEDICION******************/
class UndoInsertarLineaMedicion : public QUndoCommand
{
public:
    UndoInsertarLineaMedicion(const QString& nombretabla,const QString& codpadre, const QString& codhijo, const int num_filas, const int pos,
                              int fase, QVariant descripcion);

    void undo();
    void redo();

private:
    QString tabla, codigopadre, codigohijo, id, cadenaid;
    int posicion, numFilas;
    QSqlQuery consulta;
    int num_cert;    
};


/*************CERTIFICAR LINEA MEDICION******************/
class UndoCertificarLineaMedicion : public QUndoCommand
{
public:
    UndoCertificarLineaMedicion(const QString& nombretabla,const QString& codpadre, const QString& codhijo, const QString indices, const QString num_cert, QVariant descripcion);

    void undo();
    void redo();

private:
    QString tabla, codigopadre, codigohijo, indices, num_cert;
    QSqlQuery consulta;
};


#endif // UNDOEDITARMEDICION_H
