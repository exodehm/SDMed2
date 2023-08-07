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

//#include "./Ficheros/exportarXLS.h"

#include "./Undo/undoeditarprincipal.h"
#include "./Undo/undoajustar.h"

#include "./Dialogos/dialogocertificaciones.h"
#include "./Dialogos/dialogoajustar.h"

#include "./miundostack.h"

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
#include <QMessageBox>
#include <QSqlRecord>
#include <QWidget>

#include <algorithm>

Instancia::Instancia(QString cod, QString res, QWidget *parent):QWidget(parent), m_tabla(cod), m_resumen(res)
{
    m_codigopadre ="";
    m_codigohijo = cod;
    m_ruta<<m_codigopadre<<m_codigohijo;
    m_tablamedcertactiva=0;
    m_pila = new MiUndoStack(this);
    GenerarUI();
}

Instancia::~Instancia()
{
    delete modeloArbol;
    delete m_editor;
    QString cadenaborrarobra = "SELECT cerrar_tablas_auxiliares('"+m_tabla+"');";
    m_consulta.exec(cadenaborrarobra);
}

void Instancia::GenerarUI()
{
    lienzoGlobal = new QVBoxLayout(this);
    separadorPrincipal = new QSplitter(Qt::Horizontal);

    //arbol
    modeloArbol = new TreeModel(m_tabla, m_pila);
    m_arbol = new VistaArbol;
    m_arbol->setModel(modeloArbol);
    m_arbol->setVisible(false);
    separadorTablas = new QSplitter(Qt::Vertical);

    const QSize BUTTON_SIZE = QSize(25, 25);
    m_Maximizado = false;
    //tabla principal
    m_PanelTablaP = new QWidget;
    m_botoneraTablaPrincipal =  new QHBoxLayout;        
    m_IconMax = new QIcon(":/images/maximizar.png");
    m_IconMin = new QIcon(":/images/minimizar.png");
    m_BtnmaxminTablaP = new QPushButton;
    m_BtnmaxminTablaP->setIcon(*m_IconMax);
    m_BtnmaxminTablaP->setIconSize(QSize(18,18));
    m_BtnmaxminTablaP->setMaximumSize(BUTTON_SIZE);
    m_BtnmaxminTablaP->setObjectName("BtnP");
    QObject::connect(m_BtnmaxminTablaP,SIGNAL(clicked(bool)),this,SLOT(MaxMinPanel()));

    m_botoneraTablaPrincipal->addStretch();
    m_botoneraTablaPrincipal->addWidget(m_BtnmaxminTablaP);

    m_lienzoTablaPrincipal = new QVBoxLayout;
    tablaPrincipal = new TablaPrincipal(m_tabla, m_ruta, m_pila);
    m_lienzoTablaPrincipal->addLayout(m_botoneraTablaPrincipal);
    m_lienzoTablaPrincipal->addWidget(tablaPrincipal);
    m_PanelTablaP->setLayout(m_lienzoTablaPrincipal);
    separadorTablas->addWidget(m_PanelTablaP);

    //tablas medicion y certificacion
    m_PanelTablasMC = new QWidget;
    m_botoneraTablaMediciones = new QHBoxLayout;
    m_BtnmaxminTablaMC = new QPushButton;
    m_BtnmaxminTablaMC->setIcon(*m_IconMax);
    m_BtnmaxminTablaMC->setIconSize(QSize(18,18));
    m_BtnmaxminTablaMC->setMaximumSize(BUTTON_SIZE);
    m_BtnmaxminTablaMC->setObjectName("BtnMC");
    QObject::connect(m_BtnmaxminTablaMC,SIGNAL(clicked(bool)),this,SLOT(MaxMinPanel()));
    m_botoneraTablaMediciones->addStretch();
    m_botoneraTablaMediciones->addWidget(m_BtnmaxminTablaMC);

    m_TabWidgetTablasMedCert = new QTabWidget;
    m_lienzoTablaMediciones = new QVBoxLayout;
    m_lienzoTablaMediciones->addLayout(m_botoneraTablaMediciones);
    m_lienzoTablaMediciones->addWidget(m_TabWidgetTablasMedCert);
    m_PanelTablasMC->setLayout(m_lienzoTablaMediciones);
    separadorTablas->addWidget(m_PanelTablasMC);

    //separadorTablas->addWidget(separadorTablasMedCert);
    //Tabla Medicion
    InsertarTablaMedCert(0);//0 es la tabla de mediciones
    //Tablas de certificacion
    QString cadenalistadocertificaciones = "SELECT * FROM ver_certificaciones('"+ m_tabla + "');";
    m_consulta.exec(cadenalistadocertificaciones);
    while (m_consulta.next())
    {
     InsertarTablaMedCert(m_consulta.value(0).toInt());
    }
    //ultimo elemento del tab. Un boton para añadir mas certificaciones
    QIcon icono (":/images/plus.png");
    QPushButton* buton = new QPushButton(icono,"");
    buton->setFlat(true);
    buton->setToolTip(tr("Añadir certificacion"));
    QObject::connect(buton,SIGNAL(clicked(bool)),this,SLOT(AdministrarCertificaciones()));
    m_TabWidgetTablasMedCert->addTab(buton,icono,"");    
    //separadorTablas->addWidget(separadorTablasMedCert);

    //editor
    m_editor = new Editor;//(separadorTablas);
    m_editor->EscribirRuta(m_ruta);
    separadorTablas->addWidget(m_editor);

    //añado el separador al layout
    separadorPrincipal->addWidget(separadorTablas);
    separadorPrincipal->addWidget(m_arbol);
    lienzoGlobal->addWidget(separadorPrincipal);

    //vista de arbol
    m_arbol->expandAll();
    m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::CODIGO);
    m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::NATURALEZA);
    m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::UD);
    m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::RESUMEN);
    m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::IMPPRES);
    RefrescarVista();
    //tablaPrincipal->resizeColumnsToContents();
    MostrarDeSegun(0);
    m_certActual = LeerCertifActual();
    ActualizarCertificacionEnModelo();

    /************signals y slots*****************/
    QObject::connect(tablaPrincipal,SIGNAL(doubleClicked(QModelIndex)),this,SLOT(BajarNivel()));
    QObject::connect(tablaPrincipal->CabeceraDeTabla(),SIGNAL(sectionDoubleClicked(int)),this,SLOT(SubirNivel()));   
    QObject::connect(tablaPrincipal,SIGNAL(Copiar()),this,SLOT(Copiar()));
    QObject::connect(tablaPrincipal,SIGNAL(Pegar()),this,SLOT(Pegar()));
    //QObject::connect(tablaMediciones,SIGNAL(CertificarLineasMedicion()),this,SLOT(Certificar()));
    QObject::connect(m_TabWidgetTablasMedCert,SIGNAL(currentChanged(int)),this,SLOT(ActualizarTablaMedCertActiva(int)));
    QObject::connect(m_pila,SIGNAL(indexChanged(int)),this,SLOT(ActivarDesactivarUndoRedo(int)));
    QObject::connect(m_pila,SIGNAL(indexChanged(int)),this,SLOT(RefrescarVista()));
    QObject::connect(m_arbol,SIGNAL(clicked(QModelIndex)),this,SLOT(SincronizarArbolTablal()));
}

