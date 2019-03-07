#include "tablaprincipal.h"

TablaPrincipal::TablaPrincipal(int nColumnas, QWidget *parent): TablaBase(nColumnas, parent)
{
    limiteIzquierdo=tipoColumnaTPrincipal::CODIGO;
    limiteDerecho=tipoColumnaTPrincipal::IMPPRES;

    celdaBloqueada[tipoColumnaTPrincipal::CODIGO]=true;
    celdaBloqueada[tipoColumnaTPrincipal::PORCERTPRES]=true;
    celdaBloqueada[tipoColumnaTPrincipal::IMPPRES]=true;
    celdaBloqueada[tipoColumnaTPrincipal::IMPCERT]=true;
    setItemDelegateForColumn(tipoColumnaTPrincipal::CODIGO,dlgBA);
    setItemDelegateForColumn(tipoColumnaTPrincipal::UD,dlgBA);
    setItemDelegateForColumn(tipoColumnaTPrincipal::RESUMEN,dlgBA);
    setItemDelegateForColumn(tipoColumnaTPrincipal::CANPRES,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumnaTPrincipal::CANCERT,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumnaTPrincipal::PRPRES,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumnaTPrincipal::PRCERT,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumnaTPrincipal::PORCERTPRES,dlgNumTablaP);
    setItemDelegateForColumn(tipoColumnaTPrincipal::IMPPRES,dlgCB);
    setItemDelegateForColumn(tipoColumnaTPrincipal::IMPCERT,dlgCB);

    dlgIco= new DelegadoIconos;
    setItemDelegateForColumn(tipoColumnaTPrincipal::NATURALEZA,dlgIco);
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
    QObject::connect(AccionCopiar, SIGNAL(triggered()), this, SLOT(CopiarPartidas()));
    QObject::connect(AccionPegar, SIGNAL(triggered()), this, SLOT(Pegar()));
    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

void TablaPrincipal::CopiarPartidas()
{
    qDebug()<<"Copiar tabla principal";
    emit Copiar();
}
