#include "undobase.h"

UndoBase::UndoBase(const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
                   const QVariant& datoNuevo, const QVariant& descripcion):
    m_tabla(tabla),m_codigopadre(codigopadre),m_codigohijo(codigohijo),m_datoAntiguo(datoAntiguo),m_datoNuevo(datoNuevo),m_descripcion(descripcion)
{

}

