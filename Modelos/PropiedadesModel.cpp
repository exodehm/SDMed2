#include "PropiedadesModel.h"
#include <QDebug>

PropiedadesModel::PropiedadesModel(const QString &tabla, QObject *parent):m_tabla(tabla),  QSqlQueryModel(parent)
{
    RellenarTabla(tabla);
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
    QString cadenaConsulta = "SELECT propiedad->>'Variable' AS \"Variable\", propiedad->>'Tipo' AS \"Tipo\", "
                             "propiedad->>'Valor' AS \"Valor\", propiedad->>'Nombre' AS \"Nombre\" "
                             "FROM (SELECT json_array_elements(propiedades->'Valor') AS propiedad FROM \""  + m_tabla + "_Propiedades\" "
                            "WHERE propiedades->>'Propiedad'= '"+ propiedad + "') AS pp";

    qDebug()<<"Rellenar la tabla con la consulta: "<<cadenaConsulta;
    setQuery(cadenaConsulta);
    //layoutChanged();
}
