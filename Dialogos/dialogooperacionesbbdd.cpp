#include "dialogooperacionesbbdd.h"
#include "ui_dialogooperacionesbbdd.h"

DialogoOperacionesBBDD::DialogoOperacionesBBDD(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoOperacionesBBDD)
{
    ui->setupUi(this);
}

DialogoOperacionesBBDD::~DialogoOperacionesBBDD()
{
    delete ui;
}
