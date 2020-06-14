#ifndef PRINCIPALMODEL_H
#define PRINCIPALMODEL_H

#include "./Modelos/Modelobase.h"

class PrincipalModel : public ModeloBase
{
    Q_OBJECT
public:

    PrincipalModel(const QString &tabla, const QStringList& ruta, MiUndoStack *p, QObject* parent=nullptr);
    ~PrincipalModel() override;

    bool setData(const QModelIndex & index, const QVariant& value, int role) override;
    bool removeRows(int fila, int numFilas, const QModelIndex& parent) override;

    Qt::ItemFlags flags(const QModelIndex &index) const override;

    bool EsPartida() override;
    void PrepararCabecera(/*QList<QList<QVariant>>&datos*/) override;

    void BorrarFilas(const QList<int>&filas) override;
    void InsertarFila(int fila) override;
    void ActualizarDatos(const QStringList& ruta) override;
    void BloquearPrecio(const QModelIndex &index, bool bloquear = true);

    void Copiar(const QList<int> &filas) override;
    void Pegar(int fila) override;

public slots:
    //void MostrarHijos (QModelIndex idpadre);
};

#endif // PRINCIPALMODEL_H
