#include "dialogoconexionbbdd.h"
#include "ui_dialogoconexionbbdd.h"
#include <QDebug>
#include <QMessageBox>
#include <QSettings>
#include <QSqlError>

DialogoConexionBBDD::DialogoConexionBBDD(QSqlDatabase* db, QWidget *parent) : QDialog(parent), ui(new Ui::DialogoConexionBBDD)
{
    ui->setupUi(this);
    ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    m_db = db;
    m_conectado = false;
    ui->lineEdit_Puerto->setText("5432");
    ui->lineEdit_Servidor->setText("localhost");
    ui->lineEdit_BBDD->setText("sdmed");
    ui->lineEdit_NombreUsuario->setText("postgres");
    QObject::connect(ui->boton_ProbarConexion,SIGNAL(clicked(bool)),this,SLOT(ProbarConexion()));
    QObject::connect(ui->checkBox_GuardarNombre,SIGNAL(stateChanged(int)),this,SLOT(ActivarCheckConexionAutomatica(int)));
    QObject::connect(ui->checkBox_GuardarPassword,SIGNAL(stateChanged(int)),this,SLOT(ActivarCheckConexionAutomatica(int)));
    QObject::connect(ui->buttonBox->button(QDialogButtonBox::Ok),SIGNAL(clicked(bool)),this,SLOT(GuardarDatosConexion()));
}

bool DialogoConexionBBDD::HayConexion()
{
    return m_conectado;
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
              "-"<<ui->lineEdit_NombreUsuario->text();
    *m_db= QSqlDatabase::addDatabase("QPSQL");
    m_db->setHostName(ui->lineEdit_Servidor->text());
    m_db->setPort(ui->lineEdit_Puerto->text().toInt());
    m_db->setDatabaseName(ui->lineEdit_BBDD->text());
    m_db->setUserName(ui->lineEdit_NombreUsuario->text());
    m_db->setPassword(ui->lineEdit_PassWord->text());
    if (m_db->open())
    {
        ui->boton_ProbarConexion->setText(ui->boton_ProbarConexion->text().append(tr(". Conectado con éxito!!")));
        //solo si estan estos check activados se permite guardar y conectar automaticamente la proxima vez
        if (ui->checkBox_GuardarNombre->isChecked() && ui->checkBox_GuardarPassword->isChecked())
        {
            ui->checkBox_ConexionAutomatica->setEnabled(true);
        }
        ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(true);
        m_conectado = true;
        return true;
    }
    QMessageBox::critical(0, QObject::tr("Error de conexión"), m_db->lastError().text());
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
    settings.setValue("database", ui->lineEdit_BBDD->text());
    settings.setValue("usuario", ui->lineEdit_NombreUsuario->text());
    settings.setValue("password", ui->lineEdit_PassWord->text());
    settings.endGroup();
}

void DialogoConexionBBDD::ActivarCheckConexionAutomatica(int estado)
{
    if (estado == Qt::Checked)
    {if (m_db->open() && ui->checkBox_GuardarNombre->isChecked() && ui->checkBox_GuardarPassword->isChecked())
        {
            ui->checkBox_ConexionAutomatica->setEnabled(true);
        }
    }
    else
    {
        ui->checkBox_ConexionAutomatica->setEnabled(false);
    }
}
