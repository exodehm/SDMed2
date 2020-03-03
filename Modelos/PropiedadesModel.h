#ifndef PROPIEDADESMODEL_H
#define PROPIEDADESMODEL_H

#include <QObject>
#include "./Modelos/Modelobase.h"
#include <QSqlQuery>

class PropiedadesModel : public QSqlQueryModel
{
public:
    PropiedadesModel(const QString& tabla, QObject* parent=nullptr);

    /*int rowCount(const QModelIndex& parent) const;
    int columnCount(const QModelIndex& parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex& index,int role = Qt::DisplayRole) const;*/
    bool setData(const QModelIndex & index, const QVariant& value, int role) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    void ActualizarDatos(const QStringList& ruta);
    int LeeColor(int fila, int columna);
    void PrepararCabecera(/*QList<QList<QVariant>>&datos*/);
    void Copiar(const QList<int> &filas);
    void Pegar(int fila);

//private slots:
    void RellenarTabla(const QString& propiedad);

 private:
    QString m_tabla;
    QString m_propiedad;
};

#endif // PROPIEDADESMODEL_H
