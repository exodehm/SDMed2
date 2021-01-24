#ifndef DIALOGOTIPOAPERTURABC3_H
#define DIALOGOTIPOAPERTURABC3_H

#include <QDialog>

namespace Ui {
class DialogoTipoAperturaBC3;
}

class DialogoTipoAperturaBC3 : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoTipoAperturaBC3(QWidget *parent = nullptr);
    ~DialogoTipoAperturaBC3();

    bool ImportacionRapida();

private:
    Ui::DialogoTipoAperturaBC3 *ui;
};

#endif // DIALOGOTIPOAPERTURABC3_H
