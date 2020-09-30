#ifndef DIALOGOADVERTENCIABORRARBBDD_H
#define DIALOGOADVERTENCIABORRARBBDD_H

#include <QDialog>

namespace Ui {
class DialogoAdvertenciaBorrarBBDD;
}

class DialogoAdvertenciaBorrarBBDD : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoAdvertenciaBorrarBBDD(QStringList datos, QWidget *parent = nullptr);
    ~DialogoAdvertenciaBorrarBBDD();
    bool Exportar();

private:
    Ui::DialogoAdvertenciaBorrarBBDD *ui;
};

#endif // DIALOGOADVERTENCIABORRARBBDD_H
