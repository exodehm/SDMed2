#include "delegadobase.h"
#include <QPainter>
#include <QKeyEvent>

DelegadoBase::DelegadoBase(QObject *parent):QStyledItemDelegate(parent)
{
    m_color_importe_bloqueado = QColor(Qt::red);
    m_color_importe_con_descomposicion = QColor(Qt::magenta);
    m_color_importe_sin_descomposicion = QColor(Qt::black);
    m_color_precio_parcial_subtotal = QColor(Qt::darkMagenta);
    m_color_fondo_subtotal_normal = QColor(Qt::yellow);
    m_color_fondo_subtotal_parcial = QColor(190,252,253);
    m_color_fondo_subtotal_acumulado = QColor(241,192,137);
}

bool DelegadoBase::eventFilter(QObject *obj, QEvent* event)
{
    if (event->type()==QEvent::KeyPress)
    {
        QKeyEvent* key = static_cast<QKeyEvent*>(event);
        if (key->key()==Qt::Key_Tab || key->key()==Qt::Key_Enter || key->key()==Qt::Key_Return)
        {
            QLineEdit *editor=qobject_cast<QLineEdit*>(obj);
            emit commitData(editor);
            emit closeEditor(editor, QStyledItemDelegate::NoHint);
        }
        else if (key->key()==Qt::Key_Escape)
        {
             QLineEdit *editor=qobject_cast<QLineEdit*>(obj);
             emit closeEditor(editor, QStyledItemDelegate::NoHint);
        }
        else
        {
            return QObject::eventFilter(obj, event);
        }
        return false;
    }
    else
    {
        return QObject::eventFilter(obj, event);
    }
    return false;
}
