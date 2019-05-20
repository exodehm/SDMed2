#include "dialogoeditorformulasmedicion.h"
#include "ui_dialogoeditorformulasmedicion.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlQueryModel>
#include <QDebug>

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
    QObject::connect(ui->radioButtonPerfil,SIGNAL(clicked(bool)),this,SLOT(RellenarListadoPerfiles()));
    QObject::connect(ui->comboBoxPerfil,SIGNAL(currentIndexChanged(int)),this,SLOT(RellenarTablasDiferentesPerfiles(int)));
    QObject::connect(ui->comboBoxTamanno,SIGNAL(currentIndexChanged(int)),this,SLOT(SeleccionarPeso()));
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
    float ud,longitud,total,peso;
    ud = ui->lineEditUds->text().toFloat();
    longitud = ui->lineEditLongitud->text().toFloat();
    QString calibre = ui->comboBoxTamanno->currentText();
    QString consulta;
    int tabla = ui->comboBoxPerfil->currentIndex();
    if (tabla == 0) //cero son los corrugados que van un poco aparte
    {
        consulta = ("SELECT peso FROM \"tCorrugados\" WHERE diametro ='"+calibre+ "'");
    }
    else
    {
        consulta = ("SELECT peso FROM perfiles WHERE nombre ='"+calibre+ "'");
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
    ui->plainTextEditExpresion->clear();
    ui->plainTextEditExpresion->insertPlainText("a*b*"+QString::number(peso));
    total = ud*longitud*peso;
    ui->lineEditResultado->setText(QString::number(total));
}

QString DialogoEditorFormulasMedicion::LeeFormula()
{
    return ui->plainTextEditExpresion->document()->toPlainText();
}

