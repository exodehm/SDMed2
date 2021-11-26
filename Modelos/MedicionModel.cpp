#include "MedicionModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"
#include "./miundostack.h"
#include "../Undo/undoeditarmedicion.h"
#include "./Dialogos/dialogoeditorformulasmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

MedicionModel::MedicionModel(const QString &tabla, const QStringList &ruta, int fase, MiUndoStack *p, QObject *parent):
    ModeloBase(tabla, ruta, p, parent), num_cert(fase)
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
    //cuando estoy en una fila extra (la ultima o cuando no hay medicion)
    if (index.row() == m_datos.size()-1)
    {
        //QString descripcion ="Añado fila extra y edito";
        //qDebug()<<descripcion;
        InsertarFila(index.row());
    }
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        QString descripcion ="Cambio el valor de "+ index.data().toString()+" a "+value.toString()+" en la linea: "+m_datos.at(index.row()+1).at(tipoColumnaTMedCert::POSICION).toString();
        //qDebug()<<descripcion;
        m_pila->Push(m_ruta, num_cert, new UndoEditarMedicion(m_tabla,m_codigopadre,m_codigohijo,index.data(),value,
         index.row(),index.column(), num_cert, QVariant(descripcion)));
        return true;
    }
    if (index.isValid() && role == Qt::ToolTipRole)
    {
        return true;
    }
    return false;
}

Qt::ItemFlags MedicionModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
    {
        return nullptr;
    }
    if (index.column()!=tipoColumnaTMedCert::FORMULA && index.column()!=tipoColumnaTMedCert::PARCIAL && index.column()!=tipoColumnaTMedCert::SUBTOTAL)
    {
        return QAbstractTableModel::flags(index) | Qt::ItemIsEditable;
    }
    return  QAbstractItemModel::flags(index);
}

void MedicionModel::PrepararCabecera(/*QList<QList<QVariant> > &datos*/)
{    
    QList<QVariant>cabecera;    
    for (int i=0;i<m_LeyendasCabecera.size();i++)
    {
        //qDebug()<<"cabecera: "<<static_cast<QVariant>(LeyendasCabecera[i]);
        if (i == tipoColumnaTMedCert::PARCIAL)
        {
            //QString SubT = m_LeyendasCabecera[i] + QString::number(m_subtotal,'f',2);
            QString SubT = m_LeyendasCabecera[i] + m_locale.toString(m_subtotal,'f',m_precision);
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
    qDebug()<<"Copiar mediciones";
    QString lista;
    lista.append("{");
    for (int i=0;i<filas.size();i++)
    {
       lista.append(QString::number(filas.at(i)));
       if (i<filas.size()-1)
       {
           lista.append(",");
       }
    }
    lista.append("}");
    QString cadenacopiar = "SELECT copiar_medicion('"+m_tabla+"','"+m_codigopadre +"','"+ m_codigohijo +"','"+ QString::number(num_cert) +"','"+ lista+"')";
    qDebug()<<cadenacopiar;
    m_consulta.exec(cadenacopiar);
}

void MedicionModel::Pegar(int fila)
{
    m_pila->Push(m_ruta, num_cert, new UndoPegarLineasMedicion(m_tabla, m_codigopadre, m_codigohijo, num_cert, fila,QVariant()));
}

void MedicionModel::Certificar(const QList<int> &filas)
{
    QString desc = "Certificar lineas medicion";
    QVariant V(desc);
    QString cadenacertificacionactiva = "SELECT * FROM ver_certificacion_actual('"+m_tabla+"')";
    m_consulta.exec(cadenacertificacionactiva);
    int certificacionActiva=-1;
    while (m_consulta.next())
    {
        certificacionActiva = m_consulta.value(0).toInt();
    }
    if (certificacionActiva>0)
    {
        //en este caso no guardo la tabla activa cuando certifico (que sería la tabla de mediciones), sino la tabla en la que
        //voy a certificar
        m_pila->Push(m_ruta,certificacionActiva,new UndoCertificarLineaMedicion(m_tabla,m_codigopadre,m_codigohijo,filas,num_cert,V));
    }
}

void MedicionModel::BorrarFilas(const QList<int>& filas)
{
    qDebug()<<"Borrar filas medicion"<<m_datos.size()<<"-"<<m_datos.at(0).size();    
    QString desc="Undo borrar lineas medicion";
    QVariant V(desc);
    m_pila->Push(m_ruta,num_cert,new UndoBorrarLineasMedicion(m_tabla,m_codigopadre,m_codigohijo,filas,num_cert,V));
}

void MedicionModel::InsertarFila(int fila)
{
    QString desc="Insertar linea medicion en fila: "+ QString::number(fila);
    qDebug()<<desc;
    QVariant V(desc);
    m_pila->Push(m_ruta,num_cert, new UndoInsertarLineaMedicion(m_tabla,m_codigopadre,m_codigohijo,1,fila,num_cert, V));
}

void MedicionModel::CambiarTipoLineaMedicion(int fila, int columna, QVariant tipo)
{
    QString desc = "Cambiar tipo de columna subtotal" ;
    m_pila->Push(m_ruta,num_cert,new UndoEditarMedicion(m_tabla,m_codigopadre,m_codigohijo,m_datos.at(fila+1).at(columna+1),tipo,
                                      m_datos.at(fila+1).at(tipoColumnaTMedCert::POSICION).toInt(),columna, num_cert, QVariant(desc)));
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
    m_subtotal = 0;
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
                float numero = m_consulta.value(i).toFloat();
                QString numeroletra = QString::number(numero, 'f', 2);
                lineaDatos.append(static_cast<QVariant>(numeroletra));
            }
            else
            {
                lineaDatos.append(m_consulta.value(i));
            }
            if (i == tipoColumnaTMedCert::PARCIAL)
            {
                m_subtotal += m_consulta.value(i).toFloat();
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

void MedicionModel::EditarFormula(const QModelIndex& index)
{
    QVariant uds = index.sibling(index.row(),index.column()-4).data();
    QVariant longitud = index.sibling(index.row(),index.column()-3).data();
    QVariant anchura = index.sibling(index.row(),index.column()-2).data();
    QVariant altura = index.sibling(index.row(),index.column()-1).data();
    QVariant formula = index.data();
    DialogoEditorFormulasMedicion* d = new DialogoEditorFormulasMedicion(uds,longitud,anchura,altura,formula);
    if (d->exec())
    {
        setData(index.sibling(index.row(),index.column()-4),QVariant(d->LeeUd()),Qt::EditRole);
        setData(index.sibling(index.row(),index.column()-3),QVariant(d->LeeLong()),Qt::EditRole);
        setData(index.sibling(index.row(),index.column()-2),QVariant(d->LeeAnc()),Qt::EditRole);
        setData(index.sibling(index.row(),index.column()-1),QVariant(d->LeeAlt()),Qt::EditRole);
        setData(index,QVariant(d->LeeFormula()),Qt::EditRole);

        setData(index,QVariant("chachi"),Qt::ToolTipRole);
        qDebug()<<"contenido: "<<data(index).toString();
        qDebug()<<"lo otro: "<<data(index,Qt::ToolTipRole);
    }
}

void MedicionModel::IgualarDatoColumna(const QModelIndexList &celdas)
{
    auto it = celdas.begin();
    QVariant datoInicial = (*it).data();
    qDebug()<<"Igualar las celdas a "<<datoInicial;
    ++it;
    while (it!=celdas.end())
    {
        setData(*it,datoInicial,Qt::EditRole);
        ++it;
    }
}
