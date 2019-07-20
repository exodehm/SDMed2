#include "PropiedadesModel.h"
#include <QMessageBox>
#include <QDebug>

PropiedadesModel::PropiedadesModel(const QString &tabla, QObject *parent):m_tabla(tabla),  QSqlQueryModel(parent)
{
    RellenarTabla(tabla);
}

bool PropiedadesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    Q_UNUSED (role);
    //hay dos funciones especificas para cambiar el codigo o resumen raiz
    //estas cambian tanto la tabla de conceptos, la de relaciones y la de propiedades.
    //para el resto de datos se hace un cambio generico que solo afecta a la tabla de propiedades
    QSqlQuery consulta;
    QString cadenaConsulta;
    //si estoy cambiando el codigo
    if (m_propiedad == "Datos generales" && index.row() == 0)
    {
        //lo primero advertencia de que hay que reiniciar la obra para que los cambios surjan efecto
        QMessageBox msgBox;
        msgBox.setText(tr("Si se cambia el código de la obra habrá que reiniciarla"));
        msgBox.setInformativeText(tr("Proceder a cambiarlo?"));
        msgBox.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
        msgBox.setDefaultButton(QMessageBox::No);
        int ret = msgBox.exec();
        qDebug()<<"ret "<<ret;
        if (ret == QMessageBox::No)
        {
            return false;
        }
        cadenaConsulta = "SELECT cambiar_codigo_obra ('"+m_tabla+"','" + value.toString() + "')";
        qDebug()<<cadenaConsulta;
        consulta.exec(cadenaConsulta);
        //si me retorna un valor -1 es que la consulta es la de cambiar el codigo y me advierte de que ya hay una obra con ese valor.
        int res = 0;
        while (consulta.next())
        {
            res = consulta.value(0).toInt();
        }
        if (res == -1)
        {
            QMessageBox msgBox;
            msgBox.setText(tr("Ya existe una obra con ese nombre"));
            msgBox.exec();
            return false;
        }
        else
        {
            return true;
        }
    }
    //si estoy cambiando el resumen
    else if (m_propiedad == "Datos generales" && index.row() == 1)
    {
        cadenaConsulta = "SELECT cambiar_resumen_obra ('"+m_tabla+"','" + value.toString() + "')";
    }
    //cambio del resto de datos
    else
    {
        cadenaConsulta = "UPDATE \"" + m_tabla + "_Propiedades\" "
                                     "SET propiedades = jsonb_set(propiedades,'{Valor," + QString::number(index.row())+ ",Valor}','\""+ value.toString()+"\"',true)"
                                     " WHERE propiedades->>'Propiedad' = '"+ m_propiedad + "'";
    }
    qDebug()<<cadenaConsulta;
    consulta.exec(cadenaConsulta);
    RellenarTabla(m_propiedad);
    emit dataChanged(index,index);
    emit layoutChanged();
    return true;
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
                            "WHERE propiedades->>'Propiedad'= '"+ propiedad + "') AS datos";

    qDebug()<<"Rellenar la tabla con la consulta: "<<cadenaConsulta;
    setQuery(cadenaConsulta);
}
