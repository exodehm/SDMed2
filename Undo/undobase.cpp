#include "undobase.h"
#include <QDebug>

UndoBase::UndoBase(const QString& nombretabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                   const QVariant& datoNuevo, const QVariant& descripcion):
    m_tabla(nombretabla),m_codigopadre(codigopadre),m_codigohijo(codigohijo),m_datoAntiguo(datoAntiguo),m_datoNuevo(datoNuevo),m_descripcion(descripcion)
{

}


UndoMedicionBase::UndoMedicionBase(const QString &nombretabla, const QString &id_padre, const QString &id_hijo, const int &num_cert, const QString &posicion, const QVariant &descripcion):
    m_tabla(nombretabla),m_codigopadre(id_padre),m_codigohijo(id_hijo),m_num_cert(num_cert), m_posicion(posicion),m_descripcion(descripcion)
{
}


QString UndoMedicionBase::ObtenerIdPorPosicion()
{
    QString cadenaconsultarid = "SELECT * FROM id_por_posicion('" + m_tabla + "','" + m_codigopadre + "','" + m_codigohijo + "','"
            + m_posicion + "','" + QString::number(m_num_cert)+ "')";
    qDebug()<<"CAdena ID "<<cadenaconsultarid;
    m_consulta.exec(cadenaconsultarid);
    QString cadenaid;
    while (m_consulta.next())
    {
        cadenaid.append(m_consulta.value(0).toString());
    }
    return cadenaid;
}

QString UndoMedicionBase::ObtenerArrayIdPorPosicion()
{
    QString arraycadenaid;
    arraycadenaid.append("{");
    arraycadenaid.append(ObtenerIdPorPosicion());
    arraycadenaid.append("}");
    return arraycadenaid;
}

