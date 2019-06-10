#ifndef FILTROTABLAMEDICIONES_H
#define FILTROTABLAMEDICIONES_H

#include "./filtrotablabase.h"

class QPushButton;

class FiltroTablaMediciones : public FiltroTablaBase
{
public:
    explicit FiltroTablaMediciones(TablaBase* tabla, QObject *parent = nullptr);
    bool eventFilter(QObject* obj, QEvent *event) override;

private:
    QPushButton * m_boton_formulas;
    QModelIndex currentIndex;
};

#endif // FILTROTABLAMEDICIONES_H
