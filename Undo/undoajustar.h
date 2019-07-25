#ifndef UNDOAJUSTAR_H
#define UNDOAJUSTAR_H

#include <QUndoCommand>
#include <QDebug>
#include <QSqlQuery>

class UndoAjustarPresupuesto : public QUndoCommand
{
public:
    UndoAjustarPresupuesto(const QString& nombretabla, const QString& _precioactual, const QString& _precionuevo);

    void undo();
    void redo();

private:
    QString m_tabla;
    QString m_cantidadnueva, m_cantidadantigua;
    QSqlQuery m_consulta;
};

#endif // UNDOAJUSTAR_H
