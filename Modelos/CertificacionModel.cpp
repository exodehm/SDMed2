#include "CertificacionModel.h"

#include <QDebug>

CertificacionModel::CertificacionModel(const QString &tabla, const QString &codigopadre, const QString &codigohijo, QUndoStack *p, QObject *parent):
    MedCertModel(tabla, codigopadre, codigohijo, p, parent)
{
    //NUM_COLUMNAS = 10;
    //if (tabla==tipoTablaMedicion::MEDICION)
    {
       // LeyendasCabecera.append(QObject::tr("Fase\n"));
    }
    /*else
    {
        LeyendasCabecera.append(QObject::tr("Nº Certificacion\n"));
    }*/
    /*LeyendasCabecera.append(QObject::tr("Comentario\n"));
    LeyendasCabecera.append(QObject::tr("Nº Uds\n"));
    LeyendasCabecera.append(QObject::tr("Longitud\n"));
    LeyendasCabecera.append(QObject::tr("Anchura\n"));
    LeyendasCabecera.append(QObject::tr("Altura\n"));
    LeyendasCabecera.append(QObject::tr("Fórmula\n"));
    LeyendasCabecera.append(QObject::tr("Parcial\n"));
    LeyendasCabecera.append(QObject::tr("SubTotal\n"));
    LeyendasCabecera.append(QObject::tr("Id\n"));
    ActualizarDatos(codigopadre,codigohijo);*/
}

CertificacionModel::~CertificacionModel()
{
    qDebug()<<"Destructor modelo CertificacionModel";
}

void CertificacionModel::Certificar(const QList<int> &filas)
{
    qDebug()<<"Certificarrrr";

    for (auto elem:filas)
        qDebug()<<"Copiar los indices: "<<elem;
}

void CertificacionModel::ActualizarDatos(QString padre, QString hijo)
{
    qDebug()<<"aarrghhh";
}
