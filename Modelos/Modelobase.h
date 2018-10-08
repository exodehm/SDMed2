#ifndef MODELOBASE_H
#define MODELOBASE_H

#include <QModelIndex>
#include <QtSql/QSqlQueryModel>
#include <QtSql/QSqlQuery>

class QUndoStack;

class ModeloBase: public QSqlQueryModel
{
    Q_OBJECT

public:

    ModeloBase(const QString& cadenaInicio, QUndoStack* p, QObject* parent=nullptr);
    ~ModeloBase();
    bool esColumnaNumerica(int columna) const;
    void QuitarIndicadorFilaVacia();


    int rowCount(const QModelIndex& parent) const;
    int columnCount(const QModelIndex& parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex& index,int role = Qt::DisplayRole) const;
    Qt::ItemFlags flags(const QModelIndex &index) const;    
    bool insertRows(int row, int count, const QModelIndex & parent);
    bool removeRows(int filaInicial, int numFilas, const QModelIndex& parent);

    bool HayFilaVacia();
    int FilaVacia();
    void ActualizarDatos(QString cadena_consulta);
    virtual bool EsPartida()=0;
    virtual void PrepararCabecera(QList<QList<QVariant>>&datos)=0;

public slots:
    //void MostrarHijos (QModelIndex idpadre);

protected:
    int NUM_COLUMNAS;
    QStringList cabecera;
    QStringList LeyendasCabecera;
    bool hayFilaVacia;
    int filavacia;
    QList<QList<QVariant>>datos;
    QSqlQuery consulta;
    int naturalezapadre;
    QUndoStack* pila;
};

#endif // MODELOBASE_H
