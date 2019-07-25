#include "undoajustar.h"

UndoAjustarPresupuesto::UndoAjustarPresupuesto(const QString &nombretabla, const QString& _precioactual, const QString& _precionuevo):
    m_tabla(nombretabla),m_cantidadantigua(_precioactual),m_cantidadnueva(_precionuevo)
{    
}

void UndoAjustarPresupuesto::redo()
{
    qDebug()<<"Undo ajustar presupuesto con la cantidad de: "<<m_cantidadnueva;
    QString cadenaconsulta = "SELECT ajustar('"+m_tabla+"','"+m_cantidadnueva+"')";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
    qDebug()<<m_consulta.executedQuery();
}

void UndoAjustarPresupuesto::undo()
{
    qDebug()<<"Undo ajustar presupuesto con la cantidad de: "<<m_cantidadantigua;
    QString cadenaconsulta = "SELECT ajustar('"+m_tabla+"','"+m_cantidadantigua+"')";
    m_consulta.exec(cadenaconsulta);
    qDebug()<<m_consulta.executedQuery();
}
