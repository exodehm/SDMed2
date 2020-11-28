#include "dialogoconfiguracion.h"
#include "ui_dialogoconfiguracion.h"
#include "./Dialogos/dialogosudo.h"
#include "./Dialogos/dialogocredencialesconexionadmin.h"

#include <QFileDialog>
#include <QSettings>
#include <QDirIterator>
#include <QTemporaryDir>
#include <QProcess>
#include <QMessageBox>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QTextEdit>
#include <QDebug>

#include "pyrun.h"

DialogoConfiguracion::DialogoConfiguracion(QWidget *parent) : QDialog(parent), ui(new Ui::DialogoConfiguracion)
{
    ui->setupUi(this);
    ReadSettings();    
    ComprobacionesPostgres();
    ComprobacionesPython();
    QObject::connect(ui->boton_ruta_python,SIGNAL(clicked(bool)),this,SLOT(DefinirRutaScripts()));
    QObject::connect(ui->botonDatosAdmin,SIGNAL(clicked(bool)),this,SLOT(DatosAdmin()));
    QObject::connect(ui->boton_salir,SIGNAL(clicked(bool)),this,SLOT(Salir()));
    QObject::connect(ui->boton_instalar_extension,SIGNAL(clicked(bool)),this,SLOT(InstalarExtension()));
    QObject::connect(ui->boton_instalar_python,SIGNAL(clicked(bool)),this,SLOT(InstalarScriptsPython()));
}

DialogoConfiguracion::~DialogoConfiguracion()
{
    delete ui;
}

void DialogoConfiguracion::ReadSettings()
{
    QSettings settings;
    ui->lineEdit_ruta_python->setText(settings.value("rutas/ruta_python").toString());    
    m_rutaPython = settings.value("rutas/ruta_python").toString();    
}

void DialogoConfiguracion::DefinirRutaScripts()
{
    QFileDialog fd(this,"Elige directorio scripts python",m_rutaPython);
    fd.setFilter(QDir::Dirs|QDir::AllDirs|QDir::Hidden|QDir::NoDotAndDotDot);
    fd.setFileMode(QFileDialog::DirectoryOnly);
    if (fd.exec())
    {
        qDebug()<<fd.selectedFiles();
        if (!fd.selectedFiles().isEmpty())
        {
            ui->lineEdit_ruta_python->setText(fd.selectedFiles().at(0));
            m_rutaPython = fd.selectedFiles().at(0);
        }
    }
}

void DialogoConfiguracion::ActivarBotonInstalarExtension()
{
    //ui->boton_ruta_extension->setEnabled(!ui->lineEdit_ruta_extension->text().isEmpty());
}

void DialogoConfiguracion::InstalarExtension()
{    
    //primer paso, copiar los archivos al directorio extension
    //para ello creo un directorio temporal para copiar loa archivos del resource al disco duro y luego poder copiarlos
    //al directorio extension (solo necesario para linux/mac pero hago el mismo procedimiento para windows para no aumentar codigo
    QTemporaryDir tempdir;
    if (tempdir.isValid())
    {
        QString sResourceFiles = ":/postgres-extension";
        QTextEdit htmlText(ui->label_ruta_directorio_extension->text());
        QString ruta_extension = htmlText.toPlainText() + "/";
        QDirIterator it(sResourceFiles);//, QDirIterator::Subdirectories);
        QStringList listaArchivosCopiar;
        while (it.hasNext())
        {
            it.next();
            listaArchivosCopiar<<it.fileName();
        }
        //crear el dialogo de confirmacion
        QString aviso = "Se copiarán <b>";
        int i = 0;
        while (i<listaArchivosCopiar.size())
        {
            aviso.append(listaArchivosCopiar.at(i)).append(" ");
            i++;

        }
        aviso.append("</b>en:<br> ");
        aviso.append("<b>" + ruta_extension + "</b>");
        //fin crear el dialogo de confirmacion
        int ret = QMessageBox::information(this, tr("Aviso"),aviso,QMessageBox::Ok|QMessageBox::Cancel, QMessageBox::Cancel);
        if (ret == QMessageBox::Ok)
        {
            QFile file_extension(QStringLiteral(":/postgres-extension/sdmed--0.1.sql"));
#if defined(Q_OS_WIN)//<---Windows
            QFile file_extension_destino(ficheroExtensionDestino);
            if (file_extension_destino.exists())
            {
                file_extension_destino.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);
                file_extension_destino.remove();
            }
            QFile file_control_destino(ficheroExtensionControlDestino);
            if (file_control_destino.exists())
            {
                file_control_destino.setPermissions(QFileDevice::WriteUser | QFileDevice::ReadUser | QFileDevice::ExeUser);
                file_control_destino.remove();
            }
            file_extension.copy(ficheroExtensionDestino);
            file_control.copy(ficheroExtensionControlDestino);
            //file_makefile.copy(ficheroExtensionMakefile);
#else//<--Linux ....y mac?
            DialogoSudo* d = new DialogoSudo(this);
            if (d->exec())
            {
                QString passw = d->PassWSudo();
                for (int i=0;i<listaArchivosCopiar.size();i++)
                {
                    QFile f(sResourceFiles + QDir::separator() + listaArchivosCopiar.at(i));
                    const QString fichero_origen = tempdir.path() + QDir::separator() + listaArchivosCopiar.at(i);
                    f.copy(fichero_origen);
                    QString fichero_destino = ruta_extension + listaArchivosCopiar.at(i);
                    CopiarConPermisos(fichero_origen,fichero_destino,passw);
                }
            }
#endif
        }
    }
}

