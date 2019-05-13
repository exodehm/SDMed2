#ifndef UNDOBASE_H
#define UNDOBASE_H

#include <QUndoCommand>
#include <QVariant>
#include <QSqlQuery>


class UndoBase : public QUndoCommand
{
public:
    UndoBase(const QString& nombretabla, const QString& codigopadre, const QString& codigohijo, const QVariant& datoAntiguo,
             const QVariant& datoNuevo, const QVariant& descripcion);

protected:
    QSqlQuery m_consulta;
    QVariant m_datoAntiguo, m_datoNuevo, m_descripcion;
    QString m_tabla, m_codigopadre, m_codigohijo;
};


class UndoMedicionBase : public QUndoCommand
{
public:
    UndoMedicionBase (const QString& nombretabla,const QString& id_padre,const QString& id_hijo,
    const int& num_cert, const int& posicion, const QVariant& descripcion);

    QString ObtenerIdPorPosicion();
    QString ObtenerArrayIdPorPosicion();

protected:
    QString m_tabla, m_codigopadre, m_codigohijo;
    QSqlQuery m_consulta;
    int m_num_cert;
    int m_posicion;
    QVariant m_descripcion;
};

#endif // UNDOBASE_H
