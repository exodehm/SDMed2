#include "dialogodatosgenerales.h"
#include "ui_dialogodatosgenerales.h"

DialogoDatosGenerales::DialogoDatosGenerales(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoDatosGenerales)
{
    ui->setupUi(this);
    QObject::connect(ui->pushButton_Ok,SIGNAL(clicked(bool)),this,SLOT(accept()));
}

DialogoDatosGenerales::~DialogoDatosGenerales()
{
    delete ui;
}
