#include "dialogomensajeconexioninicial.h"
#include "ui_dialogomensajeconexioninicial.h"

#include "./Dialogos/dialogosudo.h"

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
    ui->botonArrancarServidor->setEnabled(EsConexionLocal());
    QObject::connect(ui->botonArrancarServidor,SIGNAL(clicked()),this, SLOT(ArrancarServidor()));
}

void DialogoMensajeConexionInicial::ArrancarServidor()
{
    int exitCode = 1;
#if defined(Q_OS_WIN)//<---Windows
    exitCode = ArrancarServidorWin();
#else//<--Linux falta mac?
    exitCode = ArrancarServidorLinux();
#endif
    if (exitCode == 0)
    {
        ui->textoDatosConexion->setText(tr("<font color=green><b>%1</b></font>").arg("Servidor arrancado"));
    }
    else
    {
        ui->textoDatosConexion->setText(tr("<font color=red><b>%1</b></font>").arg("Problemas al arrancar el servidor"));
    }
}

int DialogoMensajeConexionInicial::ArrancarServidorWin()
{
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
    return exitCode;
}

int DialogoMensajeConexionInicial::ArrancarServidorLinux()
{
    DialogoSudo* d = new DialogoSudo(this);
    if (d->exec())
    {
        QString passw = d->PassWSudo();
        QProcess process1;
        QProcess process2;
        process1.setStandardOutputProcess(&process2);
        QString s_process1 = "echo " + passw;
        qDebug()<<s_process1;
        QString s_process2 = "sudo -S service postgresql start";
        qDebug()<<s_process2;
        process1.start(s_process1);
        process2.start(s_process2);
        process2.setProcessChannelMode(QProcess::ForwardedChannels);
        bool retval = false;
        QByteArray buffer;
        while ((retval = process2.waitForFinished()))
        {
            buffer.append(process2.readAll());
        }
        if (!retval)
        {
            qDebug() << "Process 2 error:" << process2.errorString();
        }
        qDebug()<<"retval "<<retval;
        return process2.exitCode();
    }
    return -1;
}

bool DialogoMensajeConexionInicial::EsConexionLocal()
{
    return m_db->hostName()=="localhost" || m_db->hostName()=="127.0.0.1";
}
