#ifndef CERTIFICACIONMODEL_H
#define CERTIFICACIONMODEL_H

#include "./Modelos/MedCertModel.h"

class CertificacionModel : public MedCertModel
{
    Q_OBJECT

public:

    CertificacionModel(const QString &tabla, const QString& codigopadre, const QString &codigohijo, QUndoStack *p, QObject* parent=nullptr);
    ~CertificacionModel();

    void Certificar(const QList<int> &filas);
    void ActualizarDatos(QString padre, QString hijo);
};

#endif // CERTIFICACIONMODEL_H
