#ifndef TABLACERT_H
#define TABLACERT_H


#include "tablamed.h"

class TablaCert : public TablaMed
{
     Q_OBJECT
public:
    explicit TablaCert(const QString& tabla, const QStringList& ruta, int num_certif, MiUndoStack* p, QWidget *parent=nullptr);


public slots:
    //void MostrarMenuCabecera(QPoint pos) override; //descomentar y añadir definición si se quiere un menu flotante propio
    void MostrarMenuLateralTabla(QPoint pos) override;
    //void Copiar();

signals:
    //void CopiarMediciones();
};


#endif // TABLACERT_H
