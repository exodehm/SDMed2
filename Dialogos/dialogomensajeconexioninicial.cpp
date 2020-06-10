#include "dialogomensajeconexioninicial.h"
#include "ui_dialogomensajeconexioninicial.h"

#include "./Dialogos/dialogosudo.h"

#include <QProcess>
#include <QSqlDatabase>
#include <QSqlError>
#include <QDirIterator>
#include <QSettings>
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
    //miro a ver si tengo la ruta de datos guardada
    QString directorioDatos;
    QSettings settings;
    directorioDatos = settings.value("rutas/ruta datos postgresql").toString();
    if (directorioDatos.isEmpty())//si no existe, lo busco y lo almaceno en los settings
    {
        QDirIterator it("/", QDirIterator::Subdirectories);
        while (it.hasNext())
        {
            directorioDatos = it.next();
            if (directorioDatos.contains("/data/PG_VERSION"))
            {
                qDebug()<<"Diretorio datos en: "<<directorioDatos;
                directorioDatos = directorioDatos.left(directorioDatos.lastIndexOf("/")+1);
                settings.beginGroup("rutas");
                settings.setValue("ruta datos postgresql", directorioDatos);
                break;
            }
        }
    }
    QProcess programa;
    QStringList environment = programa.systemEnvironment();
    QString commandToStart= "pg_ctl";
    QStringList argumentos;
    argumentos<<"-D"<<directorioDatos<<"start";
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
