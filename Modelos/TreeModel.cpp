#include "TreeModel.h"

#include <QSqlRecord>

TreeModel::TreeModel(const QString &tabla, QUndoStack *p, QObject *parent):QAbstractItemModel(parent),rootItem(nullptr),m_tabla(tabla)
{
    //cabecera
    QList<QVariant> rootData;
    rootData <<tr("Código")<<tr("Nat.")<<tr("Ud.")<<tr("Resumen")<<tr("Precio");//
    // si pongo esta cabecera sin añadir las ultimas columnas tengo un arbol en el que se pueden
    //ver las primeras 5 columnas, sin que se vean las dos ultimas, aunque sus datos se incorporan al nodo
    //habra que ver si no hay una forma mas correcta de hacerlo <<tr("ret_depth")<<("ret_camino");
    rootItem = new TreeItem(rootData);
    ActualizarDatos(m_tabla);
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
        return Qt::ItemFlags();

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
    BorrarHijos(rootItem);
    TreeItem* itemsuperior = rootItem;
    int nivel=0;
    int nivelanterior=0;
    //datos
    QString consultaArbol = "SELECT * FROM recorrercte ('"+tabla+"');";
    consulta.exec(consultaArbol);
    QSqlRecord rec = consulta.record();
    while (consulta.next())
    {
        QList<QVariant> ObraData;
        ObraData<<consulta.value(rec.indexOf("ret_codigo"))\
               <<consulta.value(rec.indexOf("ret_naturaleza"))\
              <<consulta.value(rec.indexOf("ret_ud"))\
             <<consulta.value(rec.indexOf("ret_resumen"))\
            <<consulta.value(rec.indexOf("ret_preciomed"))\
            <<consulta.value(rec.indexOf("ret_depth"))\
            <<consulta.value(rec.indexOf("ret_camino"));
        nivelanterior = nivel;
        nivel = consulta.value(rec.indexOf("ret_depth")).toInt();
        if (nivel == 0)//primer elemento
        {
            TreeItem* unItem = new TreeItem(ObraData,rootItem);
            rootItem->appendChild(unItem);
            itemsuperior = unItem;
        }
        else
        {
            int subirnivel = nivelanterior-nivel+1;
            qDebug()<<"Subir nivel "<<subirnivel;
            for (int i=0;i<subirnivel;i++)
            {
                if (itemsuperior && itemsuperior->parentItem())
                {
                    itemsuperior = itemsuperior->parentItem();
                }
            }
            TreeItem* unItem = new TreeItem(ObraData,itemsuperior);
            itemsuperior->appendChild(unItem);
            itemsuperior = unItem;
            nivelanterior=nivel;
        }
    }
}

void TreeModel::BorrarHijos(TreeItem *nodo)
{    
    if (nodo->childCount()>0)//si tiene hijos
    {
        for (int i =0; i< nodo->childCount();i++)
        {
            qDebug()<<"Recorro el nodo: "<<nodo->ListaHijos().at(i)->data(0).toString();
            //qDebug()<<"Borrar hijos";
            BorrarHijos(nodo->ListaHijos().at(i));
        }
        if (nodo->parentItem())

        {
            qDebug()<<"Borro el nodo: "<<nodo->data(0).toString();
            qDebug()<<"Borrar nodo";
            //delete nodo;
            qDebug()<<"Adios borrado";
        }
    }
    else
    {
        if (nodo->parentItem())//si no es el raiz
        {
            qDebug()<<"Borro el Nodo: "<<nodo->data(0).toString();
            qDebug()<<"Borrar Nodo";
            //delete nodo;
        }
    }


    if (!nodo->parentItem())
    {
        nodo->BorrarHijos();
    }
    qDebug()<<"Listo";
}
