#include "tablaprincipalmodel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

TablaPrincipalModel::TablaPrincipalModel(const QString &cadenaInicio, QObject *parent):ModeloBase(cadenaInicio, parent)
{
    NUM_COLUMNAS = 11;
    LeyendasCabecera.append(tr("Código\n"));
    LeyendasCabecera.append(tr("Nat\n"));
    LeyendasCabecera.append(tr("Ud\n"));
    LeyendasCabecera.append(tr("Resumen\n"));
    LeyendasCabecera.append(tr("CanPres\n"));
    LeyendasCabecera.append(tr("CanCert\n"));
    LeyendasCabecera.append(tr("PorCertPres\n"));
    LeyendasCabecera.append(tr("PrPres\n"));
    LeyendasCabecera.append(tr("PrCert\n"));
    LeyendasCabecera.append(tr("ImpPres\n"));
    LeyendasCabecera.append(tr("ImpCert\n"));
    ActualizarDatos(cadenaInicio);
}

TablaPrincipalModel::~TablaPrincipalModel()
{
    qDebug()<<"Destructor modelo PrincipalModel";
}


bool TablaPrincipalModel::EsPartida()
{
    return naturalezapadre == 7;
}
