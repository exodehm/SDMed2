#include "CertificacionModel.h"

#include <QDebug>

CertificacionModel::CertificacionModel(const QString &tabla, const QString &codigopadre, const QString &codigohijo, QUndoStack *p, QObject *parent):
    MedCertModel(tabla, codigopadre, codigohijo, p, parent)
{
    NUM_COLUMNAS = 11;
    /*if (tabla==tipoTablaMedicion::MEDICION)
    {
       // LeyendasCabecera.append(QObject::tr("Fase\n"));
    }
    else*/
    {
        LeyendasCabecera.append(QObject::tr("Nº Certificacion\n"));
    }
    LeyendasCabecera.append(QObject::tr("Comentario\n"));
    LeyendasCabecera.append(QObject::tr("Nº Uds\n"));
    LeyendasCabecera.append(QObject::tr("Longitud\n"));
    LeyendasCabecera.append(QObject::tr("Anchura\n"));
    LeyendasCabecera.append(QObject::tr("Altura\n"));
    LeyendasCabecera.append(QObject::tr("Fórmula\n"));
    LeyendasCabecera.append(QObject::tr("Parcial\n"));
    LeyendasCabecera.append(QObject::tr("SubTotal\n"));
    LeyendasCabecera.append(QObject::tr("Id\n"));
    ActualizarDatos(codigopadre,codigohijo);
}

CertificacionModel::~CertificacionModel()
{
    qDebug()<<"Destructor modelo CertificacionModel";
}

void CertificacionModel::ActualizarDatos(QString padre, QString hijo)
{
    hayFilaVacia = false;
    datos.clear();
    codigopadre=padre;
    codigohijo=hijo;
    QString cadena_consulta = "SELECT * FROM ver_certificaciones('"+tabla+"','"+ codigopadre + "','"+ codigohijo+"')";
    qDebug()<<cadena_consulta;
    consulta.exec(cadena_consulta);
    QList<QVariant> lineaDatos;
    while (consulta.next())
    {
        for (int i=0;i<NUM_COLUMNAS;i++)
        {
            //qDebug()<<"CONSULTA.VALUE["<<i<<"] "<<consulta.value(i);
            if (consulta.value(i).type()==QVariant::Double)
            {
                float numero = consulta.value(i).toDouble();
                QString numeroletra = QString::number(numero, 'f', 2);
                lineaDatos.append(static_cast<QVariant>(numeroletra));
            }
            else
            {
                lineaDatos.append(consulta.value(i));
            }
        }
        datos.append(lineaDatos);
        lineaDatos.clear();
    }
    PrepararCabecera(datos);
    if (datos.size()<=1)//añado una fila extra para poder insertar hijos en caso de hojas
    {
        hayFilaVacia = true;
        filavacia=0;
    }
}

