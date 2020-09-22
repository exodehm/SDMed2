#include "dialogoconfiguracion.h"
#include "ui_dialogoconfiguracion.h"
#include "./Dialogos/dialogosudo.h"

#include <QFileDialog>
#include <QSettings>
#include <QDirIterator>
#include <QProcess>
#include <QMessageBox>
#include <QDebug>

DialogoConfiguracion::DialogoConfiguracion(QWidget *parent) : QDialog(parent), ui(new Ui::DialogoConfiguracion)
{
    ui->setupUi(this);
    ReadSettings();
    QObject::connect(ui->boton_ruta_python,SIGNAL(clicked(bool)),this,SLOT(DefinirRutaScripts()));
    QObject::connect(ui->boton_ruta_extension,SIGNAL(clicked(bool)),this,SLOT(BuscarManualRutaExtension()));
    QObject::connect(ui->boton_buscar_ruta_extension,SIGNAL(clicked(bool)),this,SLOT(BuscarAutomaticaRutaExtension()));
    QObject::connect(ui->combobox_rutas_extension,SIGNAL(currentIndexChanged(int)),this,SLOT(ActivarDirectorioInstalacion(int)));
    QObject::connect(ui->lineEdit_ruta_extension,SIGNAL(textChanged(const QString)),this,SLOT(ActivarBotonInstalarExtension()));
    QObject::connect(ui->boton_instalar_extension,SIGNAL(clicked(bool)),this,SLOT(InstalarExtension()));
    QObject::connect(ui->boton_salir,SIGNAL(clicked(bool)),this,SLOT(Salir()));
}

DialogoConfiguracion::~DialogoConfiguracion()
{
    delete ui;
}

void DialogoConfiguracion::ReadSettings()
{
    QSettings settings;
    ui->lineEdit_ruta_python->setText(settings.value("rutas/ruta_python").toString());
    ui->lineEdit_ruta_datos->setText(settings.value("rutas/ruta datos postgresql").toString());
    m_rutaPython = settings.value("rutas/ruta_python").toString();    
}

void DialogoConfiguracion::DefinirRutaScripts()
{
    QFileDialog fd;
    fd.setFilter(QDir::Dirs|QDir::Files|QDir::AllDirs|QDir::Hidden);
    fd.setOption(QFileDialog::DontUseNativeDialog);
    QString ruta = fd.getOpenFileName(this, tr("Open Directory"), m_rutaPython,"*.py");
    if (!ruta.isEmpty())
    {
        m_rutaPython = ruta;
        ui->lineEdit_ruta_python->setText(m_rutaPython);
    }
}

void DialogoConfiguracion::BuscarManualRutaExtension()
{
   QString ruta = QFileDialog::getExistingDirectory(this, tr("Ruta extensiones PostgreSQL"),
                                                 "/",
                                                 QFileDialog::ShowDirsOnly
                                                 | QFileDialog::DontResolveSymlinks);
    if (!ruta.isEmpty())
    {
        m_rutaExtensiones = ruta;
        ui->lineEdit_ruta_extension->setText(m_rutaExtensiones);
    }
}

void DialogoConfiguracion::BuscarAutomaticaRutaExtension()
{
    ui->combobox_rutas_extension->clear();
    QDirIterator it("/", QDirIterator::Subdirectories);
    QRegExp rx("/extension/plpgsql[-]{1,2}[0-9]{1,2}.[0-9]{1,2}.sql");
    while (it.hasNext())
    {
        QString fichero = it.next();
        //if (fichero.contains("/extension/plpgsql--1.0.sql"))
        if (fichero.contains(rx))
        {
            QString algo = fichero.left(fichero.lastIndexOf("/"));
            ui->combobox_rutas_extension->addItem(algo);
            ui->boton_instalar_extension->setEnabled(true);
            if (ui->check_busqueda_rapida->isChecked())
            {
                break;
            }
        }
    }
}

void DialogoConfiguracion::ActivarDirectorioInstalacion(int indice)
{
    ui->lineEdit_ruta_extension->setText(ui->combobox_rutas_extension->itemText(indice));
}

void DialogoConfiguracion::ActivarBotonInstalarExtension()
{
    ui->boton_ruta_extension->setEnabled(!ui->lineEdit_ruta_extension->text().isEmpty());
}

void DialogoConfiguracion::InstalarExtension()
{
    QFile file_extension(QStringLiteral(":/postgres-extension/sdmed--0.1.sql"));
    QFile file_control(QStringLiteral(":/postgres-extension/sdmed.control"));
    QFile file_makefile(QStringLiteral(":/postgres-extension/Makefile"));
    if(file_extension.open(QIODevice::ReadOnly) && file_control.open(QIODevice::ReadOnly) && file_makefile.open(QIODevice::ReadOnly))
    {
        QString ruta_extension = ui->lineEdit_ruta_extension->text() + "/";
        QString nombreFicheroExtensionDestino = file_extension.fileName().mid(file_extension.fileName().lastIndexOf("/")+1);
        QString nombreFicheroControlDestino = file_control.fileName().mid(file_control.fileName().lastIndexOf("/")+1);
        QString nombreFicheroMakefileDestino = file_makefile.fileName().mid(file_makefile.fileName().lastIndexOf("/")+1);
        QString ficheroExtensionDestino = ruta_extension+ nombreFicheroExtensionDestino;
        QString ficheroExtensionControlDestino = ruta_extension + nombreFicheroControlDestino;
        QString ficheroExtensionMakefileDestino = ruta_extension + nombreFicheroMakefileDestino;

        QString aviso = "Se copiarán <b>"+ nombreFicheroExtensionDestino + " , " + nombreFicheroControlDestino + " y "+nombreFicheroMakefileDestino +
                "</b> en:<br> "+ ruta_extension;
        int ret = QMessageBox::information(this, tr("Aviso"),aviso,QMessageBox::Ok|QMessageBox::Cancel, QMessageBox::Cancel);
        qDebug()<<"ret "<<ret;
        if (ret == QMessageBox::Ok)
        {
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
                CopiarExtensionPermisos(file_extension,ficheroExtensionDestino,passw);
                CopiarExtensionPermisos(file_control,nombreFicheroControlDestino,passw);
                CopiarExtensionPermisos(file_makefile,nombreFicheroMakefileDestino,passw);
            }
            #endif
        }       
    }
}

void DialogoConfiguracion::CopiarExtensionPermisos(QFile &fichero_origen, const QString &ruta_destino, QString passw)
{
    //creo una copia fisica en el disco duro para poder copiarlos
    QString copia = QDir::homePath()+"/copia.sql";
    fichero_origen.copy(copia);
    QProcess process1;
    QProcess process2;
    process1.setStandardOutputProcess(&process2);
    QString s_process1 = "echo " + passw;
    qDebug()<<s_process1;
    QString s_process2 = "sudo -S cp " + fichero_origen.fileName() + " " + ruta_destino;
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
    //borro la copia del disco duro
    fichero_origen.remove(copia);
}

void DialogoConfiguracion::Salir()
{
    WriteSettings();
    this->exec();
}

void DialogoConfiguracion::WriteSettings()
{
    QSettings settings;
    settings.beginGroup("rutas");
    settings.setValue("ruta_python", m_rutaPython);
    settings.endGroup();
}
