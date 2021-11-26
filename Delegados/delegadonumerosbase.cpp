#include "delegadonumerosbase.h"
#include <QApplication>
#include <QPainter>

DelegadoNumerosBase::DelegadoNumerosBase(QObject *parent):DelegadoBase(parent)
{
    rx = new QRegExp("[-]{0,1}[0-9]{0,5}[\\,\\.]{1}[0-9]{1,3}");
    m_precision = 2;
    /*colores[color::NODEFINIDO] = QColor();
    colores[color::NORMAL] = m_color_importe_sin_descomposicion;
    colores[color::BLOQUEADO] = m_color_importe_bloqueado;
    colores[color::DESCOMPUESTO] = m_color_importe_con_descomposicion;*/
}

void DelegadoNumerosBase::setPrecision(quint8 precision)
{
    m_precision = precision;
}

QWidget* DelegadoNumerosBase::createEditor(QWidget * parent, const QStyleOptionViewItem& option, const QModelIndex& index) const
{
    const QAbstractItemModel *model = index.model();
    if (!model)
    {
        return QStyledItemDelegate::createEditor(parent,option, index);
    }
    QLineEdit* mieditor = new QLineEdit(parent);
    mieditor->setValidator(new QRegExpValidator(*rx));
    return mieditor;
}

void DelegadoNumerosBase::setEditorData(QWidget * editor, const QModelIndex&index) const
{
    QLineEdit *mieditor=qobject_cast<QLineEdit*>(editor);
    if (!mieditor)
    {
        QStyledItemDelegate::setEditorData(editor,index);
    }
    mieditor->setText(index.data().toString());
}

void DelegadoNumerosBase::setModelData(QWidget * editor, QAbstractItemModel * model, const QModelIndex&index) const
{
    if (!index.isValid()) return;
    QLineEdit * mieditor=qobject_cast<QLineEdit * >(editor);    
    if (!mieditor)
    {
        return QStyledItemDelegate::setModelData(editor, model, index);
    }
    QString dato = mieditor->text();
    //dato.replace(",",".");
    model->setData(index,dato,Qt::DisplayRole);
    model->setData(index,dato,Qt::EditRole);
}

void DelegadoNumerosBase::paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const
{
    if ((option.state & QStyle::State_Selected) && (option.state & QStyle::State_Active))
    {
        painter->save();
        painter->setBrush(Qt::NoBrush);
        painter->setPen(Qt::black);
        painter->drawRect(option.rect);
        painter->setBrush(Qt::SolidPattern);
        painter->drawRect(option.rect.x()+option.rect.width()-5,option.rect.y()+option.rect.height()-5,5,5);
        painter->drawText(option.rect, Qt::AlignRight | Qt::AlignVCenter, index.data().toString());
        painter->restore();
    }
    else
    {
        DelegadoBase::paint(painter, option, index);
    }
}

QSize DelegadoNumerosBase::sizeHint(const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    Q_UNUSED(index)    
    return option.rect.size();
}

QString DelegadoNumerosBase::displayText(const QVariant & value, const QLocale & locale) const
{
   if (value==0)
   {
       return "";
   }
   else
   {
       return m_locale.toString(value.toDouble(),'f',m_precision);
   }
}
