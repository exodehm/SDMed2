#ifndef PRINCIPALMODEL_H
#define PRINCIPALMODEL_H

#include "./Modelos/Modelobase.h"

class PrincipalModel : public ModeloBase
{
    Q_OBJECT
public:

    PrincipalModel(const QString &tabla, const QString& codigopadre, const QString &codigohijo, QUndoStack *p, QObject* parent=nullptr);
    ~PrincipalModel();

    bool setData(const QModelIndex & index, const QVariant& value, int role);
    bool removeRows(int fila, int numFilas, const QModelIndex& parent);

    bool EsPartida();
    void PrepararCabecera(/*QList<QList<QVariant>>&datos*/) override;

    void BorrarFilas(const QList<int>&filas) override;
    void InsertarFila(int fila) override;
    void ActualizarDatos(QString padre, QString hijo);

    int LeeColor(int fila, int columna);

    void Copiar(const QList<int> &filas);
    void Pegar(int fila);

public slots:
    //void MostrarHijos (QModelIndex idpadre);
};

#endif // PRINCIPALMODEL_H
