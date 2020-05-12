#ifndef DIALOGOGOOPCIONESPAGINA_H
#define DIALOGOGOOPCIONESPAGINA_H

#include <QDialog>
#include "Dialogos/dialogolistadoimprimir.h"
namespace Ui {
class DialogogoOpcionesPagina;
}

class DialogogoOpcionesPagina : public QDialog
{
    Q_OBJECT

public:
    explicit DialogogoOpcionesPagina(QWidget *parent = nullptr);
    explicit DialogogoOpcionesPagina(const sOpcionesPagina& opciones, QWidget *parent = nullptr);
    ~DialogogoOpcionesPagina();
    sOpcionesPagina LeerDatos();
    QString LeeDatosS();

private:
    Ui::DialogogoOpcionesPagina *ui;
    sOpcionesPagina m_opciones;
};

#endif // DIALOGOGOOPCIONESPAGINA_H
