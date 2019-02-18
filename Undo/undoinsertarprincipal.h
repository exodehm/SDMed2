#ifndef UNDOINSERTARPRINCIPAL_H
#define UNDOINSERTARPRINCIPAL_H

#include <QUndoCommand>
#include <QVariant>
#include <QSqlQuery>

/*************INSERTAR PARTIDAS**************/

class UndoInsertarPartidas : public QUndoCommand
{
public:
    UndoInsertarPartidas(QString tablaactual, QString cod_padre, QVariant nuevocod, int pos, QVariant descripcion);

void undo();
void redo();

private:
    QSqlQuery consulta;
    QVariant datoAntiguo, datoNuevo;
    QString tabla, codigopadre, nuevocodigo;
    int posicion;
};

/*************BORRAR PARTIDAS**************/

class UndoBorrarPartidas : public QUndoCommand
{
public:
    UndoBorrarPartidas (QString tablaactual, QStringList codigos, QVariant descripcion);

    void undo();
    void redo();

private:
    QSqlQuery consulta;
    QString tabla, codigopadre;
    QStringList codigoshijos;    
};

/****************PEGAR DEL PORTAPAPELES***************/

class UndoPegarPartidas : public QUndoCommand
{
public:
    UndoPegarPartidas (QString tablaactual, QString codigopadre, QVariant descripcion);

    void undo();
    void redo();

private:
    QSqlQuery consulta;
    QString tabla, codigopadre, nodosinsertados;
    bool esPrimerRedo;
};

#endif // UNDOINSERTARPRINCIPAL_H
