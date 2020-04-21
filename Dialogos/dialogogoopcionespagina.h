#ifndef DIALOGOGOOPCIONESPAGINA_H
#define DIALOGOGOOPCIONESPAGINA_H

#include <QDialog>

namespace Ui {
class DialogogoOpcionesPagina;
}

class DialogogoOpcionesPagina : public QDialog
{
    Q_OBJECT

public:
    explicit DialogogoOpcionesPagina(QWidget *parent = nullptr,
                                     double marIzq = 1.5,
                                     double marDer = 1.5,
                                     double marSup = 1.5,
                                     double marInf = 1.5,
                                     int pagInic = 1
                                     );
    ~DialogogoOpcionesPagina();

private:
    Ui::DialogogoOpcionesPagina *ui;
};

#endif // DIALOGOGOOPCIONESPAGINA_H
