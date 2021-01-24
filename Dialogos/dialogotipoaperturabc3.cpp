#include "dialogotipoaperturabc3.h"
#include "ui_dialogotipoaperturabc3.h"

DialogoTipoAperturaBC3::DialogoTipoAperturaBC3(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoTipoAperturaBC3)
{
    ui->setupUi(this);
}

DialogoTipoAperturaBC3::~DialogoTipoAperturaBC3()
{
    delete ui;
}

bool DialogoTipoAperturaBC3::ImportacionRapida()
{
    return ui->checkBoxImportacionRapida->isChecked();
}