void DialogoConfiguracion::InstalarScriptsPython()
{
    qDebug()<<"Instalar Scripts Python en "<<m_rutaPython;
    QString ruta = "/home/david/programacion/python/instalador/";
    QString m_pModulo = "instalar_scripts";
    QString m_pFuncion = "Instalar";
    QStringList pArgumentos;
    pArgumentos<<m_rutaPython;

    QPair <int,QVariant>res = ::PyRun::loadModule(ruta, m_pModulo, m_pFuncion, pArgumentos);
    qDebug()<<res.first;
}

void DialogoConfiguracion::DatosAdmin()
{
    DialogoCredencialesConexionAdmin* d = new DialogoCredencialesConexionAdmin(this);
    QObject::connect(d,SIGNAL(accepted()),this,SLOT(ComprobacionesPostgres()));
    d->exec();
}

void DialogoConfiguracion::CopiarConPermisos(const QString &fichero_origen, const QString &fichero_destino, QString passw)
{
    QProcess process1;
    QProcess process2;
    process1.setStandardOutputProcess(&process2);
    QString s_process1 = "echo " + passw;
    qDebug()<<s_process1;
    QString s_process2 = "sudo -S cp " + fichero_origen + " " + fichero_destino;
    qDebug()<<s_process2;
    process1.start(s_process1);
    process2.start(s_process2);
    process2.setProcessChannelMode(QProcess::ForwardedChannels);
    bool retval = false;
    QByteArray buffer;
    process1.waitForFinished(5000);
    while ((retval = process2.waitForFinished()))
    {
        buffer.append(process2.readAll());
    }
    if (!retval)
    {
        qDebug() << "Process 1 error:" << process1.errorString();
        qDebug() << "Process 2 error:" << process2.errorString();
    }
}

void DialogoConfiguracion::Salir()
{
    WriteSettings();
    int result = 0;
    this->done(result);
}

void DialogoConfiguracion::WriteSettings()
{
    QSettings settings;
    settings.beginGroup("rutas");
    settings.setValue("ruta_python", m_rutaPython);
    settings.endGroup();
}

bool DialogoConfiguracion::HayPython()
{
    QProcess programa;
    QStringList environment = programa.systemEnvironment();
    QString commandToStart= "python3";
    QStringList argumentos;
    argumentos<<"-V";
    programa.start(commandToStart,argumentos);
    bool started = programa.waitForStarted();
    qDebug()<<"bool "<<started;
    if (!programa.waitForFinished(10000)) // 10 Second timeout
    {
        programa.kill();
    }
    int exitCode = programa.exitCode();
    qDebug()<<"exit status"<<exitCode;
    m_versionPython = QString::fromLocal8Bit(programa.readAllStandardOutput());
    QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
    //qDebug()<<"Salida: "<<stdOutput;
    //qDebug()<<"Errores: "<<stdError;
    if (exitCode == 0)
    {
        return true;
    }
    return false;
}

bool DialogoConfiguracion::IsPostgresRunning()
{
    #if defined(Q_OS_LINUX)
        QProcess programa;
        QStringList environment = programa.systemEnvironment();
        QString commandToStart= "pgrep";
        QStringList argumentos;
        argumentos<<"-u"<<"postgres"<<"-fa"<<"--"<<"-D";
        programa.start(commandToStart,argumentos);
        bool started = programa.waitForStarted();
        qDebug()<<"bool "<<started;
        if (!programa.waitForFinished(10000)) // 10 Second timeout
        {
            programa.kill();
        }
        int exitCode = programa.exitCode();
        qDebug()<<"exit status"<<exitCode;
        m_postgres = QString::fromLocal8Bit(programa.readAllStandardOutput());
        QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
        //qDebug()<<"Salida: "<<stdOutput;
        //qDebug()<<"Errores: "<<stdError;
        if (exitCode == 0)
        {
            return true;
        }
        return false;
    #endif
}

