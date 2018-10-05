#ifndef TABLAPRINCIPALMODEL_H
#define TABLAPRINCIPALMODEL_H

#include "./Modelos/Modelobase.h"

class TablaPrincipalModel : public ModeloBase
{
    Q_OBJECT
public:

    TablaPrincipalModel(const QString& cadenaInicio, QObject* parent=nullptr);
    ~TablaPrincipalModel();

    bool EsPartida();

public slots:
    //void MostrarHijos (QModelIndex idpadre);
};

#endif // TABLAPRINCIPALMODEL_H
