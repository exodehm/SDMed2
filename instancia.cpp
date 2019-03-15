#include "instancia.h"
#include "consultas.h"

#include "./Modelos/Modelobase.h"
#include "./Modelos/PrincipalModel.h"
#include "./Modelos/MedicionModel.h"
#include "./Modelos/TreeModel.h"

#include "./Tablas/tablaprincipal.h"
#include "./Tablas/tablacert.h"
#include "./Editor/editor.h"
#include "./Tablas/vistaarbol.h"

#include "./defs.h"

#include "./Undo/undoeditarprincipal.h"

#include "./Dialogos/dialogocertificaciones.h"

#include <QDebug>
#include <QHeaderView>
#include <QKeyEvent>
#include <QClipboard>
#include <QMimeData>
#include <QTextStream>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QSplitter>
#include <QPushButton>
#include <QTabWidget>
#include <QUndoStack>
#include <QMessageBox>

Instancia::Instancia(QString cod, QString res, QWidget *parent):tabla(cod),resumen(res),QWidget(parent)
{
    codigopadre ="";
    codigohijo = cod;
    ruta<<codigopadre<<codigohijo;
    pila = new QUndoStack(this);    
    GenerarUI();
}

Instancia::~Instancia()
{   
    delete modeloTablaP;
    delete modeloTablaMed;
    delete modeloTablaCert;
    delete modeloArbol;
    delete editor;
    QString cadenaborrarobra = "SELECT cerrar_tablas_auxiliares('"+tabla+"');";
    consulta.exec(cadenaborrarobra);
}

