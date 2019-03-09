#include "MedicionModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"
#include "../Undo/undoeditarmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

MedicionModel::MedicionModel(const QString &tabla, const QString &codigopadre, const QString &codigohijo, tipoTablaMedCert tipotabla, QUndoStack *p, QObject *parent):
    eTipoTabla(tipotabla), ModeloBase(tabla, codigopadre, codigohijo, p, parent)
{    
    if (eTipoTabla == tipoTablaMedCert::MEDICION)
    {
        LeyendasCabecera.append(QObject::tr("Fase\n"));
    }
    else
    {
        LeyendasCabecera.append(QObject::tr("Certificación\n"));
    }
    LeyendasCabecera.append(QObject::tr("Comentario\n"));
    LeyendasCabecera.append(QObject::tr("Nº Uds\n"));
    LeyendasCabecera.append(QObject::tr("Longitud\n"));
    LeyendasCabecera.append(QObject::tr("Anchura\n"));
    LeyendasCabecera.append(QObject::tr("Altura\n"));
    LeyendasCabecera.append(QObject::tr("Fórmula\n"));
    LeyendasCabecera.append(QObject::tr("Parcial\n"));
    LeyendasCabecera.append(QObject::tr("SubTotal\n"));
    LeyendasCabecera.append(QObject::tr("Tipo\n"));
    LeyendasCabecera.append(QObject::tr("Id\n"));
    LeyendasCabecera.append(QObject::tr("Posicion\n"));
    NUM_COLUMNAS = LeyendasCabecera.size();
    ActualizarDatos(codigopadre,codigohijo);
}

MedicionModel::~MedicionModel()
{
    qDebug()<<"Destructor modelo MedCertModel";
}

bool MedicionModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    qDebug()<<"Set data mediciones en "<<index.row()<<" con datos de "<<datos.size();
    //cuando estoy en una fila extra (la ultima o cuando no hay medicion)
    if (index.row() == datos.size()-1)
    {
        QString descripcion ="Añado fila extra y edito";
        qDebug()<<descripcion;
        InsertarFila(index.row());
    }
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        QString descripcion ="Cambio el valor de "+ index.data().toString()+" a "+value.toString()+" en la linea: "+datos.at(index.row()+1).at(tipoColumnaTMedCert::ID).toString();
        qDebug()<<descripcion;
        pila->push(new UndoEditarMedicion(tabla,codigopadre,codigohijo,index.data(),value,
         datos.at(index.row()+1).at(tipoColumnaTMedCert::ID).toString(),index.column(), eTipoTabla, QVariant(descripcion)));
        return true;
    }    
    return false;
}

void MedicionModel::PrepararCabecera(/*QList<QList<QVariant> > &datos*/)
{    
    QList<QVariant>cabecera;
    for (int i=0;i<LeyendasCabecera.size();i++)
    {
        //qDebug()<<"cabecera: "<<static_cast<QVariant>(LeyendasCabecera[i]);
        if (i == tipoColumnaTMedCert::PARCIAL)
        {
            QString SubT = LeyendasCabecera[i] + QString::number(subtotal,'f',2);
            cabecera.append(static_cast<QVariant>(SubT));
            ++i;
            //qDebug()<<"El numero es: "<<QString::number(subtotal,'f',2);
        }
        cabecera.append(static_cast<QVariant>(LeyendasCabecera[i]));
    }
    datos.prepend(cabecera);
}

void MedicionModel::Copiar(const QList<int>& filas)
{

}

void MedicionModel::Pegar(int fila)
{

}

void MedicionModel::Certificar(const QList<int> &filas, QString num_cert)
{
    for (auto elem:filas)
        qDebug()<<"Copiar los indices: "<<elem;
    QString indices;
    indices.append("{");
    for (int i=0;i<filas.size();i++)
    {
       indices.append(QString::number(filas.at(i)));
       if (i<filas.size()-1)
       {
           indices.append(",");
       }
    }
    indices.append("}");
    pila->push(new UndoCertificarLineaMedicion(tabla,codigopadre,codigohijo,indices,num_cert,QVariant()));    
}

void MedicionModel::BorrarFilas(const QList<int>& filas)
{
    qDebug()<<"Borrar filas medicion"<<datos.size()<<"-"<<datos.at(0).size();
    QList<QString>filasBorrar;
    foreach (const int& i, filas)
    {        
        filasBorrar.append(datos.at(i+1).at(tipoColumnaTMedCert::POSICION).toString());
    }
    QString desc="Undo borrar lineas medicion";
    QVariant V(desc);
    pila->push(new UndoBorrarLineasMedicion(tabla,filasBorrar,V));
}

void MedicionModel::InsertarFila(int fila)
{
    QString desc="Insertar linea medicion en fila: "+fila;
    qDebug()<<desc;
    QVariant V(desc);
    pila->push(new UndoInsertarLineaMedicion(tabla,codigopadre,codigohijo,1,fila,eTipoTabla,V));
}

void MedicionModel::CambiarTipoLineaMedicion(int fila, int columna, QVariant tipo)
{
    QString desc = "Cambiar tipo de columna subtotal" ;
    pila->push(new UndoEditarMedicion(tabla,codigopadre,codigohijo,datos.at(fila+1).at(columna+1),tipo,
     datos.at(fila+1).at(tipoColumnaTMedCert::ID).toString(),columna, eTipoTabla, QVariant(desc)));
}

void MedicionModel::ActualizarDatos(QString padre, QString hijo)
{
    hayFilaVacia = false;
    datos.clear();
    codigopadre=padre;
    codigohijo=hijo;
    subtotal = 0;
    QString cadena_consulta = "SELECT * FROM ver_medcert('"+tabla+"','"+ codigopadre + "','"+ codigohijo+"','"+QString::number(eTipoTabla)+"')";
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
            if (i == tipoColumnaTMedCert::PARCIAL)
            {
                subtotal += consulta.value(i).toFloat();
            }
        }
        datos.append(lineaDatos);
        lineaDatos.clear();        
    }
    PrepararCabecera(/*datos*/);
    if (datos.size()<=1)//añado una fila extra para poder insertar hijos en caso de hojas
    {
        hayFilaVacia = true;
        filavacia=0;
    }
}
