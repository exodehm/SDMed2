#include "dialogogoopcionespagina.h"
#include "ui_dialogogoopcionespagina.h"

DialogogoOpcionesPagina::DialogogoOpcionesPagina(QWidget *parent,double marIzq, double marDer, double marSup, double marInf, int pagInic):
    QDialog(parent),
    ui(new Ui::DialogogoOpcionesPagina)
{
    ui->setupUi(this);
    ui->spinDer->setValue(marDer);
    ui->spinIzq->setValue(marIzq);
    ui->spinSup->setValue(marSup);
    ui->spinInf->setValue(marInf);
    ui->spinPaginaInicial->setValue(pagInic);
}

DialogogoOpcionesPagina::~DialogogoOpcionesPagina()
{
    delete ui;
}
