#ifndef DIALOGODATOSGENERALES_H
#define DIALOGODATOSGENERALES_H

#include <QDialog>

namespace Ui {
class DialogoDatosGenerales;
}

class DialogoDatosGenerales : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoDatosGenerales(QWidget *parent = 0);
    ~DialogoDatosGenerales();

private:
    Ui::DialogoDatosGenerales *ui;
};

#endif // DIALOGODATOSGENERALES_H
