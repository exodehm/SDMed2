#include "PropiedadesModel.h"
#include <QDebug>

PropiedadesModel::PropiedadesModel(const QString &tabla, QObject *parent):m_tabla(tabla),  QSqlQueryModel(parent)
{
    RellenarTabla(tabla);
}

bool PropiedadesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    qDebug()<<"Cambiar en "<<index.row()<<" - "<<index.column();
    QString cadenaConsulta = "UPDATE \"" + m_tabla + "_Propiedades\" "
                             "SET propiedades = jsonb_set(propiedades,'{Valor," + QString::number(index.row())+ ",Valor}','\""+ value.toString()+"\"',true)"
                             " WHERE propiedades->>'Propiedad' = '"+ m_propiedad + "'";

    qDebug()<<cadenaConsulta;
    QSqlQuery consulta;
    consulta.exec(cadenaConsulta);
    RellenarTabla(m_propiedad);
    emit dataChanged(index,index);
    emit layoutChanged();
}

Qt::ItemFlags PropiedadesModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
    {
        return 0;
    }
    if (index.column()==2)
    {
        return QAbstractTableModel::flags(index) | Qt::ItemIsEditable;
    }
    return  QAbstractItemModel::flags(index);
}

/*int PropiedadesModel::rowCount(const QModelIndex &parent) const
{
    return 4;
}

int PropiedadesModel::columnCount(const QModelIndex &parent) const
{
    return 4;
}

QVariant PropiedadesModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

QVariant PropiedadesModel::data(const QModelIndex &index, int role) const
{
    return QVariant();

}*/

void PropiedadesModel::ActualizarDatos(const QStringList &ruta)
{

}

void PropiedadesModel::PrepararCabecera()
{

}

void PropiedadesModel::Copiar(const QList<int> &filas)
{

}

void PropiedadesModel::Pegar(int fila)
{

}

void PropiedadesModel::RellenarTabla(const QString &propiedad)
{
    m_propiedad = propiedad;
    QString cadenaConsulta = "SELECT propiedad->>'Variable' AS \"Variable\", propiedad->>'Tipo' AS \"Tipo\", "
                             "propiedad->>'Valor' AS \"Valor\", propiedad->>'Nombre' AS \"Nombre\" "
                             "FROM (SELECT jsonb_array_elements(propiedades->'Valor') AS propiedad FROM \""  + m_tabla + "_Propiedades\" "
                            "WHERE propiedades->>'Propiedad'= '"+ propiedad + "') AS pp";

    qDebug()<<"Rellenar la tabla con la consulta: "<<cadenaConsulta;
    setQuery(cadenaConsulta);
}
