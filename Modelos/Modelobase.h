#ifndef MODELOBASE_H
#define MODELOBASE_H

#include <QModelIndex>
#include <QtSql/QSqlQueryModel>
#include <QtSql/QSqlQuery>

class MiUndoStack;

class ModeloBase: public QSqlQueryModel
{
    Q_OBJECT

public:

    ModeloBase(const QString& tabla, const QStringList& ruta, MiUndoStack* p, QObject* parent=nullptr);
    ~ModeloBase();
    bool esColumnaNumerica(int columna) const;
    void QuitarIndicadorFilaVacia();


    int rowCount(const QModelIndex& parent) const;
    int columnCount(const QModelIndex& parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex& index,int role = Qt::DisplayRole) const;
    bool insertRows(int row, int count, const QModelIndex & parent);
    bool removeRows(int filaInicial, int numFilas, const QModelIndex& parent);

    bool HayFilaVacia();
    int FilaVacia();
    virtual void ActualizarDatos(const QStringList& ruta)=0;
    virtual bool EsPartida(){return bool();}
    virtual void PrepararCabecera(/*QList<QList<QVariant>>&datos*/)=0;

    virtual void BorrarFilas(const QList<int>&filas){Q_UNUSED (filas)}
    virtual void InsertarFila(int fila){Q_UNUSED(fila)}

    virtual void Copiar(const QList<int> &filas)=0;
    virtual void Pegar(int fila)=0;
    virtual void Certificar(const QList<int> &filas){}
    //void ActualizarIds(QString idpadre, QString idhijo);

public slots:
    //void MostrarHijos (QModelIndex idpadre);

protected:
    int NUM_COLUMNAS;
    QStringList m_cabecera;
    QStringList m_LeyendasCabecera;
    QStringList m_ruta;
    bool m_hayFilaVacia;
    int m_filavacia;
    QList<QList<QVariant>>m_datos;
    QList<QList<QVariant>>m_datoscolor;
    QSqlQuery m_consulta;
    int m_naturalezapadre;
    MiUndoStack* m_pila;
    QString m_tabla;
    QString m_codigopadre, m_codigohijo;
};

#endif // MODELOBASE_H
