#ifndef DELEGADOCODIGOS_H
#define DELEGADOCODIGOS_H

#include "./delegadobase.h"


class DelegadoCodigos : public DelegadoBase
{
public:
    explicit DelegadoCodigos(QObject* parent=nullptr);
    void paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const;
};

#endif // DELEGADOCODIGOS_H
