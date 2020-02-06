#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "instancia.h"
#include "./Ficheros/abrirguardarbc3.h"
#include "./Ficheros/exportarBC3.h"
#include "./Dialogos/dialogoabout.h"
#include "./Dialogos/dialogodatoscodigoresumen.h"
#include "./Dialogos/dialogogestionobras.h"
#include "./Dialogos/dialogodatosgenerales.h"
#include "./Dialogos/dialogoadvertenciaborrarbbdd.h"
#include "./imprimir.h"
#include "./miundostack.h"

#include "pyrun.h"

#include <QMessageBox>
#include <QDebug>
#include <QLabel>
#include <QComboBox>
#include <QPushButton>
#include <QFileDialog>
#include <QDir>


MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow)
{
    {
        ui->setupUi(this);
        setWindowTitle(QCoreApplication::applicationName());
        //seccion ver medicion/certificacion
        labelVerMedCert = new QLabel("Ver:");
        comboMedCert = new QComboBox;
        comboMedCert->addItem(tr("Medición"));
        comboMedCert->addItem(tr("Certificación"));
        comboMedCert->setEnabled(false);//lo inicio desactivado mientras no haya una obra activa
        ui->CertBar->addWidget(labelVerMedCert);
        ui->CertBar->addWidget(comboMedCert);
        //seccion annadir nueva certificacion
        botonCertificaciones = new QPushButton(tr("Certificaciones"));
        botonCertificaciones->setEnabled(false);
        ui->CertBar->addWidget(botonCertificaciones);
        //seccion certificacion actual
        labelCertificacionActual[0] = new QLabel(tr("Cert. actual: "));
        labelCertificacionActual[1] = new QLabel(tr(""));
        ui->CertBar->addWidget(labelCertificacionActual[0]);
        ui->CertBar->addWidget(labelCertificacionActual[1]);
        setupActions();
        readSettings();        
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::writeSettings()
{
    QSettings settings;

    settings.beginGroup("mainwindow");
    settings.setValue("size", this->size());
    settings.endGroup();
}

void MainWindow::readSettings()
{
    QSettings settings;
    resize(settings.value("mainwindow/size", QSize(800,600)).toSize());
    bool conectar = settings.value("conexionBBDD/conexion automatica",false).toBool();
    if (conectar)
    {
        db = QSqlDatabase::addDatabase(settings.value("conexionBBDD/driverdb").toString());
        db.setHostName(settings.value("conexionBBDD/servidor").toString());
        db.setDatabaseName(settings.value("conexionBBDD/database").toString());
        db.setPort(settings.value("conexionBBDD/puerto").toInt());
        db.setUserName(settings.value("conexionBBDD/usuario").toString());
        db.setPassword(settings.value("conexionBBDD/password").toString());
        if (db.open())
        {
            ActivarBotonesBasicos(true);
        }
        else
        {
            QMessageBox msgBox;
            msgBox.setText(db.lastError().text());
            msgBox.exec();
        }
    }
    else
    {
        qDebug()<<"No se esta conectado a ninguna BBDD";
    }

}

/*QString MainWindow::CodigoBC3(const QString &nombrefichero)
{
    QFile fichero(nombrefichero);
    if(fichero.open(QIODevice::ReadOnly))
    {
        QTextStream datos(&fichero);
        datos.setCodec("Windows-1252");
        QStringList registros = datos.readAll().split('~');
        foreach (QString linea, registros)
        {
            if (linea.contains("##"))
            {
                QStringList datos = linea.split("|");
                QString codigo = datos.at(1);
                codigo.remove('#');
                qDebug()<<"La linea tiene el codigo: "<<codigo;
                foreach (QList<QVariant> l, VerObrasEnBBDD())
                {
                    qDebug()<<l.at(0).toString();
                    if (codigo == l.at(0))
                    {
                        qDebug()<<"ERROR, la obra YA EXiSTE";
                    }
                }
                return codigo;
                break;
            }
        }
    }
    return QString();
}*/

void MainWindow::ActionNuevo()
{
    DialogoDatosCodigoResumen* cuadro = new DialogoDatosCodigoResumen(this);
    if (cuadro->exec())
    {
        QString cadenaconsulta = "SELECT crear_obra ('" + cuadro->LeeCodigo() + "','" + cuadro->LeeResumen() + "');";
        qDebug()<<"la consulta es: "<<cadenaconsulta;
        QSqlQuery consulta (cadenaconsulta);
        //la consulta genera las tablas y retorna 0 si todo esta correcto. Si no puede hacerlo retorna -1
        int res = -1;
        while (consulta.next())
        {
            res = consulta.value(0).toInt();
        }
        if (res==0)
        {
            AnadirObraAVentanaPrincipal(cuadro->LeeCodigo(),cuadro->LeeResumen());            
        }
        else
        {
            qDebug()<<consulta.lastError().text();
            QMessageBox::warning(this, tr("Aviso"),
                                 tr("Existe una obra en la BBDD con el código %1").arg(cuadro->LeeCodigo()),
                                 QMessageBox::Ok);
        }
    }
    delete cuadro;
}

bool MainWindow::ActionImportar()
{
    QString nombrefichero;
    nombrefichero = QFileDialog::getOpenFileName(this,\
                                                 tr("Abrir Obra"),\
                                                 rutaarchivo,\
                                                 tr("Archivos BC3 (*.bc3);;Archivos SEG (*.seg)"));
    QString codigoBC3, resumenBC3;
    bool existecodigo = false;
    bool obraabierta = false;
    QFile fichero(nombrefichero);
    if(fichero.open(QIODevice::ReadOnly))
    {
        QTextStream datos(&fichero);
        datos.setCodec("Windows-1252");
        QStringList registros = datos.readAll().split('~');
        foreach (QString linea, registros)
        {
            qDebug()<<"linea: "<<linea;

            if (linea.contains("##") && linea.at(0)=='C')
            {
                QStringList datos = linea.split("|");
                codigoBC3 = datos.at(1);
                resumenBC3 = datos.at(3);
                codigoBC3.remove('#');
                /*foreach (QList<QVariant> l, VerObrasEnBBDD())
                {
                    qDebug()<<l.at(0);
                    if (codigoBC3 == l.at(0).toString())
                    {
                        existecodigo = true;
                    }
                }*/
                break;
            }
        }
        if (existecodigo)
        {
            QMessageBox::warning(this, tr("Aviso"),
                                 tr("Existe una obra en la BBDD con el código %1").arg(codigoBC3),
                                 QMessageBox::Ok);
        }
        else
        {
            AbrirGuardarBC3 NuevoBC3(registros, obraabierta);
            if (obraabierta)
            {
                AnadirObraAVentanaPrincipal(codigoBC3,resumenBC3);                
            }
        }
    }
    return false;
}

bool MainWindow::ActionAbrirBBDD()
{
    DialogoGestionObras* cuadro = new DialogoGestionObras(ListaObras, db, this);
    QObject::connect(cuadro,SIGNAL(BorrarObra(QStringList)),this,SLOT(BorrarBBDD(QStringList)));
    QObject::connect(cuadro,SIGNAL(ActivarBotones(bool)),this,SLOT(ActivarBotonesBasicos(bool)));
    if (cuadro->exec())
    {
        foreach (QStringList l, cuadro->listaNombreObrasAbrir())
        {
            AnadirObraAVentanaPrincipal(l.at(0),l.at(1));            
        }
    }
    delete cuadro;
    return true;
}

bool MainWindow::BorrarBBDD(QStringList datosobra)
{
    DialogoBorrarBBDD* d = new DialogoBorrarBBDD(datosobra, this);
    int res = d->exec();
    if (res==1)//aceptar
    {
        QMessageBox::StandardButton respuesta;
        auto it = ListaObras.begin();
        foreach (Instancia* nombreobra, ListaObras)
        {
            if (nombreobra->LeeTabla() == datosobra.at(0))
            {
                respuesta = QMessageBox::question(
                            this,
                            tr("Aviso"),
                            tr("La obra esta en uso. ¿Realmente desea continuar?"),
                            QMessageBox::No | QMessageBox::Default,
                            QMessageBox::Yes);
                if (respuesta == QMessageBox::No)
                {
                    return false;
                }
            }
        }
        //primera accion, borrar la obra de la ventana principal
        obraActual = it;
        ActionCerrar();
        //segunda accion, exportar a bc3 si esta seleccionada la accion
        if (d->Exportar())
        {
            Exportar(datosobra.at(0));
            qDebug()<<"se guarda la obra";
        }
        //tercera accion, borrar la obra de la BBDD
        QString cadenaborrartablacodigo = "SELECT borrar_obra ('"+datosobra.at(0)+"');";
        //qDebug()<<cadenaborrartablacodigo;
        QSqlQuery consulta;
        consulta.exec(cadenaborrartablacodigo);
        //qDebug()<<sender();
        std::advance (it,1);
    }
    return true;
}

bool MainWindow::Exportar(QString nombrefichero)
{
    qDebug()<<"nombreficero original "<<nombrefichero;
    QString extensionBC3 = ".bc3";
    if (nombrefichero.isEmpty())
    {
        if (*obraActual)
        {
            nombrefichero = (*obraActual)->LeeTabla();
            qDebug()<<"nombreficero original 1"<<nombrefichero;
        }
    }
    nombrefichero.append(extensionBC3);
    nombrefichero = QFileDialog::getSaveFileName(this,tr("Guardar BC3"),\
                                                         QDir::homePath()+"/"+nombrefichero,\
                                                         tr("Archivos BC3 (*.bc3)"));
    return GuardarObra(nombrefichero);
}

bool MainWindow::GuardarObra(QString nombreFichero)
{
    qDebug()<<"GuardarObra: "<<nombreFichero;
    bool toReturn=false;
    QString extension = nombreFichero.right(nombreFichero.length()-nombreFichero.lastIndexOf('.'));
    if (extension == ".bc3" || extension == ".BC3")
    {
        ExportarBC3 exportador((*obraActual)->LeeTabla(),nombreFichero);
        qDebug()<<"Guardada la obra "<<nombreFichero<<" con exito";
        toReturn = true;
    }
    if (extension == ".xlsx" || extension == ".XLSX")
    {
        (*obraActual)->ExportarXLSS(nombreFichero);
        qDebug()<<"Guardando en formato xls";
        toReturn = true;
    }
    if (*obraActual && toReturn == true)
    {
        (*obraActual)->Pila()->clear();
    }
    return toReturn;
}

void MainWindow::ActionImprimir()
{   
    qDebug()<<"Current path"<<QDir::currentPath();
    QString pathPython = "/.sdmed/python";
    QString ruta = QDir::homePath()+pathPython;
    QString pModulo = "plugin_loader";
    QString pFuncion = "iniciar";
    QStringList pArgumentos;
    //argumentos
    //primero meto los datos de la conexion
    pArgumentos<<db.databaseName()<<db.hostName()<<QString::number(db.port())<<db.userName()<<db.password();
    //ahora meto los datos de la obra actual (nombre, padre e hijo)
    if (HayObrasAbiertas())
    {
        pArgumentos<<(*obraActual)->LeeTabla();

        /*if(::PyRun::loadModule(QDir::home().absoluteFilePath(ruta), pModulo, pFuncion, pArgumentos))
        {
            qDebug()<< __PRETTY_FUNCTION__ << "successful";
        }
    }
    else
    {
        QMessageBox::warning(this, tr("Aviso"),
                                       tr("Debe haber alguna obra abierta"),
                                       QMessageBox::Ok);*/
    }
    int res = ::PyRun::loadModule(QDir::home().absoluteFilePath(ruta),pModulo, pFuncion, pArgumentos);
    qDebug()<<"Resultado: "<<res<<" "<<QDir::home().absoluteFilePath(ruta);
    //hacer un switch/case con los posibles errores

}

void MainWindow::ActionCerrar()
{
    if (!ListaObras.empty())
    {
        std::list<Instancia*>::iterator obraBorrar = obraActual;
        obraActual = ListaObras.erase(obraActual);
        delete (*obraBorrar);
        if ( obraActual == ListaObras.end() && !ListaObras.empty())
        {
            obraActual = std::prev(obraActual);
        }
    }
    if (ListaObras.empty())
    {
        ui->actionGuardar->setEnabled(false);
        ui->actionCerrar->setEnabled(false);
        comboMedCert->setEnabled(false);
        botonCertificaciones->setEnabled(false);        
        ui->actionVer_Arbol->setEnabled(false);
        ui->actionExportar->setEnabled(false);
        ui->actionImprimir->setEnabled(false);
        //cerrar
        labelCertificacionActual[1]->clear();
        QString label = "";
        labelCertificacionActual[1]->setText(label);
    }
}

void MainWindow::closeEvent(QCloseEvent* event)
{
    ActionSalir();
    QMainWindow::closeEvent(event);
}

void MainWindow::ActionSalir()
{
    db.close();
    writeSettings();
    qApp->quit();
}

void MainWindow::ActionCopiar()
{
    (*obraActual)->Copiar();
    ui->actionPegar->setEnabled(true);
}

void MainWindow::ActionPegar()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->Pegar();
    }
}

