#include "delegadoformulasmedicion.h"
#include "./Dialogos/dialogoeditorformulasmedicion.h"
#include <QPushButton>
#include <QApplication>
#include <QPainter>

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
    int tipo = index.sibling(index.row(),index.column()+3).data().toInt();
    if (index.isValid() && index == m_indiceActivo && tipo==tipoLineaMedicion::NORMAL)
    {
        painter->drawText(option.rect,index.data().toString());
        QStyleOptionButton boton;
        QRect r = option.rect;//getting the rect of the cell
        int x,y,w,h;
        w = m_ancho_boton;
        h = r.height();//button height
        x = r.left() + r.width() - w;//the X coordinate
        y = r.top();//the Y coordinate
        boton.rect = QRect(x,y,w,h);
        boton.text = "...";
        boton.state = QStyle::State_MouseOver;
        QApplication::style()->drawControl( QStyle::CE_PushButton, &boton, painter);
    }
    else
    {
        DelegadoBase::paint(painter, option, index);
    }
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
        h = r.height();//button height

        if( clickX > x && clickX < x + w )
            if( clickY > y && clickY < y + h )
            {
                QVariant uds = index.sibling(index.row(),index.column()-4).data();
                QVariant longitud = index.sibling(index.row(),index.column()-3).data();
                QVariant anchura = index.sibling(index.row(),index.column()-2).data();
                QVariant altura = index.sibling(index.row(),index.column()-1).data();
                DialogoEditorFormulasMedicion* d =  new DialogoEditorFormulasMedicion(uds,longitud,anchura,altura);
                if (d->exec())
                {
                    qDebug()<<"Chachi todo";
                    model->setData(index,QVariant(d->LeeFormula()));
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
