#include "dialogoconfiguracion.h"
#include "ui_dialogoconfiguracion.h"

#include <QFileDialog>
#include <QSettings>
#include <QDebug>

DialogoConfiguracion::DialogoConfiguracion(QWidget *parent) : QDialog(parent), ui(new Ui::DialogoConfiguracion)
{
    ui->setupUi(this);
    ReadSettings();
    QObject::connect(ui->boton_ruta_python,SIGNAL(clicked(bool)),this,SLOT(DefinirRuta()));
    QObject::connect(ui->buttonBox->button(QDialogButtonBox::Ok),SIGNAL(clicked(bool)),this,SLOT(GuardarDatosConexion()));
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

void DialogoConfiguracion::DefinirRuta()
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

void DialogoConfiguracion::GuardarDatosConexion()
{
    QSettings settings;
    settings.beginGroup("rutas");
    settings.setValue("ruta_python", m_rutaPython);
    settings.endGroup();
}
