#include "dialogoadvertenciaborrarbbdd.h"
#include "ui_dialogoadvertenciaborrarbbdd.h"

DialogoBorrarBBDD::DialogoBorrarBBDD(QStringList datos, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoBorrarBBDD)
{
    ui->setupUi(this);
    ui->label_codigo->setText(datos.at(0));
    ui->label_resumen->setText(datos.at(1));

    QObject::connect(ui->boton_aceptar,SIGNAL(clicked(bool)),this,SLOT(accept()));
    QObject::connect(ui->boton_cancelar,SIGNAL(clicked(bool)),this,SLOT(reject()));

}

DialogoBorrarBBDD::~DialogoBorrarBBDD()
{
    delete ui;
}

bool DialogoBorrarBBDD::Exportar()
{
    return ui->checkBox->isChecked();
}
