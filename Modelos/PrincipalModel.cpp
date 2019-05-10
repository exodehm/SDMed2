#include "PrincipalModel.h"
#include "./Undo/undoeditarprincipal.h"
#include "./Undo/undoinsertarprincipal.h"
#include "consultas.h"
#include "../defs.h"
#include "./miundostack.h"

#include "./Dialogos/dialogosuprimirmedicion.h"
#include "../Dialogos/dialogoprecio.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

PrincipalModel::PrincipalModel(const QString &tabla, const QStringList &ruta, MiUndoStack *p, QObject *parent):
    ModeloBase(tabla, ruta, p, parent)
{
    NUM_COLUMNAS = 11;
    m_LeyendasCabecera.append(tr("Código\n"));
    m_LeyendasCabecera.append(tr("Nat\n"));
    m_LeyendasCabecera.append(tr("Ud\n"));
    m_LeyendasCabecera.append(tr("Resumen\n"));
    m_LeyendasCabecera.append(tr("CanPres\n"));
    m_LeyendasCabecera.append(tr("CanCert\n"));
    m_LeyendasCabecera.append(tr("PorCertPres\n"));
    m_LeyendasCabecera.append(tr("PrPres\n"));
    m_LeyendasCabecera.append(tr("PrCert\n"));
    m_LeyendasCabecera.append(tr("ImpPres\n"));
    m_LeyendasCabecera.append(tr("ImpCert\n"));
    //ActualizarDatos(codigopadre, codigohijo);
}

PrincipalModel::~PrincipalModel()
{
    qDebug()<<"Destructor modelo PrincipalModel";
}

