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
    explicit DialogoConexionBBDD(QSqlDatabase *db, QWidget *parent = nullptr);
    bool HayConexion();
    ~DialogoConexionBBDD();

private:
    Ui::DialogoConexionBBDD *ui;
    QSqlDatabase* m_db;
    bool m_conectado;

private slots:
    bool ProbarConexion();
    void GuardarDatosConexion();
    void ActivarCheckConexionAutomatica(int estado);
};

#endif // DIALOGOCONEXIONBBDD_H
