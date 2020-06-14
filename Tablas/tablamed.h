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
    void MostrarMenuCabecera(const QPoint& pos) override;
    void MostrarMenuLateralTabla(const QPoint& pos) override;
    void MostrarMenuTabla(const QPoint& pos) override;

    void CambiarTipoSubtotalOrigen();
    void CambiarTipoSubtotalParcial();
    void CambiarTipoSubtotal();
    //void Copiar();
    void CopiarMediciones();
    void PegarMediciones();
};


#endif // TABLAMEDCERT_H
