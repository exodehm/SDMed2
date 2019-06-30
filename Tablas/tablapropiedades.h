#ifndef TABLAPROPIEDADES_H
#define TABLAPROPIEDADES_H

#include "tablabase.h"
#include <QObject>

class PropiedadesModel;

class TablaPropiedades : public TablaBase
{
    Q_OBJECT
public:
    TablaPropiedades(const QString& tabla, /*const QStringList& ruta, */QWidget *parent=nullptr);

public slots:
    void ActualizarDatos(const QString& propiedad);
    void MostrarMenuCabecera(QPoint pos) override;
    void MostrarMenuLateralTabla(QPoint pos) override;
    void MostrarMenuTabla(QPoint pos) override;

private:
    PropiedadesModel* m_modelo;
};

#endif // TABLAPROPIEDADES_H