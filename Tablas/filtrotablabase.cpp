#include "filtrotablabase.h"
#include <QEvent>
#include <QKeyEvent>

FiltroTablaBase::FiltroTablaBase(TablaBase *tabla, QObject *parent) : m_tabla(tabla),QObject(parent)
{

}

bool FiltroTablaBase::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress)
    {
        QModelIndex indice = m_tabla->currentIndex();
        QKeyEvent *ke =static_cast<QKeyEvent*>(event);
        switch (ke->key())
        {
        case (Qt::Key_Delete):
        {
            if (m_tabla->selectionModel()->isRowSelected(indice.row(),QModelIndex()))//si hay alguna fila seleccionada
            {
                QModelIndexList indices = m_tabla->selectionModel()->selectedIndexes();
                QList<int> listaIndices;
                foreach (QModelIndex i, indices)
                {
                    if (!listaIndices.contains(i.row()))
                        listaIndices.prepend(i.row());//pongo prepend para borrar de atras a adelante de la lista de medicion
                }
                qSort(listaIndices);
                ModeloBase* modelo = qobject_cast<ModeloBase*>(m_tabla->model());
                if (modelo)
                {
                    modelo->BorrarFilas(listaIndices);
                }
                m_tabla->setUpdatesEnabled(true);
            }
            else
            {
                m_tabla->model()->setData(m_tabla->currentIndex(),"",Qt::EditRole);//solo si hay una celda seleccionada
            }
            m_tabla->clearSelection();
            return true;

        }
        case (Qt::Key_Tab):
        {
            int col=indice.column();
            col++;
            while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
            {
                col++;
            }
            QModelIndex ind;
            if (col>m_tabla->limiteDerecho)
            {
                if (indice.row()==m_tabla->model()->rowCount(QModelIndex())-1)//si estoy en la ultima fila
                {
                    ModeloBase* modelo = qobject_cast<ModeloBase*>(m_tabla->model());
                    if (modelo)
                    {
                        if (m_tabla->model()->rowCount(QModelIndex())==modelo->NumeroLineasDatosTabla()-1)
                        {
                            m_tabla->model()->insertRow(m_tabla->model()->rowCount(QModelIndex()));
                            ind = m_tabla->model()->index(indice.row()+1,m_tabla->limiteIzquierdo);
                        }
                        else
                        {
                            ind = m_tabla->model()->index(indice.row(),m_tabla->limiteIzquierdo);
                        }
                    }
                }
                else
                {
                    ind = m_tabla->model()->index(indice.row()+1,m_tabla->limiteIzquierdo);
                }
            }
            else//avance normal antes de la ultima columna
            {
                ind = m_tabla->model()->index(indice.row(),col);
            }
            m_tabla->setCurrentIndex(ind);
            emit m_tabla->CambiaFila(ind);
            return true;
        }
        case (Qt::Key_Backtab):
        {
            int col=indice.column();
            col--;
            while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
            {
                col--;
            }
            QModelIndex ind;
            if (col<m_tabla->limiteIzquierdo)
            {
                if (indice.row()==0)
                {
                    col=0;
                    while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
                    {
                        col++;
                    }
                    ind = m_tabla->model()->index(0,col);
                }
                else
                {
                    col=m_tabla->limiteDerecho;
                    while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
                    {
                        col--;
                    }
                    ind = m_tabla->model()->index(indice.row()-1,col);
                }
            }
            else
            {
                ind = m_tabla->model()->index(indice.row(),col);
            }
            m_tabla->setCurrentIndex(ind);
            emit m_tabla->CambiaFila(ind);
            return true;            
        }
        case (Qt::Key_Up):
        {
            if (indice.row()>0)//si estoy en la segunda fila o mas
            {
                QModelIndex ind = m_tabla->model()->index(indice.row()-1,indice.column());
                //qDebug()<<"Fila: "<<ind.row()<<" - Columna: "<<ind.column();
                emit m_tabla->CambiaFila(ind);
                m_tabla->setCurrentIndex(ind);
                return true;
            }
            break;
        }
        case (Qt::Key_Down):
        {
            qDebug()<<"Tecla abajo";
            QModelIndex ind;
            if (indice.row() == m_tabla->model()->rowCount(QModelIndex())-1)//ultima fila
            {
                ModeloBase* modelo = qobject_cast<ModeloBase*>(m_tabla->model());
                if (modelo)
                {
                    if (m_tabla->model()->rowCount(QModelIndex())==modelo->NumeroLineasDatosTabla()-1)
                    {
                        m_tabla->model()->insertRow(m_tabla->model()->rowCount(QModelIndex()));
                        ind = m_tabla->model()->index(indice.row()+1,indice.column(), QModelIndex());

                    }
                    else
                    {
                        ind = m_tabla->model()->index(indice.row(),indice.column(), QModelIndex());
                    }
                }
            }
            else
            {
                ind = m_tabla->model()->index(indice.row()+1,indice.column(), QModelIndex());
                emit m_tabla->CambiaFila(ind);
            }
            m_tabla->setCurrentIndex(ind);
            return true;
        }
        case (Qt::Key_Right):
        {
            int col=indice.column();
            col++;
            while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
            {
                col++;
            }
            if (col>m_tabla->limiteDerecho)
            {
                col--;
                while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
                {
                    col--;
                }
            }
            QModelIndex ind = m_tabla->model()->index(indice.row(),col);
            emit m_tabla->CambiaFila(ind);
            m_tabla->setCurrentIndex(ind);
            return true;            
        }
        case (Qt::Key_Left):
        {
            int col=indice.column();
            col--;
            while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
            {
                col--;
            }
            if (col<m_tabla->limiteIzquierdo)
            {
                col++;
                while (m_tabla->columnaBloqueada(col) || m_tabla->isColumnHidden(col))
                {
                    col++;
                }
            }
            QModelIndex ind = m_tabla->model()->index(indice.row(),col);
            emit m_tabla->CambiaFila(ind);
            m_tabla->setCurrentIndex(ind);
            return true;            
        }
        case (Qt::Key_F5):
        {
            {
                qDebug()<<m_tabla->selectionModel()->selectedRows().size();
                //si no hay filas seleccionadas selecciono la fila actual de la tabla
                if (m_tabla->selectionModel()->selectedRows().size()==0)
                {
                    m_tabla->selectRow(m_tabla->currentIndex().row());
                }
                ModeloBase* modelo = qobject_cast<ModeloBase*>(m_tabla->model());
                if (modelo)
                {
                    modelo->InsertarFila(indice.row());
                }
                QModelIndex ind = m_tabla->model()->index(indice.row(),m_tabla->limiteIzquierdo);
                m_tabla->setCurrentIndex(ind);
                return true;
            }            
        }
        case (Qt::Key_F2):
        {
            m_tabla->edit(indice);
            return true;
        }
        case (Qt::Key_A)://seleccionar todo
        {
            if (ke->modifiers()==Qt::ControlModifier)
            {
                /*if (tabla->objectName()=="TablaP")
                    {
                        emit tabla->CopiarPartidas();
                    }
                    else
                    {
                        emit tabla->CopiarMedicion();
                    }*/
                m_tabla->SeleccionarTodo();
                return true;
            }
            break;
        }
        case (Qt::Key_C)://Copiar
        {
            if (ke->modifiers()==Qt::ControlModifier)
            {
                emit m_tabla->Copiar();
                return true;
            }
            break;
        }
        case (Qt::Key_X)://Cortar
        {
            if (ke->modifiers()==Qt::ControlModifier)
            {
                qDebug()<<"Cortanding";
                return true;
            }
            break;
        }
        case (Qt::Key_V)://Pegar
        {
            if (ke->modifiers()==Qt::ControlModifier)
            {
                emit m_tabla->Pegar();
                return true;
            }
            break;
        }
        default:
        {
            return false;            
        }
        }
    }
    return QObject::eventFilter(obj, event);
}
