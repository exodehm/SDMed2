#ifndef MIUNDOSTACK_H
#define MIUNDOSTACK_H

#include <QUndoStack>
#include <QStringList>
#include <QStack>

class MiUndoStack : public QUndoStack
{
    Q_OBJECT

public:
    MiUndoStack(QObject * parent = nullptr);
    QStringList LeeRuta();
    void GuardarRuta(const QStringList &ruta);
    int tamanno();
    void Undo();
    void Redo();
    void Push(const QStringList &ruta, QUndoCommand* comando);

private:
    QStack<QStringList>m_pilarutas;

};

#endif // MIUNDOSTACK_H