void Instancia::GenerarUI()
{
    lienzoGlobal = new QVBoxLayout(this);
    separadorPrincipal = new QSplitter(Qt::Horizontal);

    //arbol
    modeloArbol = new TreeModel(tabla, pila);
    arbol = new VistaArbol;
    arbol->setModel(modeloArbol);
    arbol->setVisible(false);
    separadorTablas = new QSplitter(Qt::Vertical);

    //tabla principal
    modeloTablaP = new PrincipalModel(tabla, codigopadre, codigohijo, pila);
    tablaPrincipal = new TablaPrincipal(modeloTablaP->columnCount(QModelIndex()));
    tablaPrincipal->setObjectName("TablaP");
    tablaPrincipal->setModel(modeloTablaP);
    separadorTablas->addWidget(tablaPrincipal);

    //tabla mediciones
    modeloTablaMed = new MedicionModel(tabla, codigopadre, codigohijo, tipoTablaMedCert::MEDICION, pila);
    tablaMediciones = new TablaMed(modeloTablaMed->columnCount(QModelIndex()));
    tablaMediciones->setObjectName("TablaMC");
    tablaMediciones->setModel(modeloTablaMed);
    //en principio las columnas de id u pos es para uso interno, así que no la muestro (la id es la id de la tabla de mediciones)
    tablaMediciones->setColumnHidden(tipoColumnaTMedCert::ID,true);
    tablaMediciones->setColumnHidden(tipoColumnaTMedCert::POSICION,true);

    //tabla certificaciones
    modeloTablaCert = new MedicionModel(tabla, codigopadre, codigohijo, tipoTablaMedCert::CERTIFICACION, pila);
    tablaCertificaciones =  new TablaCert(modeloTablaCert->columnCount(QModelIndex()));
    tablaCertificaciones->setModel(modeloTablaCert);
    //igual pasa con las id de la tabla de certificaciones
    tablaCertificaciones->setColumnHidden(tipoColumnaTMedCert::ID,true);
    tablaCertificaciones->setColumnHidden(tipoColumnaTMedCert::POSICION,true);
    //por ultimo la dejo inutilizada hasta que no haya al menos unas certificacion definida
    //tablaCertificaciones->setEnabled(false);
    tablaCertificaciones->setEnabled(HayCertificacion());

    //tab para las tablas de mediciones y certificaciones
    separadorTablasMedicion = new QTabWidget;
    separadorTablasMedicion->addTab(tablaMediciones,QString(tr("Medicion")));
    separadorTablasMedicion->addTab(tablaCertificaciones,QString(tr("Certificacion")));
    separadorTablas->addWidget(separadorTablasMedicion);

    //editor
    editor = new Editor;//(separadorTablas);
    editor->EscribirRuta(ruta);
    separadorTablas->addWidget(editor);

    //añado el separador al layout
    separadorPrincipal->addWidget(separadorTablas);
    separadorPrincipal->addWidget(arbol);
    lienzoGlobal->addWidget(separadorPrincipal);

    //vista de arbol
    arbol->expandAll();
    arbol->resizeColumnToContents(tipoColumnaTPrincipal::CODIGO);
    arbol->resizeColumnToContents(tipoColumnaTPrincipal::NATURALEZA);
    arbol->resizeColumnToContents(tipoColumnaTPrincipal::UD);
    arbol->resizeColumnToContents(tipoColumnaTPrincipal::RESUMEN);
    arbol->resizeColumnToContents(tipoColumnaTPrincipal::IMPPRES);

    RefrescarVista();
    MostrarDeSegun(0);
    certActual = LeerCertifActual();
    ActualizarCertificacionEnModelo();

    /************signals y slots*****************/
    QObject::connect(tablaPrincipal,SIGNAL(doubleClicked(QModelIndex)),this,SLOT(BajarNivel()));
    QObject::connect(tablaPrincipal->CabeceraDeTabla(),SIGNAL(sectionDoubleClicked(int)),this,SLOT(SubirNivel()));   
    QObject::connect(tablaPrincipal,SIGNAL(Copiar()),this,SLOT(Copiar()));
    QObject::connect(tablaMediciones,SIGNAL(Copiar()),this,SLOT(Copiar()));
    QObject::connect(tablaPrincipal,SIGNAL(Pegar()),this,SLOT(Pegar()));
    QObject::connect(tablaMediciones,SIGNAL(Pegar()),this,SLOT(Pegar()));

    QObject::connect(tablaMediciones,SIGNAL(CertificarLineasMedicion()),this,SLOT(Certificar()));
    //QObject::connect(separadorTablasMedicion,SIGNAL(currentChanged(int)),this,SLOT(CambiarEntreMedicionYCertificacion(int)));
    QObject::connect(pila,SIGNAL(indexChanged(int)),this,SLOT(ActivarDesactivarUndoRedo(int)));
    QObject::connect(pila,SIGNAL(indexChanged(int)),this,SLOT(RefrescarVista()));
    QObject::connect(arbol,SIGNAL(clicked(QModelIndex)),this,SLOT(SincronizarArbolTablal()));
}

const QString& Instancia::LeeTabla() const
{
    return tabla;
}

const QString& Instancia::LeeResumen() const
{
    return resumen;
}

QStringList Instancia::LeerCertifActual()
{
    QString leercertificacionactual = "SELECT * FROM leer_certificacion_actual('"+tabla+"')";
    qDebug()<<leercertificacionactual;
    consulta.exec(leercertificacionactual);
    certActual.clear();
    while (consulta.next())
    {
        certActual<<consulta.value(0).toString()<<consulta.value(1).toString();
    }
    qDebug()<<"CertACtual = "<<certActual.at(0)<<"<-->"<<certActual.at(1);
    emit CambiarLabelCertActual(certActual);
    return certActual;
}

bool Instancia::HayCertificacion()
{
    QString cadenahaycertificacion = "SELECT hay_certificacion('"+tabla+"')";
    qDebug()<<cadenahaycertificacion;
    consulta.exec(cadenahaycertificacion);
    while (consulta.next())
    {        
        return consulta.value(0).toBool();
    }
    return false;
}

void Instancia::ActualizarCertificacionEnModelo()
{
    MedicionModel* m = qobject_cast<MedicionModel*>(modeloTablaCert);
    if (m)
    {
        qDebug()<<"Actualizar a: "<<certActual.at(0)<<"--"<<certActual.at(1);
        m->CambiaCertificacionActual(certActual.at(0).toInt());
    }
}

