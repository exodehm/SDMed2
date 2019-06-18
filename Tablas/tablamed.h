#ifndef TABLAMEDCERT_H
#define TABLAMEDCERT_H

#include "../defs.h"
#include "tablabase.h"

class MedicionModel;

class TablaMed : public TablaBase
{
     Q_OBJECT
public:
    explicit TablaMed(const QString& tabla, const QStringList& ruta, int num_certif, MiUndoStack* p, QWidget *parent=nullptr);

public slots:
    void MostrarMenuCabecera(QPoint pos) override;
    void MostrarMenuLateralTabla(QPoint pos) override;
    void MostrarMenuTabla(QPoint pos) override;

    void CambiarTipoSubtotalOrigen();
    void CambiarTipoSubtotalParcial();
    void CambiarTipoSubtotal();
    //void Copiar();
};


#endif // TABLAMEDCERT_H
