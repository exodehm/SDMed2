#include "delegadonumerostablamedcert.h"

DelegadoNumerosTablaMedCert::DelegadoNumerosTablaMedCert(QObject* parent):DelegadoNumerosBase(parent)
{

}

void DelegadoNumerosTablaMedCert::paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const
{   
    if (index.isValid())
    {
        QStyleOptionViewItem opt = option;
        initStyleOption(&opt, index);

        if (index.column()==tipoColumnaTMedCert::PARCIAL)
        {
            painter->save();
            painter->setPen(Qt::yellow);
            painter->setBrush(Qt::yellow);
            painter->drawRect(opt.rect);
            painter->setPen(m_color_precio_parcial_subtotal);
            painter->drawText(opt.rect, Qt::AlignCenter, displayText(index.data(), QLocale::system()));
            painter->restore();
        }
        else if (index.column()==tipoColumnaTMedCert::SUBTOTAL)
        {
            painter->save();
            //por defecto el fondo es amarillo
            painter->setBrush(Qt::yellow);
            painter->setPen(Qt::yellow);
            //miro el tipo (la siguiente columna) por si ha que cambiar el fondo
            const QAbstractItemModel * model = index.model();
            int tipo = model->data(model->index(index.row(), index.column()+1), Qt::DisplayRole).toInt();
            if (tipo == 1)//subtotal parcial
            {
                painter->setPen(colores[SUBTOTAL_PARCIAL].texto);
                painter->setBrush(colores[SUBTOTAL_PARCIAL].fondo);
                qDebug()<<"Tenemos un parcial";
            }
            else if (tipo == 2)//subtotal total
            {
                painter->setPen(colores[SUBTOTAL_ACUMULADO].texto);
                painter->setBrush(colores[SUBTOTAL_ACUMULADO].fondo);
                qDebug()<<"Tenemos un subtotal";
            }
            painter->drawRect(opt.rect);
            painter->setPen(m_color_precio_parcial_subtotal);
            painter->drawText(opt.rect, Qt::AlignCenter, displayText(index.data(), QLocale::system()));
            painter->restore();
        }
        else
        {
            painter->drawText(opt.rect, Qt::AlignCenter, displayText(index.data(), QLocale::system()));
        }
    }
    else
    {
        DelegadoNumerosBase::paint(painter, option, index);
    }
}

