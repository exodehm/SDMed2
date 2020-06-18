#include "tablaprincipal.h"
#include "./Modelos/PrincipalModel.h"
#include "./filtrotablabase.h"
//#include "./Delegados/delegadobase.h"

#include <QFontDatabase>

TablaPrincipal::TablaPrincipal(const QString &tabla, const QStringList &ruta, MiUndoStack *p, QWidget *parent): TablaBase(parent)
{
    limiteIzquierdo=tipoColumnaTPrincipal::CODIGO;
    limiteDerecho=tipoColumnaTPrincipal::IMPPRES;

    modelo = new PrincipalModel(tabla, ruta, p);
    setModel(modelo);
    setObjectName("TablaP");

    celdaBloqueada =  new bool[modelo->columnCount(QModelIndex())]{false};

    //celdaBloqueada[tipoColumnaTPrincipal::CODIGO]=true;
    celdaBloqueada[tipoColumnaTPrincipal::PORCERTPRES]=true;
    celdaBloqueada[tipoColumnaTPrincipal::IMPPRES]=true;
    celdaBloqueada[tipoColumnaTPrincipal::IMPCERT]=true;
    setItemDelegateForColumn(tipoColumnaTPrincipal::CODIGO,dlgCO);
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
    installEventFilter(new FiltroTablaBase(this));
}

void TablaPrincipal::MenuResumen(const QPoint &pos)
{
    QMenu *menu=new QMenu(this);

    QAction *AccionMayusculas = new QAction(tr("Pasar a mayúsculas"), this);
    menu->addAction(AccionMayusculas);
    QObject::connect(AccionMayusculas, SIGNAL(triggered()), this, SLOT(Mayusculas()));

    QAction *AccionMinusculas = new QAction(tr("Pasar a minúsculas"), this);
    menu->addAction(AccionMinusculas);
    QObject::connect(AccionMinusculas, SIGNAL(triggered()), this, SLOT(Minusculas()));

    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

void TablaPrincipal::MenuPrecio(const QPoint &pos)
{
    PrincipalModel* m = dynamic_cast<PrincipalModel*>(this->model());
    if (m)
    {
        qDebug()<<m->LeeColor(currentIndex().row()+1,currentIndex().column());
        int color = m->LeeColor(currentIndex().row()+1,currentIndex().column());
        QString cadenaprecio;
        switch (color)
        {
        case DelegadoBase::eColores::BLOQUEADO:
            cadenaprecio = tr("Desbloquear");
            m_opcion_precio = precio::DESBLOQUEAR;
            break;
        case DelegadoBase::eColores::DESCOMPUESTO:
            cadenaprecio = tr("Bloquear");
            m_opcion_precio = precio::BLOQUEAR;
            break;
        default:
            break;
        }
        QMenu *menu=new QMenu(this);
        QAction *AccionPrecio = new QAction(cadenaprecio, this);
        menu->addAction(AccionPrecio);
        QObject::connect(AccionPrecio, SIGNAL(triggered(bool)), this, SLOT(BloquearDesbloquearPrecio()));
        menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
    }
}

void TablaPrincipal::MostrarMenuCabecera(const QPoint &pos)
{
    int column=this->horizontalHeader()->logicalIndexAt(pos);    

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

void TablaPrincipal::MostrarMenuLateralTabla(const QPoint& pos)
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
    QObject::connect(AccionPegar, SIGNAL(triggered()), this, SLOT(PegarPartidas()));
    menu->popup(cabeceraVertical->viewport()->mapToGlobal(pos));
}

void TablaPrincipal::MostrarMenuTabla(const QPoint& pos)
{
    int columna=this->horizontalHeader()->logicalIndexAt(pos);
    switch (columna)
    {
    case tipoColumnaTPrincipal::RESUMEN:
        MenuResumen(pos);
        break;
    case tipoColumnaTPrincipal::PRPRES:
    case tipoColumnaTPrincipal::PRCERT:
        MenuPrecio(pos);
        break;
    default:
        break;
    }
}

void TablaPrincipal::CopiarPartidas()
{
    qDebug()<<"Copiar tabla principal";
    emit Copiar();
}

void TablaPrincipal::PegarPartidas()
{
    emit Pegar();
}

void TablaPrincipal::Mayusculas()
{
    QModelIndex indice = this->currentIndex();
    this->model()->setData(indice,indice.data().toString().toUpper());
}

void TablaPrincipal::Minusculas()
{
    QModelIndex indice = this->currentIndex();
    this->model()->setData(indice,indice.data().toString().toLower());
}

void TablaPrincipal::BloquearDesbloquearPrecio()
{
    PrincipalModel* m = dynamic_cast<PrincipalModel*>(this->model());
    if (m)
    {
        m->BloquearPrecio(currentIndex(), m_opcion_precio);
    }
}
