#include "dialogogoopcionespagina.h"
#include "ui_dialogogoopcionespagina.h"

DialogogoOpcionesPagina::DialogogoOpcionesPagina(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogogoOpcionesPagina)
{
    ui->setupUi(this);
}

DialogogoOpcionesPagina::~DialogogoOpcionesPagina()
{
    delete ui;
}