const QString& Instancia::LeeTabla() const
{
    return m_tabla;
}

const QString& Instancia::LeeResumen() const
{
    return m_resumen;
}

void Instancia::CambiarCodigoObra(const QString &nuevocodigo)
{
    m_tabla = nuevocodigo;
}

double Instancia::LeePrecio(const QString &codigo)
{
    QString leerpreciodecodigo = "SELECT * FROM ver_precio('"+m_tabla+"','"+codigo+"')";
    qDebug()<<leerpreciodecodigo;
    m_consulta.exec(leerpreciodecodigo);
    double preciodecodigo=0;
    while (m_consulta.next())
    {
        preciodecodigo = m_consulta.value(0).toDouble();
    }
    return preciodecodigo;
}

QStringList Instancia::LeerCertifActual()
{
    QString leercertificacionactual = "SELECT * FROM ver_certificacion_actual('"+m_tabla+"')";
    qDebug()<<leercertificacionactual;
    m_consulta.exec(leercertificacionactual);
    m_certActual.clear();
    while (m_consulta.next())
    {
        m_certActual<<m_consulta.value(0).toString()<<m_consulta.value(1).toString();
    }
    qDebug()<<"CertACtual = "<<m_certActual.at(0)<<"<-->"<<m_certActual.at(1);
    emit CambiarLabelCertActual(m_certActual);
    return m_certActual;
}

