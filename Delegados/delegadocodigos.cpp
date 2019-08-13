#include "delegadocodigos.h"
#include "./Modelos/PrincipalModel.h"
#include <QPainter>

DelegadoCodigos::DelegadoCodigos(QObject *parent):DelegadoBase(parent)
{

}

void DelegadoCodigos::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
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
        painter->setPen(m_color_fondo_normal);//pongo este Pen para evitar el marco en la celda
        painter->setBrush(colores[modelo->LeeColor(indice.row()+1,indice.column())].fondo);
        painter->drawRect(option.rect);
        painter->setPen(colores[modelo->LeeColor(indice.row()+1,indice.column())].texto);
        painter->drawText(option.rect, Qt::AlignRight | Qt::AlignVCenter,index.data().toString());
        painter->restore();
    }
    else
    {
        DelegadoBase::paint(painter,option,index);
    }
}