void MainWindow::ActionCortar()
{

}

void MainWindow::ActionUndo()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->Undo();
    }
}

void MainWindow::ActionRedo()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->Redo();
    }
}

void MainWindow::ActionAdelante()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->Mover(movimiento::DERECHA);
    }
}

void MainWindow::ActionAtras()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->Mover(movimiento::IZQUIERDA);
    }
}

void MainWindow::ActionInicio()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->Mover(movimiento::INICIO);
    }
}

void MainWindow::ActionVerArbol()
{
    if (HayObrasAbiertas())
    {
        (*obraActual)->VerArbol();
    }
}

void MainWindow::ActionSeleccionarTodo()
{

}

void MainWindow::ActionDeseleccionarTodo()
{

}

void MainWindow::ActionAjustarPresupuesto()
{
    if (HayObrasAbiertas())
    {
       (*obraActual)->AjustarPresupuesto();
    }
}

void MainWindow::ActionPropiedadesObra()
{
    if (HayObrasAbiertas())
    {
        DialogoDatosGenerales* d = new DialogoDatosGenerales((*obraActual)->LeeTabla(),db);
        QObject::connect(d,SIGNAL(CambioCostesIndirectos()),this,SLOT(ActualizarDatosObra()));
        d->exec();
    }
}

void MainWindow::AcercaDe()
{
    DialogoAbout *d = new DialogoAbout(this);
    d->show();
}