bool Instancia::HayCertificacion()
{
    QString cadenahaycertificacion = "SELECT hay_certificacion('"+m_tabla+"')";
    qDebug()<<cadenahaycertificacion;
    m_consulta.exec(cadenahaycertificacion);
    while (m_consulta.next())
    {        
        return m_consulta.value(0).toBool();
    }
    return false;
}

void Instancia::ActualizarCertificacionEnModelo()
{
    /*MedicionModel* m = qobject_cast<MedicionModel*>(modeloTablaCert);
    if (m)
    {
        qDebug()<<"Actualizar a: "<<certActual.at(0)<<"--"<<certActual.at(1);
        m->CambiaCertificacionActual(certActual.at(0).toInt());
    }*/
}

void Instancia::InsertarTablaMedCert(int num_certif)
{
    qDebug()<<"Insertar tabla en la pos "<<num_certif;
    TablaBase* tablaMC;
    if (num_certif == 0)//tabla de medicion
    {
        tablaMC = new TablaMed(m_tabla, m_ruta, num_certif, m_pila);
        tablaMC->setObjectName(tr("Mediciones"));
        QObject::connect(tablaMC,SIGNAL(CertificarLineasMedicion()),this,SLOT(Certificar()));
    }
    else
    {
        tablaMC = new TablaCert(m_tabla, m_ruta, num_certif, m_pila);
        tablaMC->setObjectName(tr("Certificación nº ")+QString::number(num_certif));
    }
    QObject::connect(tablaMC,SIGNAL(Copiar()),this,SLOT(Copiar()));
    QObject::connect(tablaMC,SIGNAL(Pegar()),this,SLOT(Pegar()));
    Listadotablasmedcert.append(tablaMC);
    m_TabWidgetTablasMedCert->insertTab(num_certif,tablaMC,tablaMC->objectName());
}

void Instancia::ExportarXLSS(QString nombreFichero)
{
    qDebug()<<"exortat xls";
    QString cadenaconsulta = "WITH RECURSIVE tree AS(\
            SELECT codpadre, codhijo, canpres, cancert, 1 AS depth, cast(posicion as text) as camino,posicion from \"PRUEBASCOMP_Relacion\"\
            WHERE codpadre is NULL\
            UNION ALL\
            SELECT rel.codpadre, rel.codhijo, rel.canpres, rel.cancert, depth+1, camino || '.' || cast(rel.posicion as text) , rel.posicion\
            FROM \"PRUEBASCOMP_Relacion\" rel\
            JOIN tree t ON rel.codpadre = t.codhijo\
            )\
            SELECT C.codigo, C.naturaleza, C.ud, C.resumen,tree.canpres,tree.cancert, C.preciocert/C.preciomed AS \"Porcerntaje\", \
            C.preciomed, C.preciocert, C.preciomed*tree.canpres as \"Importe presupuesto\", C.preciocert*tree.cancert as \"Importe certifi.\", tree.depth \
            FROM tree, \"PRUEBASCOMP_Conceptos\" AS C \
            WHERE C.codigo=tree.codhijo \
            ORDER BY camino;";
    m_consulta.exec(cadenaconsulta);
    QSqlRecord rec = m_consulta.record();
    qDebug()<<cadenaconsulta;
    QList<QList<QString>> tabladatos;
    while (m_consulta.next())
    {
        QList<QString>fila;
        for (int i=0;i<rec.count();i++)
        {
            fila.append(m_consulta.value(i).toString());
        }
        tabladatos.append(fila);
        fila.clear();
    }
    /*for (int i = 0;i<consulta.size();i++)
    {
        for (int j=0;j<rec.count();j++)
        {
            qDebug()<<tabladatos.at(i).at(j);
        }
    }*/
    //XLS::crearFuncion(nombreFichero,tabladatos);
    //ExportarXLS exportador(tabla.toUtf8().constData(),nombreFichero.toUtf8().constData(),consulta);
}

