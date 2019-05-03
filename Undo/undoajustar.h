#ifndef UNDOAJUSTAR_H
#define UNDOAJUSTAR_H

#include <QUndoCommand>
#include <QDebug>

class UndoAjustarPresupuesto : public QUndoCommand
{
public:
    UndoAjustarPresupuesto(const QString& _precioactual, const QString& _precionuevo);

    void undo();
    void redo();

private:
    //Obra* obra;
    float cantidadnueva, cantidadantigua;
};

#endif // UNDOAJUSTAR_H
