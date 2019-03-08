#ifndef TABLAMEDCERT_H
#define TABLAMEDCERT_H

#include "../defs.h"
#include "tablabase.h"

class TablaMed : public TablaBase
{
     Q_OBJECT
public:
    explicit TablaMed(int nColumnas, QWidget *parent=nullptr);


public slots:
    void MostrarMenuCabecera(QPoint pos) override;
    void MostrarMenuLateralTabla(QPoint pos) override;
    void MostrarMenuTabla(QPoint pos) override;

    void CambiarTipoSubtotalOrigen();
    void CambiarTipoSubtotalParcial();
    void CambiarTipoSubtotal();
    //void Copiar();

signals:
    //void CopiarMediciones();

};


#endif // TABLAMEDCERT_H
