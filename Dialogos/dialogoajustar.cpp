#include "dialogoajustar.h"
#include "ui_dialogoajustar.h"
#include <QDebug>

DialogoAjustar::DialogoAjustar(const QString &codigoraiz, const QString &resumenraiz, const double &precioinicial, QWidget *parent) :
    codigo(codigoraiz), resumen(resumenraiz), precio_inicial(precioinicial), precio_final(precioinicial), QDialog(parent),
    ui(new Ui::DialogoAjustar)
{
    ui->setupUi(this);
    ui->lineEditCodigo->setText(codigo);
    ui->lineEditResumen->setText(resumen);
    ui->lineEditPrecioActual->setText(QString::number(precio_inicial));
    ui->lineEditPrecioAjustar->setText(QString::number(precio_inicial));
    ui->lineEditPorcentaje->setText(QString::number(precio_inicial/precio_final*100));

    QObject::connect(ui->botonCancelar,SIGNAL(clicked(bool)),this,SLOT(close()));
    QObject::connect(ui->botonAceptar,SIGNAL(clicked(bool)),this,SLOT(accept()));
    QObject::connect(ui->botonDefecto,SIGNAL(clicked(bool)),this,SLOT(PonerValoresDefecto()));
    QObject::connect(ui->lineEditPorcentaje,SIGNAL(textChanged(QString)),this,SLOT(ModificarCantidad(QString)));
    QObject::connect(ui->lineEditPrecioAjustar,SIGNAL(textChanged(QString)),this,SLOT(ModificarPorcentaje(QString)));
}

QString DialogoAjustar::LeePrecioParaAjustar()
{
    return ui->lineEditPrecioAjustar->text();
}

DialogoAjustar::~DialogoAjustar()
{
    delete ui;
}

void DialogoAjustar::PonerValoresDefecto()
{
    ui->checkManoObraCantidad->setChecked(false);
    ui->checkMaquinariaCantidad->setChecked(false);
    ui->checkOtrosCantidad->setChecked(false);

    ui->checkManoObraPrecio->setChecked(true);
    ui->checkMaterialesPrecio->setChecked(true);
    ui->checkMaquinariaPrecio->setChecked(true);
    ui->checkOtrosPrecio->setChecked(true);
}

void DialogoAjustar::ModificarCantidad(QString porcentaje)
{
    precio_final = precio_inicial * porcentaje.toDouble()/100;
    ui->lineEditPrecioAjustar->setText(QString::number(precio_final));
    HabilitarBotonAceptar();
}

void DialogoAjustar::ModificarPorcentaje(QString cantidad)
{
    porcentaje = cantidad.toDouble()/precio_inicial*100;
    ui->lineEditPorcentaje->setText(QString::number(porcentaje));
    HabilitarBotonAceptar();
}

void DialogoAjustar::HabilitarBotonAceptar()
{
    if (!ui->lineEditPrecioAjustar->text().isEmpty())
    {
        ui->botonAceptar->setEnabled(true);
    }
    else
    {
        ui->botonAceptar->setEnabled(false);
    }
}
