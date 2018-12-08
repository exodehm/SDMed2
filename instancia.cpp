#include "instancia.h"
#include "consultas.h"
#include "./Modelos/Modelobase.h"
#include "./Modelos/PrincipalModel.h"
#include "./Modelos/MedCertModel.h"
#include "./Modelos/TreeModel.h"

#include "./Tablas/tablaprincipal.h"
#include "./Tablas/tablamedcert.h"
#include "./Editor/editor.h"
#include "./Tablas/vistaarbol.h"

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

#include <QtSql/QSqlQuery>

Instancia::Instancia(QString cod, QString res, QWidget *parent):tabla(cod),resumen(res),QWidget(parent)
{
    codigopadre ="";
    codigohijo = cod;
    pila = new QUndoStack(this);
    GenerarUI();
}

Instancia::~Instancia()
{   
    delete modeloTablaP;
    delete modeloTablaMed;
    delete modeloTablaCert;
    //delete modeloArbol;
    delete editor;
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
    modeloTablaMed = new MedCertModel(tabla, codigopadre, codigohijo, pila);
    tablaMediciones = new TablaMedCert(modeloTablaMed->columnCount(QModelIndex()));
    tablaMediciones->setObjectName("TablaMC");
    tablaMediciones->setModel(modeloTablaMed);
    //en principio la columna de id es para uso interno, así que no la muestro (la id es la id de la tabla de mediciones)
    tablaMediciones->setColumnHidden(tipoColumna::ID,true);
    //tabla certificaciones
    modeloTablaCert = new MedCertModel(tabla, codigopadre, codigohijo, pila);
    tablaCertificaciones =  new TablaMedCert(modeloTablaCert->columnCount(QModelIndex()));
    tablaCertificaciones->setModel(modeloTablaCert);
    tablaCertificaciones->setEnabled(false);
    //igual pasa con las id de la tabla de certificaciones
    tablaCertificaciones->setColumnHidden(tipoColumna::ID,true);
    //tab para las tablas de mediciones y certificaciones
    separadorTablasMedicion = new QTabWidget;
    separadorTablasMedicion->addTab(tablaMediciones,QString(tr("Medicion")));
    separadorTablasMedicion->addTab(tablaCertificaciones,QString(tr("Certificacion")));

    separadorTablas->addWidget(separadorTablasMedicion);

    //editor
    editor = new Editor;//(separadorTablas);
    separadorTablas->addWidget(editor);

    //añado el separador al layout
    separadorPrincipal->addWidget(separadorTablas);
    separadorPrincipal->addWidget(arbol);
    lienzoGlobal->addWidget(separadorPrincipal);

    arbol->expandAll();
    arbol->resizeColumnToContents(tipoColumna::CODIGO);
    arbol->resizeColumnToContents(tipoColumna::NATURALEZA);
    arbol->resizeColumnToContents(tipoColumna::UD);
    arbol->resizeColumnToContents(tipoColumna::RESUMEN);
    arbol->resizeColumnToContents(tipoColumna::IMPPRES);

    RefrescarVista();
    MostrarDeSegun(0);
    //O->cambiarEntreMedYCert(MedCert::MEDICION);

    /************signals y slots*****************/
    QObject::connect(tablaPrincipal,SIGNAL(doubleClicked(QModelIndex)),this,SLOT(BajarNivel()));
    QObject::connect(tablaPrincipal->CabeceraDeTabla(),SIGNAL(sectionDoubleClicked(int)),this,SLOT(SubirNivel()));
    //QObject::connect(tablaPrincipal,SIGNAL(clicked(QModelIndex)),this,SLOT(PosicionarTablaP(QModelIndex)));
    //QObject::connect(tablaPrincipal,SIGNAL(CambiaFila(QModelIndex)),this,SLOT(PosicionarTablaP(QModelIndex)));
    //QObject::connect(tablaMediciones,SIGNAL(CambiaFila(QModelIndex)),this,SLOT(PosicionarTablaM(QModelIndex)));
    //QObject::connect(modeloTablaMed,SIGNAL(Posicionar(QModelIndex)),this,SLOT(PosicionarTablaM(QModelIndex)));
    // QObject::connect(tablaPrincipal,SIGNAL(CopiarContenido()),this,SLOT(CopiarPartidasTablaP()));
    //QObject::connect(tablaPrincipal,SIGNAL(PegarContenido()),this,SLOT(PegarPartidasTablaP()));
    //QObject::connect(tablaMediciones,SIGNAL(CopiarContenido()),this,SLOT(CopiarMedicionTablaM()));
    // QObject::connect(tablaMediciones,SIGNAL(PegarContenido()),this,SLOT(PegarMedicionTablaM()));

    // QObject::connect(tablaMediciones,SIGNAL(CertificarLineasMedicion()),this,SLOT(Certificar()));
    //QObject::connect(separadorTablasMedicion,SIGNAL(currentChanged(int)),this,SLOT(CambiarEntreMedicionYCertificacion(int)));
    QObject::connect(pila,SIGNAL(indexChanged(int)),this,SLOT(ActivarDesactivarUndoRedo(int)));
    QObject::connect(pila,SIGNAL(indexChanged(int)),this,SLOT(RefrescarVista()));
    //QObject::connect(editor->LeeEditor(),SIGNAL(GuardaTexto()),this,SLOT(GuardarTextoPartida()));
    //QObject::connect(editor,SIGNAL(GuardaTexto()),this,SLOT(GuardarTextoPartida()));
}

