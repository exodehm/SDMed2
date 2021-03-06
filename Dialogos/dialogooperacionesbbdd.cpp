#include "../Dialogos/dialogooperacionesbbdd.h"
#include "ui_dialogooperacionesbbdd.h"
#include "../Dialogos/dialogocontrasenna.h"
#include <QDebug>
#include <QSqlQuery>

DialogoOperacionesBBDD::DialogoOperacionesBBDD(QString servidor, QString puerto, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoOperacionesBBDD)
{
    m_hayRole = false;
    ui->setupUi(this);
    ui->lineEditPuerto->setText(puerto);
    ui->lineEditServidor->setText(servidor);
    ui->lineEditSuperUser->setText("");
    db = QSqlDatabase::addDatabase("QPSQL");
    QObject::connect(ui->botonComprobar,SIGNAL(clicked(bool)),this,SLOT(Conectar()));
    QObject::connect(ui->botonRole,SIGNAL(clicked(bool)),this,SLOT(CrearRoleContrasenna()));
    QObject::connect(ui->botonBBDD,SIGNAL(clicked(bool)),this,SLOT(CrearBaseDatosSdmed()));
    QObject::connect(ui->botonExtension,SIGNAL(clicked(bool)),this,SLOT(CrearExtension()));
}

DialogoOperacionesBBDD::~DialogoOperacionesBBDD()
{
    delete ui;
}

void DialogoOperacionesBBDD::Comprobaciones()
{
    //compropbar si existe el role sdmed
    QString cadenaComprobarRole = "SELECT true FROM pg_roles WHERE rolname='sdmed'";
    qDebug()<<cadenaComprobarRole;
    QSqlQuery consulta(cadenaComprobarRole,db);
    while (consulta.next())
    {
        m_hayRole = consulta.value(0).toBool();
        qDebug()<<"Consulta hay role= "<<m_hayRole;
    }
    if (!m_hayRole)
    {
        ui->labelRole->setText(tr("No existe el role \"sdmed\""));
        ui->botonRole->setText("Crear role");
        ui->labelRole->setEnabled(true);
        ui->botonRole->setEnabled(true);        
    }
    else
    {
        ui->labelRole->setText(tr("Existe el role \"sdmed\""));
        //ui->labelRole->setText(tr("Cambiar contraseña"));
        //ui->botonRole->setText("...");
        ui->botonRole->setText("Cambiar contraseña");
        ui->labelRole->setEnabled(true);
        ui->botonRole->setEnabled(true);
    }
    //compropbar si existe la base de datos
    QString cadenaComprobarBBDD = "SELECT 1 FROM pg_database WHERE datname='sdmed'";
    qDebug()<<cadenaComprobarBBDD;
    consulta.exec(cadenaComprobarBBDD);
    bool hayBBDDSdmed = false;
    while (consulta.next())
    {
        hayBBDDSdmed = consulta.value(0).toBool();
    }
    if (!hayBBDDSdmed)
    {
        ui->labelBBDD->setText(tr("No existe la base de datos \"sdmed\""));
        ui->botonBBDD->setText("Crear BBDD");
        ui->labelBBDD->setEnabled(true);
        ui->botonBBDD->setEnabled(true);
    }
    else
    {
        ui->labelBBDD->setText(tr("Existe la base de datos \"sdmed\""));
        ui->botonBBDD->setText("...");
        ui->labelBBDD->setEnabled(true);
        ui->botonBBDD->setEnabled(false);
    }
    if (hayBBDDSdmed)
    {
        db.close();
        db.setDatabaseName("sdmed");
        db.open();
        //compropbar si existe la extension
        QString cadenaComprobarExtension = "SELECT 1 FROM pg_extension WHERE extname ='sdmed'";
        qDebug()<<cadenaComprobarExtension;
        consulta.exec(cadenaComprobarExtension);
        bool hayExtensionSdmed = false;
        while (consulta.next())
        {
            hayExtensionSdmed = consulta.value(0).toBool();
        }
        if (!hayExtensionSdmed)
        {
            ui->labelExtension->setText(tr("No existe la extensión \"sdmed\""));
            ui->botonExtension->setText("Crear extensión");
            ui->labelExtension->setEnabled(true);
            ui->botonExtension->setEnabled(true);
        }
        else
        {
            ui->labelExtension->setText(tr("Existe la extensión \"sdmed\""));
            ui->botonExtension->setText("...");
            ui->labelExtension->setEnabled(true);
            ui->botonExtension->setEnabled(false);
        }
    }
}

