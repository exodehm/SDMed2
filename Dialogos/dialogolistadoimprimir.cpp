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
#include <QDesktopServices>
#include <QtPrintSupport/QPrinter>

DialogoListadoImprimir::DialogoListadoImprimir(const QString& obra, QSqlDatabase db, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoListadoImprimir), m_db(db), m_obra(obra)
{
    ui->setupUi(this);
    QString pathPython = "/.sdmed/python/plugins/";
    m_pModulo = "cargador";
    m_pFuncion = "iniciar";
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
    //extensiones
    m_lista_extensiones.insert(tr("Documento de texto Open Document(*.odt)"),".odt");
    m_lista_extensiones.insert(tr("Documento de texto MS Word (*.docx)"),".docx");
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
        QObject::connect(boton,SIGNAL(clicked()),this, SLOT(ActualizarBotonPrevisualizar()));
    }
    QObject::connect(ui->boton_Previsualizar,SIGNAL(pressed()),this,SLOT(Imprimir()));
    QObject::connect(ui->botonImprimir,SIGNAL(pressed()),this,SLOT(Imprimir()));
    QObject::connect(ui->botonSalir,SIGNAL(pressed()),this,SLOT(accept()));
    QObject::connect(ui->tabWidget,SIGNAL(currentChanged(int)),this,SLOT(DesactivarBotones()));
}

DialogoListadoImprimir::~DialogoListadoImprimir()
{
    delete ui;
}

void DialogoListadoImprimir::ActualizarBotonPrevisualizar()
{
    QRadioButton* c = dynamic_cast<QRadioButton*>(sender());
    if (c)
    {
        ui->boton_Previsualizar->setEnabled(c->isChecked());
    }
}

void DialogoListadoImprimir::DesactivarBotones()
{
    ui->boton_Previsualizar->setEnabled(false);
    for (auto elem : m_lista)
    {
        elem.boton->setChecked(false);
    }
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
                        QStringList pArgumentos;
                        pArgumentos<<m_db.databaseName()<<m_db.hostName()<<QString::number(m_db.port())<<m_db.userName()<<m_db.password();
                        pArgumentos<<m_obra;
                        pArgumentos<<m_lista.at(i).ruta;
                        qDebug()<<"m_lista.at(i).ruta "<<m_lista.at(i).ruta;
                        QString fileName = "";                        
                        QString extensiones;
                        //preparo las extensiones
                        QHashIterator<QString, QString> i(m_lista_extensiones);
                        while (i.hasNext())
                        {
                            i.next();
                            extensiones += i.key();
                            if (i.hasNext())
                                extensiones += ";;";
                        }
                        QString extension;
                        if (ui->checkBoxGuardar->isChecked())
                        {
                            fileName = QFileDialog::getSaveFileName(this,
                                                                    tr("Guardar archivo"),
                                                                    m_ruta,
                                                                    extensiones,
                                                                    &extension,
                                                                    QFileDialog::DontUseNativeDialog
                                                                    );

                        }
                        qDebug()<<"filename "<<fileName;
                        //si no hay extensiones (ocurre bajo linux)
                #if not defined(Q_OS_WIN) || not defined(Q_OS_MAC)
                        fileName += m_lista_extensiones[extension];                
                #endif
                        qDebug()<<"filename "<<fileName;
                        pArgumentos<<fileName;
                        int res = ::PyRun::loadModule(m_ruta, m_pModulo, m_pFuncion, pArgumentos);
                        if (res == ::PyRun::Resultado::Success)
                        {
                            qDebug()<< __PRETTY_FUNCTION__ << "successful"<<res;
                            //ver el pdf
                            QString rutaPDF = "listado.pdf";
                            qDebug()<<"FIchero PDF " + rutaPDF;
                            QDesktopServices::openUrl(QUrl(rutaPDF, QUrl::TolerantMode));

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

void DialogoListadoImprimir::Previsualizar()
{
   //QPrinter printer(QPrinter::HighResolution);
}
