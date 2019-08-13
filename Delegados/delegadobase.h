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

    struct ColorCelda
    {
      QBrush fondo;
      QPen texto;
    };
    enum eColores{NORMAL=1,BLOQUEADO,DESCOMPUESTO,PORCENTAJE,CAPITULO,SUBCAPITULO,PARCIAL,SUBTOTAL_PARCIAL,SUBTOTAL_ACUMULADO};
    explicit DelegadoBase(QObject* parent=nullptr);

    void paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const;
    bool eventFilter(QObject *obj, QEvent* event);


protected:
    QColor m_color_texto_importe_bloqueado;
    QColor m_color_texto_importe_con_descomposicion;
    QColor m_color_texto_normal;
    QColor m_color_precio_parcial_subtotal;
    QColor m_color_texto_mediciones_parcial;

    QColor m_color_fondo_normal;
    QColor m_color_fondo_mediciones_subtotal_normal;
    QColor m_color_fondo_mediciones_subtotal_parcial;
    QColor m_color_fondo_mediciones_subtotal_acumulado;
    QColor m_color_fondo_principal_capitulo;
    QColor m_color_fondo_principal_subcapitulo;
    QColor m_color_fondo_principal_porcentaje;

    ColorCelda colores[10];//TIENE UN INDICE MAS PARA COMPENSAR QUE LA LISTA DE COLORES EMPIEZA EN 1
};
#endif // DELEGADOBASE_H
