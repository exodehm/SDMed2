#ifndef TABLAPRINCIPAL_H
#define TABLAPRINCIPAL_H

#include "../defs.h"
#include "tablabase.h"

class TablaPrincipal : public TablaBase
{
     Q_OBJECT
public:
    explicit TablaPrincipal(int nColumnas, QWidget *parent=nullptr);

public slots:
    void MostrarMenuCabecera(QPoint pos) override;
    void MostrarMenuLateralTabla(QPoint pos) override;
    void MostrarMenuTabla(QPoint pos) override;
    //void Copiar();
    void CopiarPartidas();

signals:

};

#endif // TABLAPRINCIPAL_H
