#ifndef DELEGADOTABLAPROPIEDADES_H
#define DELEGADOTABLAPROPIEDADES_H

#include <QStyledItemDelegate>


class DelegadoTablaPropiedades : public QStyledItemDelegate
{
public:
    DelegadoTablaPropiedades(QObject* parent=nullptr);
    void paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const override;
};

#endif // DELEGADOTABLAPROPIEDADES_H