void MainWindow::AcercaDeQt()
{
    QMessageBox::aboutQt(this);
}

bool MainWindow::HayObrasAbiertas()
{
    return !ListaObras.empty();
}

void MainWindow::CambiarMedCert(int indice)
{
    (*obraActual)->MostrarDeSegun(indice);
}

void MainWindow::NuevaCertificacion()
{
    (*obraActual)->AdministrarCertificaciones();
}

void MainWindow::CambiarLabelCertificacionActual(QStringList certActual)
{    
    labelCertificacionActual[1]->clear();
    QString label;
    if (certActual.at(0) == "0")
    {
        label = tr("No hay certificación activa");
    }
    else
    {
        label.append("<strong><b>");
        label.append(certActual.at(0));
        label.append("</b></strong>");
        label.append("(");
        label.append(certActual.at(1));
        label.append(")");
    }
    labelCertificacionActual[1]->setText(label);
}

void MainWindow::setupActions()
{
    QObject::connect(ui->actionNuevo,SIGNAL(triggered(bool)),this,SLOT(ActionNuevo()));
    QObject::connect(ui->actionImportar,SIGNAL(triggered(bool)),this,SLOT(ActionImportar()));
    QObject::connect(ui->actionExportar,SIGNAL(triggered(bool)),this,SLOT(Exportar()));
    QObject::connect(ui->actionAbrirBBDD,SIGNAL(triggered(bool)),this,SLOT(ActionAbrirBBDD()));
    QObject::connect(ui->actionCerrar,SIGNAL(triggered(bool)),this,SLOT(ActionCerrar()));
    QObject::connect(ui->actionPropiedades_de_la_obra,SIGNAL(triggered(bool)),this,SLOT(ActionPropiedadesObra()));
    //QObject::connect(ui->actionGuardar,SIGNAL(triggered(bool)),this,SLOT(ActionGuardar()));
    QObject::connect(ui->actionImprimir,SIGNAL(triggered(bool)),this,SLOT(ActionImprimir()));
    QObject::connect(ui->actionGuardar_como,SIGNAL(triggered(bool)),this,SLOT(Exportar()));
    QObject::connect(ui->action_Salir, SIGNAL(triggered(bool)),this, SLOT(ActionSalir()));
    QObject::connect(ui->actionCopiar,SIGNAL(triggered(bool)),this,SLOT(ActionCopiar()));
    QObject::connect(ui->actionCortar,SIGNAL(triggered(bool)),this,SLOT(ActionCortar()));
    QObject::connect(ui->actionPegar,SIGNAL(triggered(bool)),this,SLOT(ActionPegar()));
    QObject::connect(ui->actionDeshacer,SIGNAL(triggered(bool)),this,SLOT(ActionUndo()));
    QObject::connect(ui->actionRehacer,SIGNAL(triggered(bool)),this,SLOT(ActionRedo()));
    QObject::connect(ui->actionSeleccionar_todo,SIGNAL(triggered(bool)),this,SLOT(ActionSeleccionarTodo()));
    QObject::connect(ui->actionAnular_selecci_n,SIGNAL(triggered(bool)),this,SLOT(ActionDeseleccionarTodo()));
    QObject::connect(ui->tabPrincipal,SIGNAL(currentChanged(int)),this,SLOT(CambiarObraActual(int)));
    QObject::connect(ui->actionAdelante,SIGNAL(triggered(bool)),this,SLOT(ActionAdelante()));
    QObject::connect(ui->actionAtras,SIGNAL(triggered(bool)),this,SLOT(ActionAtras()));
    QObject::connect(ui->actionIr_a_inicio,SIGNAL(triggered(bool)),this,SLOT(ActionInicio()));
    QObject::connect(ui->actionVer_Arbol,SIGNAL(triggered(bool)),this,SLOT(ActionVerArbol()));
    QObject::connect(ui->actionAjustar_precio,SIGNAL(triggered(bool)),this,SLOT(ActionAjustarPresupuesto()));
    QObject::connect(ui->actionAcerca_de,SIGNAL(triggered(bool)),this,SLOT(AcercaDe()));
    QObject::connect(ui->actionAcerca_de_Qt,SIGNAL(triggered(bool)),this,SLOT(AcercaDeQt()));
    QObject::connect(comboMedCert,SIGNAL(currentIndexChanged(int)),this,SLOT(CambiarMedCert(int)));
    QObject::connect(botonCertificaciones,SIGNAL(pressed()),this,SLOT(NuevaCertificacion()));    
    //QObject::connect(comboCertificacionActual,SIGNAL(currentIndexChanged(int)),this,SLOT(CambiarCertificacionActual(int)));
}


