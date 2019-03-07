#include "undoeditarmedicion.h"
#include <QDebug>

UndoEditarMedicion::UndoEditarMedicion(QString nombretabla, QString id_padre, QString id_hijo,
                                       QVariant dato_antiguo, QVariant dato_nuevo, QString id_fila,
                                       int nombrecolumna, tipoTablaMedCert tipotabla, QVariant descripcion):
    tabla(nombretabla),idpadre(id_padre),idhijo(id_hijo),datoAntiguo(dato_antiguo),datoNuevo(dato_nuevo),
    idfila(id_fila),columna(nombrecolumna),eTipoTabla(tipotabla)
{
    qDebug()<<descripcion.toString();
}

void UndoEditarMedicion::undo()
{
    QString cadena = "SELECT modificar_campo_medcert('"+\
            tabla+"','"+idpadre+"','"+idhijo+"','"+\
            datoAntiguo.toString()+"','"+\
            idfila+"','"+\
            QString::number(columna)+"','"+\
            QString::number(eTipoTabla)+\
            "');";
    qDebug()<<cadena;
    consulta.exec(cadena);
}

void UndoEditarMedicion::redo()
{
    QString cadena = "SELECT modificar_campo_medcert('"+\
            tabla+"','"+idpadre+"','"+idhijo+"','"+\
            datoNuevo.toString()+"','"+\
            idfila+"','"+\
            QString::number(columna)+"','"+\
            QString::number(eTipoTabla)+\
            "');";
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

    QString cadenaborrarfilas = "SELECT borrar_lineas_medicion('"+tabla+"','"+cadenaborrar+"',0,'t','t')";
    qDebug()<<cadenaborrarfilas;
    consulta.exec(cadenaborrarfilas);
}


/*************INSERTAR LINEA MEDICION******************/
UndoInsertarLineaMedicion::UndoInsertarLineaMedicion(const QString& nombretabla,const QString& codpadre, const QString& codhijo, const int num_filas, const int pos, enum tipoTablaMedCert tipo, QVariant descripcion):
    tabla(nombretabla),codigopadre(codpadre),codigohijo(codhijo), numFilas(num_filas), posicion(pos), eTipoTabla(tipo)
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
    QString cadenainsertar = "SELECT insertar_lineas_medcert('"+tabla+"','"+codigopadre+"','"+codigohijo+"','"+QString::number(numFilas)+"','"+QString::number(posicion)+"','"+QString::number(eTipoTabla)+"')";
    qDebug()<<"cadena insertar"<<cadenainsertar;
    consulta.exec(cadenainsertar);
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
