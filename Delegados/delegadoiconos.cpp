#include "delegadoiconos.h"
#include "./iconos.h"
#include <QPainter>

DelegadoIconos::DelegadoIconos(QObject *parent):DelegadoBase(parent)
{
    indiceCombo=0;
    leyendas.append(tr("Sin clasificar"));
    leyendas.append(tr("Mano de obra"));
    leyendas.append(tr("Maquinaria"));
    leyendas.append(tr("Materiales"));
    leyendas.append(tr("Comp. de residuos"));
    leyendas.append(tr("Clasif. de residuos"));
    leyendas.append(tr("Capítulo"));
    leyendas.append(tr("Partida"));
}

QWidget *DelegadoIconos::createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    //precaución por si no hay modelo
    const QAbstractItemModel * model = index.model();
    if (!model) return QStyledItemDelegate::createEditor(parent,option, index);
    //creación del editor
    QComboBox * box = new QComboBox(parent);
    box->setEditable(true);
    for (int i = 0;i<RepoIconos::tam(); i++)
    {
        box->addItem(RepoIconos::GetIcon(i),leyendas.at(i));
    }
    return box;
}

void DelegadoIconos::setEditorData(QWidget *editor, const QModelIndex &index) const
{
    QComboBox *box=qobject_cast<QComboBox*>(editor);
    const QAbstractItemModel *model =index.model();
    if (!box|| !model)
    {
        QStyledItemDelegate::setEditorData(editor,index);
    }
    box->setCurrentIndex(index.data(DatosIconos::ImageIndexRole).toInt());
}

void DelegadoIconos::setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const
{
    if (!index.isValid()) return;
    QComboBox * box=qobject_cast<QComboBox * >(editor);
    if (!box) return QStyledItemDelegate::setModelData(editor,model, index);

    int indiceCombo = box->currentIndex();
    model->setData(index,indiceCombo,Qt::DisplayRole);
    model->setData(index,indiceCombo,Qt::EditRole);
    model->setData(index,indiceCombo,Qt::DecorationRole);
}

QSize DelegadoIconos::sizeHint(const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    return option.rect.size();
}

void DelegadoIconos::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    QRectF source(0.0, 0.0, 70.0, 40.0);
    painter->drawPixmap(option.rect, RepoIconos::GetIcon(index.data().toInt()).pixmap(QSize(32, 32)),source);
}
