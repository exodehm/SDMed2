#ifndef TABLAPRINCIPALMODEL_H
#define TABLAPRINCIPALMODEL_H

#include "./Modelos/Modelobase.h"

class TablaPrincipalModel : public ModeloBase
{
    Q_OBJECT
public:

    TablaPrincipalModel(const QString &tabla, const QString& idpadre, const QString &idhijo, QUndoStack *p, QObject* parent=nullptr);
    ~TablaPrincipalModel();

    bool setData(const QModelIndex & index, const QVariant& value, int role);
    bool removeRows(int fila, int numFilas, const QModelIndex& parent);

    bool EsPartida();
    void PrepararCabecera(QList<QList<QVariant>>&datos);

    void BorrarFilas(QList<int>filas);
    void ActualizarDatos(QString padre, QString hijo);

public slots:
    //void MostrarHijos (QModelIndex idpadre);
};

#endif // TABLAPRINCIPALMODEL_H
