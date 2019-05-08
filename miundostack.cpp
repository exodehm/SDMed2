#include "miundostack.h"
#include <QDebug>

MiUndoStack::MiUndoStack(QObject *parent):QUndoStack(parent)
{

}

QStringList MiUndoStack::LeeRuta()
{
    return m_pilarutas.pop();
}

void MiUndoStack::GuardarRuta(const QStringList &ruta)
{
    m_pilarutas.push(ruta);
}

int MiUndoStack::tamanno()
{
    return m_pilarutas.size();
}

void MiUndoStack::Undo()
{
    undo();
}

void MiUndoStack::Redo()
{
    redo();
}

void MiUndoStack::Push(const QStringList &ruta, QUndoCommand *comando)
{
    GuardarRuta(ruta);
    push(comando);
    qDebug()<<"Pushhh";
}

