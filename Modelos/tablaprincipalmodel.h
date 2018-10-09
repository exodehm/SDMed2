#ifndef TABLAPRINCIPALMODEL_H
#define TABLAPRINCIPALMODEL_H

#include "./Modelos/Modelobase.h"

class TablaPrincipalModel : public ModeloBase
{
    Q_OBJECT
public:

    TablaPrincipalModel(const QString &tabla, const QString& cadenaInicio, QUndoStack *p, QObject* parent=nullptr);
    ~TablaPrincipalModel();

    bool setData(const QModelIndex & index, const QVariant& value, int role);

    bool EsPartida();
    void PrepararCabecera(QList<QList<QVariant>>&datos);

public slots:
    //void MostrarHijos (QModelIndex idpadre);
};

#endif // TABLAPRINCIPALMODEL_H