QUndoStack* Instancia::Pila()
{
    return pila;
}

void Instancia::MostrarDeSegun(int indice)
{
    bool verCertificacion;
    if (indice==0)
    {
        verCertificacion=true;
    }
    else
    {
        verCertificacion=false;
    }
    tablaPrincipal->setColumnHidden(tipoColumnaTPrincipal::CANCERT,verCertificacion);
    tablaPrincipal->setColumnHidden(tipoColumnaTPrincipal::PORCERTPRES,verCertificacion);
    tablaPrincipal->setColumnHidden(tipoColumnaTPrincipal::PRCERT,verCertificacion);
    tablaPrincipal->setColumnHidden(tipoColumnaTPrincipal::IMPCERT,verCertificacion);
}

void Instancia::SubirNivel()
{
    Mover(movimiento::ARRIBA);
}

void Instancia::BajarNivel()
{
    Mover(movimiento::ABAJO);
}

void Instancia::Mover(int tipomovimiento)
{
    GuardarTextoPartida();
    QString cadenamover;
    switch (tipomovimiento)
    {
    case movimiento::INICIO:
    {
        codigopadre="";
        codigohijo =tabla;
        ruta.clear();
        ruta<<codigopadre<<codigohijo;
        break;
    }
    case movimiento::ARRIBA:
    {
        if (!codigopadre.isEmpty())
        {
            {
                ruta.pop_back();
                codigohijo = codigopadre;
                codigopadre = ruta.at(ruta.size()-2);
            }
        }
        break;
    }
    case movimiento::ABAJO:
    {
        QString cod = tablaPrincipal->model()->index(tablaPrincipal->currentIndex().row(),0).data().toString();
        if (!cod.isEmpty())
        {
            codigopadre=codigohijo;
            codigohijo = cod;
            ruta.append(codigohijo);
        }
        break;
    }
    case movimiento::DERECHA:
    {
        ruta.pop_back();
        cadenamover = "SELECT ver_siguiente('"+ tabla + "','"+ codigopadre + "','"+ codigohijo+"')";
        consulta.exec(cadenamover);
        while (consulta.next())
        {
            codigohijo = consulta.value(0).toString();
        }
        ruta.append(codigohijo);
        break;
    }
    case movimiento::IZQUIERDA:
    {
        ruta.pop_back();
        cadenamover = "SELECT ver_anterior('"+ tabla + "','"+ codigopadre + "','"+ codigohijo+"')";
        consulta.exec(cadenamover);
        while (consulta.next())
        {
            codigohijo = consulta.value(0).toString();
        }
        ruta.append(codigohijo);
        break;
    }
    default:
        break;
    }
    tablaPrincipal->clearSelection();
    RefrescarVista();
}

void Instancia::VerArbol()
{
    arbol->setVisible(!arbol->isVisible());
}

void Instancia::TablaSeleccionarTodo(QWidget* widgetactivo)
{
    TablaBase* tabla = qobject_cast<TablaBase*>(widgetactivo);
    if (tabla)
    {
        tabla->selectAll();
    }
}

void Instancia::TablaDeseleccionarTodo(QWidget* widgetactivo)
{
    TablaBase* tabla = qobject_cast<TablaBase*>(widgetactivo);
    if (tabla)
    {
        tabla->clearSelection();
    }
}

void Instancia::Undo()
{
    pila->undo();
}

void Instancia::Redo()
{
    pila->redo();
}

