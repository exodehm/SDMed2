#include "exportarBC3.h"
#include <QApplication>
#include <QDebug>
#include <QSqlQuery>

ExportarBC3::ExportarBC3(const QString &_tabla, const QString nombrefichero):tabla(_tabla)
{
    qDebug()<<"EXPORTANDO LA TABLA: "<<_tabla<<" en el fichero "<<nombrefichero;
    QFile ficheroBC3(nombrefichero);
    if (ficheroBC3.open(QIODevice::WriteOnly|QIODevice::Text))
    {
        Escribir(ficheroBC3);
    }
}

void ExportarBC3::Escribir(QFile &fichero)
{
    QString cadenabc3;
    EscribirRegistroV(cadenabc3);
    EscribirRegistroK(cadenabc3);
    EscribirRegistrosCDMT(cadenabc3);

    QTextStream texto(&fichero);
    texto.setCodec("Windows-1252");
    texto<<cadenabc3;
}

void ExportarBC3::EscribirRegistroV(QString &cadena)
{
    cadena.append("~V|"+QCoreApplication::organizationName()+"|FIEBDC-3/2012|"+QApplication::applicationName()+" "+QApplication::applicationVersion() +"||ANSI||||||");
    cadena.append("\n");
}

void ExportarBC3::EscribirRegistroK(QString &cadena)
{
    cadena.append("~K|\\2\\2\\3\\2\\2\\2\\2\\EUR\\|0|");
    cadena.append("\n");
}

void ExportarBC3::EscribirRegistrosCDMT(QString &cadena)
{
    QString cadenaconsultaregistrosDMTC = "SELECT exportarBC3('"+tabla+"');";
    qDebug()<<cadenaconsultaregistrosDMTC;
    QSqlQuery consulta;
    consulta.exec(cadenaconsultaregistrosDMTC);
    while (consulta.next())
    {
        qDebug()<<consulta.value(0);
        cadena.append(consulta.value(0).toString());
    }
    cadena.append("\n");
    cadena.replace("\n", "\r\n");
    cadena.replace("\r\r\n", "\r\n");
}
