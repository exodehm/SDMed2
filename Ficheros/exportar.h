#ifndef EXPORTAR_H
#define EXPORTAR_H

#include <QString>
#include <QFile>



class ExportarBC3
{
public:
    ExportarBC3(const QString& _tabla, const QString nombrefichero);

    void Escribir(QFile& fichero);
    void EscribirRegistroV(QString& cadena);
    void EscribirRegistroK(QString &cadena);
    void EscribirRegistroC(QString &cadena);
    void EscribirRegistroD(QString &cadena);
    void EscribirRegistroM( QString &cadena);
    void EscribirRegistroT(QString &cadena);

    bool esRaiz(const QString &S);
    void quitarSimbolos(QString &codigo);
    void escribirAlmohadilla(QString &cadena);

private:
    QString tabla;
};

#endif // EXPORTAR_H
