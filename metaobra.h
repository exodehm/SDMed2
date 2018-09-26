#ifndef METAOBRA_H
#define METAOBRA_H

#include<QString>

class Instancia;


struct MetaObra
{
    Instancia* miobra;
    QString codigo;
    QString resumen;
    MetaObra();
    //~MetaObra(){delete miobra;}
};

#endif // METAOBRA_H
