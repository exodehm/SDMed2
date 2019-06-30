#include "tablapropiedades.h"
#include "./Modelos/PropiedadesModel.h"
#include "./filtrotablabase.h"

TablaPropiedades::TablaPropiedades(const QString &tabla, QWidget *parent):TablaBase(parent)
{
    limiteIzquierdo=1;
    limiteDerecho=3;

    m_modelo = new PropiedadesModel(tabla);
    setModel(m_modelo);
    setObjectName("TablaP");
    qDebug()<<"Modelo con "<<m_modelo->rowCount(QModelIndex());

    celdaBloqueada =  new bool[m_modelo->columnCount(QModelIndex())]{false};
    celdaBloqueada[0]=true;
    celdaBloqueada[1]=true;
    celdaBloqueada[3]=true;

    setItemDelegateForColumn(0,dlgCB);
    setItemDelegateForColumn(1,dlgCB);
    setItemDelegateForColumn(3,dlgCB);
    installEventFilter(new FiltroTablaBase(this));


}

void TablaPropiedades::ActualizarDatos(const QString &propiedad)
{
    m_modelo->RellenarTabla(propiedad);
}

void TablaPropiedades::MostrarMenuCabecera(QPoint pos)
{

}

void TablaPropiedades::MostrarMenuLateralTabla(QPoint pos)
{

}

void TablaPropiedades::MostrarMenuTabla(QPoint pos)
{

}
