#include "exportar.h"

Exportar::Exportar(const QString &tabla)
{

}

void Exportar::Escribir(QFile &fichero)
{
    QString cadenabc3;
    EscribirRegistroV(cadenabc3);
    //EscribirRegistroK(cadenabc3);
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
    }
    QTextStream texto(&fichero);
    texto.setCodec("Windows-1252");
    texto<<cadenabc3;
    //ofs<<FinDeArchivo;*/

}

void Exportar::EscribirRegistroV(QString &cadena)
{

}

