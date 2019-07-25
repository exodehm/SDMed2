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

#include "./Ficheros/exportarXLS.h"

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

Instancia::Instancia(QString cod, QString res, QWidget *parent):tabla(cod),resumen(res),QWidget(parent)
{
    codigopadre ="";
    codigohijo = cod;
    ruta<<codigopadre<<codigohijo;
    m_tablamedcertactiva=0;
    pila = new MiUndoStack(this);
    GenerarUI();
}

Instancia::~Instancia()
{
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
    tablaPrincipal = new TablaPrincipal(tabla, ruta, pila);
    separadorTablas->addWidget(tablaPrincipal);

    //tablas medicion y certificacion
    separadorTablasMedCert = new QTabWidget;
    separadorTablas->addWidget(separadorTablasMedCert);
    //Tabla Medicion
    InsertarTablaMedCert(0);//0 es la tabla de mediciones
    //Tablas de certificacion
    QString cadenalistadocertificaciones = "SELECT * FROM ver_certificaciones('"+ tabla + "');";
    consulta.exec(cadenalistadocertificaciones);
    while (consulta.next())
    {
     InsertarTablaMedCert(consulta.value(0).toInt());
    }
    //ultimo elemento del tab. Un boton para añadir mas certificaciones
    QIcon icono ("/home/david/programacion/Qt/SDMed2/SDMed2/Iconos/plus.png");
    QPushButton* buton = new QPushButton(icono,"");
    buton->setFlat(true);
    buton->setToolTip(tr("Añadir certificacion"));
    QObject::connect(buton,SIGNAL(clicked(bool)),this,SLOT(AdministrarCertificaciones()));
    separadorTablasMedCert->addTab(buton,icono,"");
    separadorTablas->addWidget(separadorTablasMedCert);

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
    //tablaPrincipal->resizeColumnsToContents();
    MostrarDeSegun(0);
    certActual = LeerCertifActual();
    ActualizarCertificacionEnModelo();


    /************signals y slots*****************/
    QObject::connect(tablaPrincipal,SIGNAL(doubleClicked(QModelIndex)),this,SLOT(BajarNivel()));
    QObject::connect(tablaPrincipal->CabeceraDeTabla(),SIGNAL(sectionDoubleClicked(int)),this,SLOT(SubirNivel()));   
    QObject::connect(tablaPrincipal,SIGNAL(Copiar()),this,SLOT(Copiar()));
    QObject::connect(tablaPrincipal,SIGNAL(Pegar()),this,SLOT(Pegar()));
    //QObject::connect(tablaMediciones,SIGNAL(CertificarLineasMedicion()),this,SLOT(Certificar()));
    QObject::connect(separadorTablasMedCert,SIGNAL(currentChanged(int)),this,SLOT(ActualizarTablaMedCertActiva(int)));
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

void Instancia::CambiarCodigoObra(const QString &nuevocodigo)
{
    tabla = nuevocodigo;
}

const float Instancia::LeePrecio(const QString &codigo)
{
    QString leerpreciodecodigo = "SELECT * FROM ver_precio('"+tabla+"','"+codigo+"')";
    qDebug()<<leerpreciodecodigo;
    consulta.exec(leerpreciodecodigo);
    float preciodecodigo;
    while (consulta.next())
    {
        preciodecodigo = consulta.value(0).toFloat();
    }
    return preciodecodigo;
}

QStringList Instancia::LeerCertifActual()
{
    QString leercertificacionactual = "SELECT * FROM ver_certificacion_actual('"+tabla+"')";
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
        tablaMC = new TablaMed(tabla, ruta, num_certif, pila);
        tablaMC->setObjectName(tr("Mediciones"));
        QObject::connect(tablaMC,SIGNAL(CertificarLineasMedicion()),this,SLOT(Certificar()));
    }
    else
    {
        tablaMC = new TablaCert(tabla, ruta, num_certif, pila);
        tablaMC->setObjectName(tr("Certificación nº ")+QString::number(num_certif));
    }
    QObject::connect(tablaMC,SIGNAL(Copiar()),this,SLOT(Copiar()));
    QObject::connect(tablaMC,SIGNAL(Pegar()),this,SLOT(Pegar()));
    Listadotablasmedcert.append(tablaMC);
    separadorTablasMedCert->insertTab(num_certif,tablaMC,tablaMC->objectName());
}