bool DialogoOperacionesBBDD::Conectar()
{
    db.setHostName(ui->lineEditServidor->text());qDebug()<<ui->lineEditServidor->text();
    db.setPort(ui->lineEditPuerto->text().toInt());qDebug()<<ui->lineEditPuerto->text();
    db.setDatabaseName("postgres");
    db.setUserName(ui->lineEditSuperUser->text());qDebug()<<ui->lineEditSuperUser->text();
    db.setPassword(ui->lineEditPassword->text());qDebug()<<ui->lineEditPassword->text();
    if (db.open())
    {
        Comprobaciones();
        return true;
    }
    return false;
}

bool DialogoOperacionesBBDD::CrearRoleContrasenna()
{
    //esta funcion servira para crear el role si no existe y asignar una contrasenna, o solo
    //crear la contrasenna si ya existe el role
    QSqlQuery consulta(db);
    QString cadenaRole;
    DialogoContrasenna* d = new DialogoContrasenna(this);
    if (d->exec())
    {
        if (m_hayRole)
        {
            cadenaRole = "ALTER ROLE sdmed WITH PASSWORD '" + d->LeePassword() + "'";

        }
        else
        {
            cadenaRole = "CREATE ROLE sdmed WITH LOGIN WITH PASSWORD '" + d->LeePassword() + "'";
        }
        consulta.exec(cadenaRole);
        Comprobaciones();
    }
    return  consulta.isValid();
}

bool DialogoOperacionesBBDD::CrearBaseDatosSdmed()
{
    qDebug()<<"Crear base de datos sdmed";
    QString cadenaCrearBBDD = "CREATE DATABASE sdmed WITH TEMPLATE = template0 ENCODING 'UTF8'";
    qDebug()<<cadenaCrearBBDD;
    QSqlQuery consulta(cadenaCrearBBDD,db);
    qDebug()<<"consulta sice "<<consulta.size();
    cadenaCrearBBDD = "SELECT 1 FROM pg_database WHERE datname='sdmed'";
    consulta.exec(cadenaCrearBBDD);
    bool hayBBDD=false;
    while (consulta.next())
    {
        hayBBDD = consulta.value(0).toBool();
    }
    if (hayBBDD)
    {
        ui->labelExtension->setText(tr("No existe la extensión \"sdmed\""));
        ui->botonExtension->setText("Crear extensión");
        ui->labelExtension->setEnabled(true);
        ui->botonExtension->setEnabled(true);
    }
    Comprobaciones();
    return consulta.isValid();
}

bool DialogoOperacionesBBDD::CrearExtension()
{
    db.close();
    db.setDatabaseName("sdmed");
    db.open();
    qDebug()<<"Crear extension sdmed";
    QString cadenaCrearExtension = "\\c sdmed";
    QSqlQuery consulta(cadenaCrearExtension,db);
    cadenaCrearExtension = "CREATE EXTENSION sdmed";
    qDebug()<<cadenaCrearExtension;
    consulta.exec(cadenaCrearExtension);
    cadenaCrearExtension = "SELECT 1 FROM pg_extension WHERE extname ='sdmed'";
    consulta.exec(cadenaCrearExtension);
    /*bool hayExtension=false;
    while (consulta.next())
    {
        hayExtension = consulta.value(0).toBool();
    }
    if (hayExtension)
    {
        ui->labelExtension->setText(tr("No existe la extensión \"sdmed\""));
        ui->botonExtension->setText("Crear extensión");
        ui->labelExtension->setEnabled(true);
        ui->botonExtension->setEnabled(true);
    }*/
    Comprobaciones();
    return consulta.isValid();
}
