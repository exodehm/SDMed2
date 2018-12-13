#include "tablaprincipal.h"

TablaPrincipal::TablaPrincipal(int nColumnas, QWidget *parent): TablaBase(nColumnas, parent)
{
    limiteIzquierdo=tipoColumna::CODIGO;
    limiteDerecho=tipoColumna::IMPPRES;

    celdaBloqueada[tipoColumna::CODIGO]=true;
    celdaBloqueada[tipoColumna::PORCERTPRES]=true;
    celdaBloqueada[tipoColumna::IMPPRES]=true;
    celdaBloqueada[tipoColumna::IMPCERT]=true;
    setItemDelegateForColumn(tipoColumna::CODIGO,dlgBA);
    setItemDelegateForColumn(tipoColumna::UD,dlgBA);
    setItemDelegateForColumn(tipoColumna::RESUMEN,dlgBA);
    setItemDelegateForColumn(tipoColumna::CANPRES,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumna::CANCERT,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumna::PRPRES,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumna::PRCERT,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumna::PORCERTPRES,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumna::IMPPRES,dlgCB);
    setItemDelegateForColumn(tipoColumna::IMPCERT,dlgCB);

    dlgIco= new DelegadoIconos;
    setItemDelegateForColumn(tipoColumna::NATURALEZA,dlgIco);
    cabeceraHorizontal->setSelectionMode(QAbstractItemView::NoSelection);
}

void TablaPrincipal::MostrarMenuCabecera(QPoint pos)
{
    int column=this->horizontalHeader()->logicalIndexAt(pos);
    qDebug()<<"Columna: "<<column;

    QMenu *menu=new QMenu(this);
    QString nombre;
    columnaBloqueada(column)
            ?nombre=tr("Desbloquear")
            :nombre=tr("Bloquear");
    QAction *AccionBloquearColumna = new QAction(nombre, this);
    menu->addAction(AccionBloquearColumna);
    mapperH->setMapping(AccionBloquearColumna,column);
    QObject::connect(AccionBloquearColumna, SIGNAL(triggered()), mapperH, SLOT(map()));
    QObject::connect(mapperH, SIGNAL(mapped(int)), this, SLOT(Bloquear(int)));

    menu->popup(this->horizontalHeader()->viewport()->mapToGlobal(pos));
}

void TablaPrincipal::MostrarMenuLateralTabla(QPoint pos)
{
    QMenu *menu=new QMenu(this);
    QAction *AccionCopiar = new QAction(tr("Copiar partidas"), this);
    QAction *AccionPegar = new QAction(tr("Pegar partidas"), this);
    QModelIndexList indexes = this->selectionModel()->selectedIndexes();
    if (indexes.size()==0)
    {
        AccionCopiar->setEnabled(false);
    }
    menu->addAction(AccionCopiar);
    menu->addAction(AccionPegar);
    /*copiar*/
    QObject::connect(AccionCopiar, SIGNAL(triggered()), this, SLOT(Copiar()));
    QObject::connect(AccionPegar, SIGNAL(triggered()), this, SLOT(Pegar()));
    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

/*void TablaPrincipal::Copiar()
{
    qDebug()<<"Copiar tabla principal";
    emit CopiarPartidas();
}*/
