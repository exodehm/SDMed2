#ifndef DELEGADOBASE_H
#define DELEGADOBASE_H

#include <QStyledItemDelegate>
#include <QLineEdit>
#include <QDebug>

#include "./defs.h"

class DelegadoBase : public QStyledItemDelegate
{
    Q_OBJECT

public:
    explicit DelegadoBase(QObject* parent=nullptr);
    bool eventFilter(QObject *obj, QEvent* event);

protected:
    QColor m_color_importe_bloqueado;
    QColor m_color_importe_con_descomposicion;
    QColor m_color_importe_sin_descomposicion;
    QColor m_color_precio_parcial_subtotal;
    QColor m_color_fondo_subtotal_normal;
    QColor m_color_fondo_subtotal_parcial;
    QColor m_color_fondo_subtotal_acumulado;

};
#endif // DELEGADOBASE_H
