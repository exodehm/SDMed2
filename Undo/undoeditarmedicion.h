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
                       QVariant dato_antiguo, QVariant dato_nuevo, QString id_fila,
                       int nombrecolumna, enum tipoTablaMedCert tipotabla, QVariant descripcion);

    void undo();
    void redo();

private:
    QSqlQuery consulta;
    QString tabla,idpadre,idhijo,idfila;
    QVariant datoAntiguo, datoNuevo;
    int columna;
    enum tipoTablaMedCert eTipoTabla;

};

/*************BORRAR LINEA MEDICION******************/
class UndoBorrarLineasMedicion : public QUndoCommand
{
public:
    UndoBorrarLineasMedicion(const QString& nombretabla,const QList<QString>&idsborrar,QVariant descripcion);

    void undo();
    void redo();

private:    
    QString tabla, cadenaborrar;
    QList<QString>ids;
    QSqlQuery consulta;
};

/*************INSERTAR LINEA MEDICION******************/
class UndoInsertarLineaMedicion : public QUndoCommand
{
public:
    UndoInsertarLineaMedicion(const QString& nombretabla,const QString& codpadre, const QString& codhijo, const int num_filas, const int pos, enum tipoTablaMedCert tipo, QVariant descripcion);

    void undo();
    void redo();

private:
    QString tabla, codigopadre, codigohijo, id, cadenaid;
    int posicion, numFilas;
    QSqlQuery consulta;
    enum tipoTablaMedCert eTipoTabla;
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
