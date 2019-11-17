#ifndef MEDCERTMODELBASE_H
#define MEDCERTMODELBASE_H

#include "./Modelos/Modelobase.h"
#include "./defs.h"


class MedicionModel : public ModeloBase
{
    Q_OBJECT

public:

    MedicionModel(const QString &tabla, const QStringList& ruta, int fase,  MiUndoStack *p, QObject* parent=nullptr);
    ~MedicionModel() override;

    bool setData(const QModelIndex & index, const QVariant& value, int role) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    void PrepararCabecera(/*QList<QList<QVariant>>&datos*/) override;
    void Copiar(const QList<int> &filas) override;
    void Pegar(int fila) override;
    void Certificar(const QList<int> &filas) override;
    void BorrarFilas(const QList<int> &filas) override;
    void InsertarFila(int fila) override;
    void ActualizarDatos(const QStringList& ruta) override;
    void EditarFormula(const QModelIndex& index);
    void IgualarDatoColumna(const QModelIndexList &celdas);

    void CambiarTipoLineaMedicion(int fila, int columna, QVariant tipo);
    void CambiaCertificacionActual(int cert);
    void CambiarNumeroCertificacion(int numcert);

private:

    int num_cert;
    float subtotal;
    int certif_actual;
};

#endif // MEDCERTMODELBASE_H
