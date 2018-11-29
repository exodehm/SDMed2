#include "undoinsertarprincipal.h"
#include "./defs.h"
#include <QDebug>

/*************INSERTAR PARTIDAS**************/

UndoInsertarPartidas::UndoInsertarPartidas(QString tablaactual, QString cod_padre, QVariant nuevocod, int pos, QVariant descripcion):
    tabla(tablaactual),codigopadre(cod_padre),nuevocodigo(nuevocod.toString()),posicion(pos)
{
    qDebug()<<"Undo insertar nueva partida en la tabla "<<tabla<<" con el código: "<<nuevocodigo<<
              " bajo la partida: "<<codigopadre<<" en la posicion: "<<QString::number(posicion);
}

void UndoInsertarPartidas::undo()
{
    QString cadenaborrar = "SELECT borrar('"+tabla+"','"+codigopadre+"','"+nuevocodigo+"');";
    qDebug()<<cadenaborrar;
    consulta.exec(cadenaborrar);
}

void UndoInsertarPartidas::redo()
{
    QString cadenainsertar = "SELECT insertar_partida('"+tabla+"','"+codigopadre+"','"+nuevocodigo\
            +"','"+QString::number(posicion)+"')";
    qDebug()<<cadenainsertar;
    consulta.exec(cadenainsertar);
}

/*************BORRAR PARTIDAS**************/

UndoBorrarPartidas::UndoBorrarPartidas(QString tablaactual, QStringList codigos, QVariant descripcion):
    tabla(tablaactual)
{
    codigopadre = codigos.at(0);
    codigos.pop_front();
    codigoshijos = codigos;
}

void UndoBorrarPartidas::undo()
{
    qDebug()<<"restablecer lo borrado con "<<partidas.size()<<" partidas primarias borradas";
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


void UndoBorrarPartidas::redo()
{
    QString cadenaborrar;
    QString arrayscodigoshijos;
    int i=0;
    for (auto elem : codigoshijos)
    {
        arrayscodigoshijos.append(elem);
        if (i<codigoshijos.size()-1)
        {
            arrayscodigoshijos.append(",");
        }
        i++;
    }
    qDebug()<<arrayscodigoshijos;
    cadenaborrar = "SELECT * FROM borrar_hijos('"+tabla+"','"+codigopadre+"','"+arrayscodigoshijos+"');";
    consulta.exec(cadenaborrar);
}
