#include "delegadonumerostablaprincipal.h"
#include "./Modelos/PrincipalModel.h"

DelegadoNumerosTablaPrincipal::DelegadoNumerosTablaPrincipal(QObject *parent):DelegadoNumerosBase(parent)
{

}

void DelegadoNumerosTablaPrincipal::paint(QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const
{
    QAbstractItemModel *model =const_cast<QAbstractItemModel *>(index.model());
    PrincipalModel* modelo = qobject_cast<PrincipalModel*>(model);
    if (index.isValid())// && modelo->HayListaDatos())
    {
        QModelIndex indice = index;
        if (modelo->HayFilaVacia())
        {
            if (index.row()>modelo->FilaVacia())
            {
                //qDebug()<<"indice 1: "<<indice.row()<<"--"<<indice.column()<<"--Fila vacia: "<<modelo->FilaVacia();
                indice = modelo->index(index.row()-1,index.column());
            }
        }
        painter->save();
        //qDebug()<<"Indice: "<<indice.row()<<" - "<<indice.column()<<"-"<<indice.data().toString()<<"-"<<modelo->LeeColor(indice.row(),indice.column());
        painter->setPen(colores[modelo->LeeColor(indice.row()+1,indice.column())].texto);
        painter->setBrush(colores[modelo->LeeColor(indice.row()+1,indice.column())].fondo);
        if (option.showDecorationSelected && (option.state & QStyle::State_Selected)){
            if (option.state & QStyle::State_Active)
            {
                // Celda seleccionadas
                painter->fillRect(option.rect, option.palette.highlight().color());
            }
            else
            {
                // Celdas seleccionadas no activas
                QPalette p=option.palette;
                painter->fillRect(option.rect, p.color(QPalette::Inactive, QPalette::Background));
            }
        }
        //painter->drawText(option.rect, Qt::AlignRight | Qt::AlignVCenter,index.data().toString());
        painter->drawText(option.rect, Qt::AlignRight | Qt::AlignVCenter,displayText(index.data().toString(),m_locale));
        painter->restore();
    }
    else
    {
        DelegadoNumerosBase::paint(painter, option, index);
    }
}
