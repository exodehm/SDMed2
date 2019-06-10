#include "delegadoformulasmedicion.h"
#include "./Dialogos/dialogoeditorformulasmedicion.h"
#include <QPushButton>
#include <QApplication>
#include <QPainter>
#include <QStyleOptionViewItemV4>

DelegadoFormulasMedicion::DelegadoFormulasMedicion(QObject *parent):DelegadoBase(parent)
{
    m_ancho_boton = 15;
}


QWidget *DelegadoFormulasMedicion::createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    //precaución por si no hay modelo
    //const QAbstractItemModel * model = index.model();
    //if (!model) return QStyledItemDelegate::createEditor(parent,option, index);
    //creación del editor
    //QPushButton * boton = new QPushButton(parent);
    /*box->setEditable(true);
    for (int i = 0;i<RepoIconos::tam(); i++)
    {
        box->addItem(RepoIconos::GetIcon(i),leyendas.at(i));
    }*/
    //return boton;
    return QStyledItemDelegate::createEditor(parent,option, index);

}

void DelegadoFormulasMedicion::setEditorData(QWidget *editor, const QModelIndex &index) const
{

}

void DelegadoFormulasMedicion::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const
{

}

void DelegadoFormulasMedicion::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    if (index.isValid() && index == m_indiceActivo && index.column()==tipoColumnaTMedCert::FORMULA)
    {
        painter->drawText(option.rect,index.data().toString());
        QStyleOptionButton boton;
        QRect r = option.rect;//getting the rect of the cell
        int x,y,w,h;
        w = m_ancho_boton;
        h = r.height()/1.5;//button height
        x = r.left() + r.width() - w;//the X coordinate
        y = r.top();//the Y coordinate
        boton.rect = QRect(x,y,w,h);
        boton.text = "...";
        boton.state = QStyle::State_MouseOver;
        QApplication::style()->drawControl( QStyle::CE_PushButton, &boton, painter);
        if ((option.state & QStyle::State_Selected) && (option.state & QStyle::State_Active))
        {
            /*QStyleOptionViewItem itemOption(option);
            itemOption.palette.setColor(QPalette::Highlight, Qt::red);
            initStyleOption(&itemOption, index);
            QApplication::style()->drawControl(QStyle::CE_ItemViewItem, &itemOption, painter, nullptr);*/
        }
    }
    else
    {
        QStyledItemDelegate::paint(painter, option, index);
    }
    /*QStyleOptionViewItem itemOption(option);
    QBrush brush;
    brush.setColor(QColor(Qt::red));
    itemOption.backgroundBrush = brush;
    itemOption.text = "lala";
    initStyleOption(&itemOption, index);

    if ((itemOption.state & QStyle::State_Selected) && (itemOption.state & QStyle::State_Active))
    {
        itemOption.palette.setColor(QPalette::Highlight, Qt::red);  // set your color here
        QApplication::style()->drawControl(QStyle::CE_ItemViewItem, &itemOption, painter, nullptr);
        qDebug()<<"Aqui";
    }
    else
    {
        DelegadoBase::paint(painter, option, index);
    }*/

    //QApplication::style()->drawControl(QStyle::CE_ItemViewItem, &itemOption, painter, nullptr);
}

bool DelegadoFormulasMedicion::editorEvent(QEvent *event, QAbstractItemModel *model, const QStyleOptionViewItem &option, const QModelIndex &index)
{
    if( event->type() == QEvent::MouseButtonRelease )
    {
        QMouseEvent * e = (QMouseEvent *)event;
        int clickX = e->x();
        int clickY = e->y();

        QRect r = option.rect;//getting the rect of the cell
        int x,y,w,h;
        x = r.left() + r.width() - m_ancho_boton;//the X coordinate
        y = r.top();//the Y coordinate
        w = m_ancho_boton;//button width
        h = r.height()/1.5;//button height

        if( clickX > x && clickX < x + w )
            if( clickY > y && clickY < y + h )
            {
                QVariant uds = index.sibling(index.row(),index.column()-4).data();
                QVariant longitud = index.sibling(index.row(),index.column()-3).data();
                QVariant anchura = index.sibling(index.row(),index.column()-2).data();
                QVariant altura = index.sibling(index.row(),index.column()-1).data();
                QVariant formula = index.data();
                DialogoEditorFormulasMedicion* d = new DialogoEditorFormulasMedicion(uds,longitud,anchura,altura,formula);
                if (d->exec())
                {
                    model->setData(index.sibling(index.row(),index.column()-4),QVariant(d->LeeUd()));
                    model->setData(index.sibling(index.row(),index.column()-3),QVariant(d->LeeLong()));
                    model->setData(index.sibling(index.row(),index.column()-2),QVariant(d->LeeAnc()));
                    model->setData(index.sibling(index.row(),index.column()-1),QVariant(d->LeeAlt()));
                    model->setData(index,QVariant(d->LeeFormula()));

                    model->setData(index,QVariant("chachi"),Qt::ToolTipRole);
                    qDebug()<<"contenido: "<<model->data(index).toString();
                    qDebug()<<"lo otro: "<<model->data(index,Qt::ToolTipRole);
                }
            }
        return true;
    }
    return false;
}

void DelegadoFormulasMedicion::onHoverIndexChanged(const QModelIndex &indice)
{
    m_indiceActivo = indice;
}
