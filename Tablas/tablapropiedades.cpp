#include "tablapropiedades.h"
#include "./Modelos/PropiedadesModel.h"
#include "./filtrotablabase.h"
#include "./Delegados/delegadotablapropiedades.h"

TablaPropiedades::TablaPropiedades(const QString &tabla, QWidget *parent):TablaBase(parent)
{
    limiteIzquierdo=1;
    limiteDerecho=3;

    m_modelo = new PropiedadesModel(tabla);
    setModel(m_modelo);
    setObjectName("TablaPropiedades");
    //qDebug()<<"Modelo con "<<m_modelo->rowCount(QModelIndex());

    celdaBloqueada =  new bool[m_modelo->columnCount(QModelIndex())]{false};
    celdaBloqueada[0]=true;
    celdaBloqueada[1]=true;
    celdaBloqueada[3]=true;

    setItemDelegateForColumn(0,new DelegadoTablaPropiedades);
    setItemDelegateForColumn(1,new DelegadoTablaPropiedades);
    setItemDelegateForColumn(3,new DelegadoTablaPropiedades);
    //installEventFilter(new FiltroTablaBase(this));


}

void TablaPropiedades::ActualizarDatosPropiedades(const QString &propiedad)
{
    m_modelo->RellenarTabla(propiedad);
    //m_modelo->layoutChanged();
    resizeColumnsToContents();

}

void TablaPropiedades::MostrarMenuCabecera(const QPoint& pos)
{

}

void TablaPropiedades::MostrarMenuLateralTabla(const QPoint& pos)
{

}

void TablaPropiedades::MostrarMenuTabla(const QPoint& pos)
{

}
