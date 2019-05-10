#ifndef MIUNDOSTACK_H
#define MIUNDOSTACK_H

#include <QUndoStack>
#include <QStringList>
#include <QStack>
#include <QPair>

class MiUndoStack : public QUndoStack
{
    Q_OBJECT

public:
    typedef QPair<QStringList,int> POSICION;
    MiUndoStack(QObject * parent = nullptr);
    QStringList LeeRuta();
    int LeeTablaMedCertActiva();
    POSICION LeePosicion();
    void GuardarPosicion(const QStringList &ruta, int tablamedcertactiva);

    int tamanno();
    void Undo();
    void Redo();
    void Push(const QStringList &ruta,int tablaactiva, QUndoCommand* comando);

private:
    QStack<QPair<QStringList,int>>m_pilaposiciones;
};

#endif // MIUNDOSTACK_H
