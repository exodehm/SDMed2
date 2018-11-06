#ifndef MEDCERTMODELBASE_H
#define MEDCERTMODELBASE_H

#include "./Modelos/Modelobase.h"


class MedCertModel : public ModeloBase
{
    Q_OBJECT

public:

    MedCertModel(const QString &tabla, const QString& idpadre, const QString &idhijo, QUndoStack *p, QObject* parent=nullptr);
    ~MedCertModel();

    bool setData(const QModelIndex & index, const QVariant& value, int role);

    bool EsPartida();
    void PrepararCabecera(QList<QList<QVariant>>&datos);

    void BorrarFilas(QList<int>filas);
    void InsertarFila(int fila);
    void ActualizarDatos(QString padre, QString hijo);
};


#endif // MEDCERTMODELBASE_H