MiUndoStack *Instancia::Pila()
{
    return m_pila;
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
        m_codigopadre="";
        m_codigohijo =m_tabla;
        m_ruta.clear();
        m_ruta<<m_codigopadre<<m_codigohijo;
        break;
    }
    case movimiento::ARRIBA:
    {
        if (!m_codigopadre.isEmpty())
        {
            {
                m_ruta.pop_back();
                m_codigohijo = m_codigopadre;
                m_codigopadre = m_ruta.at(m_ruta.size()-2);
            }
        }
        break;
    }
    case movimiento::ABAJO:
    {
        QString cod = tablaPrincipal->model()->index(tablaPrincipal->currentIndex().row(),0).data().toString();
        if (!cod.isEmpty())
        {
            m_codigopadre=m_codigohijo;
            m_codigohijo = cod;
            m_ruta.append(m_codigohijo);
        }
        break;
    }
    case movimiento::DERECHA:
    {
        m_ruta.pop_back();
        cadenamover = "SELECT ver_siguiente('"+ m_tabla + "','"+ m_codigopadre + "','"+ m_codigohijo+"')";
        qDebug()<<cadenamover;
        m_consulta.exec(cadenamover);
        while (m_consulta.next())
        {
            m_codigohijo = m_consulta.value(0).toString();
        }
        m_ruta.append(m_codigohijo);
        break;
    }
    case movimiento::IZQUIERDA:
    {
        m_ruta.pop_back();
        cadenamover = "SELECT ver_anterior('"+ m_tabla + "','"+ m_codigopadre + "','"+ m_codigohijo+"')";
        m_consulta.exec(cadenamover);
        while (m_consulta.next())
        {
            m_codigohijo = m_consulta.value(0).toString();
        }
        m_ruta.append(m_codigohijo);
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
    m_arbol->setVisible(!m_arbol->isVisible());
}

void Instancia::AjustarPresupuesto()
{
    qDebug()<<LeePrecio();
    DialogoAjustar* d = new DialogoAjustar(LeeTabla(), LeeResumen(), LeePrecio());
    int res = d->exec();
    if (res==1)
    {
        m_pila->push(new UndoAjustarPresupuesto(m_tabla,QString::number(LeePrecio()),d->LeePrecioParaAjustar()));
    }
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
    MiUndoStack::POSICION pos = m_pila->LeePosicion();
    m_ruta = pos.first;
    m_tablamedcertactiva = pos.second;
    m_codigopadre = m_ruta.at(m_ruta.size()-2);
    m_codigohijo = m_ruta.at(m_ruta.size()-1);
    m_TabWidgetTablasMedCert->setCurrentIndex(m_tablamedcertactiva);
    m_pila->Undo();
    m_pila->GuardarPosicion(m_ruta,m_tablamedcertactiva);
}

void Instancia::Redo()
{
    MiUndoStack::POSICION pos = m_pila->LeePosicion();
    m_ruta = pos.first;
    m_tablamedcertactiva = pos.second;
    m_codigopadre = m_ruta.at(m_ruta.size()-2);
    m_codigohijo = m_ruta.at(m_ruta.size()-1);
    m_TabWidgetTablasMedCert->setCurrentIndex(m_tablamedcertactiva);
    m_pila->Redo();
    m_pila->GuardarPosicion(m_ruta,m_tablamedcertactiva);
}

void Instancia::RefrescarVista()
{
    //qDebug()<<"Refrescar la vista con "<<m_codigopadre<<" -- "<<m_codigohijo;
    tablaPrincipal->ActualizarDatos(m_ruta);
    for (auto it = Listadotablasmedcert.begin();it!=Listadotablasmedcert.end();++it)
    {    
        (*it)->ActualizarDatos(m_ruta);
    }
    /*modeloTablaP->QuitarIndicadorFilaVacia();
    if (modeloTablaP->rowCount(QModelIndex())==0)
    {
        modeloTablaP->insertRow(0);
    }*/
    EscribirTexto();
    m_editor->EscribirRuta(m_ruta);
    //editor->Formatear();
    GuardarTextoPartidaInicial();    
    //tablaPrincipal->setCurrentIndex(indiceActual);
    PrincipalModel *m = qobject_cast<PrincipalModel*>(tablaPrincipal->model());
    if (m)
    {
        //separadorTablasMedCert->setVisible(m->EsPartida());//solo se ve si es partida(Nat == 7)
        m_PanelTablasMC->setVisible(m->EsPartida());//solo se ve si es partida(Nat == 7)
    }
    //modeloArbol->ActualizarDatos(m_tabla);
    //modeloArbol->layoutChanged();
    //m_arbol->expandAll();
    //m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::CODIGO);
    //m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::NATURALEZA);
    //m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::UD);
    //m_arbol->resizeColumnToContents(tipoColumnaTPrincipal::RESUMEN);
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
            std::sort(listaIndices.begin(),listaIndices.end());
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
    QString cadenavertexto = "SELECT ver_texto('" + m_tabla + "','" + m_codigohijo+"');";
    qDebug()<<cadenavertexto;
    m_consulta.exec(cadenavertexto);
    QString descripcion;
    while (m_consulta.next())
    {
        descripcion = m_consulta.value(0).toString();
    }
    m_editor->EscribeTexto(descripcion);
}

