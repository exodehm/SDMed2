#include "delegadotablapropiedades.h"
#include <QPainter>

DelegadoTablaPropiedades::DelegadoTablaPropiedades(QObject *parent):QStyledItemDelegate(parent)
{

}

void DelegadoTablaPropiedades::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    if (index.isValid())
    {
        painter->save();
        painter->setPen(QColor(255,255,170));
        painter->setBrush(QColor(255,255,170));
        painter->drawRect(option.rect);
        //painter->setPen(Qt::gray);
        //painter->drawText(option.rect, Qt::AlignRight | Qt::AlignVCenter, index.data().toString());
        painter->restore();
    }
    QStyledItemDelegate::paint(painter, option, index);

}
