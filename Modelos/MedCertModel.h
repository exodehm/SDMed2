#ifndef MEDCERTMODELBASE_H
#define MEDCERTMODELBASE_H

#include "./Modelos/Modelobase.h"


class MedCertModel : public ModeloBase
{
    Q_OBJECT

public:

    MedCertModel(const QString &tabla, const QString& codigopadre, const QString &codigohijo, QUndoStack *p, QObject* parent=nullptr);
    ~MedCertModel();

    bool setData(const QModelIndex & index, const QVariant& value, int role);

    bool EsPartida();
    void PrepararCabecera(QList<QList<QVariant>>&datos);
    void Copiar(const QList<int> &filas);
    void Pegar();
    void BorrarFilas(const QList<int> &filas);
    void InsertarFila(int fila);
    void ActualizarDatos(QString padre, QString hijo);
};


#endif // MEDCERTMODELBASE_H
