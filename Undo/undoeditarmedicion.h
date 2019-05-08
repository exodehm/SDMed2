#ifndef UNDOEDITARMEDICION_H
#define UNDOEDITARMEDICION_H

#include "./defs.h"

#include "./undobase.h"
#include <QVariant>
#include <QSqlQuery>

class UndoEditarMedicion : public UndoBase
{
public:
    UndoEditarMedicion(const QString& nombretabla, const QString& id_padre, const QString& id_hijo,
                       const QVariant& dato_antiguo, const QVariant& dato_nuevo, const QString& pos,
                       const int& nombrecolumna, const int& num_cert, const QVariant& descripcion);

    void undo();
    void redo();
    QString ObtenerIdPorPosicion();
    QString ObtenerArrayIdPorPosicion();

protected:
    QString m_posicion;
    int m_columna;
    int m_num_cert;
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
class UndoInsertarLineaMedicion : public UndoEditarMedicion
{
public:
    UndoInsertarLineaMedicion(const QString& nombretabla,const QString& codpadre, const QString& codhijo, const int num_filas, const int pos,
                              int fase, QVariant descripcion);

    void undo();
    void redo();

private:
    QString m_id, m_cadenaid;
    int m_numFilas;
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
