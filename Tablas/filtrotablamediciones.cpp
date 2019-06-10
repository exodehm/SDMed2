#include "filtrotablamediciones.h"

#include <QPushButton>


FiltroTablaMediciones::FiltroTablaMediciones(TablaBase *tabla, QObject *parent):FiltroTablaBase(tabla,parent)
{

}

bool FiltroTablaMediciones::eventFilter(QObject *obj, QEvent *event)
{
    if( event->type() == QEvent::HoverMove)
    {
        QHoverEvent * hoverEvent = static_cast<QHoverEvent*>(event);
        QPoint pos = m_tabla->viewport()->mapFromParent(hoverEvent->pos());
        //establecer puntero del raton
        /*if (m_tabla->selectionModel()->selectedIndexes().size()>0)//si hay alguna celda seleccionada
        {
            QRect rectSelect = m_tabla->visualRect(m_tabla->selectionModel()->currentIndex());

            if (pos.x()>=rectSelect.bottomRight().x()-m_tabla->LeeTamMarca() &&
                    pos.x()<=rectSelect.bottomRight().x() &&
                    pos.y()>=rectSelect.bottomRight().y()-m_tabla->LeeTamMarca() &&
                    pos.y()<=rectSelect.bottomRight().y())
            {
                if (!m_tabla->BotonIzquierdoPresionado())
                {
                    m_tabla->setCursor(Qt::CrossCursor);
                    m_tabla->SetModoSeleccionRestringido();
                }
            }
            else
            {
                m_tabla->setCursor(Qt::ArrowCursor);
                if (!m_tabla->BotonIzquierdoPresionado())
                {
                    m_tabla->SetModoSeleccionNormal();
                }
            }
        }*/
        //boton en la tercera columna
        currentIndex = m_tabla->indexAt(pos);
        QRect rect = m_tabla->visualRect(currentIndex);
        m_boton_formulas->setVisible(currentIndex.isValid() && currentIndex.column() == 3);
        qDebug()<<"Lo del boton";
        if( m_boton_formulas->isVisible() )
        {
            QPoint point = rect.topRight();
            point.setX(point.x() - m_boton_formulas->width());
            m_boton_formulas->move(m_tabla->viewport()->mapToParent(point));
        }
        event->accept();
        return true;
    }
    else if (event->type() == QEvent::MouseButtonRelease)//quito la cruceta del puntero
    {
        qDebug()<<"Aprento el boton en la tabla de medicoibes";
        m_tabla->setCursor(Qt::ArrowCursor);
        //retorno false para propagar el evento a la tabla y que la funcion tabla::mouseReleaseEvent termine de hacer otras cosas
        //esta misma función, de hacer que el puntero vuelva al modo "arrow", podría hacerse desde la tabla, pero la dejo aquí
        //por legibilidad, ya que las funciones que cambian el modo del cursor estan aqui
        return false;
    }
    return FiltroTablaBase::eventFilter(obj,event);
}

