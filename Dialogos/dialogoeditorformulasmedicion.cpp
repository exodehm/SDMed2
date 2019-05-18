#include "dialogoeditorformulasmedicion.h"
#include "ui_dialogoeditorformulasmedicion.h"

DialogoEditorFormulasMedicion::DialogoEditorFormulasMedicion(QVariant uds, QVariant longitud, QVariant anchura, QVariant altura, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoEditorFormulasMedicion)
{
    ui->setupUi(this);
    ui->lineEditUds->setText(uds.toString());
    ui->lineEditLongitud->setText(longitud.toString());
    ui->lineEditAnchura->setText(anchura.toString());
    ui->lineEditAltura->setText(altura.toString());

    QObject::connect(ui->radioButtonExpresion,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonGeometria,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonPerfil,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
}

DialogoEditorFormulasMedicion::~DialogoEditorFormulasMedicion()
{
    delete ui;
}

void DialogoEditorFormulasMedicion::SincronizarWidgets()
{
    ui->plainTextEditExpresion->setEnabled(ui->radioButtonExpresion->isChecked());
    ui->pushButtonExpresion->setEnabled(ui->radioButtonExpresion->isChecked());
    ui->plainTextEditGeometria->setEnabled(ui->radioButtonGeometria->isChecked());
    ui->pushButtonGeometria->setEnabled(ui->radioButtonGeometria->isChecked());
    ui->comboBoxPerfil->setEnabled(ui->radioButtonPerfil->isChecked());
    //ui->pushButtonExpresion->setEnabled(ui->radioButtonExpresion->isChecked());
}
