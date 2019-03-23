#include "dialogosuprimirmedicion.h"
#include "ui_dialogosuprimirmedicion.h"

DialogoSuprimirMedicion::DialogoSuprimirMedicion(QString titulo, QString tipocantidad, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoSuprimirMedicion)
{
    ui->setupUi(this);
    ui->radioButton_No->setChecked(true);
    if (tipocantidad == "1")
    {
        ui->radioButton_Suprimir->setText(tr("Suprimir lineas de certificación y sus fases"));
    }
    setWindowTitle(titulo);
}

DialogoSuprimirMedicion::~DialogoSuprimirMedicion()
{
    delete ui;
}

bool DialogoSuprimirMedicion::Suprimir() const
{
    return ui->radioButton_Suprimir->isChecked();
}
