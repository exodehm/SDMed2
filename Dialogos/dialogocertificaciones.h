#ifndef DIALOGONUEVACERTIFICACION_H
#define DIALOGONUEVACERTIFICACION_H

#include <QDialog>
#include <QDate>
#include <QSqlQuery>

namespace Ui {
class DialogoCertificaciones;
}

class DialogoCertificaciones : public QDialog
{
    enum tipoColumna{NUM_CERTIFICACION,FECHA,BORRAR,ACTUAL};

    Q_OBJECT

public:
    explicit DialogoCertificaciones(QString tabla, QWidget *parent = 0);
    ~DialogoCertificaciones();
    QString LeeFecha();
    QStringList CertificacionActual();

private slots:
    void cambiaDia(int d);
    void cambiaMes(int m);
    void cambiaAnno(int a);
    void actualizarCombos(QDate date);
    void insertarNuevaCertificacion();
    void borrarCertificacion();
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
