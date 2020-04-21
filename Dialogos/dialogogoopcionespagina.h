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
    explicit DialogogoOpcionesPagina(QWidget *parent = nullptr);
    ~DialogogoOpcionesPagina();

private:
    Ui::DialogogoOpcionesPagina *ui;
};

#endif // DIALOGOGOOPCIONESPAGINA_H
