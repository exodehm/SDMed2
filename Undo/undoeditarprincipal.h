#ifndef UNDOEDITARPRINCIPAL_H
#define UNDOEDITARPRINCIPAL_H

#include <QUndoCommand>
#include <QVariant>
#include <QSqlQuery>


class UndoEditarPrincipal : public QUndoCommand
{
public:
    UndoEditarPrincipal(QString tabla, QString cod_padre, QString cod_hijo,
                        QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion);

protected:
    QSqlQuery consulta;
    QVariant datoAntiguo, datoNuevo;
    QString tabla, codigopadre, codigohijo;
};


/*************RESUMEN**************/


class UndoEditarResumen : public UndoEditarPrincipal
{
public:
    UndoEditarResumen (QString tabla, QString cod_padre, QString cod_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion);

    void undo();
    void redo();
};


/*************NATURALEZA**************/


class UndoEditarNaturaleza : public UndoEditarPrincipal
{
public:
    UndoEditarNaturaleza (QString tabla, QString cod_padre, QString cod_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion);

    void undo();
    void redo();
};

/*************PRECIO**************/


class UndoEditarPrecio : public UndoEditarPrincipal
{
public:
    UndoEditarPrecio (QString tabla, QString cod_padre, QString cod_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion);

    void undo();
    void redo();
};


/*************CANTIDAD**************/


class UndoEditarCantidad : public UndoEditarPrincipal
{
public:
    UndoEditarCantidad (QString tabla, QString cod_padre, QString cod_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion);

    void undo();
    void redo();
};


/*************UNIDAD**************/


class UndoEditarUnidad : public UndoEditarPrincipal
{
public:
    UndoEditarUnidad (QString tabla, QString cod_padre, QString cod_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion);

    void undo();
    void redo();
};


#endif // UNDOEDITARPRINCIPAL_H
