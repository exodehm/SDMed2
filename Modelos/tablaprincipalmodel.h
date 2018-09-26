#ifndef TABLAPRINCIPALMODEL_H
#define TABLAPRINCIPALMODEL_H

#include <QModelIndex>
#include <QtSql/QSqlQueryModel>
#include <QtSql/QSqlQuery>
#include <QColor>

struct DatoCelda
{
    QString valor;
    QColor color;
};
Q_DECLARE_METATYPE(DatoCelda)

class TablaPrincipalModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    enum {NUM_COLUMNAS = 11};

    TablaPrincipalModel(const QString& cadenaInicio, QObject* parent=nullptr);
    ~TablaPrincipalModel();
    bool esColumnaNumerica(int columna) const;
    void QuitarIndicadorFilaVacia();


    int rowCount(const QModelIndex& parent) const;
    int columnCount(const QModelIndex& parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex& index,int role = Qt::DisplayRole) const;
    Qt::ItemFlags flags(const QModelIndex &index) const;
    bool setData(const QModelIndex & index, const QVariant& value, int role);
    bool insertRows(int row, int count, const QModelIndex & parent);
    bool removeRows(int filaInicial, int numFilas, const QModelIndex& parent);

    bool HayFilaVacia();
    int FilaVacia();
    void ActualizarDatos(QString cadena_consulta);

public slots:
    //void MostrarHijos (QModelIndex idpadre);

private:
    QStringList cabecera;
    QString LeyendasCabecera[NUM_COLUMNAS];    
    bool hayFilaVacia;
    int filavacia;
    QList<QList<DatoCelda>>datos;
    QSqlQuery consulta;
};

#endif // TABLAPRINCIPALMODEL_H
