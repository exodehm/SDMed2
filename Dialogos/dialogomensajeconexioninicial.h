#ifndef DIALOGOMENSAJECONEXIONINICIAL_H
#define DIALOGOMENSAJECONEXIONINICIAL_H

#include <QDialog>

namespace Ui {
class DialogoMensajeConexionInicial;
}

class QSqlDatabase;

class DialogoMensajeConexionInicial : public QDialog
{
    Q_OBJECT
public:
    explicit DialogoMensajeConexionInicial(QSqlDatabase* db, QWidget *parent = nullptr);

private:
    Ui::DialogoMensajeConexionInicial* ui;
    QSqlDatabase* m_db;

private slots:
    void ArrancarServidor();
    int ArrancarServidorWin();
    int ArrancarServidorLinux();
    bool EsConexionLocal();


};

#endif // DIALOGOMENSAJECONEXIONINICIAL_H
