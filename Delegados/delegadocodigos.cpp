#include "delegadocodigos.h"
#include "./Modelos/PrincipalModel.h"
#include <QPainter>

DelegadoCodigos::DelegadoCodigos(QObject *parent):DelegadoBase(parent)
{

}

void DelegadoCodigos::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    DelegadoBase::paint(painter,option,index);
}

void DelegadoCodigos::initStyleOption(QStyleOptionViewItem *option, const QModelIndex &index) const
{
    QAbstractItemModel *model =const_cast<QAbstractItemModel *>(index.model());
    PrincipalModel* modelo = qobject_cast<PrincipalModel*>(model);
    //QModelIndex indice = index;
    QStyledItemDelegate::initStyleOption(option, index);
    option->backgroundBrush = colores[modelo->LeeColor(index.row()+1,index.column())].fondo;
    //option->palette.setBrush(QPalette::Text, colores[modelo->LeeColor(index.row()+1,index.column())].fondo);
    option->displayAlignment = Qt::AlignRight | Qt::AlignVCenter;
}