const QString& Instancia::LeeTabla() const
{
    return tabla;
}

const QString& Instancia::LeeResumen() const
{
    return resumen;
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
    tablaPrincipal->setColumnHidden(tipoColumna::CANCERT,verCertificacion);
    tablaPrincipal->setColumnHidden(tipoColumna::PORCERTPRES,verCertificacion);
    tablaPrincipal->setColumnHidden(tipoColumna::PRCERT,verCertificacion);
    tablaPrincipal->setColumnHidden(tipoColumna::IMPCERT,verCertificacion);
}

void Instancia::SubirNivel()
{   
    qDebug()<<"Subir nivel";
    /*GuardarTextoPartida();
    GuardarTextoPartidaInicial();
    QString cadenaundo = tr("Subir nivel");
    //pila->push(new UndoMover(movimiento::ARRIBA,this,cadenaundo));
    O->SubirNivel();
    modeloTablaP->QuitarIndicadorFilaVacia();
    RefrescarVista(QModelIndex(),QModelIndex());*/
    Mover(movimiento::ARRIBA);
}

void Instancia::BajarNivel()
{
    qDebug()<<"Bajar nivel";
    /*Q_UNUSED (indice);
    GuardarTextoPartidaInicial();
    GuardarTextoPartidaModificada();
    QString cadenaundo = tr("Bajar nivel");
    //pila->push(new UndoMover(movimiento::ABAJO, this,cadenaundo));
    O->BajarNivel();
    RefrescarVista(QModelIndex(),QModelIndex());*/
    Mover(movimiento::ABAJO);
}

/*void Instancia::Avanzar()
{
    GuardarTextoPartida();
    GuardarTextoPartidaInicial();
    QString cadenaundo = tr("Avanzar");
    //pila->push(new UndoMover(movimiento::DERECHA,this,cadenaundo));
    O->Siguiente();
    RefrescarVista(QModelIndex(),QModelIndex());
}*/

/*void Instancia::Retroceder()
{
    GuardarTextoPartida();
    GuardarTextoPartidaInicial();
    QString cadenaundo = tr("Retroceder");
    //pila->push(new UndoMover(movimiento::IZQUIERDA,this,cadenaundo));
    O->Anterior();
    RefrescarVista(QModelIndex(),QModelIndex());
}
*/

