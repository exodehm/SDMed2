#ifndef MEDCERTMODELBASE_H
#define MEDCERTMODELBASE_H

/*#include <QAbstractTableModel>
#include <QStandardItemModel>
#include <QClipboard>
#include <QMimeData>
#include <QItemSelectionModel>
#include <QList>
#include <QStringList>
#include <QUndoStack>
#include <QVariant>
#include <QDebug>
#include <QTextStream>
#include <QFileDialog>
#include <QLocale>
#include <QModelIndex>
#include <iostream>*/

//#include "../Undo/undomedicion.h"
#include <QModelIndex>
#include <QtSql/QSqlQueryModel>
#include <QtSql/QSqlQuery>
#include "../defs.h"



class MedCertModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    enum {NUM_COLUMNAS = 9};

    MedCertModel(const QString& cadenaInicio, QObject* parent=nullptr);
    ~MedCertModel();

    int rowCount(const QModelIndex& parent) const;
    int columnCount(const QModelIndex& parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    Qt::ItemFlags flags(const QModelIndex &index) const;
    bool setData(const QModelIndex & index, const QVariant& value, int role);

    bool insertRows(int row, int count, const QModelIndex & parent);
    bool removeRows(int filaInicial, int numFilas, const QModelIndex& parent);
    bool filaVacia(const QStringList& linea);
    void ActualizarDatos(QString cadena_consulta);
    void emitDataChanged(const QModelIndex &index);
    void BorrarFilas(QList<int>filas);

signals:
    void EditarCampoLineaMedicion (QModelIndex, float, QString);
    void Posicionar (QModelIndex indice);


protected:
    int tabla;
    //QUndoStack* pila;
    QList<QList<QVariant>>datos;
    QStringList LeyendasCabecera;
    bool hayFilaVacia;
    int filavacia;
    QSqlQuery consulta;
};


#endif // MEDCERTMODELBASE_H
