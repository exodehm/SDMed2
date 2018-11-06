#include "MedCertModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"
#include "../Undo/undoeditarmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

MedCertModel::MedCertModel(const QString &tabla, const QString &idpadre, const QString &idhijo, QUndoStack *p, QObject *parent):
    ModeloBase(tabla, idpadre, idhijo, p, parent)
{
    NUM_COLUMNAS = 10;
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
    LeyendasCabecera.append(QObject::tr("Id\n"));
    ActualizarDatos(codigopadre,codigohijo);
}

MedCertModel::~MedCertModel()
{
    qDebug()<<"Destructor modelo MedCertModel";
}

bool MedCertModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        QString descripcion ="Cambio el valor de "+ index.data().toString()+" a "+value.toString()+" en la linea: "+datos.at(index.row()+1).at(tipoColumna::ID).toString();
        pila->push(new UndoEditarMedicion(tabla,codigopadre,codigohijo,index.data(),value,
                                      datos.at(index.row()+1).at(tipoColumna::ID).toString(),index.column(),
                                      QVariant(descripcion)));
    }
    return false;
}

bool MedCertModel::EsPartida()
{

}

void MedCertModel::PrepararCabecera(QList<QList<QVariant> > &datos)
{
    if (!datos.isEmpty())
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

void MedCertModel::BorrarFilas(QList<int> filas)
{
    QList<QString>idsBorrar;
    foreach (const int& i, filas)
    {        
        idsBorrar.append(datos.at(i+1).at(9).toString());
        qDebug()<<"ID: "<<(datos.at(i+1).at(9));
    }
    QString desc="Undo borrar lineas medicion";
    QVariant V(desc);
    pila->push(new UndoBorrarLineasMedicion(tabla,idsBorrar,V));
}

void MedCertModel::InsertarFila(int fila)
{
    QString desc="Insertar linea medicion";
    QVariant V(desc);
    pila->push(new UndoInsertarLineaMedicion(tabla,codigopadre,codigohijo,fila,V));
}

void MedCertModel::ActualizarDatos(QString padre, QString hijo)
{
    hayFilaVacia = false;
    datos.clear();
    codigopadre=padre;
    codigohijo=hijo;
    QString cadena_consulta = "SELECT * FROM ver_mediciones('"+tabla+"','"+ codigopadre + "','"+ codigohijo+"')";
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
