#include "dialogocertificaciones.h"
#include "ui_dialogocertificaciones.h"
#include <QDate>
#include <QDebug>
#include <QMessageBox>
#include <QStandardItemModel>
#include <QCheckBox>
#include <QPushButton>

DialogoCertificaciones::DialogoCertificaciones(QString tabla, QWidget *parent) :tabla(tabla),QDialog(parent),ui(new Ui::DialogoCertificaciones)
{
    ui->setupUi(this);
    QDate date = ui->calendarWidget->selectedDate();
    dia=date.day();
    mes=date.month();
    anno=date.year();
    ui->comboDia->setCurrentIndex(dia-1);
    ui->comboMes->setCurrentIndex(mes-1);
    ui->comboAnno->setCurrentIndex(anno-2010);        
    cabeceratabla<<"Nº Certificación"<<"Fecha certificación"<<"Borrar";
    actualizarTabla();
    ui->tablaCertificaciones->setHorizontalHeaderLabels(cabeceratabla);
    ui->tablaCertificaciones->horizontalHeader()->setStretchLastSection(true);
    QObject::connect(ui->comboDia,SIGNAL(currentIndexChanged(int)),this,SLOT(cambiaDia(int)));
    QObject::connect(ui->comboMes,SIGNAL(currentIndexChanged(int)),this,SLOT(cambiaMes(int)));
    QObject::connect(ui->comboAnno,SIGNAL(currentIndexChanged(int)),this,SLOT(cambiaAnno(int)));
    QObject::connect(ui->calendarWidget,SIGNAL(clicked(QDate)),this,SLOT(actualizarCombos(QDate)));
    QObject::connect(ui->botonInsertarCertificacion,SIGNAL(clicked()),this,SLOT(insertarNuevaCertificacion()));
    QObject::connect(ui->botonBorrarCertificacion,SIGNAL(clicked(bool)),this,SLOT(borrarCertificacion()));
}

DialogoCertificaciones::~DialogoCertificaciones()
{
    delete ui;
}

QString DialogoCertificaciones::LeeFecha()
{
    return ui->calendarWidget->selectedDate().toString("ddMMyyyy");
}

void DialogoCertificaciones::cambiaDia(int d)
{
    int m = ui->calendarWidget->selectedDate().month();
    int y = ui->calendarWidget->selectedDate().year();
    QDate date(y,m,d+1);
    ui->calendarWidget->setSelectedDate(date);
}

void DialogoCertificaciones::cambiaMes(int m)
{
    int d = ui->calendarWidget->selectedDate().day();
    int y = ui->calendarWidget->selectedDate().year();
    QDate date(y,m+1,d);
    ui->calendarWidget->setSelectedDate(date);
}

void DialogoCertificaciones::cambiaAnno(int a)
{
    int d = ui->calendarWidget->selectedDate().day();
    int m = ui->calendarWidget->selectedDate().month();
    QDate date(a+2010,m,d);
    ui->calendarWidget->setSelectedDate(date);
}

void DialogoCertificaciones::actualizarCombos(QDate date)
{
    QString cadena = date.toString("ddMMyyyy");

    int d = cadena.left(2).toInt();
    ui->comboDia->setCurrentIndex(d-1);
    cadena.remove(0,2);
    int m = cadena.left(2).toInt();
    ui->comboMes->setCurrentIndex(m-1);
    cadena.remove(0,2);
    ui->comboAnno->setCurrentIndex(cadena.toInt()-2010);
}

void DialogoCertificaciones::insertarNuevaCertificacion()
{
    QString cadenanuevacertificacion = "SELECT anadir_certificacion('"+ tabla + "','" + LeeFecha() + "')";
    qDebug()<<cadenanuevacertificacion;
    consulta.exec(cadenanuevacertificacion);
    bool resultado = false;
    while (consulta.next())
    {
        resultado = consulta.value(0).toBool();
    }
    if (resultado == false)
    {
        QMessageBox::warning(this, tr("Aviso"),
                                       tr("La fecha ha de ser posterior a la de la última certificación"),
                             QMessageBox::Ok);
    }
    else
    {
        actualizarTabla();
    }
}


void DialogoCertificaciones::borrarCertificacion()
{
    qDebug()<<"Borrarr";
    for (int i=0;i<ui->tablaCertificaciones->rowCount();i++)
    {
        QCheckBox* c =  static_cast<QCheckBox*>(ui->tablaCertificaciones->cellWidget(i,2));
        if (c)
        {
            if (c->isChecked())
            {
                QString fecha = ui->tablaCertificaciones->item(i,1)->text();
                QString cadenaborrarcertificacion = "DELETE FROM \"" + tabla + "_Certificaciones" + "\" WHERE fecha = '"+fecha+"'";
                qDebug()<<cadenaborrarcertificacion;
                consulta.exec(cadenaborrarcertificacion);
            }
        }
    }
    actualizarTabla();
}

void DialogoCertificaciones::actualizarTabla()
{
    QString cadenaconsultacertificaciones = "SELECT fecha FROM \"" + tabla + "_Certificaciones" + "\" ORDER BY num_certificacion";
    qDebug()<<cadenaconsultacertificaciones;
    consulta.exec(cadenaconsultacertificaciones);
    int filas = consulta.size();
    int columnas = cabeceratabla.size();
    ui->tablaCertificaciones->setRowCount(filas);
    ui->tablaCertificaciones->setColumnCount(columnas);
    int i=0,j=0;
    while (consulta.next())
    {
        QTableWidgetItem* itemnum = new QTableWidgetItem(QString::number(i+1));
        ui->tablaCertificaciones->setItem(i,j,itemnum);
        j++;
        QTableWidgetItem* item = new QTableWidgetItem(consulta.value(0).toString());
        item->setFlags(Qt::ItemIsSelectable|Qt::ItemIsEnabled);
        ui->tablaCertificaciones->setItem(i,j,item);
        j++;
        QCheckBox* itemcheck = new QCheckBox;
        ui->tablaCertificaciones->setCellWidget(i,j,itemcheck);
        j=0;
        i++;
    }
}
