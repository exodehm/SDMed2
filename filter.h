#ifndef FILTER_H
#define FILTER_H

#include "./Tablas/tablabase.h"
#include "./Editor/editor.h"


class Filter : public QObject
{
    Q_OBJECT
public:
    explicit Filter(QObject *parent = nullptr);
    bool eventFilter(QObject* object, QEvent *event) override;
};

#endif // FILTER_H
