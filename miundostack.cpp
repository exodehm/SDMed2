#include "miundostack.h"
#include <QPair>
#include <QDebug>

MiUndoStack::MiUndoStack(QObject *parent):QUndoStack(parent)
{

}

QStringList MiUndoStack::LeeRuta()
{
    return m_pilaposiciones.pop().first;
    /*QPair<QStringList,int> dato = m_pilarutas.pop();
    return dato.first;*/
}

int MiUndoStack::LeeTablaMedCertActiva()
{
    /*QPair<QStringList,int> dato = m_pilarutas.pop();
    return dato.second;*/
    return m_pilaposiciones.pop().second;
}

MiUndoStack::POSICION MiUndoStack::LeePosicion()
{
    return m_pilaposiciones.pop();
}

void MiUndoStack::GuardarPosicion(const QStringList &ruta, int tablamedcertactiva)
{
    //QPair<QStringList,int>dato(ruta,tablamedcertactiva);
    m_pilaposiciones.push(qMakePair(ruta,tablamedcertactiva));
}

int MiUndoStack::tamanno()
{
    return m_pilaposiciones.size();
}

void MiUndoStack::Undo()
{
    undo();
}

void MiUndoStack::Redo()
{
    redo();
}

void MiUndoStack::Push(const QStringList &ruta, int tablaactiva, QUndoCommand *comando)
{
    GuardarPosicion(ruta,tablaactiva);
    push(comando);
    //qDebug()<<"Pushhh";
}

