#include "./filtrotablamediciones.h"
#include "./marca.h"
#include <QModelIndex>
#include <QEvent>
#include <QHoverEvent>
#include <QMouseEvent>
#include <QPushButton>
#include <QDebug>

FiltroTablaMediciones::FiltroTablaMediciones(TablaBase *table, QObject* parent): FiltroTablaBase(table,parent)
{
    m_modoRestringido = false;
    m_tamMarca = 5;
    m_tabla->installEventFilter(this);
    m_tabla->setAttribute(Qt::WA_Hover);
    m_marca = new Marca(5,m_tabla->viewport());
    m_marca->setVisible(false);
    m_marcoSeleccionRestringida = new Marco(m_tabla->viewport());
    m_marcoSeleccionRestringida->setVisible(false);
    m_botonPulsado = false;
    m_botonFormula = new QPushButton("...",m_tabla);
    m_botonFormula->setFixedSize(20, 20);
    m_botonFormula->setVisible(false);

    QObject::connect(m_tabla->selectionModel(),SIGNAL(selectionChanged(QItemSelection,QItemSelection)),this,SLOT(FiltrarColumnaSeleccion()));


}

bool FiltroTablaMediciones::eventFilter(QObject *obj, QEvent *event)
{
    QPoint pos;
    if( event->type() == QEvent::HoverMove)
    {
        QHoverEvent * hoverEvent = static_cast<QHoverEvent*>(event);
        pos = m_tabla->viewport()->mapFromParent(hoverEvent->pos());
        //qDebug()<<"hover pos "<<pos;
        if (m_modoRestringido == false)
        {
            m_currentIndex = m_tabla->indexAt(pos);
        }
        //si hay alguna celda seleccionada y es la actual
        if (!m_tabla->selectionModel()->selectedIndexes().isEmpty() && m_currentIndex == m_tabla->currentIndex())
        {
            //obtengo el rectangulo que abarca desde la primera hasta la ultima celda seleccionada
            DibujarMarcasSeleccionRestringida();
            m_marca->setVisible(true);
            m_botonFormula->setVisible(m_currentIndex.isValid() && m_currentIndex.column() == tipoColumnaTMedCert::FORMULA);
            if( m_botonFormula->isVisible())
            {
              QRect rect = m_tabla->visualRect(m_currentIndex);
              QPoint point = rect.topRight();
              point.setX(point.x() - m_botonFormula->width());
              m_botonFormula->move(m_tabla->viewport()->mapToParent(point));
            }

            QPoint point = DibujarMarcasSeleccionRestringida().bottomRight();

            if (pos.x()>point.x()-m_tamMarca &&
                    pos.x()<point.x() &&
                    pos.y()>point.y()-m_tamMarca &&
                    pos.y()<point.y()
                    )
            {
                m_marcoSeleccionRestringida->setVisible(true);
                m_tabla->setCursor(Qt::CrossCursor);
                m_modoRestringido = true;
            }
            else
            {
                if (m_botonPulsado == false)
                {
                    m_marcoSeleccionRestringida->setVisible(false);
                    m_tabla->setCursor(Qt::ArrowCursor);
                    m_modoRestringido = false;
                }
            }
        }
        else
        {
            m_marca->setVisible(false);
        }
        return false;
    }

    else if (event->type() == QEvent::MouseButtonPress)
    {
        m_botonPulsado = true;
        if (m_modoRestringido == true)
            qDebug()<<"pulsanding el ratoning";
        return false;
    }
    else if (event->type() == QEvent::MouseButtonRelease)
    {
        m_botonPulsado = false;
        m_tabla->setCursor(Qt::ArrowCursor);
        m_currentIndex = m_tabla->selectionModel()->selectedIndexes().last();
        //m_tabla->selectionModel()->selectedIndexes().clear();
        //si estoy en modo restringido efectuo una accion al soltar el boton del raton
        if (m_modoRestringido == true)
        {
            qDebug()<<"Funcion para hacer algo con los indices:";
            for (const QModelIndex& i : m_tabla->selectionModel()->selectedIndexes())
            {
                qDebug()<<i;
            }
        }
        m_modoRestringido = false;
        return false;
    }
    return FiltroTablaBase::eventFilter(obj,event);
}

QRect FiltroTablaMediciones::DibujarMarcasSeleccionRestringida()
{
    QRect rectSelect = m_tabla->visualRect(m_tabla->selectionModel()->selectedIndexes().first())|
            m_tabla->visualRect(m_tabla->selectionModel()->selectedIndexes().last());
    m_marca->move(rectSelect.topLeft());
    m_marca->resize(rectSelect.size());
    m_marcoSeleccionRestringida->move(rectSelect.topLeft());
    m_marcoSeleccionRestringida->resize(rectSelect.size());
    return rectSelect;

}

void FiltroTablaMediciones::FiltrarColumnaSeleccion()
{
    if (m_modoRestringido == true /*&& !m_tabla->selectionModel()->selectedIndexes().isEmpty()*/)
    {
        qDebug()<<"Filtrando en modo restringido";
        for(const QModelIndex& item : m_tabla->selectionModel()->selectedIndexes())
        {
            if( item.column() != m_currentIndex.column())
            {
                m_tabla->selectionModel()->select(item,QItemSelectionModel::Deselect);
            }
        }
        DibujarMarcasSeleccionRestringida();
    }
}


