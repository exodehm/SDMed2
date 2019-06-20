#include "dialogoconexionbbdd.h"
#include "ui_dialogoconexionbbdd.h"

DialogoConexionBBDD::DialogoConexionBBDD(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoConexionBBDD)
{
    ui->setupUi(this);
}

DialogoConexionBBDD::~DialogoConexionBBDD()
{
    delete ui;
}
