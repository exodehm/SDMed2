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
    Q_OBJECT

public:
    explicit DialogoCertificaciones(QString tabla, QWidget *parent = 0);
    ~DialogoCertificaciones();
    QString LeeFecha();

private slots:
    void cambiaDia(int d);
    void cambiaMes(int m);
    void cambiaAnno(int a);
    void actualizarCombos(QDate date);
    void insertarNuevaCertificacion();
    void borrarCertificacion();
    void actualizarTabla();

private:
    QString tabla;
    Ui::DialogoCertificaciones *ui;
    int dia,mes,anno;
    QSqlQuery consulta;
    QStringList cabeceratabla;
};

#endif // DIALOGONUEVACERTIFICACION_H
