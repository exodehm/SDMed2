#ifndef UNDOEDITARPRINCIPAL_H
#define UNDOEDITARPRINCIPAL_H

#include "./undobase.h"
#include <QVariant>
#include <QSqlQuery>


/*************CODIGO**************/

class UndoEditarCodigo : public UndoBase
{
public:
    UndoEditarCodigo (const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                      const QVariant& datoNuevo, const QVariant& descripcion);

    void undo();
    void redo();
};


/*************UNIDAD**************/

class UndoEditarUnidad : public UndoBase
{
public:
    UndoEditarUnidad (const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                      const QVariant& datoNuevo, const QVariant& descripcion);

    void undo();
    void redo();
};


/*************RESUMEN**************/

class UndoEditarResumen : public UndoBase
{
public:
    UndoEditarResumen (const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                       const QVariant& datoNuevo, const QVariant& descripcion);

    void undo();
    void redo();
};


/*************NATURALEZA**************/

class UndoEditarNaturaleza : public UndoBase
{
public:
    UndoEditarNaturaleza (const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                          const QVariant& datoNuevo, const QVariant& descripcion);

    void undo();
    void redo();
};

/*************CANTIDAD**************/

class UndoEditarCantidad : public UndoBase
{
public:
    UndoEditarCantidad (const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                        const QVariant& datoNuevo, const QString& tipo_cantidad, const QVariant& descripcion);

    void undo();
    void redo();

protected:

    QString m_columnaCantidad;//canpres o cancert
    bool m_hayMedicion;
};


/*************PRECIO**************/

class UndoEditarPrecio : public UndoBase
{
public:
    UndoEditarPrecio (const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                      const QVariant& datoNuevo, int opc, const QVariant& descripcion);

    void undo();
    void redo();

private:
    int opcion;
    QList<QList<QVariant>>partidas;
};


/***************TEXTO********************/
class UndoEditarTexto : public UndoBase
{
public:
    UndoEditarTexto (const QString& tabla, const QString& cod_padre, const QString& cod_hijo, const QString& _textoantiguo, const QString& _textonuevo,
                       const QVariant &descripcion);

    void undo();
    void redo();

private:
    QString textonuevo, textonuevoplano;
    QString textoantiguo, textoantiguoplano;
};

#endif // UNDOEDITARPRINCIPAL_H
