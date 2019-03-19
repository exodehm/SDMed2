#ifndef MEDCERTMODELBASE_H
#define MEDCERTMODELBASE_H

#include "./Modelos/Modelobase.h"
#include "./defs.h"


class MedicionModel : public ModeloBase
{
    Q_OBJECT

public:

    MedicionModel(const QString &tabla, const QString& codigopadre, const QString &codigohijo, int fase,  QUndoStack *p, QObject* parent=nullptr);
    ~MedicionModel();

    bool setData(const QModelIndex & index, const QVariant& value, int role);

    void PrepararCabecera(/*QList<QList<QVariant>>&datos*/);
    void Copiar(const QList<int> &filas);
    void Pegar(int fila);
    void Certificar(const QList<int> &filas,QString num_cert) override;
    void BorrarFilas(const QList<int> &filas) override;
    void InsertarFila(int fila) override;
    void ActualizarDatos(QString padre, QString hijo) override;

    void CambiarTipoLineaMedicion(int fila, int columna, QVariant tipo);
    void CambiaCertificacionActual(int cert);

private:

    int num_cert;
    float subtotal;
    int certif_actual;
};

#endif // MEDCERTMODELBASE_H
