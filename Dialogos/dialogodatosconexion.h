#ifndef DIALOGODATOSCONEXION_H
#define DIALOGODATOSCONEXION_H

#include <QDialog>
#include <QtSql/QSqlDatabase>

class DialogoConfiguracion;

namespace Ui {
class DialogoDatosConexion;
}

class LineEditIP;

class DialogoDatosConexion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoDatosConexion(QSqlDatabase& db, QWidget *parent = nullptr);
    ~DialogoDatosConexion();
    void readSettings();
    QString ComponerIP();
    QString LeeTextoDirectorioDatosConexion();


public slots:
    void writeSettings();
    void SincronizarCheckButtons();
    void ActualizarBotonServidor();
    QStringList LeeDatosConexion();
    void ConfiguracionAvanzada();
    bool IsPostgresRunning();
    bool Conectar();
    bool ArrancarPararServidor();
    void ColocarLineEditIPs();
    void Cancelar();

private:
    Ui::DialogoDatosConexion *ui;
    DialogoConfiguracion* m_dialogoconfig;
    QString m_postgres;
    QSqlDatabase m_db;
    QString m_directorio_datos_conexion;
    bool m_ispostgres_running;
    LineEditIP* m_lineEditIP[4];
    QString m_LeyendaBotonConectarServidor[2];
};

#endif // DIALOGODATOSCONEXION_H
