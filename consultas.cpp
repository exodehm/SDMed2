#include "consultas.h"
#include <QDebug>

Consultas::Consultas()
{

}

QString Consultas::CrearObra(QString codigo, QString resumen)
{
    QString consulta = "SELECT crear_obra('" + codigo + "','"+resumen+"')";
    qDebug()<<consulta;
    return consulta;
}

QString Consultas::MostrarHijos(QString idpadre, QString idhijo)
{

QString consulta = "SELECT codigo,naturaleza,ud, resumen,cantidad,preciomed, cantidad*preciomed AS \"Importe\" \
                    FROM conceptos, relacion\
                    WHERE relacion.id_padre="+idhijo+"  AND conceptos.id = relacion.id_hijo";
return consulta;
}

QString Consultas::CabeceraTablaprincipal(QString idpadre, QString idhijo)
{
    QString consulta = "SELECT codigo, naturaleza, ud, resumen, cantidad, preciomed, cantidad*preciomed AS \"Importe\" \
                        FROM conceptos,relacion\
                        WHERE relacion.id_padre="+idpadre+" AND relacion.id_hijo = " +idhijo+ " AND conceptos.id = relacion.id_hijo";
    return consulta;
}