void Instancia::RefrescarVista()
{
    modeloTablaP->ActualizarDatos(codigopadre, codigohijo);
    modeloTablaMed->ActualizarDatos(codigopadre,codigohijo);
    modeloTablaCert->ActualizarDatos(codigopadre, codigohijo);
    //modeloArbol->ActualizarDatos(tabla);
    /*modeloTablaP->QuitarIndicadorFilaVacia();
    if (modeloTablaP->rowCount(QModelIndex())==0)
    {
        modeloTablaP->insertRow(0);
    }*/    
    EscribirTexto();
    editor->EscribirRuta(ruta);
    //editor->Formatear();
    GuardarTextoPartidaInicial();
    modeloTablaP->layoutChanged();
    modeloTablaMed->layoutChanged();
    tablaPrincipal->resizeColumnsToContents();
    tablaMediciones->resizeColumnsToContents();
    tablaCertificaciones->resizeColumnsToContents();
    modeloTablaCert->layoutChanged();
    //tablaPrincipal->setCurrentIndex(indiceActual);
    separadorTablasMedicion->setVisible(modeloTablaP->EsPartida());//solo se ve si es partida(Nat == 7)
    /*modeloArbol->layoutChanged();
    arbol->expandAll();
    arbol->resizeColumnToContents(tipoColumna::CODIGO);
    arbol->resizeColumnToContents(tipoColumna::NATURALEZA);
    arbol->resizeColumnToContents(tipoColumna::UD);
    arbol->resizeColumnToContents(tipoColumna::RESUMEN);*/
}

void Instancia::Copiar()
{
    QWidget* w = qApp->focusWidget();
    TablaBase* tabla = qobject_cast<TablaBase*>(w);
    if(tabla)
    {
        QModelIndex indice = tabla->currentIndex();
        if (tabla->selectionModel()->isRowSelected(indice.row(),QModelIndex()))//si hay alguna fila seleccionada
        {
            QModelIndexList indices = tabla->selectionModel()->selectedIndexes();
            QList<int> listaIndices;
            foreach (QModelIndex i, indices)
            {
                if (!listaIndices.contains(i.row()))
                    listaIndices.append(i.row());
            }
            qSort(listaIndices);
            for (auto elem:listaIndices)
                qDebug()<<"Copiar los indices: "<<elem;
            qDebug()<<tabla->model();            
            ModeloBase* modelo = qobject_cast<ModeloBase*>(tabla->model());
            if (modelo)
            {
                modelo->Copiar(listaIndices);
            }
            CopiarElementosTablaPortapapeles(indices, tabla);
            tabla->selectionModel()->clearSelection();
        }         
    }
}

void Instancia::Pegar()
{
    QWidget* w = qApp->focusWidget();
    TablaBase* tabla = qobject_cast<TablaBase*>(w);
    if(tabla)
    {
        QModelIndex indice = tabla->currentIndex();
        int fila = indice.row();
        ModeloBase* modelo = qobject_cast<ModeloBase*>(tabla->model());
        if (modelo)
        {
            modelo->Pegar(fila);
        }
    }
}

void Instancia::EscribirTexto()
{
    QString cadenavertexto = "SELECT ver_texto('" + tabla + "','" + codigohijo+"');";
    qDebug()<<cadenavertexto;
    consulta.exec(cadenavertexto);
    QString descripcion;
    while (consulta.next())
    {
        descripcion = consulta.value(0).toString();
    }
    editor->EscribeTexto(descripcion);
}

void Instancia::GuardarTextoPartidaInicial()
{
    //qDebug()<<"textoPartidaActual"<<textoPartidaInicial;
    textoPartidaInicial = editor->LeeContenidoConFormato();
}

void Instancia::GuardarTextoPartida()
{
    //qDebug()<<"Fucnion GuardarTextoPArtida()"<<editor->LeeContenido();
    if (editor->HayCambios())
    {
        QString cadenaundo = ("Cambiar texto de partida a " + editor->LeeContenido());
        //qDebug()<<cadenaundo;
        pila->push(new UndoEditarTexto(tabla, codigopadre, codigohijo, textoPartidaInicial,editor->LeeContenidoConFormato(),QVariant(cadenaundo)));
    }
}

