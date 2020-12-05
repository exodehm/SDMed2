#include "dialogoconexionbbdd.h"
#include "ui_dialogoconexionbbdd.h"
#include "dialogooperacionesbbdd.h"
#include <QDebug>
#include <QMessageBox>
#include <QSettings>
#include <QSqlError>
#include <QSqlQuery>
#include <QTimer>

DialogoConexionBBDD::DialogoConexionBBDD(QSqlDatabase* db, QWidget *parent) : QDialog(parent), ui(new Ui::DialogoConexionBBDD)
{
    ui->setupUi(this);    
    ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    ui->boton_ProbarConexion->setText(estadoConexion.leyendaEstado[NORMAL]);
    ui->boton_ProbarConexion->setStyleSheet(estadoConexion.colorEstado[NORMAL]);

    m_db = db;
    m_conectado = false;
    ReadSettings();
    QObject::connect(ui->boton_ProbarConexion,SIGNAL(clicked(bool)),this,SLOT(ProbarConexion()));
    QObject::connect(ui->boton_Operaciones_BBDD,SIGNAL(clicked(bool)),this,SLOT(OperacionesBBDD()));
    QObject::connect(ui->checkBox_GuardarNombre,SIGNAL(stateChanged(int)),this,SLOT(ActivarCheckConexionAutomatica(int)));
    QObject::connect(ui->checkBox_GuardarPassword,SIGNAL(stateChanged(int)),this,SLOT(ActivarCheckConexionAutomatica(int)));
    QObject::connect(ui->buttonBox->button(QDialogButtonBox::Ok),SIGNAL(clicked(bool)),this,SLOT(GuardarDatosConexion()));    
}

bool DialogoConexionBBDD::HayExension(QString bbdd)
{
    QString nombreextension, version;
    QString cadenaConsultaExtension = "SELECT * FROM pg_extension WHERE extname = '"+ bbdd + "';";
    QSqlQuery consultaExtension(cadenaConsultaExtension);
    while (consultaExtension.next())
    {
        nombreextension = consultaExtension.value(0).toString();
        version = consultaExtension.value(4).toString();
        qDebug()<<"extension" <<nombreextension;
        qDebug()<<"version "<<version;
    }
    //si no existe la extension
     if (consultaExtension.size()==-1)
     {
         return false;
     }
    return true;
}

bool DialogoConexionBBDD::HayConexion()
{
    return m_conectado;
}

void DialogoConexionBBDD::ReadSettings()
{
    QSettings settings;
    ui->lineEdit_NombreConexion->setText(settings.value("conexionBBDD/nombreconexion").toString());
    ui->lineEdit_Servidor->setText(settings.value("conexionBBDD/servidor").toString());
    //ui->lineEdit_BBDD->setText(settings.value("conexionBBDD/database").toString());
    ui->lineEdit_Puerto->setText(settings.value("conexionBBDD/puerto").toString());
    ui->lineEdit_NombreUsuario->setText(settings.value("conexionBBDD/usuario").toString());
    ui->lineEdit_PassWord->setText(settings.value("conexionBBDD/password").toString());
    ui->checkBox_GuardarNombre->setChecked(settings.value("conexionBBDD/guardarnombre").toBool());
    ui->checkBox_GuardarPassword->setChecked(settings.value("conexionBBDD/guardarclave").toBool());
}

DialogoConexionBBDD::~DialogoConexionBBDD()
{
    delete ui;
}

