#include "tablamed.h"

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
    setItemDelegateForColumn(tipoColumnaTMedCert::FORMULA,dlgBA);
    setItemDelegateForColumn(tipoColumnaTMedCert::PARCIAL,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::SUBTOTAL,dlgNumTablaMC);
    setItemDelegateForColumn(tipoColumnaTMedCert::FASE,dlgCB);
    setItemDelegateForColumn(tipoColumnaTMedCert::ID,dlgCB);

    setColumnHidden(tipoColumnaTMedCert::ID,true);

    QObject::connect(cabeceraHorizontal, SIGNAL(sectionClicked(int)), this,SLOT(Bloquear(int)));
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

/*void TablaMed::Copiar()
{
    qDebug()<<"Copiar en tabla de mediciones";
    //emit CopiarMediciones();
}*/
