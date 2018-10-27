#include "Modelobase.h"
#include "tablaprincipalmodel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

ModeloBase::ModeloBase(const QString &tabla, const QString &cadenaInicio, QUndoStack *p, QObject *parent):tabla(tabla), consulta(cadenaInicio), pila(p), QSqlQueryModel(parent)
{
    hayFilaVacia=false;
    naturalezapadre = (int)Naturaleza::CAPITULO;
}

ModeloBase::~ModeloBase(){}

bool ModeloBase::esColumnaNumerica(int columna) const
{
    return  columna==tipoColumna::CANPRES ||
            columna==tipoColumna::CANCERT ||
            columna==tipoColumna::PORCERTPRES ||
            columna==tipoColumna::PRPRES ||
            columna==tipoColumna::PRCERT ||
            columna==tipoColumna::IMPPRES ||
            columna==tipoColumna::IMPCERT;
}

void ModeloBase::QuitarIndicadorFilaVacia()
{
    hayFilaVacia=false;
}

int ModeloBase::rowCount(const QModelIndex &parent) const
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

int ModeloBase::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return NUM_COLUMNAS;
}

QVariant ModeloBase::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (orientation == Qt::Horizontal)
    {
        if (role == Qt::DisplayRole)
        {
            if (datos.size()>=1)
            {
                return datos.at(0).at(section);
            }
        }
    }
    return QAbstractTableModel::headerData(section, orientation, role);
}

QVariant ModeloBase::data(const QModelIndex &index, int role) const
{
    /*if (!index.isValid()) return QVariant();
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
            return datos.at(indice.row()+1).at(indice.column());
        }
    }
    else if (indice.column()==tipoColumna::CODIGO || indice.column()==tipoColumna::UD ||indice.column()==tipoColumna::RESUMEN)
    {
        if (role == Qt::DisplayRole || role == Qt::EditRole)
        {
            return datos.at(indice.row()+1).at(indice.column());
        }
    }
    else if (indice.column()==tipoColumna::NATURALEZA)
    {
        if (role == Qt::DecorationRole)
        {
            return RepoIconos::GetIcon((Naturaleza)datos.at(indice.row()+1).at(indice.column()).toInt());
        }
        if (role == DatosIconos::ImageIndexRole)
        {
            return datos.at(indice.row()+1).at(indice.column());
        }
        if (role == Qt::ToolTipRole)
        {
            QString tip;
            tip = "<b>";
            tip += QString("%1</b>").arg(naturaleza::leyenda_nat[datos.at(indice.row()+1).at(indice.column()).toInt()]);
            return tip;
        }
    }
    return QVariant;*/
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
    else if (role == Qt::DisplayRole || role == Qt::EditRole)
    {
        return datos.at(indice.row()+1).at(indice.column());
    }
    return QVariant();
}

Qt::ItemFlags ModeloBase::flags(const QModelIndex &index) const
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

bool ModeloBase::insertRows(int row, int count, const QModelIndex &parent)
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

bool ModeloBase::removeRows(int filaInicial, int numFilas, const QModelIndex &parent)
{
    qDebug()<<"Remove rows en modelo base";
}

bool ModeloBase::HayFilaVacia()
{
    return hayFilaVacia;
}

int ModeloBase::FilaVacia()
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


void ModeloBase::ActualizarDatos(QString cadena_consulta)
{
    hayFilaVacia = false;
    datos.clear();
    //qDebug()<<"Consulta: "<<cadena_consulta;
    consulta.exec(cadena_consulta);
    QList<QVariant> lineaDatos;
    while (consulta.next())
    {
        for (int i=0;i<NUM_COLUMNAS;i++)
        {
            //qDebug()<<"CONSULTA.VALUE["<<i<<"] "<<consulta.value(i);
            if (consulta.value(i).type()==QVariant::Double)
            {
                float numero = consulta.value(i).toDouble();
                QString numeroletra = QString::number(numero, 'f', 2);
                lineaDatos.append(static_cast<QVariant>(numeroletra));
            }
            else
            {
                lineaDatos.append(consulta.value(i));
            }
        }
        datos.append(lineaDatos);
        lineaDatos.clear();
    }
    PrepararCabecera(datos);
    if (datos.size()<=1)//añado una fila extra para poder insertar hijos en caso de hojas
    {
        hayFilaVacia = true;
        filavacia=0;
    }
}
