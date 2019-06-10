#include "delegadonumerostablamedcert.h"

DelegadoNumerosTablaMedCert::DelegadoNumerosTablaMedCert(QObject* parent):DelegadoNumerosBase(parent)
{

}

void DelegadoNumerosTablaMedCert::paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const
{   
    /*if (index.isValid())
    {
        QStyleOptionViewItem opt = option;
        initStyleOption(&opt, index);

        if (index.column()==tipoColumnaTMedCert::PARCIAL)
        {
            painter->save();
            painter->setPen(Qt::yellow);
            painter->setBrush(Qt::yellow);
            painter->drawRect(option.rect);
            painter->setPen(Qt::magenta);
            painter->drawText(option.rect, Qt::AlignCenter, displayText(index.data(), QLocale::system()));
            painter->restore();
        }
        else if (index.column()==tipoColumnaTMedCert::SUBTOTAL)
        {
            painter->save();
            painter->setPen(Qt::yellow);
            painter->setBrush(Qt::yellow);
            //if (index.data()!="")
            {
                painter->setBrush(Qt::cyan);
                opt.font.setBold(true);
            }
            painter->drawRect(opt.rect);
            painter->setPen(Qt::magenta);
            painter->drawText(opt.rect, Qt::AlignCenter, displayText(index.data(), QLocale::system()));
            painter->restore();
        }
        else
        {
            painter->drawText(option.rect, Qt::AlignCenter, displayText(index.data(), QLocale::system()));
        }
    }
    else*/
    {
        DelegadoNumerosBase::paint(painter, option, index);
    }
}

