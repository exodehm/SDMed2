#ifndef ABRIRGUARDARBC3_H
#define ABRIRGUARDARBC3_H

#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>


class AbrirGuardarBC3
{
public:
    AbrirGuardarBC3(const QStringList & listadoBC3, bool& abierta);
    int crearObra(QStringList& registroC);
    void procesarConceptos(QStringList& registroC);
    void procesarRelaciones(const QStringList& registroD);
    QString LeeCodigo() const;
    QString LeeResumen() const;
    void quitarSimbolos(QString& codigo);

private:
    QSqlQuery consulta;
    QString codigo,resumen;
};

#endif // ABRIRGUARDARBC3_H
