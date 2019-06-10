#ifndef FILTROTABLABASE_H
#define FILTROTABLABASE_H

#include <QObject>
#include "./tablabase.h"

class FiltroTablaBase : public QObject
{
    Q_OBJECT
public:
    explicit FiltroTablaBase(TablaBase* tabla, QObject *parent = nullptr);
    bool eventFilter(QObject* tabla, QEvent *event) override;

signals:

public slots:

protected:
    TablaBase* m_tabla;
};

#endif // FILTROTABLABASE_H
