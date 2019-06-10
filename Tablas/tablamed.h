#ifndef TABLAMEDCERT_H
#define TABLAMEDCERT_H

#include "../defs.h"
#include "tablabase.h"

class TablaMed : public TablaBase
{
     Q_OBJECT
public:
    enum eModoSeleccion{SELECCION_NORMAL, SELECCION_RESTRINGIDA};

    explicit TablaMed(int nColumnas, QWidget *parent=nullptr);
    //void mouseMoveEvent(QMouseEvent *event) override;
    void paintEvent(QPaintEvent* event);


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
    //void hoverIndexChanged(QModelIndex);

private:
    eModoSeleccion modoSeleccion;
    bool m_BotonIzqPresionado;
    int m_tamMarca;

};


#endif // TABLAMEDCERT_H
