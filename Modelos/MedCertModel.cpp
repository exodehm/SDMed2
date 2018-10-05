#include "MedCertModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

MedCertModel::MedCertModel(const QString &cadenaInicio, QObject *parent):ModeloBase(cadenaInicio, parent)
{
    NUM_COLUMNAS = 9;
    //if (tabla==tipoTablaMedicion::MEDICION)
    {
        LeyendasCabecera.append(QObject::tr("Fase\n"));
    }
    /*else
    {
        LeyendasCabecera.append(QObject::tr("Nº Certificacion\n"));
    }*/
    LeyendasCabecera.append(QObject::tr("Comentario\n"));
    LeyendasCabecera.append(QObject::tr("Nº Uds\n"));
    LeyendasCabecera.append(QObject::tr("Longitud\n"));
    LeyendasCabecera.append(QObject::tr("Anchura\n"));
    LeyendasCabecera.append(QObject::tr("Altura\n"));
    LeyendasCabecera.append(QObject::tr("Fórmula\n"));
    LeyendasCabecera.append(QObject::tr("Parcial\n"));
    LeyendasCabecera.append(QObject::tr("SubTotal\n"));
    //LeyendasCabecera.append(QObject::tr("Id\n"));
    ActualizarDatos(cadenaInicio);
}

MedCertModel::~MedCertModel()
{
    qDebug()<<"Destructor modelo MedCertModel";
}

bool MedCertModel::EsPartida()
{

}
