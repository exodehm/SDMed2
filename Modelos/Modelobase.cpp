#include "Modelobase.h"
//#include "PrincipalModel.h"
#include "consultas.h"
#include "../defs.h"
#include "../iconos.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>
#include <QDebug>

ModeloBase::ModeloBase(const QString &tabla, const QStringList &ruta, MiUndoStack *p, QObject *parent):
    m_tabla(tabla), m_ruta(ruta), m_pila(p), QSqlQueryModel(parent)
{
    m_codigopadre = ruta.at(ruta.size()-2);
    m_codigohijo = ruta.at(ruta.size()-1);
    m_hayFilaVacia=false;
    m_naturalezapadre = (int)Naturaleza::CAPITULO;
}

ModeloBase::~ModeloBase(){}

bool ModeloBase::esColumnaNumerica(int columna) const
{
    return  columna==tipoColumnaTPrincipal::CANPRES ||
            columna==tipoColumnaTPrincipal::CANCERT ||
            columna==tipoColumnaTPrincipal::PORCERTPRES ||
            columna==tipoColumnaTPrincipal::PRPRES ||
            columna==tipoColumnaTPrincipal::PRCERT ||
            columna==tipoColumnaTPrincipal::IMPPRES ||
            columna==tipoColumnaTPrincipal::IMPCERT;
}

void ModeloBase::QuitarIndicadorFilaVacia()
{
    m_hayFilaVacia=false;
}

int ModeloBase::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    if (m_hayFilaVacia)
    {
        return m_datos.size();
    }
    else
    {
        return m_datos.size()-1;
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
            if (m_datos.size()>=1)
            {
                return m_datos.at(0).at(section);
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
    if (m_hayFilaVacia)
    {
        if (index.row()>=m_filavacia)
        {
            indice = this->index(index.row()-1,index.column());
        }
    }
    if (m_hayFilaVacia && index.row()==m_filavacia)
    {
        return QVariant();
    }
    else if (role == Qt::DisplayRole || role == Qt::EditRole)
    {
        return m_datos.at(indice.row()+1).at(indice.column());
    }
    else if (role == Qt::ToolTipRole)
    {
        if (index.column() == tipoColumnaTMedCert::FORMULA)
        {
            QString tip;
            tip = "<b>";
            tip += QString("%1</b>").arg(index.data().toString());
            return tip;
        }
    }
    return QVariant();
}

bool ModeloBase::insertRows(int row, int count, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    qDebug()<<"-Row: "<<row<<" -Count: "<<count;
    if (!HayFilaVacia())
    {
        beginInsertRows(QModelIndex(), row, row+count-1);
        m_hayFilaVacia = true;
        m_filavacia = row;
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
    return m_hayFilaVacia;
}

int ModeloBase::FilaVacia()
{
    if (m_hayFilaVacia)
    {
        qDebug()<<"Fila vacia en: "<<m_filavacia;
        return m_filavacia;
    }
    else
    {
        //return this->rowCount(QModelIndex());
        return -1;
    }
}

/*void ModeloBase::ActualizarIds(QString idpadre, QString idhijo)
{
    codigopadre=idpadre;
    codigohijo=idhijo;
}*/
