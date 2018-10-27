#include "undoeditarprincipal.h"
#include "./defs.h"
#include <QDebug>


/************CODIGO*******************/
UndoEditarCodigo::UndoEditarCodigo(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}
//EN ESTE CASO SOLO NOS INTERESA EL codigohijo y el datoNuevo
void UndoEditarCodigo::undo()
{
    QString cadenaconsulta = "SELECT modificar_codigo('" +tabla+ "','" +datoNuevo.toString()+ "','" +codigohijo+ "');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}

void UndoEditarCodigo::redo()
{
    QString cadenaconsulta = "SELECT modificar_codigo('" +tabla+ "','" +codigohijo+ "','" +datoNuevo.toString()+ "');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}


UndoEditarPrincipal::UndoEditarPrincipal(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    tabla(tabla), codigopadre(cod_padre), codigohijo(cod_hijo), datoAntiguo(dato_antiguo),datoNuevo(dato_nuevo)
{
    qDebug()<<"Descripcion: "<<descripcion;
}

/************UNIDAD*******************/
UndoEditarUnidad::UndoEditarUnidad(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}

void UndoEditarUnidad::undo()
{
    QString cadenaconsulta = "SELECT modificar_unidad('" +tabla+ "','" +codigohijo+ "','" +datoAntiguo.toString()+ "');";
    consulta.exec(cadenaconsulta);
}

void UndoEditarUnidad::redo()
{
    QString cadenaconsulta = "SELECT modificar_unidad('" +tabla+ "','" +codigohijo+ "','" +datoNuevo.toString()+ "');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}

/************RESUMEN*******************/
UndoEditarResumen::UndoEditarResumen(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}

void UndoEditarResumen::undo()
{
    QString cadenaconsulta = "SELECT modificar_resumen('" +tabla+ "','" +codigohijo+ "','" +datoAntiguo.toString()+ "');";
    consulta.exec(cadenaconsulta);
}

void UndoEditarResumen::redo()
{
    QString cadenaconsulta = "SELECT modificar_resumen('" +tabla+ "','" +codigohijo+ "','" +datoNuevo.toString()+ "');";
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
    QString cadenaconsulta = "SELECT modificar_naturaleza('" +tabla+ "','" +codigohijo+ "'," +datoAntiguo.toString()+ ");";
    consulta.exec(cadenaconsulta);
}

void UndoEditarNaturaleza::redo()
{
    QString cadenaconsulta = "SELECT modificar_naturaleza('" +tabla+ "','" +codigohijo+ "'," +datoNuevo.toString()+ ");";
    consulta.exec(cadenaconsulta);
}


/************CANTIDAD*******************/
UndoEditarCantidad::UndoEditarCantidad(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
    QString cadenaGuardarLineasMediciom = "SELECT * from ver_lineas_medicion('"+tabla+"','"+cod_padre+"','"+cod_hijo+"');";
    //qDebug()<<cadenaGuardarLineasMediciom;
    consulta.exec(cadenaGuardarLineasMediciom);
    QList<QVariant>linea;
    while (consulta.next()) {
        for (int i=0;i<6;i++)
        {
            //qDebug()<<consulta.value(i);
            linea.append(consulta.value(i));
        }
        lineasMedicion.append(linea);
        linea.clear();
    }
}

void UndoEditarCantidad::undo()
{
    if (lineasMedicion.isEmpty())//si no hay medicion guardada pongo el antiguo valor
    {
        QString cadenaconsulta = "SELECT modificar_cantidad('" +tabla+ "','" +codigopadre + "','" +codigohijo+ "'," + datoAntiguo.toString()+ ");";
        consulta.exec(cadenaconsulta);
    }
    else//si la hay, repongo la medicion
    {
        foreach (const QList<QVariant>&linea, lineasMedicion)
        {
            QString cadenainsertarlineasmedicion = "SELECT insertar_medicion('"+ tabla +"','"+ codigopadre +"','"+\
                    codigohijo+"','"+linea.at(0).toString()+\
                    "','"+ linea.at(1).toString()+\
                    "','"+ linea.at(2).toString()+\
                    "','"+ linea.at(3).toString()+\
                    "','"+ linea.at(4).toString()+\
                    "','"+ linea.at(5).toString()+"');";
            qDebug()<<cadenainsertarlineasmedicion;
            consulta.exec(cadenainsertarlineasmedicion);
        }
    }
}

void UndoEditarCantidad::redo()
{   
    QString cadenaborrarlineasmedicion = "SELECT borrar_lineas_medicion('"+tabla+"','"+codigopadre+"','"+codigohijo+"');";
    qDebug()<<"cadenaborrarlineasmedicion"<<cadenaborrarlineasmedicion;
    consulta.exec(cadenaborrarlineasmedicion);
    QString cadenaconsulta = "SELECT modificar_cantidad('" +tabla+ "','" +codigopadre + "','" +codigohijo+ "'," + datoNuevo.toString()+ ");";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}

/************PRECIO*******************/
UndoEditarPrecio::UndoEditarPrecio(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, int opc, QVariant descripcion):
    opcion(opc), UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion)
{
}

void UndoEditarPrecio::undo()
{
    QString cadenaconsulta;
    switch (opcion)
    {
    case precio::SUPRIMIR:
    {
        qDebug()<<"restablecer lo borrado";
        QString cadenaconsulta;
        for (int i = 0;i<partidas.size();i++)
        {
            cadenaconsulta = "SELECT insertar_partida('"+tabla+ "','" +\
                    partidas.at(i).at(partidasSQL::CODIGOPADRE).toString()+"','" +\
                    partidas.at(i).at(partidasSQL::CODIGOHIJO).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::POSICION).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::UNIDAD).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::RESUMEN).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::DESCRIPCION).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::PRECIO).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::CANTIDAD).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::NATURALEZA).toString()+ "','"+\
                    partidas.at(i).at(partidasSQL::FECHA).toString()+"');";
            qDebug()<<cadenaconsulta;
            consulta.exec(cadenaconsulta);           
        }
    }
        break;
    case precio::MODIFICAR:
        cadenaconsulta= "SELECT modificar_precio('" +tabla+ "','" +codigohijo+ "'," +datoAntiguo.toString()+ ");";
        qDebug()<<cadenaconsulta;
        break;
    }
    consulta.exec(cadenaconsulta);
}

void UndoEditarPrecio::redo()
{
    QString cadenaconsulta;
    switch (opcion)
    {
    case precio::SUPRIMIR:
    {
        //primer paso-->borrar el descompuesto
        cadenaconsulta = "SELECT * from borrar_descompuesto('"+tabla+"','"+codigohijo+"');";
        qDebug()<<"Cadena suprimir descompuesto: "<<cadenaconsulta;
        consulta.exec(cadenaconsulta);
        QList<QVariant>linea;
        while (consulta.next())
        {
            for (int i=0;i<10;i++)
            {
                linea.append(consulta.value(i));
            }
            partidas.append(linea);
            linea.clear();
        }
        //segundo paso-->cambiar el precio
        cadenaconsulta = "SELECT modificar_precio('"+tabla+"','"+codigohijo+"','"+datoNuevo.toString()+"');";
        consulta.exec(cadenaconsulta);
        break;
    }
    case precio::MODIFICAR:
        cadenaconsulta= "SELECT modificar_precio('" +tabla+ "','" +codigohijo+ "'," +datoNuevo.toString()+ ");";
        qDebug()<<cadenaconsulta;
        consulta.exec(cadenaconsulta);
        break;
    }    
}
