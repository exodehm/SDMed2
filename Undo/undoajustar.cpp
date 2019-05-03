#include "undoajustar.h"

UndoAjustarPresupuesto::UndoAjustarPresupuesto(const QString& _precioactual, const QString& _precionuevo)
{
    cantidadantigua=_precioactual.toFloat();
    cantidadnueva=_precionuevo.toFloat();
}

void UndoAjustarPresupuesto::redo()
{
    /*qDebug()<<"Redo ajustar presupuesto de "<<obra->LeeResumenObra()<<"con la cantidad de: "<<cantidadnueva;
    obra->AjustarPrecio(cantidadnueva);*/
    qDebug()<<"Redo ajustar presupuesto con la cantidad de: "<<cantidadnueva;
}

void UndoAjustarPresupuesto::undo()
{
    /*qDebug()<<"Undo ajustar presupuesto de "<<obra->LeeResumenObra()<<"con la cantidad de: "<<cantidadantigua;
    obra->AjustarPrecio(cantidadantigua);*/
    qDebug()<<"Undo ajustar presupuesto con la cantidad de: "<<cantidadantigua;
}
