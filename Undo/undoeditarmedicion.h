#ifndef UNDOEDITARMEDICION_H
#define UNDOEDITARMEDICION_H

#include <QUndoCommand>
#include <QVariant>
#include <QSqlQuery>

class UndoEditarMedicion : public QUndoCommand
{
public:
    UndoEditarMedicion(QString nombretabla, QString id_padre, QString id_hijo,
                       QVariant dato_antiguo, QVariant dato_nuevo, QString id_fila,
                       int nombrecolumna,QVariant descripcion);

    void undo();
    void redo();

private:
    QSqlQuery consulta;
    QString tabla,idpadre,idhijo,idfila;
    QVariant datoAntiguo, datoNuevo;
    int columna;

};

#endif // UNDOEDITARMEDICION_H