void Instancia::GuardarTextoPartidaInicial()
{
    //qDebug()<<"textoPartidaActual"<<textoPartidaInicial;
    m_textoPartidaInicial = m_editor->LeeContenidoConFormato();
}

void Instancia::GuardarTextoPartida()
{
    //qDebug()<<"Fucnion GuardarTextoPArtida()"<<editor->LeeContenido();
    if (m_editor->HayCambios())
    {
        QString cadenaundo = ("Cambiar texto de partida a " + m_editor->LeeContenido());
        //qDebug()<<cadenaundo;
        m_pila->Push(m_ruta,m_tablamedcertactiva, new UndoEditarTexto(m_tabla, m_codigopadre, m_codigohijo, m_textoPartidaInicial,m_editor->LeeContenidoConFormato(),QVariant(cadenaundo)));
    }
}

void Instancia::SincronizarArbolTablal()
{
    TreeItem * mi_item = static_cast<TreeItem*>(m_arbol->currentIndex().internalPointer());
    if (mi_item && mi_item->parentItem()!=nullptr)
    {
        m_codigohijo = mi_item->data(tipoColumnaTPrincipal::CODIGO).toString();
        int nivel = mi_item->data(5).toInt();
        QString posicion = mi_item->data(6).toString();
        QStringList listaposicion = posicion.split( "." );
        m_ruta.clear();
        m_ruta.append(m_codigohijo);
        //evito la cabecera del arbol que no forma parte de la estructura de datos y la susituyo por una cadena nula
        if (mi_item->parentItem()->parentItem()!=nullptr)
        {
            m_codigopadre = mi_item->parentItem()->data(tipoColumnaTPrincipal::CODIGO).toString();
        }
        else
        {
            m_codigopadre = "";
        }
        while (mi_item->parentItem()!= nullptr)
        {
            if (mi_item->parentItem()->parentItem()!=nullptr)
            {
                m_ruta.push_front(mi_item->parentItem()->data(tipoColumnaTPrincipal::CODIGO).toString());
            }
            else
            {
                m_ruta.push_front("");
            }
            mi_item = mi_item->parentItem();
        }
        SubirNivel();//Subo el nivel ya que quiero que el nodo seleccionado en el arbol sea el hijo seleccionado en la tabla

        //ahora activo en la tabla ese hijo seleccionado
        //las lecturas de los registros 5 y 6 dan valores del nivel y de la posición dentro del nivel.
        //algo como "3" y "0.1.0.1". Preguntando qué valor hay en el segundo registro en el nivel marcado por el primero, hallamos la posición
        QModelIndex indice = tablaPrincipal->model()->index(listaposicion.at(nivel).toInt(), 0);
        //qDebug()<<"estamos en el nivel :"<< nivel << "y en la posicion"<<listaposicion.at(nivel);
        tablaPrincipal->setCurrentIndex(indice);
        RefrescarVista();
    }
}

void Instancia::ActualizarTablaMedCertActiva(int indice)
{
    m_tablamedcertactiva = indice;
}

