#ifndef EXPORTAR_H
#define EXPORTAR_H

#include <QString>
#include <QFile>


class Exportar
{
public:
    Exportar(const QString& tabla);

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
};

#endif // EXPORTAR_H
