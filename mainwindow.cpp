#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "instancia.h"
#include "./Ficheros/importarBC3.h"
#include "./Ficheros/exportarBC3.h"
#include "./Dialogos/dialogoabout.h"
#include "./Dialogos/dialogodatoscodigoresumen.h"
#include "./Dialogos/dialogogestionobras.h"
#include "./Dialogos/dialogodatosgenerales.h"
#include "./Dialogos/dialogoadvertenciaborrarbbdd.h"
#include "./Dialogos/dialogolistadoimprimir.h"
#include "./Dialogos/dialogoconfiguracion.h"
#include "./Dialogos/dialogomensajeconexioninicial.h"
#include "./Dialogos/dialogodatosconexion.h"
#include "./imprimir.h"
#include "./miundostack.h"

#include <QDebug>
#include <QLabel>
#include <QComboBox>
#include <QPushButton>
#include <QFileDialog>
#include <QDir>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow)
{
    {
        m_tiempoMaximoIntentoConexion = 5;
        //m_basededatos = "sdmed";
        m_db = QSqlDatabase::addDatabase("QPSQL");
        m_db.setConnectOptions("connect_timeout = " + QString::number(m_tiempoMaximoIntentoConexion));
        m_d = nullptr;
        readSettings();
        if (!Conectar())
        {
            ConfigurarDatosConexion();
        }

        ui->setupUi(this);
        setWindowTitle(QCoreApplication::applicationName()+ " - " +QCoreApplication::applicationVersion());
        //seccion ver medicion/certificacion
        labelVerMedCert = new QLabel(tr("Ver:"));
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
        //ui->actionImportar->setEnabled(true);
        ActivarBotonesBasicos(m_db);
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
    QSettings settings("DavidSoft", "SDMed2");

    resize(settings.value("mainwindow/size", QSize(800,600)).toSize());
    //settings.beginGroup("DatosConexion");
    m_host = settings.value("DatosConexion/servidor").toString();
    m_basededatos = settings.value("DatosConexion/basedatos").toString();
    m_puerto = settings.value("DatosConexion/puerto").toString();
    m_nombre = settings.value("DatosConexion/usuario").toString();
    m_password = settings.value("DatosConexion/passwd").toString();
    //settings.endGroup();
}

Instancia *MainWindow::obraActual()
{
    return qobject_cast<Instancia*>(ui->tabPrincipal->currentWidget());
}

bool MainWindow::Conectar()
{
    m_db.setDatabaseName(m_basededatos);
    m_db.setUserName(m_nombre);
    m_db.setPort(m_puerto.toInt());
    m_db.setPassword(m_password);
    m_db.setHostName(m_host);

    /*if (m_db.open())
    {
        qDebug()<<"<b>Exito</b>";
        return true; //return m_db.open()
    }
    else
    {
        qDebug()<<"<b>Fracaso</b>";
        return  false;//return m_db.open()
    }*/
    return m_db.open();
}

void MainWindow::ConfigurarDatosConexion()
{
    if (m_d==nullptr)
    {
        m_d = new DialogoDatosConexion(m_db);
    }
    m_d->show();
    if (m_d->exec())
    {
        QStringList l = m_d->LeeDatosConexion();
        foreach (QString s, l )
        {
            qDebug()<<"Leyendo del dialogo: "<<s;
        }
        m_basededatos = l.at(eDatosConexion::BBDD);
        m_nombre = l.at(eDatosConexion::NOMBRE);
        m_puerto = l.at(eDatosConexion::PUERTO);
        m_password = l.at(eDatosConexion::PASSWD);
        m_host = l.at(eDatosConexion::HOST);
        //writeSettings();
        //Conectar();
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
            ImportarBC3 NuevoBC3(registros, obraabierta);
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
    DialogoGestionObras* cuadro = new DialogoGestionObras(m_ListaObrasAbiertas, m_db, this);
    QObject::connect(cuadro,SIGNAL(BorrarObra(QStringList)),this,SLOT(BorrarBBDD(QStringList)));
    //QObject::connect(cuadro,SIGNAL(ActivarBotones(bool)),this,SLOT(ActivarBotonesBasicos(bool)));
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
    qDebug()<<"Borrar BBDD";
    DialogoAdvertenciaBorrarBBDD* d = new DialogoAdvertenciaBorrarBBDD(datosobra, this);
    int res = d->exec();
    if (res==true)//aceptar
    {
        //Mirar si esta abierta
        QMessageBox::StandardButton respuesta;
        foreach (Instancia* nombreobra, m_ListaObrasAbiertas)
        {
            if (nombreobra->LeeTabla() == datosobra.at(0))//si la obra a borrar en la BBDD esta abierta....
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
                else
                {                    
                    ActionCerrar(datosobra.at(0));
                }
            }            
        }
        //exportar a BC3 si se ha elegido la opcion
        if (d->Exportar())
        {
            Exportar(QString(), datosobra.at(0));
        }        
        //Borrar la obra de la BBDD
        QString cadenaborrartablacodigo = "SELECT borrar_obra ('"+datosobra.at(0)+"');";
        qDebug()<<cadenaborrartablacodigo;
        QSqlQuery consulta;
        consulta.exec(cadenaborrartablacodigo);
        return true;
    }
    return false;
}

bool MainWindow::Exportar(QString nombrefichero, QString obra)
{
    qDebug()<<"nombreficero original "<<nombrefichero;
    QString extensionBC3 = ".bc3";
    if (nombrefichero.isEmpty())
    {
        if (obraActual())
        {
            nombrefichero = (obraActual())->LeeTabla();
            qDebug()<<"nombrefichero original 1"<<nombrefichero;
        }
    }
    nombrefichero.append(extensionBC3);
    nombrefichero = QFileDialog::getSaveFileName(this,tr("Guardar BC3"),\
                                                         QDir::homePath()+"/"+nombrefichero,\
                                                         tr("Archivos BC3 (*.bc3)"));
    return GuardarObra(nombrefichero,obra);
}

bool MainWindow::GuardarObra(QString nombreFichero, QString obra)
{
    qDebug()<<"GuardarObra: "<<nombreFichero;
    bool toReturn=false;
    QString extension = nombreFichero.right(nombreFichero.length()-nombreFichero.lastIndexOf('.'));
    if (extension == ".bc3" || extension == ".BC3")
    {
        if (!obra.isEmpty())
        {
            ExportarBC3 exportador(obra,nombreFichero);
        }
        else
        {
            ExportarBC3 exportador((obraActual())->LeeTabla(),nombreFichero);
        }
        qDebug()<<"Guardada la obra "<<nombreFichero<<" con exito";
        toReturn = true;
    }
    if (extension == ".xlsx" || extension == ".XLSX")
    {
        obraActual()->ExportarXLSS(nombreFichero);
        qDebug()<<"Guardando en formato xls";
        toReturn = true;
    }
    if (obraActual() && toReturn == true)
    {
        (obraActual())->Pila()->clear();
    }
    return toReturn;
}

void MainWindow::ActionImprimir()
{   
    qDebug()<<"Current path"<<QDir::currentPath();
    /*QString pathPython = "/.sdmed/python/plugins/";
    QString ruta = QDir::homePath()+pathPython;
    QString pModulo = "plugin_loader";
    QString pFuncion = "iniciar";
    QStringList pArgumentos;*/
    //argumentos
    //primero meto los datos de la conexion
    //pArgumentos<<db.databaseName()<<db.hostName()<<QString::number(db.port())<<db.userName()<<db.password();
    //ahora meto los datos de la obra actual (nombre, padre e hijo)
    /*if (HayObrasAbiertas())
    {
        pArgumentos<<(*obraActual)->LeeTabla();

        if(::PyRun::loadModule(QDir::home().absoluteFilePath(ruta), pModulo, pFuncion, pArgumentos))
        {
            qDebug()<< __PRETTY_FUNCTION__ << "successful";
        }
    }
    else
    {
        QMessageBox::warning(this, tr("Aviso"),
                                       tr("Debe haber alguna obra abierta"),
                                       QMessageBox::Ok);
    }*/
    //int res = ::PyRun::loadModule(QDir::home().absoluteFilePath(ruta),pModulo, pFuncion, pArgumentos);
    //qDebug()<<"Resultado: "<<res<<" "<<QDir::home().absoluteFilePath(ruta);
    //hacer un switch/case con los posibles errores
    DialogoListadoImprimir* d = new DialogoListadoImprimir(obraActual()->LeeTabla(), m_db, this);
    int res = d->exec();    
}

void MainWindow::ActionCerrar(QString nombreobra)
{   
    it = m_ListaObrasAbiertas.begin();
    if (!nombreobra.isNull())
    {
        int indice = 0;
        while ((*it)->LeeTabla() != nombreobra)
        {
            it++;
            indice++;
        }
        delete ui->tabPrincipal->widget(indice);
    }
    else
    {
        while (*it != ui->tabPrincipal->currentWidget())
        {
            it++;
        }
        delete ui->tabPrincipal->currentWidget();
    }
    m_ListaObrasAbiertas.erase(it);
    if (m_ListaObrasAbiertas.empty())
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
    m_db.close();
    writeSettings();
    qApp->quit();
}

void MainWindow::ActionCopiar()
{
    obraActual()->Copiar();
    ui->actionPegar->setEnabled(true);
}

void MainWindow::ActionPegar()
{
    if (HayObrasAbiertas())
    {
        obraActual()->Pegar();
    }
}

void MainWindow::ActionCortar()
{

}

void MainWindow::ActionUndo()
{
    if (HayObrasAbiertas())
    {
        obraActual()->Undo();
    }
}

void MainWindow::ActionRedo()
{
    if (HayObrasAbiertas())
    {
        obraActual()->Redo();
    }
}

void MainWindow::ActionAdelante()
{
    /*if (HayObrasAbiertas())
    {
        (*obraActual)->Mover(movimiento::DERECHA);
    }*/
    Instancia* i = qobject_cast<Instancia*>(ui->tabPrincipal->currentWidget());
    if (i)
    {
        i->Mover(movimiento::DERECHA);
    }
}

void MainWindow::ActionAtras()
{
    /*if (HayObrasAbiertas())
    {
        (*obraActual)->Mover(movimiento::IZQUIERDA);
    }*/
    Instancia* i = qobject_cast<Instancia*>(ui->tabPrincipal->currentWidget());
    if (i)
    {
        i->Mover(movimiento::IZQUIERDA);
    }
}

void MainWindow::ActionInicio()
{
    /*if (HayObrasAbiertas())
    {
        (*obraActual)->Mover(movimiento::INICIO);
    }*/
    Instancia* i = qobject_cast<Instancia*>(ui->tabPrincipal->currentWidget());
    if (i)
    {
        i->Mover(movimiento::INICIO);
    }
}

void MainWindow::ActionVerArbol()
{
    if (HayObrasAbiertas())
    {
        obraActual()->VerArbol();
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
       obraActual()->AjustarPresupuesto();
    }
}

void MainWindow::ActionPropiedadesObra()
{
    if (HayObrasAbiertas())
    {
        DialogoDatosGenerales* d = new DialogoDatosGenerales(obraActual()->LeeTabla(),m_db);
        QObject::connect(d,SIGNAL(CambioCostesIndirectos()),this,SLOT(ActualizarDatosObra()));
        d->exec();
    }
}

void MainWindow::ActionConfigurar()
{
    DialogoConfiguracion* d = new DialogoConfiguracion(m_db, this);
    if (d->exec())
    {
        qDebug()<<"Configurar";
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
    return !m_ListaObrasAbiertas.empty();
}

void MainWindow::CambiarMedCert(int indice)
{
    obraActual()->MostrarDeSegun(indice);
}

void MainWindow::NuevaCertificacion()
{
    obraActual()->AdministrarCertificaciones();
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
    QObject::connect(ui->actionConfigurar,SIGNAL(triggered(bool)),this,SLOT(ActionConfigurar()));
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
    ui->actionImprimir->setEnabled(true);    
    comboMedCert->setEnabled(true);
    botonCertificaciones->setEnabled(true);
    ui->actionVer_Arbol->setEnabled(true);
    ui->tabPrincipal->addTab(NuevaObra,_resumen);
    ui->tabPrincipal->setCurrentIndex(ui->tabPrincipal->currentIndex()+1);
    m_ListaObrasAbiertas.push_back(NuevaObra);
    //obraActual=ListaObras.begin();
    //std::advance(obraActual,ListaObras.size()-1);
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
    if (!m_ListaObrasAbiertas.empty())
    {
        if ((unsigned int)indice<m_ListaObrasAbiertas.size())
        {
            //obraActual=ListaObras.begin();
            //std::advance(obraActual,indice);
            ActivarDesactivarBotonesPila(obraActual()->Pila()->index());
            obraActual()->LeerCertifActual();
        }
    }
}

void MainWindow::ActivarDesactivarBotonesPila(int indice)
{
    //qDebug()<<"ActivarDesactivarBotonesUndoRedo(): "<<indice;
    ui->actionDeshacer->setEnabled(indice!=0);
    ui->actionRehacer->setEnabled(indice<(obraActual())->Pila()->count());
    ui->actionGuardar->setEnabled(indice!=0);
}

void MainWindow::ActivarBotonesBasicos(QSqlDatabase& db)
{
    qDebug()<<"LA base de datos esta "<<db.open();
    ui->actionNuevo->setEnabled(db.open());
    ui->actionImportar->setEnabled(db.open());
    //ui->actionExportar->setEnabled(db.open());
    ui->actionCopiar->setEnabled(db.open());
    ui->menuImportar->setEnabled(db.open());
    ui->menuExportar->setEnabled(db.open());
}

void MainWindow::ActualizarDatosObra()
{
    qDebug()<<"Actualizar en main";
    obraActual()->RefrescarVista();
}