bool DialogoConexionBBDD::ProbarConexion()
{
    qDebug()<<"Probar conexion con ";
    qDebug()<<ui->lineEdit_NombreConexion->text()<<
              "-"<<ui->lineEdit_Puerto->text()<<
              "-"<<ui->lineEdit_BBDD->text()<<
              "-"<<ui->lineEdit_Servidor->text()<<
              "-"<<ui->lineEdit_NombreUsuario->text()<<
              "-"<<ui->lineEdit_PassWord ->text();
    *m_db= QSqlDatabase::addDatabase("QPSQL");
    m_db->setHostName(ui->lineEdit_Servidor->text());
    m_db->setPort(ui->lineEdit_Puerto->text().toInt());
    m_db->setDatabaseName(ui->lineEdit_BBDD->text());
    m_db->setUserName(ui->lineEdit_NombreUsuario->text());
    //m_db->setPassword(ui->lineEdit_PassWord->text());
    if (m_db->open())
    {
        if (HayExension())
        {
            ui->boton_ProbarConexion->setText(estadoConexion.leyendaEstado[CORRECTO]);
            ui->boton_ProbarConexion->setStyleSheet(estadoConexion.colorEstado[CORRECTO]);
            //solo si estan estos check activados se permite guardar y conectar automaticamente la proxima vez
            if (ui->checkBox_GuardarNombre->isChecked() && ui->checkBox_GuardarPassword->isChecked())
            {
                ui->checkBox_ConexionAutomatica->setEnabled(true);
            }
            ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(true);
            m_conectado = true;
            return true;
        }
        else
        {
            ui->boton_ProbarConexion->setText("No se encuentra la extesion");
            ui->boton_ProbarConexion->setStyleSheet(estadoConexion.colorEstado[ERROR]);
            ui->boton_ProbarConexion->setEnabled(false);
            QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setText(tr("No se encuentra la extension"));});
            QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setStyleSheet(estadoConexion.colorEstado[NORMAL]);});
            QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setText(estadoConexion.leyendaEstado[NORMAL]);});
            QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setEnabled(true);});
            m_conectado = false;
            return  false;
        }
    }
    ui->boton_ProbarConexion->setText(estadoConexion.leyendaEstado[ERROR]);
    ui->boton_ProbarConexion->setStyleSheet(estadoConexion.colorEstado[ERROR]);
    ui->boton_ProbarConexion->setEnabled(false);
    QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setStyleSheet(estadoConexion.colorEstado[NORMAL]);});
    QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setText(estadoConexion.leyendaEstado[NORMAL]);});
    QTimer::singleShot(1500, [&](){ui->boton_ProbarConexion->setEnabled(true);});

    QMessageBox::critical(nullptr, QObject::tr("Error de conexión"), m_db->lastError().text());
    ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    m_conectado = false;
    return false;
}

void DialogoConexionBBDD::GuardarDatosConexion()
{
    QSettings settings;
    settings.beginGroup("conexionBBDD");
    settings.setValue("conexion automatica", ui->checkBox_ConexionAutomatica->isChecked());
    settings.setValue("driverdb",m_db->driverName());
    settings.setValue("nombreconexion", ui->lineEdit_NombreConexion->text());
    settings.setValue("servidor", ui->lineEdit_Servidor->text());
    settings.setValue("puerto", ui->lineEdit_Puerto->text());
    //settings.setValue("database", ui->lineEdit_BBDD->text());
    settings.setValue("guardarnombre", ui->checkBox_GuardarNombre->isChecked());
    settings.setValue("guardarclave", ui->checkBox_GuardarPassword->isChecked());    
    if (ui->checkBox_GuardarNombre->isChecked())
    {
        settings.setValue("usuario", ui->lineEdit_NombreUsuario->text());
    }
    else
    {
        settings.setValue("usuario", QString());
    }
    if (ui->checkBox_GuardarPassword->isChecked())
    {
        settings.setValue("password", ui->lineEdit_PassWord->text());
    }
    else
    {
        settings.setValue("password", QString());
    }
    settings.endGroup();
}

void DialogoConexionBBDD::ActivarCheckConexionAutomatica(int estado)
{
    if (estado == Qt::Checked)
    {
        if (m_db->open() && ui->checkBox_GuardarNombre->isChecked() && ui->checkBox_GuardarPassword->isChecked())
        {
            ui->checkBox_ConexionAutomatica->setEnabled(true);
        }
    }
    else
    {
        ui->checkBox_ConexionAutomatica->setEnabled(false);
    }
}

void DialogoConexionBBDD::OperacionesBBDD()
{
    DialogoOperacionesBBDD* d =  new DialogoOperacionesBBDD(ui->lineEdit_Servidor->text(), ui->lineEdit_Puerto->text(), this);
    d->exec();
}
