#include "tablamed.h"
#include "defs.h"
#include "./Modelos/MedicionModel.h"
#include "./filtrotablamediciones.h"

TablaMed::TablaMed(const QString &tabla, const QStringList &ruta, int num_certif, MiUndoStack *p, QWidget *parent): TablaBase(parent)
{    
    limiteIzquierdo=tipoColumnaTMedCert::COMENTARIO;
    limiteDerecho=tipoColumnaTMedCert::PARCIAL;

    modelo = new MedicionModel(tabla, ruta, num_certif, p);

    celdaBloqueada =  new bool[modelo->columnCount(QModelIndex())]{false};

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

    setModel(modelo);
    setMouseTracking(true);
    setAttribute(Qt::WA_Hover);
    //en principio las columnas de id u pos es para uso interno, así que no la muestro (la id es la id de la tabla de mediciones)
    setColumnHidden(tipoColumnaTMedCert::ID,true);
    setColumnHidden(tipoColumnaTMedCert::POSICION,true);
    viewport()->installEventFilter(new FiltroTablaMediciones(this));

    QObject::connect(cabeceraHorizontal, SIGNAL(sectionClicked(int)), this,SLOT(Bloquear(int)));
}

void TablaMed::MostrarMenuCabecera(const QPoint& pos)
{
    int column=this->horizontalHeader()->logicalIndexAt(pos);
    qDebug()<<"Columna: "<<column;

    QMenu *menu=new QMenu(this);
    menu->addAction(new QAction("Hacer algo", this));
    menu->popup(this->horizontalHeader()->viewport()->mapToGlobal(pos));
}

void TablaMed::MostrarMenuLateralTabla(const QPoint& pos)
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
    QObject::connect(AccionCopiar, SIGNAL(triggered()), this, SLOT(CopiarMediciones()));
    /*pegar*/
    QObject::connect(AccionPegar, SIGNAL(triggered()), this, SLOT(PegarMediciones()));
    /*certificar*/
    QObject::connect(AccionCertificar, SIGNAL(triggered()), this, SLOT(Certificar()));

    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

void TablaMed::MostrarMenuTabla(const QPoint& pos)
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
    int tipo=0;
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

void TablaMed::CopiarMediciones()
{
    emit Copiar();
}

void TablaMed::PegarMediciones()
{
    emit Pegar();
}

/*void TablaMed::Copiar()
{
    qDebug()<<"Copiar en tabla de mediciones";
    //emit CopiarMediciones();
}*/
