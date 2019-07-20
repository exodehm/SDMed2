#include "dialogoconexionbbdd.h"
#include "ui_dialogoconexionbbdd.h"
#include <QDebug>
#include <QMessageBox>
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
    qDebug()<<ui->lineEdi_NombreConexion->text()<<
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
        ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(true);
        m_conectado = true;
        return true;
    }
    QMessageBox::critical(0, QObject::tr("Error de conexión"), m_db->lastError().text());
    ui->buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    m_conectado = false;
    return false;
}
