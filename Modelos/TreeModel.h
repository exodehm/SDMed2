#ifndef TREEMODEL_H
#define TREEMODEL_H

#include <QAbstractItemModel>
#include <QtSql/QSqlQuery>
#include "./treeitem.h"
#include "../defs.h"
#include "../iconos.h"

class QUndoStack;

class TreeModel : public QAbstractItemModel
{
    Q_OBJECT

public:
    explicit TreeModel(const QString &tabla, QUndoStack *p, QObject* parent=nullptr);
      ~TreeModel();

      QVariant data(const QModelIndex &index, int role) const override;
      Qt::ItemFlags flags(const QModelIndex &index) const override;
      QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
      QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
      QModelIndex parent(const QModelIndex &index) const override;
      int rowCount(const QModelIndex &parent = QModelIndex()) const override;
      int columnCount(const QModelIndex &parent = QModelIndex()) const override;

      void ActualizarDatos(const QString &tabla);

  private:
      TreeItem *rootItem;      
      QSqlQuery consulta;     

};

#endif // TREEMODEL_H
