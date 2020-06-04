#include "dialogoconfiguracion.h"
#include "ui_dialogoconfiguracion.h"

#include <QFileDialog>
#include <QSettings>
#include <QDirIterator>
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
    QObject::connect(ui->boton_instalar_extension,SIGNAL(clicked(bool)),this,SLOT(CopiarExtension()));
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

void DialogoConfiguracion::CopiarExtension()
{
    qDebug()<<"Copiar ficheros";
    QFile file(QStringLiteral(":/postgres-extension/hola.txt"));
    if(file.open(QIODevice::ReadOnly))
    {
        qDebug()<<"fichero abierto";
    }
    else
    {
        qDebug()<<"Fallo al cargar el fichero";
    }
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
