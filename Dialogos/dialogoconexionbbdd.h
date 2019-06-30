#ifndef DIALOGOCONEXIONBBDD_H
#define DIALOGOCONEXIONBBDD_H

#include <QDialog>

namespace Ui {
class DialogoConexionBBDD;
}

class DialogoConexionBBDD : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoConexionBBDD(QWidget *parent = nullptr);
    ~DialogoConexionBBDD();

private:
    Ui::DialogoConexionBBDD *ui;
};

#endif // DIALOGOCONEXIONBBDD_H
