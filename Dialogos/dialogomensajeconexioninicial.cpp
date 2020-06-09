#include "dialogomensajeconexioninicial.h"
#include "ui_dialogomensajeconexioninicial.h"

#include <QProcess>
#include <QSqlDatabase>
#include <QSqlError>
#include <QDebug>


DialogoMensajeConexionInicial::DialogoMensajeConexionInicial(QSqlDatabase *db, QWidget* parent) :
    QDialog(parent),
    ui(new Ui::DialogoMensajeConexionInicial)
{
    ui->setupUi(this);
    m_db = db;
    ui->textoDatosConexion->setText(m_db->lastError().text());
    QObject::connect(ui->botonArrancarServidor,SIGNAL(clicked()),this, SLOT(ArrancarServidor()));
}

void DialogoMensajeConexionInicial::ArrancarServidor()
{
    qDebug()<<"Arrancar servidor";
    QProcess programa;
    QStringList environment = programa.systemEnvironment();
    QString commandToStart= "pg_ctl";
    QStringList argumentos;
    argumentos<<"-D"<<"c:/pgsql/data"<<"start";
    programa.start(commandToStart,argumentos);
    foreach (const QString& s, programa.arguments()) {
        qDebug()<<s;
    }
    bool started = programa.waitForStarted();
    if (!programa.waitForFinished(10000)) // 10 Second timeout
    {
        programa.kill();
        //qDebug()<<"problema "<<started;
    }
    int exitCode = programa.exitCode();
    qDebug()<<"exit status"<<exitCode;
    QString stdOutput = QString::fromLocal8Bit(programa.readAllStandardOutput());
    QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
    qDebug()<<"Salida: "<<stdOutput;
    qDebug()<<"Errores: "<<stdError;
    if (exitCode == 0)
    {
        ui->textoDatosConexion->setText(tr("<font color=green><b>%1</b></font>").arg("Servidor arrancado"));
    }
    else
    {
        ui->textoDatosConexion->setText(tr("<font color=red><b>%1</b></font>").arg("Problemas al arrancar el servidor"));
    }
}
