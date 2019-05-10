#include "MedicionModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"
#include "./miundostack.h"
#include "../Undo/undoeditarmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

MedicionModel::MedicionModel(const QString &tabla, const QStringList &ruta, int fase, MiUndoStack *p, QObject *parent):
    num_cert(fase), ModeloBase(tabla, ruta, p, parent)
{    
    if (num_cert == 0)
    {
        m_LeyendasCabecera.append(QObject::tr("Fase\n"));
    }
    else
    {
        m_LeyendasCabecera.append(QObject::tr("Certificación\n"));
    }
    m_LeyendasCabecera.append(QObject::tr("Comentario\n"));
    m_LeyendasCabecera.append(QObject::tr("Nº Uds\n"));
    m_LeyendasCabecera.append(QObject::tr("Longitud\n"));
    m_LeyendasCabecera.append(QObject::tr("Anchura\n"));
    m_LeyendasCabecera.append(QObject::tr("Altura\n"));
    m_LeyendasCabecera.append(QObject::tr("Fórmula\n"));
    m_LeyendasCabecera.append(QObject::tr("Parcial\n"));
    m_LeyendasCabecera.append(QObject::tr("SubTotal\n"));
    m_LeyendasCabecera.append(QObject::tr("Tipo\n"));
    m_LeyendasCabecera.append(QObject::tr("Id\n"));
    m_LeyendasCabecera.append(QObject::tr("Posicion\n"));
    NUM_COLUMNAS = m_LeyendasCabecera.size();
    certif_actual = 0;    
}

MedicionModel::~MedicionModel()
{
    qDebug()<<"Destructor modelo MedCertModel";
}

bool MedicionModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    qDebug()<<"Set data mediciones en "<<index.row()<<" con datos de "<<m_datos.size();
    //cuando estoy en una fila extra (la ultima o cuando no hay medicion)
    if (index.row() == m_datos.size()-1)
    {
        QString descripcion ="Añado fila extra y edito";
        qDebug()<<descripcion;
        InsertarFila(index.row());
    }
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        QString descripcion ="Cambio el valor de "+ index.data().toString()+" a "+value.toString()+" en la linea: "+m_datos.at(index.row()+1).at(tipoColumnaTMedCert::ID).toString();
        qDebug()<<descripcion;
        m_pila->Push(m_ruta, num_cert, new UndoEditarMedicion(m_tabla,m_codigopadre,m_codigohijo,index.data(),value,
         m_datos.at(index.row()+1).at(tipoColumnaTMedCert::POSICION).toString(),index.column(), num_cert, QVariant(descripcion)));
        return true;
    }    
    return false;
}

void MedicionModel::PrepararCabecera(/*QList<QList<QVariant> > &datos*/)
{    
    QList<QVariant>cabecera;
    for (int i=0;i<m_LeyendasCabecera.size();i++)
    {
        //qDebug()<<"cabecera: "<<static_cast<QVariant>(LeyendasCabecera[i]);
        if (i == tipoColumnaTMedCert::PARCIAL)
        {
            QString SubT = m_LeyendasCabecera[i] + QString::number(subtotal,'f',2);
            cabecera.append(static_cast<QVariant>(SubT));
            ++i;
            //qDebug()<<"El numero es: "<<QString::number(subtotal,'f',2);
        }
        cabecera.append(static_cast<QVariant>(m_LeyendasCabecera[i]));
    }
    m_datos.prepend(cabecera);
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
    m_pila->push(new UndoCertificarLineaMedicion(m_tabla,m_codigopadre,m_codigohijo,indices,num_cert,QVariant()));
}

void MedicionModel::BorrarFilas(const QList<int>& filas)
{
    qDebug()<<"Borrar filas medicion"<<m_datos.size()<<"-"<<m_datos.at(0).size();
    /*QList<QString>filasBorrar;
    foreach (const int& i, filas)
    {        
        filasBorrar.append(m_datos.at(i+1).at(tipoColumnaTMedCert::ID).toString());
        //qDebug()<<"Id a borrar: "<<filasBorrar.at(i+1);
    }*/
    QString desc="Undo borrar lineas medicion";
    QVariant V(desc);
    m_pila->push(new UndoBorrarLineasMedicion(m_tabla,m_codigopadre,m_codigohijo,filas,num_cert,V));
}

void MedicionModel::InsertarFila(int fila)
{
    QString desc="Insertar linea medicion en fila: "+fila;
    qDebug()<<desc;
    QVariant V(desc);
    m_pila->Push(m_ruta,num_cert, new UndoInsertarLineaMedicion(m_tabla,m_codigopadre,m_codigohijo,1,QString::number(fila),num_cert, V));
}

void MedicionModel::CambiarTipoLineaMedicion(int fila, int columna, QVariant tipo)
{
    QString desc = "Cambiar tipo de columna subtotal" ;
    /*pila->push(new UndoEditarMedicion(tabla,codigopadre,codigohijo,datos.at(fila+1).at(columna+1),tipo,
                                      datos.at(fila+1).at(tipoColumnaTMedCert::ID).toString(),columna, eTipoTabla, QVariant(desc)));*/
}

void MedicionModel::CambiaCertificacionActual(int cert)
{
    //if (eTipoTabla==tipoTablaMedCert::CERTIFICACION)
    {
        certif_actual = cert;
    }
}

void MedicionModel::CambiarNumeroCertificacion(int numcert)
{
    num_cert = numcert;
}

void MedicionModel::ActualizarDatos(const QStringList &ruta)
{
    m_hayFilaVacia = false;
    m_datos.clear();
    m_ruta = ruta;
    m_codigopadre=ruta.at(ruta.size()-2);
    m_codigohijo=ruta.at(ruta.size()-1);
    subtotal = 0;
    QString cadena_consulta = "SELECT * FROM ver_medcert('"+m_tabla+"','"+ m_codigopadre + "','"+ m_codigohijo+"','"+QString::number(num_cert)+"')";
    qDebug()<<cadena_consulta;
    m_consulta.exec(cadena_consulta);
    QList<QVariant> lineaDatos;
    while (m_consulta.next())
    {
        for (int i=0;i<NUM_COLUMNAS;i++)
        {
            //qDebug()<<"CONSULTA.VALUE["<<i<<"] "<<consulta.value(i);
            if (m_consulta.value(i).type()==QVariant::Double)
            {
                float numero = m_consulta.value(i).toDouble();
                QString numeroletra = QString::number(numero, 'f', 2);
                lineaDatos.append(static_cast<QVariant>(numeroletra));
            }
            else
            {
                lineaDatos.append(m_consulta.value(i));
            }
            if (i == tipoColumnaTMedCert::PARCIAL)
            {
                subtotal += m_consulta.value(i).toFloat();
            }
        }
        m_datos.append(lineaDatos);
        lineaDatos.clear();        
    }
    PrepararCabecera(/*datos*/);
    if (m_datos.size()<=1)//añado una fila extra para poder insertar hijos en caso de hojas
    {
        m_hayFilaVacia = true;
        m_filavacia=0;
    }
}
