#include "tablaprincipalmodel.h"
#include "./Undo/undoeditarprincipal.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

TablaPrincipalModel::TablaPrincipalModel(const QString &cadenaInicio, QUndoStack *p, QObject *parent):ModeloBase(cadenaInicio, p, parent)
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
    ActualizarDatos(cadenaInicio);
}

TablaPrincipalModel::~TablaPrincipalModel()
{
    qDebug()<<"Destructor modelo PrincipalModel";
}

bool TablaPrincipalModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && (role == Qt::EditRole /*|| role == Qt::DisplayRole*/) && value.toString()!=index.data().toString())
    {
        switch (index.column())
        {
        case tipoColumna::CODIGO:
            qDebug()<<"editando código";
            //EditarCodigo(index,value);
            break;
        case tipoColumna::NATURALEZA:
            qDebug()<<"editando naturaleza: "<<value.toString();
            //EditarNaturaleza(index,value);
            break;
        case tipoColumna::UD:
            qDebug()<<"editando unidad";
            //EditarUnidad(index,value.toString());
            break;
        case tipoColumna::RESUMEN:
        {
            qDebug()<<"editando resumen";
            QString descripcion = "Editar resumen";
            pila->push(new UndoEditarPrincipal(index.data().toString(), value.toString(), descripcion));
            return true;
        }
            break;
        case tipoColumna::CANPRES:
            qDebug()<<"editando cantidad";
            //EditarCantidad(index,value);
            break;
        case tipoColumna::PRPRES:
            qDebug()<<"editando precio";
            //EditarPrecio(index, value);
            break;
        default:
            break;
        }
        return true;
    }
    return false;
}



bool TablaPrincipalModel::EsPartida()
{
    return naturalezapadre == 7;
}

void TablaPrincipalModel::PrepararCabecera(QList<QList<QVariant> > &datos)
{
    //if (!datos.isEmpty())
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