void DialogoConfiguracion::ComprobacionesPostgres()
{
    bool HayPostgres = IsPostgresRunning();
    if (HayPostgres)
    {
        QSqlDatabase db;
        db= QSqlDatabase::addDatabase("QPSQL");
        QSettings settings;
        db.setHostName(settings.value("adminrole/servidor").toString());
        db.setPort(settings.value("adminrole/puerto").toInt());
        db.setUserName(settings.value("adminrole/usuario").toString());
        db.setPassword(settings.value("adminrole/password").toString());
        bool esAdmin = false;
        if (db.open())
        {
            QSqlQuery consulta(db);
            QString cadenacomprobacionrolsuper = "SELECT rolsuper FROM pg_authid WHERE rolname = '" + settings.value("adminrole/usuario").toString() + "'";
            consulta.exec(cadenacomprobacionrolsuper);
            while (consulta.next())
            {
                esAdmin = consulta.value(0).toBool();
                qDebug()<<"esAdmin: "<<esAdmin;
            }
            if (!esAdmin)
            {
                ui->label_advertencia_noadmin->setText(tr("Algunas operaciones requieren privilegios de administrador. Ingresar los datos"));
            }
            else
            {
                //directorio extension
                QString consultaSharedir = "SELECT setting from pg_config WHERE name = \'SHAREDIR\'";
                consulta.exec(consultaSharedir);
                while (consulta.next())
                {
                    qDebug()<<consulta.value(0).toString();
                    ui->label_ruta_directorio_extension->setText(tr("<font color=green><b>%1</b></font>").arg(consulta.value(0).toString()+"/extension"));
                }
                //extensiones instaladas
                ComprobarRoleSdmed(consulta);
                ComprobarExistenciaBBDDSdmed(consulta);
            }
            ComprobarExtensionInstalada(consulta);
        }
        else

        {
            ui->label_advertencia_noadmin->setText(tr("No hay datos de conexión o éstos son erróneos."));
        }
        ui->label_existe_role_sdmed->setEnabled(esAdmin);
        ui->label_existe_bbdd_sdmed->setEnabled(esAdmin);
        ui->boton_crear_role_sdmed->setEnabled(esAdmin);
        ui->boton_crear_bbdd_sdmed->setEnabled(esAdmin);
    }
    //directorio datos
    QString smain = m_postgres.left(m_postgres.lastIndexOf("-c")-1);
    smain = smain.mid(m_postgres.lastIndexOf("-D")+3);
    ui->combobox_rutas_datos->addItem(smain);
    ComprobarExtensionSuministrada();
}


void DialogoConfiguracion::ComprobacionesPython()
{
    bool hayPython = HayPython();
    if (hayPython)
    {
        ui->labelVersionPython->setText(tr("<font color=green><b>%1</b></font>").arg(m_versionPython));
    }
    else
    {
        ui->labelLetreroVersionPython->setToolTip(tr("<p>Los scripts de python necesitan que python3 esté instalado en el equipo</p>"
                                                     "Puedes descargarlo e instalarlo desde su web oficial <b>https://www.python.org</b>"));
        ui->labelVersionPython->setText(tr("<font color=red><b>%1</b></font>").arg("No se ha detectado python3 en el equipo"));
    }
    ui->boton_instalar_python->setEnabled(hayPython);
}

void DialogoConfiguracion::ComprobarDatosAdminRole()
{
    QSettings settings;
    QString servidor = settings.value("adminrole/servidor").toString();
    QString puerto = settings.value("adminrole/puerto").toString();
    QString admin = settings.value("adminrole/usuario").toString();
    QString password = settings.value("adminrole/password").toString();

}

