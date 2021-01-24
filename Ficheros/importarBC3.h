#ifndef IMPORTARBC3_H
#define IMPORTARBC3_H

#include <QString>
#include <QSqlQuery>
#include <QHash>
#include <QDialog>

class ImportarBC3 : public QDialog
{
public:
    enum eTipoImportacion{NORMAL, SIMPLIFICADO};

    ImportarBC3(const QStringList & listadoBC3, bool& abierta);
    int crearObra(QStringList& registroC);
    bool procesarConceptos(const QStringList& registroC, eTipoImportacion tipo);
    bool procesarRelaciones(const QStringList& registroD, eTipoImportacion tipo);
    bool procesarMediciones (QStringList& registroM);
    void procesarTexto(const QStringList& registroT);

    QString LeeCodigo() const;
    QString LeeResumen() const;
    bool quitarSimbolos(QString& codigo);
    QString ProcesarCadenaFecha(const QString& cadena);
    void CrearHashTexto(const QStringList& registroT);
    void BorrarIntentoObra(const QString& mensajeerror);

private:
    QSqlDatabase db;
    QSqlQuery consulta;
    //QSqlDatabase db_superuser;
    QString codigo,resumen;
    const int TAM_MAX = 20000;
    eTipoImportacion tipoImportacion;
    QHash<QString,QString>hashtexto;

};

#endif // IMPORTARBC3_H
