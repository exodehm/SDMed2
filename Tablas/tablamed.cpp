#include "tablamed.h"
#include "defs.h"
#include "./Modelos/MedicionModel.h"
#include "./filtrotablamediciones.h"

TablaMed::TablaMed(int nColumnas, QWidget *parent): TablaBase(nColumnas, parent)
{    
    limiteIzquierdo=tipoColumnaTMedCert::COMENTARIO;
    limiteDerecho=tipoColumnaTMedCert::PARCIAL;

    celdaBloqueada[tipoColumnaTMedCert::FASE]=true;
    celdaBloqueada[tipoColumnaTMedCert::PARCIAL]=true;
    celdaBloqueada[tipoColumnaTMedCert::SUBTOTAL]=true;
    celdaBloqueada[tipoColumnaTMedCert::ID]=true;

    setItemDelegateForColumn(tipoColumnaTMedCert::N,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::COMENTARIO,dlgBA);
    setItemDelegateForColumn(tipoColumnaTMedCert::LONGITUD,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::ANCHURA,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::ALTURA,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::FORMULA,dlgFM);
    setItemDelegateForColumn(tipoColumnaTMedCert::PARCIAL,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::SUBTOTAL,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::FASE,dlgCB);
    setItemDelegateForColumn(tipoColumnaTMedCert::ID,dlgCB);

    setColumnHidden(tipoColumnaTMedCert::ID,true);
    setMouseTracking(true);
    //setAttribute(Qt::WA_Hover);

    installEventFilter(new FiltroTablaMediciones(this));

    QObject::connect(cabeceraHorizontal, SIGNAL(sectionClicked(int)), this,SLOT(Bloquear(int)));
    QObject::connect(this,SIGNAL(hoverIndexChanged(QModelIndex)),dlgFM,SLOT(onHoverIndexChanged(QModelIndex)));
}

/*void TablaMed::mouseMoveEvent(QMouseEvent *event)
{
    QPoint pos = event->pos();
    QModelIndex index = indexAt(pos);
    if (index.isValid())
    {
        if (index.column() == tipoColumnaTMedCert::FORMULA)
        {
            //setCursor(Qt::DragMoveCursor);
            emit hoverIndexChanged(index);
        }
        else
        {
            //setCursor(Qt::ArrowCursor);
            emit hoverIndexChanged(index);
        }
    }
    TablaBase::mouseMoveEvent(event);
}*/

void TablaMed::paintEvent(QPaintEvent *event)
{
    TablaBase::paintEvent(event);
    if(selectionModel() &&  selectionModel()->selectedIndexes().isEmpty())
    {
        return;
    }
    QPen pen(Qt::black,3);
    QPainter painter(viewport());
    //defino el area seleccionada
    QRect rect = visualRect(selectedIndexes().first()) | visualRect(selectedIndexes().last());
    //dibujo la marca en la esquina inferior derecha del area seleccionada
    painter.setBrush(QBrush(QColor(Qt::black)));
    painter.drawRect(rect.x()+rect.width()-m_tamMarca,rect.y()+rect.height()-m_tamMarca,m_tamMarca,m_tamMarca);
    //si hago la seleccion en modo restringido, saldra un borde
    if (modoSeleccion == SELECCION_RESTRINGIDA)    {

        painter.setPen(pen);
        //painter.drawRect(rect);
        painter.drawLine(rect.x(),rect.y(),rect.x()+rect.width(),rect.y());
        painter.drawLine(rect.x(),rect.y(),rect.x(),rect.y()+rect.height());
        pen.setWidth(1);
        painter.setPen(pen);
        painter.drawLine(rect.x()+rect.width(),rect.y(),rect.x()+rect.width(),rect.y()+rect.height());
        painter.drawLine(rect.x(),rect.y()+rect.height(),rect.x()+rect.width(),rect.y()+rect.height());
    }
    viewport()->update();
}

void TablaMed::MostrarMenuCabecera(QPoint pos)
{
    int column=this->horizontalHeader()->logicalIndexAt(pos);
    qDebug()<<"Columna: "<<column;

    QMenu *menu=new QMenu(this);
    menu->addAction(new QAction("Hacer algo", this));
    menu->popup(this->horizontalHeader()->viewport()->mapToGlobal(pos));
}

