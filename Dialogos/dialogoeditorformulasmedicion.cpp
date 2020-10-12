#include "dialogoeditorformulasmedicion.h"
#include "ui_dialogoeditorformulasmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlQueryModel>
#include <QDebug>

DialogoEditorFormulasMedicion::DialogoEditorFormulasMedicion(const QVariant &uds, const QVariant &longitud, const QVariant &anchura, const QVariant &altura, const QVariant &formula, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoEditorFormulasMedicion)
{
    ui->setupUi(this);
    ui->lineEditUds->setText(uds.toString());
    ui->lineEditLongitud->setText(longitud.toString());
    ui->lineEditAnchura->setText(anchura.toString());
    ui->lineEditAltura->setText(altura.toString());
    ui->lineEditExpresion->setText(formula.toString());

    QObject::connect(ui->radioButtonExpresion,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonGeometria,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonPerfil,SIGNAL(clicked(bool)),this,SLOT(SincronizarWidgets()));
    QObject::connect(ui->radioButtonPerfil,SIGNAL(clicked(bool)),this,SLOT(RellenarListadoPerfiles()));
    QObject::connect(ui->comboBoxPerfil,SIGNAL(currentTextChanged(const QString &)),this,SLOT(RellenarTablasDiferentesPerfiles(const QString &)));
    QObject::connect(ui->comboBoxTamanno,SIGNAL(currentTextChanged(const QString &)),this,SLOT(SeleccionarPeso(const QString &)));
    QObject::connect(ui->pushButtonEvaluar,SIGNAL(clicked(bool)),this,SLOT(Evaluar()));
    QObject::connect(ui->lineEditUds,SIGNAL(editingFinished()),this,SLOT(Evaluar()));
    QObject::connect(ui->lineEditLongitud,SIGNAL(editingFinished()),this,SLOT(Evaluar()));
    QObject::connect(ui->lineEditAnchura,SIGNAL(editingFinished()),this,SLOT(Evaluar()));
    QObject::connect(ui->lineEditAltura,SIGNAL(editingFinished()),this,SLOT(Evaluar()));
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

bool DialogoEditorFormulasMedicion::ComboVacio(const QComboBox *combo)
{
    return combo->count()==0;
}

void DialogoEditorFormulasMedicion::Evaluar()
{
    QString sUd = ui->lineEditUds->text().isEmpty()? "0" : ui->lineEditUds->text();
    QString sLong = ui->lineEditLongitud->text().isEmpty()? "0" : ui->lineEditLongitud->text();
    QString sAnch = ui->lineEditAnchura->text().isEmpty()? "0" : ui->lineEditAnchura->text();
    QString sAlt = ui->lineEditAltura->text().isEmpty()? "0" : ui->lineEditAltura->text();
    QString cadenaevaluar = "SELECT evaluar_formula('"+ sUd + "','" + sLong + "','" + sAnch + "','" + sAlt + "','" + ui->lineEditExpresion->text() + "')";
    qDebug()<<cadenaevaluar;
    float resultado;
    QSqlQuery consulta_evaluar;
    consulta_evaluar.exec(cadenaevaluar);
    while (consulta_evaluar.next())
    {
        resultado=consulta_evaluar.value(0).toFloat();
    }    
    ui->lineEditResultado->setText(QString::number(resultado,'f',2));
}

void DialogoEditorFormulasMedicion::SincronizarWidgets()
{
    ui->lineEditExpresion->setEnabled(ui->radioButtonExpresion->isChecked());
    ui->pushButtonEvaluar->setEnabled(ui->radioButtonExpresion->isChecked());
    ui->plainTextEditGeometria->setEnabled(ui->radioButtonGeometria->isChecked());
    ui->pushButtonGeometria->setEnabled(ui->radioButtonGeometria->isChecked());
    ui->comboBoxPerfil->setEnabled(ui->radioButtonPerfil->isChecked());
    ui->comboBoxTamanno->setEnabled(ui->radioButtonPerfil->isChecked());
}

void DialogoEditorFormulasMedicion::RellenarListadoPerfiles()
{
    if (ComboVacio(ui->comboBoxPerfil))
    {
        modeloPerfiles = new QSqlQueryModel;
        modeloPerfiles->setQuery("SELECT distinct tipo FROM \"tAcero\" ORDER BY tipo");
        ui->comboBoxPerfil->setModel(modeloPerfiles);
        //RellenarTablasDiferentesPerfiles(0);
    }
}

void DialogoEditorFormulasMedicion::RellenarTablasDiferentesPerfiles(const QString& tipo)
{
    modeloTipoPerfiles = new QSqlQueryModel;
    QString calibre = ui->comboBoxTamanno->currentText();
    QString cadena = "SELECT tamanno FROM \"tAcero\" WHERE tipo = '" + tipo + "' ORDER BY masa";
    qDebug()<<cadena;
    modeloTipoPerfiles->setQuery(cadena);
    ui->comboBoxTamanno->setModel(modeloTipoPerfiles);
}

void DialogoEditorFormulasMedicion::SeleccionarPeso(const QString& tam)
{
    QSqlQuery consultapeso;    
    QString tipo = ui->comboBoxPerfil->currentText();

    QString consulta = "SELECT masa FROM \"tAcero\" WHERE tipo = '" + tipo + "' AND tamanno = '"+ tam + "' ORDER BY masa";
    consultapeso.exec(consulta);
    qDebug()<<consulta;
    QString peso;
    while (consultapeso.next())
    {
        peso = consultapeso.value(0).toString();
        ui->labelPesoNumero->setText(peso);
    }
    //borro el contenido de los campos anchura y altura puesto que el resultado estará en función del nº de unidades y la longitud
    ui->lineEditAnchura->setText("");
    ui->lineEditAltura->setText("");
    ui->lineEditExpresion->clear();
    ui->lineEditExpresion->setText("a*b*"+peso);
    Evaluar();
}

QString DialogoEditorFormulasMedicion::LeeFormula()
{
    qDebug()<<"ui->lineeditexpres "<<ui->lineEditExpresion->text();
    return ui->lineEditExpresion->text();
}

QString DialogoEditorFormulasMedicion::LeeUd()
{
    return ui->lineEditUds->text();
}

QString DialogoEditorFormulasMedicion::LeeLong()
{
    return ui->lineEditLongitud->text();
}

QString DialogoEditorFormulasMedicion::LeeAnc()
{
    return ui->lineEditAnchura->text();
}

QString DialogoEditorFormulasMedicion::LeeAlt()
{
    return ui->lineEditAltura->text();
}
