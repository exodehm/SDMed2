#include "tablacert.h"

TablaCert::TablaCert(int nColumnas, QWidget *parent):TablaMed(nColumnas, parent)
{

}

/*void TablaCert::MostrarMenuCabecera(QPoint pos)
{

}*/

void TablaCert::MostrarMenuLateralTabla(QPoint pos)
{
    QMenu *menu=new QMenu(this);
    QAction *AccionCopiar = new QAction(tr("Copiar lineas de certificación"), this);
    QAction *AccionPegar = new QAction(tr("Pegar lineas de medición"), this);
    QModelIndexList indexes = this->selectionModel()->selectedIndexes();
    if (indexes.size()==0)
    {
        AccionCopiar->setEnabled(false);
    }
    menu->addAction(AccionCopiar);
    menu->addAction(AccionPegar);
    /*copiar*/
    QObject::connect(AccionCopiar, SIGNAL(triggered()), this, SLOT(Copiar()));
    /*pegar*/
    QObject::connect(AccionPegar, SIGNAL(triggered()), this, SLOT(Pegar()));

    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

