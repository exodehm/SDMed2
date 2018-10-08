#include "MedCertModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

MedCertModel::MedCertModel(const QString &cadenaInicio, QUndoStack *p,QObject *parent):ModeloBase(cadenaInicio, p, parent)
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

bool MedCertModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

}

bool MedCertModel::EsPartida()
{

}

void MedCertModel::PrepararCabecera(QList<QList<QVariant> > &datos)
{
    //if (!datos.isEmpty())
    {
        QList<QVariant>cabecera;
        for (int i=0;i<LeyendasCabecera.size();i++)
        {
            //qDebug()<<"cabecera: "<<static_cast<QVariant>(LeyendasCabecera[i]);
            cabecera.append(static_cast<QVariant>(LeyendasCabecera[i]));
        }
        datos.prepend(cabecera);
    }
}
