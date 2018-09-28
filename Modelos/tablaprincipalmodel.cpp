#include "tablaprincipalmodel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

TablaPrincipalModel::TablaPrincipalModel(const QString &cadenaInicio, QObject *parent):consulta(cadenaInicio),QSqlQueryModel(parent)
{
    LeyendasCabecera[0]=QObject::tr("Código\n");
    LeyendasCabecera[1]=QObject::tr("Nat\n");
    LeyendasCabecera[2]=QObject::tr("Ud\n");
    LeyendasCabecera[3]=QObject::tr("Resumen\n");
    LeyendasCabecera[4]=QObject::tr("CanPres\n");
    LeyendasCabecera[5]=QObject::tr("CanCert\n");
    LeyendasCabecera[6]=QObject::tr("PorCertPres\n");
    LeyendasCabecera[7]=QObject::tr("PrPres\n");
    LeyendasCabecera[8]=QObject::tr("PrCert\n");
    LeyendasCabecera[9]=QObject::tr("ImpPres\n");
    LeyendasCabecera[10]=QObject::tr("ImpCert\n");

    hayFilaVacia=false;
    naturalezapadre = (int)Naturaleza::CAPITULO;
    ActualizarDatos(cadenaInicio);
}

TablaPrincipalModel::~TablaPrincipalModel(){}

bool TablaPrincipalModel::esColumnaNumerica(int columna) const
{
    return  columna==tipoColumna::CANPRES ||
            columna==tipoColumna::CANCERT ||
            columna==tipoColumna::PORCERTPRES ||
            columna==tipoColumna::PRPRES ||
            columna==tipoColumna::PRCERT ||
            columna==tipoColumna::IMPPRES ||
            columna==tipoColumna::IMPCERT;
}

void TablaPrincipalModel::QuitarIndicadorFilaVacia()
{
    hayFilaVacia=false;
}

int TablaPrincipalModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    if (hayFilaVacia)
    {
        return datos.size();
    }
    else
    {
        return datos.size()-1;
    }
}

int TablaPrincipalModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return NUM_COLUMNAS;
}

QVariant TablaPrincipalModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (orientation == Qt::Horizontal)
    {
        if (role == Qt::DisplayRole)
        {
            return datos.at(0).at(section).valor;
        }
    }
    return QAbstractTableModel::headerData(section, orientation, role);
}

QVariant TablaPrincipalModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();
    QModelIndex indice = index;
    if (hayFilaVacia)
    {
        if (index.row()>=filavacia)
        {
            indice = this->index(index.row()-1,index.column());
        }
    }   
    if (hayFilaVacia && index.row()==filavacia)
    {
        return QVariant();
    }
    else if (esColumnaNumerica(indice.column()))
    {
        if (role==Qt::DisplayRole || role == Qt::EditRole)
        {
            //return fila.at(indice.column());
            //qDebug()<<"En fila: "<<indice.column()<<" hay un valor: "<<fila.at(indice.column())<<" con el tipo: ";
            //QString test = QString("%1").arg(numero, 7, 'f',4, QLatin1Char('0'));
            //return QString("%1").arg(fila.at(indice.column()).toFloat(),7,'f',4,QLatin1Char('0'));
            return datos.at(indice.row()+1).at(indice.column()).valor;
        }
    }
    else if (indice.column()==tipoColumna::CODIGO || indice.column()==tipoColumna::UD ||indice.column()==tipoColumna::RESUMEN)
    {
        if (role == Qt::DisplayRole || role == Qt::EditRole)
        {            
            return datos.at(indice.row()+1).at(indice.column()).valor;
        }
    }
    else if (indice.column()==tipoColumna::NATURALEZA)        
    {
        if (role == Qt::DecorationRole)
        {
            return RepoIconos::GetIcon((Naturaleza)datos.at(indice.row()+1).at(indice.column()).valor.toInt());
        }
        if (role == DatosIconos::ImageIndexRole)
        {
            return datos.at(indice.row()+1).at(indice.column()).valor;
        }
        if (role == Qt::ToolTipRole)
        {
            QString tip;
            tip = "<b>";
            tip += QString("%1</b>").arg(naturaleza::leyenda_nat[datos.at(indice.row()+1).at(indice.column()).valor.toInt()]);
            return tip;
        }
    }
    return QVariant();
}

Qt::ItemFlags TablaPrincipalModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
    {
        return 0;
    }
    if (/*index.row()!= filavacia && */index.column()!=tipoColumna::IMPPRES && index.column()!=tipoColumna::IMPCERT)
    {
        return QAbstractTableModel::flags(index) | Qt::ItemIsEditable;
    }
    return  QAbstractItemModel::flags(index);
}

bool TablaPrincipalModel::setData(const QModelIndex &index, const QVariant &value, int role)
{

}

bool TablaPrincipalModel::insertRows(int row, int count, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    qDebug()<<"-Row: "<<row<<" -Count: "<<count;
    if (!HayFilaVacia())
    {
        beginInsertRows(QModelIndex(), row, row+count-1);
        hayFilaVacia = true;
        filavacia = row;
        endInsertRows();
    }
    return true;
}

bool TablaPrincipalModel::removeRows(int filaInicial, int numFilas, const QModelIndex &parent)
{

}

bool TablaPrincipalModel::HayFilaVacia()
{
    return hayFilaVacia;
}

int TablaPrincipalModel::FilaVacia()
{
    if (hayFilaVacia)
    {
        qDebug()<<"Fila vacia en: "<<filavacia;
        return filavacia;
    }
    else
    {
        //return this->rowCount(QModelIndex());
        return -1;
    }
}


void TablaPrincipalModel::ActualizarDatos(QString cadena_consulta)
{
    qDebug()<<"Se ejecuta la consulta"<<cadena_consulta;
    datos.clear();
    consulta.exec(cadena_consulta);
    QList<DatoCelda>lineaDatos;
    DatoCelda datoC;
    while (consulta.next())
    {
        for (int i=0;i<NUM_COLUMNAS;i++)
        {
            lineaDatos.append(datoC);
            lineaDatos[i].valor = consulta.value(i).toString();
            lineaDatos[i].color = QColor(Qt::green);
        }
        datos.append(lineaDatos);
        lineaDatos.clear();
    }
    for(int i=0; i<datos.at(0).length(); i++)
    {
        //leo la naturaleza del concepto padre
        if (i==tipoColumna::NATURALEZA)
        {
            naturalezapadre = datos.at(0).at(i).valor.toInt();
        }
        datos[0][i].valor.prepend(LeyendasCabecera[i]);
    }
    if (datos.size()<=1)//añado una fila extra para poder insertar hijos en caso de hojas
    {
        hayFilaVacia = true;
        filavacia=0;
    }
}

bool TablaPrincipalModel::EsPartida()
{
    return naturalezapadre == 7;
}