void Instancia::SincronizarArbolTablal()
{
    TreeItem * mi_item = static_cast<TreeItem*>(arbol->currentIndex().internalPointer());
    if (mi_item && mi_item->parentItem()!=nullptr)
    {
        codigohijo = mi_item->data(0).toString();
        ruta.clear();
        ruta.append(codigohijo);
        //evito la cabecera del arbol que no forma parte de la estructura de datos y la susituyo por una cadena nula
        if (mi_item->parentItem()->parentItem()!=nullptr)
        {
            codigopadre = mi_item->parentItem()->data(0).toString();
        }
        else
        {
            codigopadre = "";
        }
        while (mi_item->parentItem()!= nullptr)
        {
            if (mi_item->parentItem()->parentItem()!=nullptr)
            {
                ruta.push_front(mi_item->parentItem()->data(0).toString());
            }
            else
            {
                ruta.push_front("");
            }
            mi_item = mi_item->parentItem();
        }
        RefrescarVista();
    }
}

void Instancia::CopiarMedicionTablaM()
{
    //emit CopiarM();
    qDebug()<<"Copiar partidas M en instancia";
}

void Instancia::CopiarElementosTablaPortapapeles(const QModelIndexList &lista, TablaBase *tabla)
{   
    QString textoACopiar;
    for(int i = 0; i < lista.size(); i++)
    {
        //if (i!=0 && (i-10)%10!=0 && (i-9)%9!=0) //excluyo de los datos a copiar la primera y ultima columna (Fase e Id)
        {
            QModelIndex index = lista.at(i);
            textoACopiar.append(tabla->model()->data(index).toString());
            textoACopiar.append('\t');
        }
    }
    //textoACopiar.replace(",",".");
    int i=0, n=0;
    while (i<textoACopiar.size())
    {
        if (textoACopiar.at(i)=='\t')
        {
            n++;
        }
        if (n==11)
        {
            textoACopiar.replace(i,1,'\n');
            n=0;
        }
        i++;
    }
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->setText(textoACopiar);
}

void Instancia::AnadirCertificacion()
{
    DialogoCertificaciones d(tabla);
    if (d.exec())
    {
        certActual = d.CertificacionActual();
        tablaCertificaciones->setEnabled(true);
        QString cadenainsertarcertificacion = "SELECT crear_tabla_certificaciones('"+tabla+"')";
        consulta.exec(cadenainsertarcertificacion);
        ActualizarCertificacionEnModelo();
        emit CambiarLabelCertActual(certActual);
    }
}

void Instancia::PegarPartidasTablaP()
{
    emit PegarP();
}

void Instancia::PegarMedicionTablaM()
{
    emit PegarM();
}

void Instancia::ActivarDesactivarUndoRedo(int indice)
{
    ActivarBoton(indice);
}

/*void Instancia::AjustarPresupuesto(float cantidades[2])
{
    pila->push(new UndoAjustarPresupuesto(O,cantidades));
}*/

void Instancia::Certificar()
{
    if (HayCertificacion())
    {
        qDebug()<<"Certif actual"<<certActual.at(0);
        QWidget* w = qApp->focusWidget();
        TablaMed* tabla = qobject_cast<TablaMed*>(w);
        if(tabla)
        {
            QModelIndex indice = tabla->currentIndex();
            if (tabla->selectionModel()->isRowSelected(indice.row(),QModelIndex()))//si hay alguna fila seleccionada
            {
                QModelIndexList indices = tabla->selectionModel()->selectedIndexes();
                QList<int> listaIndices;
                foreach (QModelIndex i, indices)
                {
                    if (!listaIndices.contains(i.row()))
                        listaIndices.append(i.row());
                }
                qSort(listaIndices);
                /*MedicionModel* modelo = qobject_cast<MedicionModel*>(modeloTablaCert);
            if (modelo)
            {
                modelo->Certificar(listaIndices,certActual.at(0));
            }*/
                modeloTablaMed->Certificar(listaIndices,certActual.at(0));
                tabla->selectionModel()->clearSelection();
            }
        }
    }
    else
    {
        QMessageBox::warning(this, tr("Aviso"),
                             tr("No hay certificación activa"),
                             QMessageBox::Ok);
    }
}