void Instancia::Mover(int tipomovimiento)
{
    //GuardarTextoPartidaInicial();
    QString cadenamover;
    switch (tipomovimiento)
    {
    case movimiento::INICIO:
    {
        codigopadre="";
        codigohijo =tabla;
        break;
    }
    case movimiento::ARRIBA:
    {
        if (!codigopadre.isEmpty())
        {
            {
                codigohijo = codigopadre;
                cadenamover = "SELECT codpadre FROM \""+ tabla + "_Relacion\" WHERE codhijo = '"+ codigopadre + "';";
                qDebug()<<cadenamover;
                consulta.exec(cadenamover);
                while (consulta.next())
                {
                    codigopadre = consulta.value(0).toString();
                }
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
        }
        break;
    }
    case movimiento::DERECHA:
    {
        cadenamover = "SELECT codhijo FROM \"" + tabla + "_Relacion\" WHERE codpadre = '"\
                + codigopadre + "' AND posicion = (SELECT posicion FROM \""+ \
                tabla + "_Relacion\" WHERE codpadre = '" + codigopadre + "' AND codhijo = '" + codigohijo +"')+ 1;";
        consulta.exec(cadenamover);
        while (consulta.next())
        {
            codigohijo = consulta.value(0).toString();
        }
        break;
    }
    case movimiento::IZQUIERDA:
    {
        cadenamover = "SELECT codhijo FROM \"" + tabla + "_Relacion\" WHERE codpadre = '"\
                + codigopadre + "' AND posicion = (SELECT posicion FROM \""+ \
                tabla + "_Relacion\" WHERE codpadre = '" + codigopadre + "' AND codhijo = '" + codigohijo +"')- 1;";
        consulta.exec(cadenamover);
        while (consulta.next())
        {
            codigohijo = consulta.value(0).toString();
        }
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
    /* if (widgetactivo->objectName()=="TablaP")
    {
        tablaPrincipal->selectAll();
    }
    else if (widgetactivo->objectName()=="TablaMC")
    {
        tablaMediciones->selectAll();
    }*/
}

void Instancia::TablaDeseleccionarTodo(QWidget* widgetactivo)
{
    /* if (widgetactivo->objectName()=="TablaP")
    {
        tablaPrincipal->clearSelection();
    }
    else if (widgetactivo->objectName()=="TablaMC")
    {
        tablaMediciones->clearSelection();
    }*/
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
    //modeloArbol->ActualizarDatos();
    /*modeloTablaP->QuitarIndicadorFilaVacia();
    if (modeloTablaP->rowCount(QModelIndex())==0)
    {
        modeloTablaP->insertRow(0);
    }*/
    EscribirTexto();
    tablaPrincipal->resizeColumnsToContents();
    tablaMediciones->resizeColumnsToContents();
    tablaCertificaciones->resizeColumnsToContents();
    /*editor->Formatear();
    GuardarTextoPartidaInicial();*/
    modeloTablaP->layoutChanged();
    modeloTablaMed->layoutChanged();
    //modeloTablaCert->layoutChanged();
    //tablaPrincipal->setCurrentIndex(indiceActual);
    separadorTablasMedicion->setVisible(modeloTablaP->EsPartida());//solo se ve si es partida(Nat == 7)
    /*modeloArbol->layoutChanged();
    arbol->expandAll();
    arbol->resizeColumnToContents(tipoColumna::CODIGO);
    arbol->resizeColumnToContents(tipoColumna::NATURALEZA);
    arbol->resizeColumnToContents(tipoColumna::UD);
    arbol->resizeColumnToContents(tipoColumna::RESUMEN);*/
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

void Instancia::PosicionarTablaP(QModelIndex indice)
{
    /* int linea = indice.row();
    if (modeloTablaP->HayFilaVacia())
    {
        if (linea > modeloTablaP->FilaVacia())
        {
            linea = indice.row()-1;
        }
    }
    indiceActual=indice;
    O->PosicionarAristaActual(linea);*/
}

void Instancia::PosicionarTablaM(QModelIndex indice)
{
    //O->PosicionarLineaActualMedicion(indice.row());
}

void Instancia::GuardarTextoPartidaInicial()
{
    /* if (!O->EsPartidaVacia())
    {
        textoPartidaInicial = editor->LeeContenidoConFormato();
        //qDebug()<<"textoPartidaActual"<<textoPartidaInicial;
    }*/
}

void Instancia::GuardarTextoPartida()
{
    /*qDebug()<<QApplication::focusWidget();
    if (editor->HayCambios())
    {
        TablaBase* tabla = qobject_cast<TablaBase*>(QApplication::focusWidget());
        if (tabla)
        {
            QString cadenaundo = ("Cambiar texto de partida a " + editor->LeeContenido());
            pila->push(new UndoEditarTexto(O,modeloTablaP, QModelIndex(), textoPartidaInicial, editor->LeeContenidoConFormato(), cadenaundo));
        }
    }*/
}

/*TEXTO Instancia::TextoPartidaInicial()
{
   return textoPartidaInicial;
}*/

void Instancia::CopiarPartidasTablaP()
{
    // emit CopiarP();
}

void Instancia::CopiarMedicionTablaM()
{
    //emit CopiarM();
}

/*void Instancia::CopiarPartidas(std::list<std::pair<pArista, pNodo>>&listaNodosCopiarPegar)
{
    //en esta funcion creo una lista de int para almacenar los indices de las lineas seleccionadas de la tabla
    //con esta lista de indices y las lista de nodos seleccionados me voy a la funcion Obra::CopiarPartidas
    listaNodosCopiarPegar.clear();
    QItemSelectionModel *selecmodel = tablaPrincipal->selectionModel();
    QModelIndexList selectedRowsIndexesList = selecmodel->selectedIndexes();
    CopiarPartidasPortapapeles(selectedRowsIndexesList);
    QList<int> listaIndices;
    foreach (const QModelIndex &i, selectedRowsIndexesList)
    {
        if (!listaIndices.contains(i.row()))
            listaIndices.append(i.row());
    }
    qSort(listaIndices);
    O->CopiarPartidas(listaNodosCopiarPegar, listaIndices);
    selecmodel->clearSelection();
}*/

void Instancia::CopiarPartidasPortapapeles(const QModelIndexList &lista)
{
    /*QString textoACopiar;
    for(int i = 0; i < lista.size(); i++)
    {
        //if (i!=0 && (i-10)%10!=0 && (i-9)%9!=0) //excluyo de los datos a copiar la primera y ultima columna (Fase e Id)
        {
            QModelIndex index = lista.at(i);
            textoACopiar.append(modeloTablaP->data(index).toString());
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
    clipboard->setText(textoACopiar);*/

}

void Instancia::PegarPartidasTablaP()
{
    emit PegarP();
}

void Instancia::PegarMedicionTablaM()
{
    emit PegarM();
}

/*void Instancia::PegarPartidas(const Obra::ListaAristasNodos &listaNodosCopiarPegar)
{
    qDebug()<<"Pegar partidas";
    QModelIndex indice = tablaPrincipal->currentIndex();
    qDebug()<<indice.row();
    bool insertarAlFinal=false;
    if (modeloTablaP->HayFilaVacia() && indice.row()==modeloTablaP->FilaVacia())
    {
        insertarAlFinal=true;
    }
    QString cadenaundo = "Pegar partidas";
    //O->Pegar(listaNodosCopiarPegar,insertarAlFinal);
    pila->push(new UndoPegarPartidas(O,modeloTablaP,indice,listaNodosCopiarPegar, insertarAlFinal,cadenaundo));
    RefrescarVista();
}*/

/*void Instancia::CopiarMedicion(Medicion& listaMedicionCopiarPegar)
{
   listaMedicionCopiarPegar.BorrarMedicion();
    QItemSelectionModel *selecmodel = tablaMediciones->selectionModel();
    QModelIndexList selectedRowsIndexesList = selecmodel->selectedIndexes();
    CopiarMedicionPortapapeles(selectedRowsIndexesList);
    QList<int> listaIndices;
    foreach (const QModelIndex &i, selectedRowsIndexesList)
    {
        if (!listaIndices.contains(i.row()))
            listaIndices.append(i.row());
    }
    qSort(listaIndices);
    O->CopiarMedicion(listaMedicionCopiarPegar, listaIndices);
    selecmodel->clearSelection();
}*/

void Instancia::CopiarMedicionPortapapeles(const QModelIndexList& lista)
{
    /*QString textoACopiar;
    for(int i = 0; i < lista.size(); i++)
    {
        if (i!=0 && (i-10)%10!=0 && (i-9)%9!=0) //excluyo de los datos a copiar la primera y ultima columna (Fase e Id)
        {
            QModelIndex index = lista.at(i);
            textoACopiar.append(modeloTablaMed->data(index).toString());
            textoACopiar.append('\t');
        }
    }
    textoACopiar.replace(",",".");
    int i=0, n=0;
    while (i<textoACopiar.size())
    {
        if (textoACopiar.at(i)=='\t')
        {
            n++;
        }
        if (n==8)
        {
            textoACopiar.replace(i,1,'\n');
            n=0;
        }
        i++;
    }
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->setText(textoACopiar);    */
}

/*void Instancia::PegarMedicion(const Medicion& ListaMedicion)
{    
    QModelIndex indice = tablaMediciones->currentIndex();
    QString cadenaundo = tr("Pegar lineas de medicion");
    pila->push(new UndoPegarLineasMedicion(O,indice.row(),ListaMedicion,cadenaundo));
    RefrescarVista();
}*/

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
    /*Medicion listaParaCertificar;
    CopiarMedicion(listaParaCertificar);
    O->Certificar(listaParaCertificar);*/
}

void Instancia::CambiarEntreMedicionYCertificacion(int n)
{
    //O->cambiarEntreMedYCert(n);
}

void Instancia::GuardarBC3(QString filename)
{
    /* QFile ficheroBC3(filename);
    if (ficheroBC3.open(QIODevice::WriteOnly|QIODevice::Text))
    {
        AbrirGuardarBC3* bc3 =  new AbrirGuardarBC3;
        bc3->Escribir(ficheroBC3,O);
        ficheroBC3.close();
        delete bc3;
    }*/
}

void Instancia::GuardarSEG(QString filename)
{
    /*QFile ficheroSEG(filename);
    if (ficheroSEG.open(QIODevice::WriteOnly))
    {
        AbrirGuardarSEG* seg = new AbrirGuardarSEG;
        seg->Escribir(ficheroSEG,O);
        ficheroSEG.close();
        delete seg;
    }*/
}

/*PrincipalModel* Instancia::ModeloTablaPrincipal()
{
    return modeloTablaP;
}*/

/*TablaBase* Instancia::LeeTablaPrincipal()
{
    return tablaPrincipal;
}*/

/*int Instancia::TipoFichero(TEXTO nombrefichero)
{
    nombrefichero=nombrefichero.toLower();
    if (nombrefichero.endsWith(".bc3"))
    {
        return tipoFichero::BC3;
    }
    else if (nombrefichero.endsWith(".seg"))
    {
        return tipoFichero::SEG;
    }
    else return tipoFichero::NOVALIDO;
}*/
