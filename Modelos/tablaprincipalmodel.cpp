#include "tablaprincipalmodel.h"
#include "./Undo/undoeditarprincipal.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

TablaPrincipalModel::TablaPrincipalModel(const QString &tabla, const QString &cadenaInicio, QUndoStack *p, QObject *parent):ModeloBase(tabla, cadenaInicio, p, parent)
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
        QString codpadre = datos.at(0).at(tipoColumna::CODIGO).toString();
        QString codhijo = this->index(index.row(),tipoColumna::CODIGO).data().toString();
        codpadre.remove(LeyendasCabecera[0]);
        switch (index.column())
        {
        case tipoColumna::CODIGO:
            qDebug()<<"editando código";
            //EditarCodigo(index,value);
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
            QString descripcion = "Editar precio con el codigo: ";
            pila->push(new UndoEditarCantidad(tabla, codpadre, codhijo, index.data(), value, descripcion));
            return true;
        }
            break;
        case tipoColumna::PRPRES:
        {
            QString descripcion = "Editar precio con el codigo: ";
            pila->push(new UndoEditarPrecio(tabla, codpadre, codhijo, index.data(), value, descripcion));
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

bool TablaPrincipalModel::EsPartida()
{
    return naturalezapadre == static_cast<int>(Naturaleza::PARTIDA);
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
