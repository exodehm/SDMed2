#include "exportar.h"
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
    EscribirRegistroC(cadenabc3);
    /********Registros C y D**************/
    /*pNodo indice=obra->G->LeeRaiz();
    for (int i=0; i<obra->G->LeeNumNodos(); i++)
    {
        EscribirRegistroC(indice,cadenabc3,obra);
        if (indice->adyacente)
        {
            EscribirRegistroD(indice,cadenabc3,obra);
        }
        indice=indice->siguiente;
    }*/
    /*******Registro M y N************/
    /**vuelvo al inicio**/
    /*indice=obra->G->LeeRaiz();
    while(indice)
    {
        if (indice->adyacente)
        {
            pArista A = indice->adyacente;
            while (A)
            {
                EscribirRegistroM(indice, A, cadenabc3,obra);
                A=A->siguiente;
            }
        }
        indice=indice->siguiente;
    }*/
    /******************Registro T*************/
    /*indice=obra->G->LeeRaiz();
    while(indice)
    {
        if (!indice->datonodo.LeeTexto().isEmpty())
        {
            EscribirRegistroT(indice,cadenabc3);
        }
        indice=indice->siguiente;
    }*/
    QTextStream texto(&fichero);
    texto.setCodec("Windows-1252");
    texto<<cadenabc3;
    //ofs<<FinDeArchivo;

}

void ExportarBC3::EscribirRegistroV(QString &cadena)
{
    cadena.append("~V|EGSOFT S.A.|FIEBDC-3/2012|SDMed2 beta 0.1||ANSI||||||");
    cadena.append("\n");
}

void ExportarBC3::EscribirRegistroK(QString &cadena)
{
    cadena.append("~K|\\2\\2\\3\\2\\2\\2\\2\\EUR\\|0|");
    cadena.append("\r\n");
}

void ExportarBC3::EscribirRegistroC(QString &cadena)
{
    QString cadenaconsultaregistroC = "SELECT exportarBC3('"+tabla+"');";
    qDebug()<<cadenaconsultaregistroC;
    QSqlQuery consulta;
    consulta.exec(cadenaconsultaregistroC);
    while (consulta.next())
    {
        qDebug()<<consulta.value(0);
        cadena.append(consulta.value(0).toString());
    }
}

