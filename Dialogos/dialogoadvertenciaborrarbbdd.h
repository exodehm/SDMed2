#ifndef DIALOGOBORRARBBDD_H
#define DIALOGOBORRARBBDD_H

#include <QDialog>

namespace Ui {
class DialogoBorrarBBDD;
}

class DialogoBorrarBBDD : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoBorrarBBDD(QStringList datos, QWidget *parent = nullptr);
    ~DialogoBorrarBBDD();
    bool Exportar();

private:
    Ui::DialogoBorrarBBDD *ui;
};

#endif // DIALOGOBORRARBBDD_H
