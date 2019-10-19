#include "TreeModel.h"

#include <QSqlRecord>

TreeModel::TreeModel(const QString &tabla, QUndoStack *p, QObject *parent):QAbstractItemModel(parent),rootItem(nullptr)
{
    ActualizarDatos(tabla);
}

TreeModel::~TreeModel()
{
    qDebug()<<"Borrando el treemodel";
    delete rootItem;
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
        return QModelIndex();

    TreeItem *parentItem;

    if (!parent.isValid())
        parentItem = rootItem;
    else
        parentItem = static_cast<TreeItem*>(parent.internalPointer());

    TreeItem *childItem = parentItem->child(row);
    if (childItem)
        return createIndex(row, column, childItem);
    else
        return QModelIndex();
}

QModelIndex TreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return QModelIndex();

    TreeItem *childItem = static_cast<TreeItem*>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    if (parentItem == rootItem)
        return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex &parent) const
{
    TreeItem *parentItem;
    if (parent.column() > 0)
        return 0;

    if (!parent.isValid())
        parentItem = rootItem;
    else
        parentItem = static_cast<TreeItem*>(parent.internalPointer());

    return parentItem->childCount();
}

int TreeModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return static_cast<TreeItem*>(parent.internalPointer())->columnCount();
    else
        return rootItem->columnCount();
}

QVariant TreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if (index.column()==tipoColumnaTPrincipal::NATURALEZA)
    {
        if (role == Qt::DecorationRole)
        {
            TreeItem *item = static_cast<TreeItem*>(index.internalPointer());
            return RepoIconos::GetIcon(item->data(index.column()).toInt());
        }        
    }
    else if (role == Qt::DisplayRole)//resto de columnas
    {
        TreeItem *item = static_cast<TreeItem*>(index.internalPointer());
        return item->data(index.column());
    }
    if (role != Qt::DisplayRole)
        return QVariant();
    return QVariant();
}

Qt::ItemFlags TreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return nullptr;

    return Qt::ItemIsEditable | QAbstractItemModel::flags(index);
}

QVariant TreeModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole)
        return rootItem->data(section);

    return QVariant();
}

void TreeModel::ActualizarDatos(const QString &tabla)
{
    if (rootItem)
    {
        rootItem = nullptr;
    }
    TreeItem* itemsuperior = nullptr;
    int nivel=0;
    int nivelanterior=0;
    //cabecera
    QList<QVariant> rootData;
    rootData << tr("Código")<<tr("Nat.")<<tr("Ud.")<<tr("Resumen")<<tr("Precio");
    rootItem = new TreeItem(rootData);
    //datos
    //QString consultaArbol = "SELECT * FROM recorrer_principal ('"+tabla+"');";
    QString consultaArbol = "SELECT * FROM recorrercte ('"+tabla+"');";
    qDebug()<<consultaArbol;
    consulta.exec(consultaArbol);
    QSqlRecord rec = consulta.record();
    while (consulta.next())
    {
        QList<QVariant> ObraData;
        ObraData<<consulta.value(rec.indexOf("ret_codigo"))\
               <<consulta.value(rec.indexOf("ret_naturaleza"))\
              <<consulta.value(rec.indexOf("ret_ud"))\
             <<consulta.value(rec.indexOf("ret_resumen"))\
            <<consulta.value(rec.indexOf("ret_preciomed"));
        nivelanterior = nivel;
        nivel = consulta.value(rec.indexOf("ret_depth")).toInt();
        if (nivel == 0)//primer elemento
        {
            TreeItem* unItem = new TreeItem(ObraData,rootItem);
            rootItem->appendChild(unItem);
            itemsuperior = unItem;
            nivelanterior=nivel;
        }
        else
        {
            int subirnivel = nivelanterior-nivel+1;
            qDebug()<<"Subir nivel "<<subirnivel;
            for (int i=0;i<subirnivel;i++)
            {
                itemsuperior = itemsuperior->parentItem();
            }
            TreeItem* unItem = new TreeItem(ObraData,itemsuperior);
            itemsuperior->appendChild(unItem);
            itemsuperior = unItem;
            nivelanterior=nivel;
        }
    }
}
