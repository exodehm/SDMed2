#ifndef UNDOBASE_H
#define UNDOBASE_H

#include <QUndoCommand>
#include <QVariant>
#include <QSqlQuery>


class UndoBase : public QUndoCommand
{
public:
    UndoBase(const QString& tabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
             const QVariant& datoNuevo, const QVariant& descripcion);

protected:
    QSqlQuery m_consulta;
    QVariant m_datoAntiguo, m_datoNuevo, m_descripcion;
    QString m_tabla, m_codigopadre, m_codigohijo;
};

#endif // UNDOBASE_H
