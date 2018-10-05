#ifndef MEDCERTMODELBASE_H
#define MEDCERTMODELBASE_H

#include "./Modelos/Modelobase.h"


class MedCertModel : public ModeloBase
{
    Q_OBJECT

public:

    MedCertModel(const QString& cadenaInicio, QObject* parent=nullptr);
    ~MedCertModel();

    bool EsPartida();
};


#endif // MEDCERTMODELBASE_H
