#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "instancia.h"
#include "./Ficheros/abrirguardarbc3.h"
#include "./Dialogos/dialogoabout.h"
#include "./Dialogos/dialogodatoscodigoresumen.h"
#include "./Dialogos/dialogotablaslistadoobras.h"
#include "./Dialogos/dialogoadvertenciaborrarbbdd.h"
#include <QMessageBox>
#include <QDebug>
#include <QLabel>
#include <QComboBox>
#include <QPushButton>
#include <QUndoStack>
#include <QFileDialog>



MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow)
{
    db= QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("127.0.0.1");
    db.setPort(5432);
    db.setDatabaseName("SDMed");
    db.setUserName("postgres");
    db.setPassword("melo1cotonero");
    if (db.open())
    {
        ui->setupUi(this);
        //seccion ver medicion/certificacion
        labelVerMedCert = new QLabel("Ver:");
        comboMedCert = new QComboBox;
        comboMedCert->addItem(tr("Medición"));
        comboMedCert->addItem(tr("Certificación"));
        comboMedCert->setEnabled(false);//lo inicio desactivado mientras no haya una obra activa
        ui->CertBar->addWidget(labelVerMedCert);
        ui->CertBar->addWidget(comboMedCert);
        //seccion annadir nueva certificacion
        botonNuevaCertificacion = new QPushButton(tr("Añadir Certificación"));
        botonNuevaCertificacion->setEnabled(false);
        ui->CertBar->addWidget(botonNuevaCertificacion);
        //seccion certificacion actual
        labelCertificacionActual = new QLabel(tr("Cert. actual"));
        comboCertificacionActual = new QComboBox;
        ui->CertBar->addWidget(labelCertificacionActual);
        ui->CertBar->addWidget(comboCertificacionActual);
        setupActions();
    }
    else
    {
        QMessageBox::warning(this,"Aviso mortal","No se puede abrir la BBDD");
    }    
}

MainWindow::~MainWindow()
{
    delete ui;
}

QString MainWindow::CodigoBC3(const QString &nombrefichero)
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
}

QList<QList<QVariant>> MainWindow::VerObrasEnBBDD()
{
    QList<QList<QVariant>> listadoobras;
    QList<QVariant> obra;
    QSqlQuery consultacodigos;
    QSqlQuery consultaresumenes;
    QString cadenaconsultacodigos = "SELECT table_name FROM INFORMATION_SCHEMA.TABLES \
            WHERE TABLE_SCHEMA = 'public' AND table_name like '%_Conceptos%';";
    consultacodigos.exec (cadenaconsultacodigos);
    while (consultacodigos.next())
    {
        QString nombrecodigo = consultacodigos.value(0).toString();
        nombrecodigo.remove("_Conceptos");
        QVariant nombrecodigoV(nombrecodigo);
        obra.append(nombrecodigoV);
        QString cadenaconsultaresumen = "SELECT resumen from \"" + \
                consultacodigos.value(0).toString() + "\" WHERE codigo = '" + nombrecodigo + "';";
        consultaresumenes.exec(cadenaconsultaresumen);
        while (consultaresumenes.next())
        {
            obra.append(consultaresumenes.value(0));
        }
        //ahora vemos si la obra esta abierta
        bool obraabierta = false;
        for (auto elem : ListaObras)
        {
            qDebug()<<"Listado de obras abiertas: "<<elem->LeeCodigo()<<"<-->"<<elem->LeeResumen();
            if (nombrecodigo == elem->LeeCodigo())
            {
                obraabierta = true;
            }            
        }
        obra.append(obraabierta);
        obraabierta = false;
        listadoobras.append(obra);
        obra.clear();
    }
    return listadoobras;
}

