#include "PrincipalModel.h"
#include "./Undo/undoeditarprincipal.h"
#include "./Undo/undoinsertarprincipal.h"
#include "consultas.h"
#include "../defs.h"
#include "./Dialogos/dialogosuprimirmedicion.h"
#include "../Dialogos/dialogoprecio.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

PrincipalModel::PrincipalModel(const QString &tabla, const QString &codigopadre, const QString &codigohijo, QUndoStack *p, QObject *parent):
    ModeloBase(tabla, codigopadre, codigohijo, p, parent)
{
    NUM_COLUMNAS = 11;
    LeyendasCabecera.append(tr("Código\n"));
    LeyendasCabecera.append(tr("Nat\n"));
    LeyendasCabecera.append(tr("Ud\n"));
    LeyendasCabecera.append(tr("Resumen\n"));
    LeyendasCabecera.append(tr("CanPres\n"));
    LeyendasCabecera.append(tr("CanCert\n"));
    LeyendasCabecera.append(tr("PorCertPres\n"));
    LeyendasCabecera.append(tr("PrPres\n"));
    LeyendasCabecera.append(tr("PrCert\n"));
    LeyendasCabecera.append(tr("ImpPres\n"));
    LeyendasCabecera.append(tr("ImpCert\n"));
    ActualizarDatos(codigopadre, codigohijo);
}

PrincipalModel::~PrincipalModel()
{
    qDebug()<<"Destructor modelo PrincipalModel";
}

