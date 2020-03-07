#include "dialogolistadoimprimir.h"
#include "ui_dialogolistadoimprimir.h"
#include <QDir>
#include <QDebug>
#include <QRadioButton>
#include <QTabWidget>
#include <QVBoxLayout>
#include <QGroupBox>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>

DialogoListadoImprimir::DialogoListadoImprimir(QString ruta, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoListadoImprimir)
{
    ui->setupUi(this);
    QDir dir_plugins(ruta);
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
                sTipoListado TL;
                if (LeerJSON(TL,fichero.filePath()))
                {
                    TL.ruta="";
                    lista.append(TL);
                }
            }
        }
    }
    //botones
    QVBoxLayout* botoneralayout[nTipoListados];
    botoneralayout[0]= new QVBoxLayout(ui->groupBoxGeneral);
    botoneralayout[1]= new QVBoxLayout(ui->groupBoxListados);
    botoneralayout[2]= new QVBoxLayout(ui->groupBoxMed);
    botoneralayout[3]= new QVBoxLayout(ui->groupBoxPres);
    for (int i = 0;i<lista.size();i++)
    {
        QRadioButton* boton =  new QRadioButton(lista.at(i).nombre);
        botoneralayout[lista.at(i).tipo]->addWidget(boton);
    }
}

DialogoListadoImprimir::~DialogoListadoImprimir()
{
    delete ui;
}

QFileInfoList DialogoListadoImprimir::ComprobarFicheros(const QString &ruta)
{
    QDir aplicacion(ruta);
    aplicacion.setFilter(QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
    QFileInfoList ret = aplicacion.entryInfoList();
    QStringList filtros;
    filtros<<"*.json"<<"*.py";
    foreach (const QFileInfo &subd, ret)
    {
        QString subdirectorio = ruta;
        subdirectorio.append("/").append(subd.fileName());
        qDebug()<<"Subdirectorio "<<subdirectorio;
        QDir aplicacion(subdirectorio);
        QFileInfoList ret = aplicacion.entryInfoList(filtros, QDir::Files);
        foreach (const QFileInfo& fichero, ret)
        {
            qDebug()<<"A ver que pasa "<<fichero;
            //NombreListado(fichero.filePath());
            if (fichero.filePath().contains("metadata.json"))
            {
                sTipoListado TL;
                if (LeerJSON(TL,fichero.filePath()))
                {
                    lista.append(TL);
                }
            }
        }
    }
    return ret;
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
        qDebug() << loopObj["nombre"].toString();
        qDebug() << loopObj["tipo"].toString();
        qDebug() << loopObj["version"].toString();
        tipoL.nombre = loopObj["nombre"].toString();
        tipoL.tipo = static_cast<eTipo>(loopObj["tipo"].toInt());
        if (!tipoL.nombre.isEmpty())
        {
            return true;
        }
    }
    return false;
}
