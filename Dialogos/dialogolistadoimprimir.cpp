#include "dialogolistadoimprimir.h"
#include "ui_dialogolistadoimprimir.h"
#include "Dialogos/dialogogoopcionespagina.h"
#include "Dialogos/dialogotablaopcionesimpresion.h"
#include "pyrun.h"
#include <QDir>
#include <QDebug>
#include <QTabWidget>
#include <QVBoxLayout>
#include <QGroupBox>
#include <QRadioButton>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>
#include <QSqlDatabase>
#include <QMessageBox>
#include <QFileDialog>
#include <QDesktopServices>
#include <QTableWidget>
#include <QPushButton>

DialogoListadoImprimir::DialogoListadoImprimir(const QString& obra, QSqlDatabase db, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoListadoImprimir), m_db(db), m_obra(obra)
{
    ui->setupUi(this);
    QString pathPython = "/.sdmed/python/plugins_impresion/";
    m_pModulo = "cargador";
    m_pFuncion = "iniciar";
    m_ruta = QDir::homePath()+pathPython;
    QDir dir_plugins(m_ruta);
    dir_plugins.setFilter(QDir::Dirs | QDir::NoDot | QDir::NoDotDot);
    QStringList filtros;
    //m_listadosImpresion.append("[");
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
        CustomRadioButton* radio_boton =  new CustomRadioButton(m_lista.at(i).nombre);
        QHBoxLayout* marco = new QHBoxLayout;
        m_botoneralayout[m_lista.at(i).tipo]->addLayout(marco);
        marco->addWidget(radio_boton);
        m_lista[i].boton = radio_boton;
        QObject::connect(radio_boton,SIGNAL(clicked()),this, SLOT(ActualizarBotonPrevisualizar()));
        //boton desplegable
        CustomPushButton* botonPropiedades = new CustomPushButton("+");
        botonPropiedades->setMaximumWidth(30);
        botonPropiedades->setVisible(false);        
        radio_boton->botonPropiedades = botonPropiedades;
        botonPropiedades->opciones = &m_lista[i].opciones;
        botonPropiedades->opcionesSelecionadas=&m_lista[i].opcionesSelecionadas;
        marco->addWidget(botonPropiedades);
        marco->addStretch();
        botonPropiedades->d=nullptr;
        QObject::connect(botonPropiedades,SIGNAL(clicked(bool)),this, SLOT (MostrarTablaOpciones()));
    }
    QObject::connect(ui->boton_Previsualizar,SIGNAL(pressed()),this,SLOT(Previsualizar()));
    QObject::connect(ui->botonSalir,SIGNAL(pressed()),this,SLOT(accept()));
    QObject::connect(ui->tabWidget,SIGNAL(currentChanged(int)),this,SLOT(DesactivarBotones()));
    QObject::connect(ui->boton_opcionesPagina,SIGNAL(pressed()),this,SLOT(OpcionesPagina()));
    QObject::connect(ui->boton_anadir,SIGNAL(pressed()),this, SLOT(AnadirListadoImpresion()));
}

DialogoListadoImprimir::~DialogoListadoImprimir()
{
    delete ui;
}

void DialogoListadoImprimir::ActualizarBotonPrevisualizar()
{
    //Primero desactivar los botones de propiedades que haya visibles
    for (auto c : m_lista)
    {
        c.boton->botonPropiedades->setVisible(c.boton->isChecked());
    }
    //Despues activar el que sea en funcion de si esta activo o no
    CustomRadioButton* c = dynamic_cast<CustomRadioButton*>(sender());
    if (c)
    {
        ui->boton_Previsualizar->setEnabled(c->isChecked());
        ui->boton_anadir->setEnabled(c->isChecked());
        c->botonPropiedades->setVisible(c->isChecked());
    }
}

void DialogoListadoImprimir::DesactivarBotones()
{
    ui->boton_Previsualizar->setEnabled(false);
    ui->boton_anadir->setEnabled(false);
    for (auto elem : m_lista)
    {
        elem.boton->setChecked(false);
    }
}

