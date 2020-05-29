#ifndef TABLAPRINCIPAL_H
#define TABLAPRINCIPAL_H

#include "../defs.h"
#include "tablabase.h"

class ModeloBase;

class TablaPrincipal : public TablaBase
{
     Q_OBJECT
public:
    explicit TablaPrincipal(const QString& tabla, const QStringList& ruta, MiUndoStack* p, QWidget *parent=nullptr);

    void MenuResumen(QPoint pos);

public slots:
    void MostrarMenuCabecera(QPoint pos) override;
    void MostrarMenuLateralTabla(QPoint pos) override;
    void MostrarMenuTabla(QPoint pos) override;
    //void Copiar();
    void CopiarPartidas();
    void PegarPartidas();
    void Mayusculas();
    void Minusculas();
};

#endif // TABLAPRINCIPAL_H