void Instancia::ExportarXLSS(QString nombreFichero)
{
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
    consulta.exec(cadenaconsulta);
    QSqlRecord rec = consulta.record();
    qDebug()<<cadenaconsulta;
    QList<QList<QString>> tabladatos;
    while (consulta.next())
    {
        QList<QString>fila;
        for (int i=0;i<rec.count();i++)
        {
            fila.append(consulta.value(i).toString());
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
    XLS::crearFuncion(nombreFichero,tabladatos);
    //ExportarXLS exportador(tabla.toUtf8().constData(),nombreFichero.toUtf8().constData(),consulta);
}

MiUndoStack *Instancia::Pila()
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
        qDebug()<<cadenamover;
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

void Instancia::AjustarPresupuesto()
{
    qDebug()<<LeePrecio();
    DialogoAjustar* d = new DialogoAjustar(LeeTabla(), LeeResumen(), LeePrecio());
    int res = d->exec();
    if (res==1)
    {
        pila->push(new UndoAjustarPresupuesto(tabla,QString::number(LeePrecio()),d->LeePrecioParaAjustar()));
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
    MiUndoStack::POSICION pos = pila->LeePosicion();
    ruta = pos.first;
    m_tablamedcertactiva = pos.second;
    codigopadre = ruta.at(ruta.size()-2);
    codigohijo = ruta.at(ruta.size()-1);
    separadorTablasMedCert->setCurrentIndex(m_tablamedcertactiva);
    pila->Undo();
    pila->GuardarPosicion(ruta,m_tablamedcertactiva);
}

void Instancia::Redo()
{
    MiUndoStack::POSICION pos = pila->LeePosicion();
    ruta = pos.first;
    m_tablamedcertactiva = pos.second;
    codigopadre = ruta.at(ruta.size()-2);
    codigohijo = ruta.at(ruta.size()-1);
    separadorTablasMedCert->setCurrentIndex(m_tablamedcertactiva);
    pila->Redo();
    pila->GuardarPosicion(ruta,m_tablamedcertactiva);
}

void Instancia::RefrescarVista()
{
    //qDebug()<<"Refrescar la vista con "<<codigopadre<<" -- "<<codigohijo;
    tablaPrincipal->ActualizarDatos(ruta);
    for (auto it = Listadotablasmedcert.begin();it!=Listadotablasmedcert.end();++it)
    {    
        (*it)->ActualizarDatos(ruta);
    }
    /*modeloTablaP->QuitarIndicadorFilaVacia();
    if (modeloTablaP->rowCount(QModelIndex())==0)
    {
        modeloTablaP->insertRow(0);
    }*/
    EscribirTexto();
    editor->EscribirRuta(ruta);
    //editor->Formatear();
    GuardarTextoPartidaInicial();    
    //tablaPrincipal->setCurrentIndex(indiceActual);
    PrincipalModel *m = qobject_cast<PrincipalModel*>(tablaPrincipal->model());
    if (m)
    {
        separadorTablasMedCert->setVisible(m->EsPartida());//solo se ve si es partida(Nat == 7)
    }
    //separadorTablasMedCert->setVisible(modeloTablaP->EsPartida());//solo se ve si es partida(Nat == 7)
    //modeloArbol->ActualizarDatos(tabla);
    //modeloArbol->layoutChanged();
    //arbol->expandAll();
    /*arbol->resizeColumnToContents(tipoColumna::CODIGO);
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
        pila->Push(ruta,m_tablamedcertactiva, new UndoEditarTexto(tabla, codigopadre, codigohijo, textoPartidaInicial,editor->LeeContenidoConFormato(),QVariant(cadenaundo)));
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

void Instancia::ActualizarTablaMedCertActiva(int indice)
{
    m_tablamedcertactiva = indice;
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
    DialogoCertificaciones* d = new DialogoCertificaciones(tabla);
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
    QString cadenaborrarcertificacion = "SELECT * FROM borrar_certificacion('" + tabla + "','" + fecha_certificacion + "')";
    qDebug()<<cadenaborrarcertificacion;
    consulta.exec(cadenaborrarcertificacion);
    //ahora hallo el nº de certificacion para reajustar las tablas
    int num_certificacion;
    while (consulta.next())
    {
        num_certificacion = consulta.value(0).toInt();
        qDebug()<<"Numero de ce "<<num_certificacion;
    }
    auto iterador = Listadotablasmedcert.begin();
    std::advance(iterador,num_certificacion);
    Listadotablasmedcert.erase(iterador);
    separadorTablasMedCert->removeTab(num_certificacion);
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
        separadorTablasMedCert->removeTab(i);
        separadorTablasMedCert->insertTab(i,*iterador,(*iterador)->objectName());
        i++;
        ++iterador;
    }   
    RefrescarVista();
}

void Instancia::AnadirCertificacion(QString fecha_certificacion)
{
    QString cadenanuevacertificacion = "SELECT anadir_certificacion('"+ tabla + "','" + fecha_certificacion + "')";
    qDebug()<<cadenanuevacertificacion;
    consulta.exec(cadenanuevacertificacion);
    bool resultado = false;
    while (consulta.next())
    {
        resultado = consulta.value(0).toBool();
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
        QString cadenavercertificaciones = "SELECT * FROM ver_certificaciones('"+tabla+"');";
        consulta.exec(cadenavercertificaciones);
        while (consulta.next())
        {
            if (consulta.value(1).toString() == fecha_certificacion)
            {
                numcert = consulta.value(0).toInt();
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
