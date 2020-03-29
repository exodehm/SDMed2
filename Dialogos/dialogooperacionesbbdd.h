#ifndef DIALOGOOPERACIONESBBDD_H
#define DIALOGOOPERACIONESBBDD_H

#include <QDialog>
#include <QSqlDatabase>

namespace Ui {
class DialogoOperacionesBBDD;
}

class DialogoOperacionesBBDD : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoOperacionesBBDD(QString servidor, QString puerto, QWidget *parent = nullptr);
    ~DialogoOperacionesBBDD();
    void Comprobaciones();

private slots:
    bool Conectar();
    bool CrearRole();
    bool CrearBaseDatosSdmed();
    bool CrearExtension();

private:
    Ui::DialogoOperacionesBBDD *ui;
    QSqlDatabase db;
};

#endif // DIALOGOOPERACIONESBBDD_H
