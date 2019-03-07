#include "vistaarbol.h"

VistaArbol::VistaArbol(QWidget *parent):QTreeView(parent)
{
    delegado = new DelegadoArbol;
    setItemDelegateForColumn(tipoColumnaTPrincipal::CODIGO,delegado);
    setItemDelegateForColumn(tipoColumnaTPrincipal::RESUMEN,delegado);
    setColumnWidth(tipoColumnaTPrincipal::NATURALEZA,10);
    setColumnWidth(tipoColumnaTPrincipal::CODIGO,10);
    //setItemDelegate(delegado);    
}