void DialogoListadoImprimir::OpcionesPagina()
{
    DialogogoOpcionesPagina* d = new DialogogoOpcionesPagina(m_opciones_pagina,this);
    if (d->exec())
    {
        m_opciones_pagina = d->LeerDatos();
        m_layout_pagina = d->LeeDatosS();
    }
}

void DialogoListadoImprimir::MostrarTablaOpciones()
{
    CustomPushButton *w = dynamic_cast<CustomPushButton*>(sender());
    if (w)
    {
        if (!w->d)
        {
            w->d =  new DialogoTablaOpcionesImpresion(*w->opciones,w);
            w->d->move(mapToGlobal(QPoint(w->geometry().x()+w->width()*2,w->geometry().y()+w->height()*2)));
        }
        if (w->d->exec())
        {
            *(w->opcionesSelecionadas) = w->d->OpcionesSeleccionadas();
            for (auto elem : w->d->OpcionesSeleccionadas())
            {
                qDebug()<<elem.first<<" . "<<elem.second;
            }
        }
    }
}

void DialogoListadoImprimir::AnadirListadoImpresion()
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
                        qDebug()<<"Añadir al listado.... "<<m_lista.at(i).ruta<<" - "<<m_lista.at(i).opcionesSelecionadas;
                        m_listadosImpresion.append(m_lista.at(i).ruta);
                    }
                }
            }
        }
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
    QJsonArray datos_script = datos["datos_script"].toArray();
    //QJsonArray arraynombre = datos["datos_nombre"].toArray();<--POR AHORA NO TOCO ESTOS DATOS
    QJsonArray opciones = datos["opciones"].toArray();
    for(const QJsonValue val: datos_script)
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
            //si hay nombre, leo las opciones, si las hubiera para incorporarlas
            OpcionesListado Listaopciones;
            for(const QJsonValue val: opciones)
            {
                QJsonObject loopObj = val.toObject();
                for (auto first : loopObj.keys())
                {
                    QJsonArray datos_opciones = loopObj[first].toArray();
                    QStringList second;
                    for(const QJsonValue opcionessecond: datos_opciones)
                    {
                        second<<opcionessecond.toString();
                    }
                    QPair<QString,QStringList>elemento(first,second);
                    second.clear();
                    Listaopciones.append(elemento);
                }
            }
            tipoL.opciones = Listaopciones;
            return true;
        }
    }
    return false;
}

void DialogoListadoImprimir::Previsualizar()
{

    //m_listadosImpresion.append("]");
    QStringList pArgumentos;
    QString datosConexion = m_db.databaseName()+","+m_db.hostName()+","+QString::number(m_db.port())+","+ m_db.userName()+","+m_db.password();
    pArgumentos<<datosConexion;
    pArgumentos<<m_obra;
    pArgumentos<<m_listadosImpresion;
    //qDebug()<<"m_lista.at(i).ruta "<<m_lista.at(i).ruta;
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
    //si no guarda la extension (ocurre bajo linux) se la pongo "a mano"
#if not defined(Q_OS_WIN) || not defined(Q_OS_MAC)
    fileName += m_lista_extensiones[extension];
#endif
    pArgumentos<<fileName;
    pArgumentos<<m_layout_pagina;
    qDebug()<<"m_layout_pagina "<<m_layout_pagina;
    QPair <int,QVariant>res = ::PyRun::loadModule(m_ruta, m_pModulo, m_pFuncion, pArgumentos);
    if (res.first == ::PyRun::Resultado::Success)
    {
        qDebug()<< __PRETTY_FUNCTION__ << "successful"<<res.first;
        //ver el pdf
        QString rutaPDF = res.second.toString();
        qDebug()<<"FIchero PDF " + rutaPDF;
        QDesktopServices::openUrl(QUrl(rutaPDF, QUrl::TolerantMode));

    }
    else //definir los mensajes de error en caso de no successful
    {
        int ret = QMessageBox::warning(this, tr("Problemas al imprimir"),
                                       tr("Ha habido problemas con el script de python"/*este mensaje* es el que hay que especificar el tipo de error*/),
                                       QMessageBox::Ok);
        qDebug()<<"ret "<<res.first;
    }

}