void DialogoConfiguracion::ComprobarExtensionInstalada(QSqlQuery consulta)
{
    ui->label_version_instalada->setText("...");
    QString consultaExtensionesSdmedInstaladas = "SELECT * FROM pg_available_extensions where name like \'%sdmed%\'";
    consulta.exec(consultaExtensionesSdmedInstaladas);
    if (consulta.isValid() && consulta.size()>0)
    {
        qDebug()<<"AEUI ESTOY!!!";
        while (consulta.next())
        {
            ui->label_nombre_extension->setText(consulta.value(0).toString());
            ui->label_version_defecto->setText(consulta.value(1).toString());
            if (consulta.value(2).toString().isEmpty())
            {
                ui->label_version_instalada->setText(tr("<font color=red><b>%1</b></font>").arg("Ninguna"));
            }
            else
            {
                ui->label_version_instalada->setText(consulta.value(2).toString());
            }
            ui->label_descripcion->setText(consulta.value(3).toString());
        }
    }
    else
    {
        //ui->label_nombre_extension->setEnabled(consulta.isValid());
        ui->label_nombre_extension->setText(tr("<font color=red><b>%1</b></font>").arg("No hay extension instalada"));
    }
}

void DialogoConfiguracion::ComprobarRoleSdmed(QSqlQuery consulta)
{
    QString cadenaComprobarRole = "SELECT true FROM pg_roles WHERE rolname='sdmed'";
    qDebug()<<cadenaComprobarRole;
    consulta.exec(cadenaComprobarRole);
    bool hayRoleSdmed = false;    
    while (consulta.next())
    {
        hayRoleSdmed = consulta.value(0).toBool();
        qDebug()<<"Consulta hay role= "<<hayRoleSdmed;
    }
    if (!hayRoleSdmed)
    {
        ui->label_existe_role_sdmed->setText(tr("<font color=red><b>%1</b></font>").arg("No existe el role \"sdmed\""));
        ui->boton_crear_role_sdmed->setText("Crear role");
        ui->label_existe_role_sdmed->setEnabled(true);
        ui->boton_crear_role_sdmed->setEnabled(true);
    }
    else
    {
        ui->label_existe_role_sdmed->setText(tr("<font color=green><b>%1</b></font>").arg("Existe el role \"sdmed\""));
        ui->boton_crear_role_sdmed->setText("...");
        ui->label_existe_role_sdmed->setEnabled(false);
        ui->boton_crear_role_sdmed->setEnabled(false);
        ui->boton_crear_role_sdmed->setVisible(false);
    }
}

void DialogoConfiguracion::ComprobarExistenciaBBDDSdmed(QSqlQuery consulta)
{
    QString cadenaComprobarBBDD = "SELECT true FROM pg_database WHERE datname='sdmed'";
    qDebug()<<cadenaComprobarBBDD;
    consulta.exec(cadenaComprobarBBDD);
    bool hayBBDDSdmed = false;
    while (consulta.next())
    {
        hayBBDDSdmed = consulta.value(0).toBool();
        qDebug()<<"existe sdmed bbdd"<<hayBBDDSdmed;
    }
    if (!hayBBDDSdmed)
    {
        ui->label_existe_bbdd_sdmed->setText(tr("No existe la base de datos \"sdmed\""));
        ui->boton_crear_bbdd_sdmed->setText("Crear BBDD");
        ui->label_existe_bbdd_sdmed->setEnabled(true);
        ui->boton_crear_bbdd_sdmed->setEnabled(true);
    }
    else
    {
        ui->label_existe_bbdd_sdmed->setText(tr("<font color=green><b>%1</b></font>").arg("Existe la base de datos \"sdmed\""));
        ui->boton_crear_bbdd_sdmed->setText("...");
        ui->label_existe_bbdd_sdmed->setEnabled(true);
        ui->boton_crear_bbdd_sdmed->setEnabled(false);
        ui->boton_crear_bbdd_sdmed->setVisible(false);
    }
}

void DialogoConfiguracion::ComprobarExtensionSuministrada()
{
    QFile file_control(QStringLiteral(":/postgres-extension/sdmed.control"));
    QStringList listado;
    if(file_control.open(QIODevice::ReadOnly))
    {
        QTextStream control(&file_control);
        listado = control.readAll().split('\n');
    }
    for (int i=0;i<listado.size();i++)
    {
        if (listado.at(i).contains("default_version"))
            {
                QString version = listado.at(i).section("'",1,1);
                if (version.remove(".") < ui->label_version_defecto->text().remove("."))
                {
                    ui->label_version_suministrada->setText(tr("<font color=red><b>%1</b></font>").arg(listado.at(i).section("'",1,1)));
                    ui->boton_instalar_extension->setEnabled(false);
                }
                else
                {
                    ui->label_version_suministrada->setText(tr("<font color=green><b>%1</b></font>").arg(listado.at(i).section("'",1,1)));
                    ui->boton_instalar_extension->setEnabled(true);
                }
                break;
            }
    }
}