void Instancia::MaxMinPanel()
{
    qDebug()<<sender()->objectName();
    m_Maximizado = !m_Maximizado;
    if (m_Maximizado)
    {
        if (sender()->objectName()=="BtnP")
        {
            QList<int> tams = {1,0,0};
            separadorTablas->setSizes(tams);
            m_BtnmaxminTablaP->setIcon(*m_IconMin);
        }
        else
        {
            QList<int> tams = {0,1,0};
            separadorTablas->setSizes(tams);
            m_BtnmaxminTablaMC->setIcon(*m_IconMin);
        }
    }
    else
    {
        QList<int> tams = {1,1,1};
        separadorTablas->setSizes(tams);
        m_BtnmaxminTablaP->setIcon(*m_IconMax);
        m_BtnmaxminTablaMC->setIcon(*m_IconMax);
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

void Instancia::AdministrarCertificaciones()
{
    DialogoCertificaciones* d = new DialogoCertificaciones(m_tabla);
    QObject::connect(d,SIGNAL(BorrarCertificacion(QString)),this,SLOT(BorrarCertificacion(QString)));
    QObject::connect(d,SIGNAL(InsertarCertificacion(QString)),this,SLOT(AnadirCertificacion(QString)));
    QObject::connect(d,SIGNAL(ActualizarCert()),this,SLOT(LeerCertifActual()));
    if (d->exec())
    {
        //ActualizarCertificacionEnModelo();
        //emit CambiarLabelCertActual(certActual);
    }
}

void Instancia::BorrarCertificacion(QString fecha_certificacion)
{
    //Borro la certificacion de la BBDD. Todas las lineas que tengan ese numero de certificacion quedaran borradas
    QString cadenaborrarcertificacion = "SELECT * FROM borrar_certificacion('" + m_tabla + "','" + fecha_certificacion + "')";
    qDebug()<<cadenaborrarcertificacion;
    m_consulta.exec(cadenaborrarcertificacion);
    //ahora hallo el nº de certificacion para reajustar las tablas
    int num_certificacion=-1;
    while (m_consulta.next())
    {
        num_certificacion = m_consulta.value(0).toInt();
        qDebug()<<"Numero de ce "<<num_certificacion;
    }
    if (num_certificacion>0)
    {
        auto iterador = Listadotablasmedcert.begin();
        std::advance(iterador,num_certificacion);
        Listadotablasmedcert.erase(iterador);
        m_TabWidgetTablasMedCert->removeTab(num_certificacion);
        iterador = Listadotablasmedcert.begin();//lo llevo de nuevo al origen
        ++iterador;//ahora lo avanzo una unidad hasta la tabla de certificaciones
        int i = 1;
        while (iterador!=Listadotablasmedcert.end())
        {
            (*iterador)->setObjectName("Certificación nº "+ QString::number(i));
            MedicionModel* m = qobject_cast<MedicionModel*>((*iterador)->model());
            if (m)
            {
                m->CambiarNumeroCertificacion(i);
            }
            m_TabWidgetTablasMedCert->removeTab(i);
            m_TabWidgetTablasMedCert->insertTab(i,*iterador,(*iterador)->objectName());
            i++;
            ++iterador;
        }
    }
    RefrescarVista();
}

void Instancia::AnadirCertificacion(QString fecha_certificacion)
{
    QString cadenanuevacertificacion = "SELECT anadir_certificacion('"+ m_tabla + "','" + fecha_certificacion + "')";
    qDebug()<<cadenanuevacertificacion;
    m_consulta.exec(cadenanuevacertificacion);
    bool resultado = false;
    while (m_consulta.next())
    {
        resultado = m_consulta.value(0).toBool();
    }
    if (resultado == false)
    {
        QMessageBox::warning(this, tr("Aviso"),
                                       tr("La fecha ha de ser posterior a la de la última certificación"),
                             QMessageBox::Ok);
    }
    else
    {
        int numcert = 0;
        QString cadenavercertificaciones = "SELECT * FROM ver_certificaciones('"+m_tabla+"');";
        m_consulta.exec(cadenavercertificaciones);
        while (m_consulta.next())
        {
            if (m_consulta.value(1).toString() == fecha_certificacion)
            {
                numcert = m_consulta.value(0).toInt();
                //qDebug()<<"LA fecha es : "<<consulta.value(1).toString()<<" y el numcert es: "<<numcert;
            }
        }
        InsertarTablaMedCert(numcert);
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

void Instancia::Certificar()
{
    if (HayCertificacion())
    {
        qDebug()<<"Certif actual"<<m_certActual.at(0);
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
                std::sort(listaIndices.begin(),listaIndices.end());
                MedicionModel* modelo = qobject_cast<MedicionModel*>(tabla->model());
                if (modelo)
                {
                    modelo->Certificar(listaIndices);
                }
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
