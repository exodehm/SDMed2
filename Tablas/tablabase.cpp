#include "tablabase.h"
#include "./filtrotablabase.h"
#include <QDebug>

TablaBase::TablaBase(int nColumnas, QWidget *parent): QTableView(parent)
{
    celdaBloqueada =  new bool[nColumnas];
    for (int i=0;i<nColumnas;i++)
    {
        celdaBloqueada[i]=false;
    }
    cabeceraHorizontal = this->horizontalHeader();
    cabeceraVertical = this->verticalHeader();
    alturaFilas = this->verticalHeader();
    dlgBA = new DelegadoBase;
    dlgCB = new DelegadoColumnasBloqueadas;        
    dlgNumTablaP = new DelegadoNumerosTablaPrincipal;
    dlgNumTablaMC = new DelegadoNumerosTablaMedCert;
    dlgFM = new DelegadoFormulasMedicion;
    //filtro = new Filter;
    //installEventFilter(filtro);
    //installEventFilter(new FiltroTablaBase(this));
    cabeceraHorizontal->setContextMenuPolicy(Qt::CustomContextMenu);
    cabeceraVertical->setContextMenuPolicy(Qt::CustomContextMenu);
    this->setContextMenuPolicy(Qt::CustomContextMenu);
    mapperH = new QSignalMapper(cabeceraHorizontal);
    mapperV = new QSignalMapper(cabeceraVertical);

    resizeColumnsToContents();
    resizeRowsToContents();
    setEditTriggers(QAbstractItemView::SelectedClicked | QAbstractItemView::AnyKeyPressed);

    cabeceraHorizontal->setSectionResizeMode(QHeaderView::Fixed);
    alturaFilas->setDefaultSectionSize(24);

    QObject::connect(cabeceraHorizontal, SIGNAL(customContextMenuRequested(QPoint)), SLOT(MostrarMenuCabecera(QPoint)));
    QObject::connect(cabeceraVertical, SIGNAL(customContextMenuRequested(QPoint)), SLOT(MostrarMenuLateralTabla(QPoint)));
    QObject::connect(this, SIGNAL(customContextMenuRequested(QPoint)), SLOT(MostrarMenuTabla(QPoint)));
}

TablaBase::~TablaBase()
{
    qDebug()<<"Borrando tabla";
    delete model();
}

bool TablaBase::columnaBloqueada(int columna)
{
    return celdaBloqueada[columna];
}

void TablaBase::Bloquear(int columna)
{
    if (columna>=limiteIzquierdo && columna<=limiteDerecho)
    {
        celdaBloqueada[columna]=!celdaBloqueada[columna];
        if (columnaBloqueada(columna))
        {
            setItemDelegateForColumn(columna,dlgCB);
        }
        else       
        {
            PonerDelegadoOriginal(columna);
        }
        clearSelection();
    }
}

/*void TablaBase::Copiar()
{
    qDebug()<<sender()->parent();
    /*TablaBase* tabla = qobject_cast<TablaBase*>(sender()->parent());
    MedCertModel* mod = qobject_cast<MedCertModel*>(tabla->model());//pruebo a castear a modelo de tabla medicion
    if (mod)
    {
        emit CopiarMedicion();
    }
    else
    {
        emit CopiarPartidas();
    }*/
    /*qDebug()<<"emit copiar contenido";
    emit CopiarContenido();
}*/

/*void TablaBase::Pegar()
{
    qDebug()<<sender()->parent();    
    emit PegarContenido();
}*/

void TablaBase::SeleccionarTodo()
{
    selectAll();
}

void TablaBase::Certificar()
{    
    emit CertificarLineasMedicion();
}

QHeaderView* TablaBase::CabeceraDeTabla()
{
    return cabeceraHorizontal;
}

void TablaBase::PonerDelegadoOriginal(int columna)
{
    if (sender()->parent()->parent()->objectName()=="TablaP") //tabla principal
    {
        if (columna!=tipoColumnaTPrincipal::CODIGO && columna!=tipoColumnaTPrincipal::UD && columna!=tipoColumnaTPrincipal::RESUMEN)
        {
            setItemDelegateForColumn(columna,dlgNumTablaP);
        }
        else
        {
            setItemDelegateForColumn(columna,dlgBA);
        }
    }
    else //tabla de mediciones o certificaciones
    {
        if (columna==tipoColumnaTMedCert::N || columna==tipoColumnaTMedCert::LONGITUD || columna==tipoColumnaTMedCert::ANCHURA || columna==tipoColumnaTMedCert::ALTURA)
        {
            setItemDelegateForColumn(columna,dlgNumTablaMC);
        }
        else
        {
            setItemDelegateForColumn(columna,dlgBA);
        }
    }
}
