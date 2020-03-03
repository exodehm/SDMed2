#include "delegadonumerostablamedcert.h"
#include <QPalette>

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
            //DelegadoNumerosBase::paint(painter, option, index);
        }
    }
    else*/
    {
        DelegadoNumerosBase::paint(painter, option, index);
    }
}

void DelegadoNumerosTablaMedCert::initStyleOption(QStyleOptionViewItem *option, const QModelIndex &index) const
{
    QStyledItemDelegate::initStyleOption(option, index);
    option->displayAlignment = Qt::AlignRight | Qt::AlignVCenter;
    if (index.isValid())
    {
        if (index.column()==tipoColumnaTMedCert::PARCIAL)
        {
            option->backgroundBrush = QBrush(QColor(m_color_texto_mediciones_parcial));
            option->palette.setBrush(QPalette::Text, QBrush(QColor(m_color_precio_parcial_subtotal)));
        }
        else if (index.column()==tipoColumnaTMedCert::SUBTOTAL)
        {
            const QAbstractItemModel * model = index.model();
            int tipo = model->data(model->index(index.row(), index.column()+1), Qt::DisplayRole).toInt();
            if (tipo == 0 || tipo == 3)//normal o formula
            {
                option->backgroundBrush = QBrush(QColor(m_color_texto_mediciones_parcial));
                option->palette.setBrush(QPalette::Text, QBrush(QColor(m_color_precio_parcial_subtotal)));
            }
            if (tipo == 1)//subtotal parcial
            {
                option->backgroundBrush = QBrush(QColor(m_color_fondo_mediciones_subtotal_parcial));
                option->palette.setBrush(QPalette::Text, QBrush(QColor(m_color_precio_parcial_subtotal)));
            }
            else if (tipo == 2)//subtotal total
            {
                option->backgroundBrush = QBrush(QColor(m_color_fondo_mediciones_subtotal_acumulado));
                option->palette.setBrush(QPalette::Text, QBrush(QColor(m_color_texto_normal)));
            }
            /*QAbstractItemModel *model =const_cast<QAbstractItemModel *>(index.model());
    PrincipalModel* modelo = qobject_cast<PrincipalModel*>(model);
    QModelIndex indice = index;*/
            //QStyledItemDelegate::initStyleOption(option, index);
            //option->backgroundBrush = colores[modelo->LeeColor(indice.row()+1,indice.column())].fondo;
            //option->palette.setBrush(QPalette::Text, colores[modelo->LeeColor(indice.row()+1,indice.column())].fondo);
            //option->displayAlignment = Qt::AlignRight | Qt::AlignVCenter;
        }
    }
}