void MainWindow::AnadirObraAVentanaPrincipal(QString _codigo, QString _resumen)
{
    Instancia* NuevaObra =new Instancia(_codigo,_resumen,this);
    ui->actionGuardar->setEnabled(true);
    ui->actionCerrar->setEnabled(true);
    ui->actionExportar->setEnabled(true);
    ui->actionImprimir->setEnabled(true);
    comboMedCert->setEnabled(true);
    botonCertificaciones->setEnabled(true);
    ui->actionVer_Arbol->setEnabled(true);
    ui->tabPrincipal->addTab(NuevaObra,_resumen);
    ui->tabPrincipal->setCurrentIndex(ui->tabPrincipal->currentIndex()+1);
    ListaObras.push_back(NuevaObra);
    obraActual=ListaObras.begin();
    std::advance(obraActual,ListaObras.size()-1);
    //ActivarDesactivarBotonesPila(obraActual->miobra->Pila()->index());
    QString leyenda = QString(tr("Creada la obra %1").arg(_resumen));
    statusBar()->showMessage(leyenda,5000);
    QObject::connect(NuevaObra,SIGNAL(ActivarBoton(int)),this,SLOT(ActivarDesactivarBotonesPila(int)));
    QObject::connect(NuevaObra,SIGNAL(CopiarP()),this,SLOT(ActionCopiar()));
    QObject::connect(NuevaObra,SIGNAL(PegarP()),this,SLOT(ActionPegar()));
    QObject::connect(NuevaObra,SIGNAL(CopiarM()),this,SLOT(ActionCopiar()));
    QObject::connect(NuevaObra,SIGNAL(PegarM()),this,SLOT(ActionPegar()));
    QObject::connect(NuevaObra,SIGNAL(CambiarLabelCertActual(QStringList)),this,SLOT(CambiarLabelCertificacionActual(QStringList)));
    NuevaObra->LeerCertifActual();
}

