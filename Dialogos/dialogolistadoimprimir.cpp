#include "dialogolistadoimprimir.h"
#include "ui_dialogolistadoimprimir.h"
#include "pyrun.h"
#include <QDir>
#include <QDebug>
#include <QRadioButton>
#include <QTabWidget>
#include <QVBoxLayout>
#include <QGroupBox>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>
#include <QSqlDatabase>
#include <QMessageBox>
#include <QFileDialog>

DialogoListadoImprimir::DialogoListadoImprimir(const QString& obra, QSqlDatabase db, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoListadoImprimir), m_db(db), m_obra(obra)
{
    ui->setupUi(this);
    QString pathPython = "/.sdmed/python/plugins/";
    m_ruta = QDir::homePath()+pathPython;
    QDir dir_plugins(m_ruta);
    dir_plugins.setFilter(QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
    QStringList filtros;
    QFileInfoList directorios = dir_plugins.entryInfoList();
    foreach (const QFileInfo& fichero, directorios)
    {
        QDir subd(fichero.absoluteFilePath());
        subd.setFilter(QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
        QStringList filtros;
        filtros<<"*.json"<<"*.py";
        QFileInfoList posible_plugin = subd.entryInfoList(filtros, QDir::Files);
        foreach (const QFileInfo &fichero, posible_plugin)
        {
            if (fichero.filePath().contains("metadata.json"))
            {
                //qDebug()<<"fichero "<<fichero.absolutePath()<<" - "<<fichero.filePath();
                sTipoListado TL;
                if (LeerJSON(TL,fichero.filePath()))
                {
                    TL.ruta=fichero.absolutePath();
                    m_lista.append(TL);
                }
            }
        }
    }
    //botones
    m_botoneralayout[eTipo::LISTADO]= new QVBoxLayout(ui->groupBoxListados);
    m_botoneralayout[eTipo::MEDICION]= new QVBoxLayout(ui->groupBoxMedPres);
    m_botoneralayout[eTipo::CERTIFICACION]= new QVBoxLayout(ui->groupBoxCertif);
    m_botoneralayout[eTipo::GENERAL]= new QVBoxLayout(ui->groupBoxSinClasif);

    for (int i = 0;i<m_lista.size();i++)
    {
        QRadioButton* boton =  new QRadioButton(m_lista.at(i).nombre);
        m_botoneralayout[m_lista.at(i).tipo]->addWidget(boton);
        m_lista[i].boton = boton;
    }
    QObject::connect(ui->botonImprimir,SIGNAL(pressed()),this,SLOT(Imprimir()));
    QObject::connect(ui->botonSalir,SIGNAL(pressed()),this,SLOT(accept()));
}

DialogoListadoImprimir::~DialogoListadoImprimir()
{
    delete ui;
}

bool DialogoListadoImprimir::LeerJSON(sTipoListado& tipoL, const QString& nombrefichero)
{
    QFile file(nombrefichero);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qFatal("No puedo abrir el fichero para lectura.");
    }
    QJsonParseError jsonError;
    QJsonDocument metadataJson = QJsonDocument::fromJson(file.readAll(),&jsonError);
    if (jsonError.error != QJsonParseError::NoError)
    {
        qDebug() << jsonError.errorString();
    }
    QJsonObject datos = metadataJson.object();
    QJsonArray arrayscript = datos["datos_script"].toArray();
    //QJsonArray arraynombre = datos["datos_nombre"].toArray();<--POR AHORA NO TOCO ESTOS DATOS
    for(const QJsonValue val: arrayscript)
    {
        QJsonObject loopObj = val.toObject();
        //qDebug() << loopObj["nombre"].toString();
        //qDebug() << loopObj["tipo"].toString();
        //qDebug() << loopObj["version"].toString();
        tipoL.nombre = loopObj["nombre"].toString();
        tipoL.tipo = static_cast<eTipo>(loopObj["tipo"].toInt());
        //si el tipo por algun caso esta mal, le asignaremos el tipo general
        if (tipoL.tipo<eTipo::LISTADO || tipoL.tipo>eTipo::CERTIFICACION)
        {
            tipoL.tipo = eTipo::GENERAL;
        }
        if (!tipoL.nombre.isEmpty())
        {
            return true;
        }
    }
    return false;
}

void DialogoListadoImprimir::Imprimir()
{
    QGroupBox* g = qobject_cast<QGroupBox*>(m_botoneralayout[ui->tabWidget->currentIndex()]->parent());
    if (g)
    {
        foreach (const QRadioButton* button, g->findChildren<QRadioButton*>())
        {
            if (button->isChecked())
            {
                for( int i=0; i<m_lista.count(); ++i )
                {
                    if (m_lista.at(i).boton == button)
                    {
                        //QString ruta =m_lista.at(i).ruta;
                        QString pModulo = "prueba";
                        QString pFuncion = "iniciar";
                        QStringList pArgumentos;
                        pArgumentos<<m_db.databaseName()<<m_db.hostName()<<QString::number(m_db.port())<<m_db.userName()<<m_db.password();
                        pArgumentos<<m_obra;
                        pArgumentos<<m_lista.at(i).ruta;
                        QString fileName = m_ruta;
                        qDebug()<<fileName;
                        if (ui->checkBoxGuardar->isChecked())
                        {
                            fileName = QFileDialog::getSaveFileName(this, tr("Guardar archivo"),
                                                                            m_ruta,
                                                                            tr("Hoja de calculo (*.xslx)"));
                        }
                        qDebug()<<"fichero con ruta completa "<<fileName;
                        int res = ::PyRun::loadModule(m_ruta, pModulo, pFuncion, pArgumentos);
                        if (res == ::PyRun::Resultado::Success)
                        {
                            qDebug()<< __PRETTY_FUNCTION__ << "successful"<<res;

                        }
                        else //definir los mensajes de error en caso de no successful
                        {
                            int ret = QMessageBox::warning(this, tr("Problemas al imprimir"),
                                                           tr("Ha habido problemas con el script de python"/*este mensaje* es el que hay que especificar el tipo de error*/),
                                                           QMessageBox::Ok);
                            qDebug()<<"ret "<<ret;
                        }
                    }
                }
            }
        }
    }
}
