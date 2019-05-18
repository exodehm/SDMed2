#include "dialogoeditorformulasmedicion.h"
#include "ui_dialogoeditorformulasmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlQueryModel>
#include <QDebug>

DialogoEditorFormulasMedicion::DialogoEditorFormulasMedicion(QVariant uds, QVariant longitud, QVariant anchura, QVariant altura, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoEditorFormulasMedicion)
{
    m_comboPerfilesRelleno = false;

    ui->setupUi(this);
    ui->lineEditUds->setText(uds.toString());
    ui->lineEditLongitud->setText(longitud.toString());
    ui->lineEditAnchura->setText(anchura.toString());
    ui->lineEditAltura->setText(altura.toString());

    QObject::connect(ui->radioButtonExpresion,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonGeometria,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonPerfil,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonPerfil,SIGNAL(clicked(bool)),this,SLOT(RellenarListadoPerfiles()));
    QObject::connect(ui->comboBoxPerfil,SIGNAL(currentIndexChanged(int)),this,SLOT(RellenarTablasDiferentesPerfiles(int)));
}

DialogoEditorFormulasMedicion::~DialogoEditorFormulasMedicion()
{
    if (modeloPerfiles)
    {
        delete modeloPerfiles;
    }
    if (modeloTipoPerfiles)
    {
        delete modeloTipoPerfiles;
    }
    delete ui;
}

void DialogoEditorFormulasMedicion::SincronizarWidgets()
{
    ui->plainTextEditExpresion->setEnabled(ui->radioButtonExpresion->isChecked());
    ui->pushButtonExpresion->setEnabled(ui->radioButtonExpresion->isChecked());
    ui->plainTextEditGeometria->setEnabled(ui->radioButtonGeometria->isChecked());
    ui->pushButtonGeometria->setEnabled(ui->radioButtonGeometria->isChecked());
    ui->comboBoxPerfil->setEnabled(ui->radioButtonPerfil->isChecked());
    ui->comboBoxTamanno->setEnabled(ui->radioButtonPerfil->isChecked());
}

void DialogoEditorFormulasMedicion::RellenarListadoPerfiles()
{
    if (!m_comboPerfilesRelleno)
    {
        modeloPerfiles = new QSqlQueryModel;
        modeloPerfiles->setQuery("SELECT nombre FROM perfiles ORDER BY id");
        ui->comboBoxPerfil->setModel(modeloPerfiles);
        m_comboPerfilesRelleno = true;
    }
}

void DialogoEditorFormulasMedicion::RellenarTablasDiferentesPerfiles(int tabla)
{
    qDebug()<<"Tabla "<<tabla;
    if (tabla == 0) //cero son los corrugados que van un poco aparte
    {
        modeloTipoPerfiles = new QSqlQueryModel;
        modeloTipoPerfiles->setQuery("SELECT diametro FROM \"tCorrugados\" ORDER BY diametro");
        ui->comboBoxTamanno->setModel(modeloTipoPerfiles);
    }
}
