#ifndef DIALOGONUEVACERTIFICACION_H
#define DIALOGONUEVACERTIFICACION_H

#include <QDialog>
#include <QDate>
#include <QSqlQuery>

#include "./Tablas/tablabase.h"

namespace Ui {
class DialogoCertificaciones;
}

class DialogoCertificaciones : public QDialog
{
    enum tipoColumna{NUM_CERTIFICACION,FECHA,BORRAR,ACTUAL};

    Q_OBJECT

public:
    explicit DialogoCertificaciones(QString tabla,QWidget *parent = nullptr);
    ~DialogoCertificaciones();
    QString LeeFecha();
    QStringList CertificacionActual();

signals:
    void BorrarCertificacion(QString fecha_certificacion);
    void InsertarCertificacion(QString fecha_certificacion);
    void ActualizarCert();

private slots:
    void cambiaDia(int d);
    void cambiaMes(int m);
    void cambiaAnno(int a);
    void actualizarCombos(QDate date);
    void InsertarNuevaCertificacion();
    void BorrarCertificacion();
    void actualizarTabla();
    void ActualizarCertifActual();

private:
    Ui::DialogoCertificaciones *ui;
    QString tabla;
    int dia,mes,anno;
    QSqlQuery consulta;
    QStringList cabeceratabla;
    QStringList certifActual;    
};

#endif // DIALOGONUEVACERTIFICACION_H
