#include "dialogoadvertenciaborrarbbdd.h"
#include "ui_dialogoadvertenciaborrarbbdd.h"

DialogoAdvertenciaBorrarBBDD::DialogoAdvertenciaBorrarBBDD(QStringList datos, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoAdvertenciaBorrarBBDD)
{
    ui->setupUi(this);
    ui->label_codigo->setText(datos.at(0));
    ui->label_resumen->setText(datos.at(1));

    QObject::connect(ui->boton_aceptar,SIGNAL(clicked(bool)),this,SLOT(accept()));
    QObject::connect(ui->boton_cancelar,SIGNAL(clicked(bool)),this,SLOT(reject()));

}

DialogoAdvertenciaBorrarBBDD::~DialogoAdvertenciaBorrarBBDD()
{
    delete ui;
}

bool DialogoAdvertenciaBorrarBBDD::Exportar()
{
    return ui->checkBox->isChecked();
}