void MainWindow::CambiarObraActual(int indice)
{
    if (!ListaObras.empty())
    {
        if ((unsigned int)indice<ListaObras.size())
        {
            obraActual=ListaObras.begin();
            std::advance(obraActual,indice);
            ActivarDesactivarBotonesPila((*obraActual)->Pila()->index());
            (*obraActual)->LeerCertifActual();
        }
    }
}

void MainWindow::ActivarDesactivarBotonesPila(int indice)
{
    //qDebug()<<"ActivarDesactivarBotonesUndoRedo(): "<<indice;
    ui->actionDeshacer->setEnabled(indice!=0);
    ui->actionRehacer->setEnabled(indice<(*obraActual)->Pila()->count());
    ui->actionGuardar->setEnabled(indice!=0);
}

void MainWindow::ActivarBotonesBasicos(bool activar)
{
    ui->actionNuevo->setEnabled(db.open());
    ui->actionImportar->setEnabled(db.open());
    ui->actionExportar->setEnabled(db.open());
    ui->actionCopiar->setEnabled(db.open());
    ui->menuImportar->setEnabled(db.open());
    ui->menuExportar->setEnabled(db.open());
}

void MainWindow::ActualizarDatosObra()
{
    qDebug()<<"Actualizar en main";
    (*obraActual)->RefrescarVista();
}
