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

    void MenuResumen(const QPoint& pos);
    void MenuPrecio (const QPoint& pos);

public slots:
    void MostrarMenuCabecera(const QPoint& pos) override;
    void MostrarMenuLateralTabla(const QPoint& pos) override;
    void MostrarMenuTabla(const QPoint &pos) override;
    //void Copiar();
    void CopiarPartidas();
    void PegarPartidas();
    void Mayusculas();
    void Minusculas();
    void BloquearDesbloquearPrecio();

private:
    bool m_precio_bloqueado;
};

#endif // TABLAPRINCIPAL_H