void MainWindow::ActionNuevo()
{
    DialogoDatosCodigoResumen* cuadro = new DialogoDatosCodigoResumen(this);
    if (cuadro->exec())
    {
        QString cadenaconsulta = "SELECT crear_obra ('" + cuadro->LeeCodigo() + "','" + cuadro->LeeResumen() + "');";
        qDebug()<<"la comsulta es: "<<cadenaconsulta;
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
                foreach (QList<QVariant> l, VerObrasEnBBDD())
                {
                    qDebug()<<l.at(0);
                    if (codigoBC3 == l.at(0).toString())
                    {
                        existecodigo = true;
                    }
                }
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
    QList<QList<QVariant>>ListaObrasenBDD = VerObrasEnBBDD();
    if (ListaObrasenBDD.isEmpty())
    {
        QMessageBox::warning(this, tr("Aviso"),
                                             tr("Actualmente no hay obras en la BBDD"),
                                             QMessageBox::Yes | QMessageBox::Default);
    }
    else
    {
        DialogoTablaListadosObras* cuadro = new DialogoTablaListadosObras(ListaObrasenBDD, this);
        QObject::connect(cuadro,SIGNAL(BorrarObra(QStringList)),this,SLOT(BorrarBBDD(QStringList)));
        if (cuadro->exec())
        {
            foreach (QStringList l, cuadro->listaNombreObrasAbrir())
            {
                AnadirObraAVentanaPrincipal(l.at(0),l.at(1));
            }
        }
        delete cuadro;
    }
    return true;
}

void MainWindow::BorrarBBDD(QStringList datosobra)
{
    DialogoBorrarBBDD* d = new DialogoBorrarBBDD(datosobra, this);
    int res = d->exec();
    if (res==1)//aceptar
    {
        QMessageBox::StandardButton respuesta;
        auto it = ListaObras.begin();
        foreach (Instancia* nombreobra, ListaObras)
        {
            if (nombreobra->LeeCodigo() == datosobra.at(0))
            {
                respuesta = QMessageBox::question(
                            this,
                            tr("Aviso"),
                            tr("La obra esta en uso. ¿Realmente desea continuar?"),
                            QMessageBox::No | QMessageBox::Default,
                            QMessageBox::Yes);
                if (respuesta == QMessageBox::Yes)
                {
                    //primera accion, borrar la obra de la ventana principal
                    obraActual = it;
                    qDebug()<<"leer cifrado "<<(*it)->LeeCodigo();
                    ActionCerrar();
                    //segunda accion, exportar a bc3 si esta seleccionada la accion
                    if (d->Exportar())
                    {
                        ActionGuardarComo();
                        qDebug()<<"se guarda la obra";
                    }
                    //tercera accion, borrar la obra de la BBDD
                    QString cadenaborrartablacodigo = "SELECT borrar_obra ('"+datosobra.at(0)+"');";
                    qDebug()<<cadenaborrartablacodigo;
                    QSqlQuery consulta;
                    consulta.exec(cadenaborrartablacodigo);
                    qDebug()<<sender();
                }
                break;
            }
            std::advance (it,1);
        }
    }
}

bool MainWindow::ActionGuardar()
{

}

bool MainWindow::ActionGuardarComo()
{

}

void MainWindow::ActionCerrar()
{
    if (!ListaObras.empty())
    {
        if (ConfirmarContinuar())
        {
            std::list<Instancia*>::iterator obraBorrar = obraActual;
            {
                qDebug()<<"Borrando la obra actual-> "<<(*obraBorrar)->LeeResumen();
                obraActual = ListaObras.erase(obraActual);
                delete (*obraBorrar);
                if ( obraActual == ListaObras.end() && !ListaObras.empty())
                {
                    obraActual = std::prev(obraActual);
                }
            }
        }
    }
    if (ListaObras.empty())
    {
        ui->actionGuardar->setEnabled(false);
        ui->actionCerrar->setEnabled(false);
        comboMedCert->setEnabled(false);
        botonNuevaCertificacion->setEnabled(false);
        ui->actionVer_Arbol->setEnabled(false);
    }
}

void MainWindow::closeEvent(QCloseEvent* event)
{
    ActionSalir();
    QMainWindow::closeEvent(event);
}

void MainWindow::ActionSalir()
{
    qApp->quit();
}

void MainWindow::ActionCopiar()
{
    qDebug()<<"Borrar en el sitpo equivocado";
}

void MainWindow::ActionPegar()
{

}

void MainWindow::ActionCortar()
{

}

void MainWindow::ActionUndo()
{

}

void MainWindow::ActionRedo()
{

}

void MainWindow::ActionAdelante()
{

}

void MainWindow::ActionAtras()
{

}

void MainWindow::ActionInicio()
{
    if (HayObra())
    {
        (*obraActual)->IrAInicio();
    }
}

void MainWindow::ActionVerArbol()
{

}

void MainWindow::ActionSeleccionarTodo()
{

}

void MainWindow::ActionDeseleccionarTodo()
{

}

void MainWindow::ActionAjustarPresupuesto()
{

}

void MainWindow::AcercaDe()
{
    qDebug()<<"acerca de ";
    DialogoAbout *d = new DialogoAbout(this);
    d->show();
}

void MainWindow::AcercaDeQt()
{
    QMessageBox::aboutQt(this);
}

bool MainWindow::HayObra()
{
    return !ListaObras.empty();
}

void MainWindow::CambiarMedCert(int indice)
{
    (*obraActual)->MostrarDeSegun(indice);
}

bool MainWindow::ConfirmarContinuar()
{
    if ((*obraActual)->Pila()->index()>0)
    {
        QString cadena = tr("La obra  <b>%1</b> ha sido modificada.<br>¿Quieres guardar los cambios?").arg((*obraActual)->LeeResumen());
        int r = QMessageBox::warning(this, tr("SDMed2"),
                                     cadena,
                                     QMessageBox::Yes | QMessageBox::Default,
                                     QMessageBox::No,
                                     QMessageBox::Cancel | QMessageBox::Escape);
        if (r == QMessageBox::Yes)
        {
            return ActionGuardar();
        }
        else if (r == QMessageBox::Cancel)
        {
            return false;
        }
    }
    return true;
}

void MainWindow::setupActions()
{
    QObject::connect(ui->actionNuevo,SIGNAL(triggered(bool)),this,SLOT(ActionNuevo()));
    QObject::connect(ui->actionImportar,SIGNAL(triggered(bool)),this,SLOT(ActionImportar()));
    QObject::connect(ui->actionAbrirBBDD,SIGNAL(triggered(bool)),this,SLOT(ActionAbrirBBDD()));
    QObject::connect(ui->actionCerrar,SIGNAL(triggered(bool)),this,SLOT(ActionCerrar()));
    QObject::connect(ui->actionGuardar,SIGNAL(triggered(bool)),this,SLOT(ActionGuardar()));
    QObject::connect(ui->actionGuardar_como,SIGNAL(triggered(bool)),this,SLOT(ActionGuardarComo()));
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
    //QObject::connect(botonNuevaCertificacion,SIGNAL(pressed()),this,SLOT(NuevaCertificacion()));
    //QObject::connect(comboCertificacionActual,SIGNAL(currentIndexChanged(int)),this,SLOT(CambiarCertificacionActual(int)));
}


void MainWindow::AnadirObraAVentanaPrincipal(QString _codigo, QString _resumen)
{
    /*QObject::connect(nuevaobra.miobra,SIGNAL(CopiarP()),this,SLOT(ActionCopiar()));
    QObject::connect(nuevaobra.miobra,SIGNAL(PegarP()),this,SLOT(ActionPegar()));
    QObject::connect(nuevaobra.miobra,SIGNAL(CopiarM()),this,SLOT(ActionCopiar()));
    QObject::connect(nuevaobra.miobra,SIGNAL(PegarM()),this,SLOT(ActionPegar()));
    QObject::connect(nuevaobra.miobra,SIGNAL(ActivarBoton(int)),this,SLOT(ActivarDesactivarBotonesPila(int)));*/
    Instancia* NuevaObra =new Instancia(_codigo,_resumen);
    ui->actionGuardar->setEnabled(true);
    ui->actionCerrar->setEnabled(true);
    comboMedCert->setEnabled(true);
    botonNuevaCertificacion->setEnabled(true);
    ui->actionVer_Arbol->setEnabled(true);
    ui->tabPrincipal->addTab(NuevaObra,_resumen);
    ui->tabPrincipal->setCurrentIndex(ui->tabPrincipal->currentIndex()+1);
    ListaObras.push_back(NuevaObra);
    obraActual=ListaObras.begin();
    std::advance(obraActual,ListaObras.size()-1);
    //ActivarDesactivarBotonesPila(obraActual->miobra->Pila()->index());
    QString leyenda = QString(tr("Creada la obra %1").arg(_resumen));
    statusBar()->showMessage(leyenda,5000);
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
