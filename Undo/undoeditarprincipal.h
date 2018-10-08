#ifndef UNDOEDITARPRINCIPAL_H
#define UNDOEDITARPRINCIPAL_H

#include <QUndoCommand>


class UndoEditarPrincipal : public QUndoCommand
{
public:
    UndoEditarPrincipal(QString resumenantiguo, QString resumennuevo, QString descripcion);
    void undo();
    void redo();

private:
    QString datoAntiguo, datoNuevo;
};

#endif // UNDOEDITARPRINCIPAL_H
