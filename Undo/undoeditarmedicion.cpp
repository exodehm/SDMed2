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

/*************BORRAR LINEA MEDICION******************/
UndoBorrarLineasMedicion::UndoBorrarLineasMedicion(const QString &nombretabla, const QList<QString> &idsborrar, QVariant descripcion):
    tabla(nombretabla),ids(idsborrar)
{    
    cadenaborrar.append("{");
    foreach (QString i, ids)
    {
        cadenaborrar.append(i);
        cadenaborrar.append(",");
    }
    cadenaborrar.chop(1);;
    cadenaborrar.append("}");
    qDebug()<<descripcion;
}

void UndoBorrarLineasMedicion::undo()
{
    QString cadenaborrarfilas = "SELECT restaurar_lineas_borradas('"+tabla+"')";
    qDebug()<<cadenaborrarfilas;
    consulta.exec(cadenaborrarfilas);

}

void UndoBorrarLineasMedicion::redo()
{

    QString cadenaborrarfilas = "SELECT borrar_lineas_medicion('"+tabla+"','"+cadenaborrar+"','t','t')";
    qDebug()<<cadenaborrarfilas;
    consulta.exec(cadenaborrarfilas);
}


/*************INSERTAR LINEA MEDICION******************/
UndoInsertarLineaMedicion::UndoInsertarLineaMedicion(const QString& nombretabla, const QString &codpadre, const QString &codhijo, const int pos, QVariant descripcion):
    tabla(nombretabla),codigopadre(codpadre),codigohijo(codhijo),posicion(pos)
{
    qDebug()<<descripcion;
}

void UndoInsertarLineaMedicion::undo()
{
    QString cadenaborrarfilas = "SELECT borrar_lineas_medicion('"+tabla+"','"+cadenaid+"','f','t',)";
    consulta.exec(cadenaborrarfilas);
}

void UndoInsertarLineaMedicion::redo()
{
    QString cadenainsertar = "SELECT insertar_medicion('"+tabla+"','"+codigopadre+"','"+codigohijo+"','"+QString::number(posicion)+"')";
    qDebug()<<"cadena insertar"<<cadenainsertar;
    consulta.exec(cadenainsertar);
}
