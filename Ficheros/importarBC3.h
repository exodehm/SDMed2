#ifndef IMPORTARBC3_H
#define IMPORTARBC3_H

#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>


class ImportarBC3
{
public:
    ImportarBC3(const QStringList & listadoBC3, bool& abierta);
    int crearObra(QStringList& registroC);
    void procesarConceptos(QStringList& registroC);
    void procesarRelaciones(const QStringList& registroD);
    void procesarMediciones (QStringList& registroM);
    void procesarTexto(const QStringList& registroT);

    QString LeeCodigo() const;
    QString LeeResumen() const;
    bool quitarSimbolos(QString& codigo);

private:
    QSqlQuery consulta;
    QString codigo,resumen;
};

#endif // IMPORTARBC3_H
