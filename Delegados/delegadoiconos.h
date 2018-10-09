#ifndef DELEGADOICONOS_H
#define DELEGADOICONOS_H

#include <QStyledItemDelegate>
#include <QComboBox>
#include "../Delegados/delegadobase.h"
#include "../iconos.h"


class DelegadoIconos : public DelegadoBase
{
public:
    DelegadoIconos(QObject* parent=nullptr);
    QWidget * createEditor(QWidget * parent, const QStyleOptionViewItem&option, const QModelIndex&index) const;
    void setEditorData(QWidget * editor, const QModelIndex&index)const;
    void setModelData(QWidget * editor, QAbstractItemModel * model, const QModelIndex&index) const;
    QSize sizeHint( const QStyleOptionViewItem &option, const QModelIndex &index ) const;
    void paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const;

    //bool eventFilter(QObject *obj, QEvent* event);

private:
    uint indiceCombo;
    QStringList leyendas;
};

#endif // DELEGADOICONOS_H
