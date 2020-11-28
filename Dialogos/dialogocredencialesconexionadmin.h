#ifndef DIALOGODATOSCONEXION_H
#define DIALOGODATOSCONEXION_H

#include <QDialog>


namespace Ui {
class DialogoCredencialesConexionAdmin;
}

class DialogoCredencialesConexionAdmin : public QDialog
{
    Q_OBJECT
    struct sDatosConexion
    {
        QString hostName;
        int puerto;
        QString usuario;
        QString password;
    };

public:
    explicit DialogoCredencialesConexionAdmin(QWidget *parent = nullptr);
    ~DialogoCredencialesConexionAdmin();
    void WriteSettings();
    void ReadSettings();
    sDatosConexion LeeDatosConexion();

public slots:
    bool ComprobarAdminRole();
    void ResetearBotonComprobar(const QString& texto);

private:
    Ui::DialogoCredencialesConexionAdmin *ui;
    sDatosConexion m_datosConexion;
};

#endif // DIALOGODATOSCONEXION_H
