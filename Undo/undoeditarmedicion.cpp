#include "undoeditarmedicion.h"
#include <QDebug>

UndoEditarMedicion::UndoEditarMedicion(QString nombretabla, QString id_padre, QString id_hijo,
                                       QVariant dato_antiguo, QVariant dato_nuevo, QString pos,
                                       int nombrecolumna, int fase, QVariant descripcion):
    tabla(nombretabla),idpadre(id_padre),idhijo(id_hijo),datoAntiguo(dato_antiguo),datoNuevo(dato_nuevo),
    posicion(pos),columna(nombrecolumna),num_cert(fase)
{
    qDebug()<<descripcion.toString();
}

void UndoEditarMedicion::undo()
{
    QString idfila = ObtenerIdPorPosicion();
    QString cadena = "SELECT modificar_campo_medcert('"+\
            tabla+"','"+idpadre+"','"+idhijo+"','"+\
            datoAntiguo.toString()+"','"+\
            idfila+"','"+\
            QString::number(columna)+"','"+\
            QString::number(num_cert)+\
            "');";
    qDebug()<<cadena;
    consulta.exec(cadena);
}

void UndoEditarMedicion::redo()
{
    QString idfila = ObtenerIdPorPosicion();
    QString cadena = "SELECT modificar_campo_medcert('"+\
            tabla+"','"+idpadre+"','"+idhijo+"','"+\
            datoNuevo.toString()+"','"+\
            idfila+"','"+\
            QString::number(columna)+"','"+\
            QString::number(num_cert)+\
            "');";
    qDebug()<<cadena;
    consulta.exec(cadena);
}

QString UndoEditarMedicion::ObtenerIdPorPosicion()
{
    QString cadenaconsultarid = "SELECT * FROM id_por_posicion('" + tabla + "','" + idpadre + "','" + idhijo + "','"
            + posicion + "','" + QString::number(num_cert)+ "')";
    //qDebug()<<"CAdena ID "<<cadenaconsultarid;
    consulta.exec(cadenaconsultarid);
    QString cadenaid;
    while (consulta.next())
    {
        cadenaid.append(consulta.value(0).toString());
    }
    return cadenaid;
}

/*************BORRAR LINEA MEDICION******************/
UndoBorrarLineasMedicion::UndoBorrarLineasMedicion(const QString& nombretabla, const QList<QString>&idsborrar, int fase, QVariant descripcion):
    tabla(nombretabla),ids(idsborrar),num_certif(fase)
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

    QString cadenaborrarfilas = "SELECT borrar_lineas_medcert('"+tabla+"','"+cadenaborrar+"','" + QString::number(num_certif)+ "','t','t')";
    qDebug()<<cadenaborrarfilas;
    consulta.exec(cadenaborrarfilas);
}

/*************INSERTAR LINEA MEDICION/CERTIFICACION******************/
UndoInsertarLineaMedicion::UndoInsertarLineaMedicion(const QString& nombretabla, const QString& codpadre, const QString& codhijo,
                                                     const int num_filas, const int pos, int fase, QVariant descripcion):
    tabla(nombretabla),codigopadre(codpadre),codigohijo(codhijo), numFilas(num_filas), posicion(pos), num_cert(fase)
{
    qDebug()<<descripcion;
}

void UndoInsertarLineaMedicion::undo()
{
    //en este caso no me interesa guardar las lineas borradas, porque la accion es la contraria al insertado, no un borrado directo
    QString cadenaborrarfilas = "SELECT borrar_lineas_medcert('"+tabla+"','"+cadenaid+"','" + QString::number(num_cert)+ "','f','t')";
    qDebug()<<cadenaborrarfilas;
    consulta.exec(cadenaborrarfilas);
}

void UndoInsertarLineaMedicion::redo()
{
    QString cadenainsertar = "SELECT insertar_lineas_medcert('"+tabla+"','"+codigopadre+"','"+codigohijo+"','"+QString::number(numFilas)+"','"+
            QString::number(posicion)+"','"+QString::number(num_cert)+"')";
    qDebug()<<"cadena insertar"<<cadenainsertar;
    consulta.exec(cadenainsertar);
    //ahora preparo el array de ids a borrar para la orden redo. En este caso será siempre un array de un solo elemento, ya que la insercion se hace de uno en uno
    QString cadenaconsultarid = "SELECT * FROM id_por_posicion('" + tabla + "','" + codigopadre + "','" + codigohijo + "','"
            + QString::number(posicion) + "','" + QString::number(num_cert)+ "')";
    //qDebug()<<"CAdena ID "<<cadenaconsultarid;
    consulta.exec(cadenaconsultarid);
    cadenaid.clear();
    cadenaid.append("{");
    while (consulta.next())
    {
        cadenaid.append(consulta.value(0).toString());
    }
    cadenaid.append("}");
}


/*************CERTIFICAR LINEA MEDICION******************/
UndoCertificarLineaMedicion::UndoCertificarLineaMedicion(const QString& nombretabla, const QString &codpadre, const QString &codhijo, const QString indices, const QString num_cert, QVariant descripcion):
    tabla(nombretabla),codigopadre(codpadre),codigohijo(codhijo),indices(indices),num_cert(num_cert)
{
    qDebug()<<descripcion;
}

void UndoCertificarLineaMedicion::undo()
{
    /*QString cadenaborrarfilas = "SELECT borrar_lineas_medicion('"+tabla+"','"+cadenaid+"','f','t',)";
    consulta.exec(cadenaborrarfilas);*/
}

void UndoCertificarLineaMedicion::redo()
{
    QString cadenacertificar = "SELECT certificar('"+tabla+"','"+codigopadre+"','"+codigohijo+"','"+indices+"','"+num_cert+"')";
    qDebug()<<cadenacertificar;
    consulta.exec(cadenacertificar);
    while (consulta.next())
    {
        if (consulta.value(0).toBool()==false)
        {
            qDebug()<<"No hay certificacion";
        }
    }
}