bool PrincipalModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        QString codpadre = datos.at(0).at(tipoColumna::CODIGO).toString();
        QString codhijo = this->index(index.row(),tipoColumna::CODIGO).data().toString();
        codpadre.remove(LeyendasCabecera[0]);
        switch (index.column())
        {
        case tipoColumna::CODIGO:
            if (index.data().isNull())//cuando este en una fila vacia se insertara una nueva partida
            {
                QString descripcion = "Insertar nueva partida con el codigo: ";
                pila->push(new UndoInsertarPartidas(tabla, codpadre, value, index.row(),descripcion));
                return true;
            }
            else
            {
                QString descripcion = "Editar codigo con el codigo: ";
                pila->push(new UndoEditarCodigo(tabla, codpadre, codhijo, index.data(), value, descripcion));
                return true;
            }            
            break;
        case tipoColumna::NATURALEZA:
        {
            QString descripcion = "Editar resumen con el codigo: ";
            pila->push(new UndoEditarNaturaleza(tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumna::UD:
        {
            QString descripcion = "Editar ud con el codigo: ";
            pila->push(new UndoEditarUnidad(tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumna::RESUMEN:
        {
            QString descripcion = "Editar resumen con el codigo: ";
            pila->push(new UndoEditarResumen(tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumna::CANPRES:
        {
            QString descripcion = "Editar cantidad con el codigo: ";
            QString cadenahaymediciones = "SELECT hay_medicion ('"+ tabla + "','" + codpadre + "','" + codhijo+"');";
            consulta.exec(cadenahaymediciones);
            bool hayMedicion;
            while (consulta.next())
            {
                hayMedicion = consulta.value(0).toBool();
            }
            if (hayMedicion)
            {
                DialogoSuprimirMedicion* d = new DialogoSuprimirMedicion(tabla);
                if (d->exec()==QDialog::Rejected || d->Suprimir()==false)
                {
                    return false;
                }
            }
            pila->push(new UndoEditarCantidad(tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumna::PRPRES:
        {
            QString descripcion = "Editar precio con el codigo: ";
            QString cadenahaydescompuesto = "SELECT hay_descomposicion ('"+ tabla + "','" + codhijo+"');";
            consulta.exec(cadenahaydescompuesto);
            bool hayDescompuesto;
            while (consulta.next())
            {
                hayDescompuesto = consulta.value(0).toBool();
            }
            if (hayDescompuesto)
            {
                DialogoPrecio* d = new DialogoPrecio(tabla);
                if (d->exec()==QDialog::Rejected || d->Respuesta()==0)
                {
                    return false;
                }
                else
                {           
                    pila->push(new UndoEditarPrecio(tabla, codpadre, codhijo, index.data(), value, d->Respuesta(), descripcion));
                }
            }
            else
            {
                pila->push(new UndoEditarPrecio(tabla, codpadre, codhijo, index.data(), value, precio::MODIFICAR, descripcion));
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
    qDebug()<<datos.at(fila).at(0);
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
    return naturalezapadre == static_cast<int>(Naturaleza::PARTIDA);
}

void PrincipalModel::PrepararCabecera(QList<QList<QVariant> > &datos)
{
    if (!datos.isEmpty())
    {     for(int i=0; i<datos.at(0).length(); i++)
        {
            //leo la naturaleza del concepto padre
            if (i==tipoColumna::NATURALEZA)
            {
                naturalezapadre = datos.at(0).at(i).toInt();
            }
            QString datocabecera =datos.at(0).at(i).toString();
            datocabecera.prepend(LeyendasCabecera[i]);
            datos[0][i] = static_cast<QVariant>(datocabecera);
        }
    }
}

void PrincipalModel::BorrarFilas(const QList<int> &filas)
{
    QStringList partidasborrar;
    QString codpadre = datos.at(0).at(0).toString();
    codpadre.remove(LeyendasCabecera[0]);
    partidasborrar.append(codpadre);
    foreach (const int& i, filas)
    {
        //removeRows(i,1,QModelIndex());
        partidasborrar.append(datos.at(i+1).at(0).toString());//añado 1 por la cabecera
    }
    pila->push(new UndoBorrarPartidas(tabla,partidasborrar,QVariant()));
}

void PrincipalModel::InsertarFila(int fila)
{
    insertRows(fila,1,QModelIndex());
}

void PrincipalModel::ActualizarDatos(QString padre, QString hijo)
{
    hayFilaVacia = false;
    datos.clear();
    datoscolor.clear();
    codigopadre=padre;
    codigohijo=hijo;
    QString cadena_consulta = "SELECT * FROM ver_hijos('"+tabla+"','"+ codigopadre+"','"+ codigohijo+"')";
    QString cadena_consulta_color = "SELECT * FROM ver_color_hijos('"+tabla+"','"+ codigopadre+"','"+ codigohijo+"')";
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
    //ahora el color
    consulta.exec(cadena_consulta_color);
    QList<QVariant> lineaDatosColor;
    while (consulta.next())
    {
        for (int i=0;i<NUM_COLUMNAS;i++)
        {
                lineaDatosColor.append(consulta.value(i));                
        }
        datoscolor.append(lineaDatosColor);
        lineaDatosColor.clear();
    }
}

int PrincipalModel::LeeColor(int fila, int columna)
{
    if (fila>datoscolor.size()-1)
    {
        return 0;
    }
    else
    {
        return datoscolor.at(fila).at(columna).toInt();
    }
}

void PrincipalModel::Copiar(const QList<int> &filas)
{
    qDebug()<<"Copiar en el modelo";
    QString listahijos;
    listahijos.append("{");
    for (int i=0;i<filas.size();i++)
    {
       listahijos.append(datos.at(filas.at(i)+1).at(0).toString());
       if (i<filas.size()-1)
       {
           listahijos.append(",");
       }
    }
    listahijos.append("}");
    QString codpadre = datos.at(0).at(0).toString();
    codpadre.remove(LeyendasCabecera[0]);
    QString cadenacopiar = "SELECT copiar('"+tabla+"','"+codpadre +"','"+ listahijos+"')";
    qDebug()<<cadenacopiar;
    consulta.exec(cadenacopiar);
}

void PrincipalModel::Pegar()
{
    //nodo padre bajo el cual se pegaran los nodos
    QString codpadre = datos.at(0).at(0).toString();
    codpadre.remove(LeyendasCabecera[0]);
    //por ultimo llamo a la funcion
    pila->push(new UndoPegarPartidas(tabla,codpadre,QVariant()));
}
