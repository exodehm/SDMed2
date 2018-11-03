#include "undoeditarmedicion.h"
#include <QDebug>

UndoEditarMedicion::UndoEditarMedicion(QString nombretabla, QString id_padre, QString id_hijo,
                                       QVariant dato_antiguo, QVariant dato_nuevo, QString id_fila,
                                       int nombrecolumna, QVariant descripcion):
    tabla(nombretabla),idpadre(id_padre),idhijo(id_hijo),datoAntiguo(dato_antiguo),datoNuevo(dato_nuevo),
    idfila(id_fila),columna(nombrecolumna)
{
    qDebug()<<descripcion.toString();
}

void UndoEditarMedicion::undo()
{
    QString cadena = "SELECT modificar_campo_medicion('"+\
            tabla+"','"+idpadre+"','"+idhijo+"','"+\
            datoAntiguo.toString()+"','"+\
            idfila+"','"+\
            QString::number(columna)+"');";
    qDebug()<<cadena;
    consulta.exec(cadena);
}

void UndoEditarMedicion::redo()
{
    QString cadena = "SELECT modificar_campo_medicion('"+\
            tabla+"','"+idpadre+"','"+idhijo+"','"+\
            datoNuevo.toString()+"','"+\
            idfila+"','"+\
            QString::number(columna)+"');";
    qDebug()<<cadena;
    consulta.exec(cadena);
}


UndoBorrarLineasMedicion::UndoBorrarLineasMedicion(const QList<QList<QVariant> > &lineas, QVariant descripcion):
    datos(lineas)
{    
    qDebug()<<descripcion;
}

void UndoBorrarLineasMedicion::undo()
{

}

void UndoBorrarLineasMedicion::redo()
{
    foreach (const QList<QVariant>&d, datos)
    {
        QString cadenaborrar = "SELECT borrar_linea_medicion('"+d.at(0).toString()+"','"+d.at(10).toString()+"');";
        qDebug()<<cadenaborrar;
        consulta.exec(cadenaborrar);
    }
}
