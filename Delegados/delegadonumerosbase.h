#ifndef DELEGADONUMEROSBASE_H
#define DELEGADONUMEROSBASE_H

#include <QRegExp>
#include <QRegExpValidator>
#include <QPainter>

#include "./delegadobase.h"


class DelegadoNumerosBase : public DelegadoBase
{
public:
    explicit DelegadoNumerosBase(QObject* parent=nullptr);
    void setPrecision(quint8 precision);
    QWidget * createEditor(QWidget * parent, const QStyleOptionViewItem&option, const QModelIndex&index) const;
    void setEditorData(QWidget * editor, const QModelIndex&index)const;
    void setModelData(QWidget * editor, QAbstractItemModel * model, const QModelIndex&index) const;
    void paint( QPainter *painter,const QStyleOptionViewItem &option, const QModelIndex &index ) const;
    QSize sizeHint( const QStyleOptionViewItem &option, const QModelIndex &index ) const;
    QString displayText(const QVariant & value, const QLocale & locale) const;

protected:
    QRegExp* rx;
    quint8 m_precision;
    QLocale m_locale;
};

#endif // DELEGADONUMEROSBASE_H