bool PrincipalModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        QString codpadre = m_datos.at(0).at(tipoColumnaTPrincipal::CODIGO).toString();
        QString codhijo = this->index(index.row(),tipoColumnaTPrincipal::CODIGO).data().toString();
        codpadre.remove(m_LeyendasCabecera[0]);
        switch (index.column())
        {
        case tipoColumnaTPrincipal::CODIGO:
            if (index.data().isNull())//cuando este en una fila vacia se insertara una nueva partida
            {
                QString descripcion = "Insertar nueva partida con el codigo: ";
                m_pila->Push(m_ruta,0,new UndoInsertarPartidas(m_tabla, codpadre, value, index.row(),descripcion));
                return true;
            }
            else
            {
                QString descripcion = "Editar codigo con el codigo: ";
                m_pila->Push(m_ruta,0,new UndoEditarCodigo(m_tabla, codpadre, codhijo, index.data(), value, descripcion));
                return true;
            }
            break;
        case tipoColumnaTPrincipal::NATURALEZA:
        {
            QString descripcion = "Editar resumen con el codigo: ";
            m_pila->Push(m_ruta,0,new UndoEditarNaturaleza(m_tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumnaTPrincipal::UD:
        {
            QString descripcion = "Editar ud con el codigo: ";
            m_pila->Push(m_ruta,0,new UndoEditarUnidad(m_tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumnaTPrincipal::RESUMEN:
        {
            QString descripcion = "Editar resumen con el codigo: ";            
            m_pila->Push(m_ruta,0,new UndoEditarResumen(m_tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumnaTPrincipal::CANPRES:
        case tipoColumnaTPrincipal::CANCERT:
        {
            QString descripcion = "Editar cantidad con el codigo: ";
            QString tipoCantidad;
            if (index.column()==tipoColumnaTPrincipal::CANPRES)
            {
                tipoCantidad = "0";
            }
            else
            {
                tipoCantidad = "1";
            }
            QString cadenahaymediciones = "SELECT hay_medcert ('"+ m_tabla + "','" + codpadre + "','" + codhijo+"','" + tipoCantidad+"');";
            m_consulta.exec(cadenahaymediciones);
            qDebug()<<cadenahaymediciones;
            bool hayMedCert;
            while (m_consulta.next())
            {
                hayMedCert = m_consulta.value(0).toBool();
            }
            if (hayMedCert)
            {
                DialogoSuprimirMedicion* d = new DialogoSuprimirMedicion(m_tabla, tipoCantidad);
                if (d->exec()==QDialog::Rejected || d->Suprimir()==false)
                {
                    return false;
                }
            }
            m_pila->Push(m_ruta,0,new UndoEditarCantidad(m_tabla, codpadre, codhijo, index.data(), value, tipoCantidad, descripcion));
            return true;
        }
            break;
        case tipoColumnaTPrincipal::PRPRES:
        {
            QString descripcion = "Editar precio con el codigo: ";
            QString cadenahaydescompuesto = "SELECT hay_descomposicion ('"+ m_tabla + "','" + codhijo+"');";
            m_consulta.exec(cadenahaydescompuesto);
            bool hayDescompuesto;
            while (m_consulta.next())
            {
                hayDescompuesto = m_consulta.value(0).toBool();
            }
            if (hayDescompuesto)
            {
                DialogoPrecio* d = new DialogoPrecio(m_tabla);
                if (d->exec()==QDialog::Rejected || d->Respuesta()==0)
                {
                    return false;
                }
                else
                {           
                    m_pila->Push(m_ruta,0,new UndoEditarPrecio(m_tabla, codpadre, codhijo, index.data(), value, d->Respuesta(), descripcion));
                }
            }
            else
            {
                m_pila->Push(m_ruta,0,new UndoEditarPrecio(m_tabla, codpadre, codhijo, index.data(), value, precio::MODIFICAR, descripcion));
            }
            return true;
        }
            break;
        default:
            break;
        }
        return true;
    }
    return false;
}

bool PrincipalModel::removeRows(int fila, int numFilas, const QModelIndex& parent)
{
    Q_UNUSED(parent);
    beginRemoveRows(QModelIndex(), fila, fila+numFilas-1);
    qDebug()<<"Borrar Fila en tabla principal: "<<fila;
    qDebug()<<m_datos.at(fila).at(0);
    //QStringList partidasparaborrar;
    //partidasparaborrar.append(datos.at(0).at(0));//codigo padre
    //miobra->PosicionarAristaActual(filaInicial);
    //miobra->BorrarPartida();
    //ActualizarDatos(miobra->LeeDescompuesto());
    /*if (rowCount(QModelIndex())==0)
    {
        insertRow(0);
    }*/
    endRemoveRows();
    //layoutChanged();
    return true;
}

bool PrincipalModel::EsPartida()
{
    return m_naturalezapadre == static_cast<int>(Naturaleza::PARTIDA);
}

void PrincipalModel::PrepararCabecera()
{
    if (!m_datos.isEmpty())
    {     for(int i=0; i<m_datos.at(0).length(); i++)
        {
            //leo la naturaleza del concepto padre
            if (i==tipoColumnaTPrincipal::NATURALEZA)
            {
                m_naturalezapadre = m_datos.at(0).at(i).toInt();
            }
            QString datocabecera =m_datos.at(0).at(i).toString();
            datocabecera.prepend(m_LeyendasCabecera[i]);
            m_datos[0][i] = static_cast<QVariant>(datocabecera);
        }
    }
}

void PrincipalModel::BorrarFilas(const QList<int> &filas)
{
    QStringList partidasborrar;
    QString codpadre = m_datos.at(0).at(0).toString();
    codpadre.remove(m_LeyendasCabecera[0]);
    partidasborrar.append(codpadre);
    foreach (const int& i, filas)
    {
        //removeRows(i,1,QModelIndex());
        partidasborrar.append(m_datos.at(i+1).at(0).toString());//añado 1 por la cabecera
    }
    m_pila->Push(m_ruta,0,new UndoBorrarPartidas(m_tabla,partidasborrar,QVariant()));
}

void PrincipalModel::InsertarFila(int fila)
{
    insertRows(fila,1,QModelIndex());
}

void PrincipalModel::ActualizarDatos(const QStringList &ruta)
{
    m_hayFilaVacia = false;
    m_datos.clear();
    m_datoscolor.clear();
    m_ruta = ruta;
    m_codigopadre=ruta.at(ruta.size()-2);
    m_codigohijo=ruta.at(ruta.size()-1);
    QString cadena_consulta = "SELECT * FROM ver_hijos('"+m_tabla+"','"+ m_codigopadre+"','"+ m_codigohijo+"')";
    QString cadena_consulta_color = "SELECT * FROM ver_color_hijos('"+m_tabla+"','"+ m_codigopadre+"','"+ m_codigohijo+"')";
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
    //ahora el color
    m_consulta.exec(cadena_consulta_color);
    QList<QVariant> lineaDatosColor;
    while (m_consulta.next())
    {
        for (int i=0;i<NUM_COLUMNAS;i++)
        {
                lineaDatosColor.append(m_consulta.value(i));
        }
        m_datoscolor.append(lineaDatosColor);
        lineaDatosColor.clear();
    }
}

int PrincipalModel::LeeColor(int fila, int columna)
{
    if (fila>m_datoscolor.size()-1)
    {
        return 0;
    }
    else
    {
        return m_datoscolor.at(fila).at(columna).toInt();
    }
}

void PrincipalModel::Copiar(const QList<int> &filas)
{
    qDebug()<<"Copiar en el modelo";
    QString listahijos;
    listahijos.append("{");
    for (int i=0;i<filas.size();i++)
    {
       listahijos.append(m_datos.at(filas.at(i)+1).at(0).toString());
       if (i<filas.size()-1)
       {
           listahijos.append(",");
       }
    }
    listahijos.append("}");
    QString codpadre = m_datos.at(0).at(0).toString();
    codpadre.remove(m_LeyendasCabecera[0]);
    QString cadenacopiar = "SELECT copiar('"+m_tabla+"','"+codpadre +"','"+ listahijos+"')";
    qDebug()<<cadenacopiar;
    m_consulta.exec(cadenacopiar);
}

void PrincipalModel::Pegar(int fila)
{
    //nodo padre bajo el cual se pegaran los nodos
    QString codpadre = m_datos.at(0).at(0).toString();
    codpadre.remove(m_LeyendasCabecera[0]);
    //por ultimo llamo a la funcion
    m_pila->push(new UndoPegarPartidas(m_tabla,codpadre,fila,QVariant()));
}
