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
    ActualizarDatos(id_padre,id_hijo);
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
        pila->push(new UndoEditarMedicion(tabla,id_padre,id_hijo,index.data(),value,
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
    //guardo los datos de las filas que voy a borrar
    //estos datos los saco de la lista de datos. De esta lista solo me interesan los indices:
    //1:comentario
    //2:ud
    //3:longitud
    //4:latitud
    //5:altura
    //6:formula
    //9: id de la linea en la tabla
    //ademas he de suministrar la tabla, la id del padre y la id del hijo
    QList<QList<QVariant>>datosborrar;
    foreach (const int& i, filas)
    {
        QList<QVariant>datosborrarlinea;
        //añado la tabla y los idpadre e idhijo
        datosborrarlinea.append(tabla);
        datosborrarlinea.append(id_padre);
        datosborrarlinea.append(id_hijo);
        //el tipo
        if (datos.at(i+1).at(tipoColumna::SUBTOTAL).toString()!="0.00")
        {
            datosborrarlinea.append(1);
        }
        else if (!datos.at(i+1).at(tipoColumna::FORMULA).toString().isEmpty())
        {
            datosborrarlinea.append(3);
        }
        else
        {
            datosborrarlinea.append(0);
        }
        for (int j=0;j<NUM_COLUMNAS;j++)
        {
            if (j!=0 && j!=7 && j!=8)//descarto los indices 0,7 y 8
            {
                datosborrarlinea.append(datos.at(i+1).at(j));
            }
        }
        datosborrar.append(datosborrarlinea);
    }
    QString desc="Undo borrar lineas medicion";
    QVariant V(desc);
    pila->push(new UndoBorrarLineasMedicion(datosborrar,V));
}

void MedCertModel::ActualizarDatos(QString padre, QString hijo)
{
    hayFilaVacia = false;
    datos.clear();
    id_padre=padre;
    id_hijo=hijo;
    QString cadena_consulta = "SELECT * FROM ver_mediciones('"+tabla+"','"+ id_padre + "','"+ id_hijo+"')";
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
