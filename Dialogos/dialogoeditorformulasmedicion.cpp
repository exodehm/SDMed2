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
    QObject::connect(ui->comboBoxPerfil,SIGNAL(currentIndexChanged(int)),this,SLOT(RellenarTablasDiferentesPerfiles(int)));
    QObject::connect(ui->comboBoxTamanno,SIGNAL(currentIndexChanged(int)),this,SLOT(SeleccionarPeso()));
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
    //qDebug()<<cadenaevaluar;
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
        modeloPerfiles->setQuery("SELECT nombre FROM tipoperfiles ORDER BY id");
        ui->comboBoxPerfil->setModel(modeloPerfiles);
        RellenarTablasDiferentesPerfiles(0);
    }
}

void DialogoEditorFormulasMedicion::RellenarTablasDiferentesPerfiles(int tabla)
{
    qDebug()<<"Tabla "<<tabla;
    modeloTipoPerfiles = new QSqlQueryModel;
    QString cadena;
    if (tabla == 0) //cero son los corrugados que van un poco aparte
    {        
        cadena = "SELECT diametro FROM \"tCorrugados\" ORDER BY diametro";
        qDebug()<<cadena;
        modeloTipoPerfiles->setQuery(cadena);
        ui->comboBoxTamanno->setModel(modeloTipoPerfiles);        
    }
    else
    {
        modeloTipoPerfiles->setQuery("SELECT nombre FROM perfiles WHERE id_tipoperfil = '"+QString::number(tabla)+"' ORDER BY peso");
        ui->comboBoxTamanno->setModel(modeloTipoPerfiles);
    }
}

void DialogoEditorFormulasMedicion::SeleccionarPeso()
{
    QSqlQuery consultapeso;
    float peso;
    QString calibre = ui->comboBoxTamanno->currentText();
    QString consulta;
    int tabla = ui->comboBoxPerfil->currentIndex();
    if (tabla == 0) //cero son los corrugados que van un poco aparte
    {
        consulta = ("SELECT peso FROM \"tCorrugados\" WHERE diametro ='"+calibre+ "'");
    }
    else if (tabla>0 && tabla<7)//IPE,IPN,HEB,HEA,HEM,UPN
    {
        consulta = ("SELECT peso FROM perfiles WHERE nombre ='"+calibre+ "' AND id_tipoperfil ='"+QString::number(tabla)+"'");
    }
    consultapeso.exec(consulta);
    qDebug()<<consulta;
    while (consultapeso.next())
    {
        peso = consultapeso.value(0).toFloat();
        ui->labelContenidoPesoKgm->setText(QString::number(peso));
    }
    //borro el contenido de los campos anchura y altura puesto que el resultado estará en función del nº de unidades y la longitud
    ui->lineEditAnchura->setText("");
    ui->lineEditAltura->setText("");
    ui->lineEditExpresion->clear();
    ui->lineEditExpresion->setText("a*b*"+QString::number(peso));
    Evaluar();
}

QString DialogoEditorFormulasMedicion::LeeFormula()
{
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
