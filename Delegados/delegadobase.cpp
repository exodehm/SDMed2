#include "delegadobase.h"
#include <QPainter>
#include <QKeyEvent>

DelegadoBase::DelegadoBase(QObject *parent):QStyledItemDelegate(parent)
{
    m_color_texto_importe_bloqueado = QColor(Qt::red);
    m_color_texto_importe_con_descomposicion = QColor(Qt::magenta);
    m_color_texto_normal = QColor(Qt::black);
    m_color_precio_parcial_subtotal = QColor(Qt::darkMagenta);
    m_color_fondo_normal = QColor(Qt::transparent);
    m_color_fondo_mediciones_subtotal_normal = QColor(Qt::yellow);
    m_color_fondo_mediciones_subtotal_parcial = QColor(190,252,253);
    m_color_fondo_mediciones_subtotal_acumulado = QColor(241,192,137);
    m_color_fondo_principal_capitulo = QColor(102,255,255);
    m_color_fondo_principal_subcapitulo = QColor(102,255,102);
    m_color_fondo_principal_porcentaje = QColor(255,120,120);
    m_color_texto_mediciones_parcial = QColor(Qt::yellow);

    colores[NORMAL].fondo = m_color_fondo_normal;
    colores[NORMAL].texto = m_color_texto_normal;

    colores[BLOQUEADO].fondo = m_color_fondo_normal;
    colores[BLOQUEADO].texto = m_color_texto_importe_bloqueado;

    colores[DESCOMPUESTO].fondo = m_color_fondo_normal;
    colores[DESCOMPUESTO].texto = m_color_texto_importe_con_descomposicion;

    colores[PORCENTAJE].fondo = m_color_fondo_principal_porcentaje;
    colores[PORCENTAJE].texto = m_color_texto_normal;

    colores[CAPITULO].fondo = m_color_fondo_principal_capitulo;
    colores[CAPITULO].texto = m_color_texto_normal;

    colores[SUBCAPITULO].fondo = m_color_fondo_principal_subcapitulo;
    colores[SUBCAPITULO].texto = m_color_texto_normal;

    colores[PARCIAL].fondo = m_color_fondo_mediciones_subtotal_parcial;
    colores[PARCIAL].texto = m_color_texto_mediciones_parcial;

    colores[SUBTOTAL_PARCIAL].fondo = m_color_fondo_mediciones_subtotal_parcial;
    colores[SUBTOTAL_PARCIAL].texto = m_color_precio_parcial_subtotal;

    colores[SUBTOTAL_ACUMULADO].fondo = m_color_fondo_mediciones_subtotal_acumulado;
    colores[SUBTOTAL_ACUMULADO].texto = m_color_texto_normal;
}

void DelegadoBase::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    QStyledItemDelegate::paint(painter,option,index);
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
}
