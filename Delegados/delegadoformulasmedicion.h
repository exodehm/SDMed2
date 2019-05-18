#ifndef DELEGADOFORMULASMEDICION_H
#define DELEGADOFORMULASMEDICION_H

#include "./delegadobase.h"

class DelegadoFormulasMedicion : public DelegadoBase
{
    Q_OBJECT
public:    
    explicit DelegadoFormulasMedicion(QObject* parent=nullptr);
    QWidget * createEditor(QWidget * parent, const QStyleOptionViewItem&option, const QModelIndex&index) const;
    void setEditorData(QWidget * editor, const QModelIndex&index)const;
    void setModelData(QWidget * editor, QAbstractItemModel * model, const QModelIndex&index) const;
    void paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const;
    bool editorEvent(QEvent *event, QAbstractItemModel *model, const QStyleOptionViewItem &option, const QModelIndex &index);
    /*QSize sizeHint( const QStyleOptionViewItem &option, const QModelIndex &index ) const;
    QString displayText(const QVariant & value, const QLocale & locale) const;*/

public slots:
    void onHoverIndexChanged(const QModelIndex& indice);


private:
    int m_ancho_boton;
    QModelIndex m_indiceActivo;
};

#endif // DELEGADOFORMULASMEDICION_H