void TablaMed::MostrarMenuLateralTabla(QPoint pos)
{
    QMenu *menu=new QMenu(this);
    QAction *AccionCopiar = new QAction(tr("Copiar lineas de medición"), this);
    QAction *AccionPegar = new QAction(tr("Pegar lineas de medición"), this);
    QAction *AccionCertificar = new QAction(tr("Certificar lineas de medición"), this);
    QModelIndexList indexes = this->selectionModel()->selectedIndexes();
    if (indexes.size()==0)
    {
        AccionCopiar->setEnabled(false);
        AccionCertificar->setEnabled(false);
    }
    menu->addAction(AccionCopiar);
    menu->addAction(AccionPegar);
    menu->addAction(AccionCertificar);
    /*copiar*/
    QObject::connect(AccionCopiar, SIGNAL(triggered()), this, SLOT(Copiar()));
    /*pegar*/
    QObject::connect(AccionPegar, SIGNAL(triggered()), this, SLOT(Pegar()));
    /*certificar*/
    QObject::connect(AccionCertificar, SIGNAL(triggered()), this, SLOT(Certificar()));

    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

void TablaMed::MostrarMenuTabla(QPoint pos)
{
   if (this->currentIndex().column()==tipoColumnaTMedCert::SUBTOTAL)
   {
       QMenu *menu=new QMenu(this);
       QAction *AccionSubtotalNormal = new QAction(tr("Normal"), this);
       QAction *AccionSubtotalOrigen = new QAction(tr("Subtotal a origen"), this);
       QAction *AccionSubtotalParcial = new QAction(tr("Subtotal parcial"), this);
       AccionSubtotalNormal->setObjectName("AccionSubtotalNormal");
       AccionSubtotalOrigen->setObjectName("AccionSubtotalOrigen");
       AccionSubtotalParcial->setObjectName("AccionSubtotalParcial");
       QList<QAction*>listaAcciones;
       listaAcciones<<AccionSubtotalNormal<<AccionSubtotalOrigen<<AccionSubtotalParcial;
       menu->addActions(listaAcciones);
       menu->popup(this->viewport()->mapToGlobal(pos));
       QObject::connect(AccionSubtotalNormal,SIGNAL(triggered(bool)),this,SLOT(CambiarTipoSubtotal()));
       QObject::connect(AccionSubtotalOrigen,SIGNAL(triggered(bool)),this,SLOT(CambiarTipoSubtotal()));
       QObject::connect(AccionSubtotalParcial,SIGNAL(triggered(bool)),this,SLOT(CambiarTipoSubtotal()));

   }
}

void TablaMed::CambiarTipoSubtotalOrigen()
{
    MedicionModel* M = qobject_cast<MedicionModel*>(this->model());    
    if (M)
    {
        QVariant tipo = 2;
        M->CambiarTipoLineaMedicion(this->currentIndex().row(),this->currentIndex().column(),tipo);
    }
}

void TablaMed::CambiarTipoSubtotalParcial()
{
    MedicionModel* M = qobject_cast<MedicionModel*>(this->model());
    QVariant tipo = 1;
    if (M)
    {
        M->CambiarTipoLineaMedicion(this->currentIndex().row(),this->currentIndex().column(),tipo);
    }
}

void TablaMed::CambiarTipoSubtotal()
{
    int tipo;
    QString accion = sender()->objectName();
    if (accion == "AccionSubtotalNormal")
    {
        tipo = 0;
    }
    else if (accion == "AccionSubtotalParcial")
    {
        tipo = 1;
    }
    else if (accion == "AccionSubtotalOrigen")
    {
        tipo = 2;
    }
    MedicionModel* M = qobject_cast<MedicionModel*>(this->model());
    if (M)
    {
        M->CambiarTipoLineaMedicion(this->currentIndex().row(),this->currentIndex().column(),tipo);
    }
}

/*void TablaMed::Copiar()
{
    qDebug()<<"Copiar en tabla de mediciones";
    //emit CopiarMediciones();
}*/
