#ifndef DIALOGOCONEXIONBBDD_H
#define DIALOGOCONEXIONBBDD_H

#include <QDialog>
#include <QSqlDatabase>

namespace Ui {
class DialogoConexionBBDD;
}

class DialogoConexionBBDD : public QDialog
{
    Q_OBJECT

public:
    enum eEstadoColor{NORMAL, ERROR, CORRECTO};
    struct sEstados
    {
        QString colorEstado[3];
        QString leyendaEstado[3];
        sEstados()
        {
            colorEstado[NORMAL]= "background-color: #d9dede";
            colorEstado[ERROR]= "background-color: red; color : black";
            colorEstado[CORRECTO]= "background-color: lime";
            leyendaEstado[NORMAL]=tr("Probar conexón");
            leyendaEstado[ERROR]=tr("Error abriendo base de datos");
            leyendaEstado[CORRECTO]=tr("¡Conectado con éxito!");
        }
    };

    explicit DialogoConexionBBDD(QSqlDatabase *db, QWidget *parent = nullptr);
    bool HayExension(QString bbdd = "sdmed");
    bool HayConexion();
    void ReadSettings();
    ~DialogoConexionBBDD();

private:
    Ui::DialogoConexionBBDD *ui;
    QSqlDatabase* m_db;
    bool m_conectado;
    sEstados estadoConexion;


private slots:
    bool ProbarConexion();
    void GuardarDatosConexion();
    void ActivarCheckConexionAutomatica(int estado);
    void OperacionesBBDD();
};

#endif // DIALOGOCONEXIONBBDD_H
