#include "undoeditarprincipal.h"
#include <QDebug>

UndoEditarPrincipal::UndoEditarPrincipal(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    tabla(tabla), codigopadre(cod_padre), codigohijo(cod_hijo), datoAntiguo(dato_antiguo),datoNuevo(dato_nuevo)
{
    qDebug()<<"Descripcion: "<<descripcion;
}

/************RESUMEN*******************/
UndoEditarResumen::UndoEditarResumen(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}

void UndoEditarResumen::undo()
{
    QString cadenaconsulta = "SELECT modificar_resumen('" +tabla+ "','" +codigopadre+ "','" +datoAntiguo.toString()+ "');";
    consulta.exec(cadenaconsulta);
}

void UndoEditarResumen::redo()
{
    QString cadenaconsulta = "SELECT modificar_resumen('" +tabla+ "','" +codigopadre+ "','" +datoNuevo.toString()+ "');";
    consulta.exec(cadenaconsulta);
}



/************NATURALEZA*******************/
UndoEditarNaturaleza::UndoEditarNaturaleza(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}

void UndoEditarNaturaleza::undo()
{
    QString cadenaconsulta = "SELECT modificar_naturaleza('" +tabla+ "','" +codigopadre+ "'," +datoAntiguo.toString()+ ");";
    consulta.exec(cadenaconsulta);
}

void UndoEditarNaturaleza::redo()
{
    QString cadenaconsulta = "SELECT modificar_naturaleza('" +tabla+ "','" +codigopadre+ "'," +datoNuevo.toString()+ ");";    
    consulta.exec(cadenaconsulta);
}


/************PRECIO*******************/
UndoEditarPrecio::UndoEditarPrecio(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}

void UndoEditarPrecio::undo()
{
    QString cadenaconsulta = "SELECT modificar_precio('" +tabla+ "','" +codigopadre+ "'," +datoAntiguo.toString()+ ");";
    consulta.exec(cadenaconsulta);
}

void UndoEditarPrecio::redo()
{
    QString cadenaconsulta = "SELECT modificar_precio('" +tabla+ "','" +codigopadre+ "'," +datoNuevo.toString()+ ");";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}
