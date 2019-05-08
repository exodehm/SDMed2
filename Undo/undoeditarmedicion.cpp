#include "undoeditarmedicion.h"
#include <QDebug>

UndoEditarMedicion::UndoEditarMedicion(const QString &nombretabla, const QString &id_padre, const QString &id_hijo,
                                       const QVariant &dato_antiguo, const QVariant &dato_nuevo, const QString &pos,
                                       const int &nombrecolumna, const int &num_cert, const QVariant &descripcion):
    UndoBase(nombretabla,id_padre,id_hijo,dato_antiguo,dato_nuevo,descripcion), m_posicion(pos),m_columna(nombrecolumna),m_num_cert(num_cert)
{
    qDebug()<<descripcion.toString();
}

void UndoEditarMedicion::undo()
{
    QString idfila = ObtenerIdPorPosicion();
    QString cadena = "SELECT modificar_campo_medcert('"+\
            m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+"','"+\
            m_datoAntiguo.toString()+"','"+\
            idfila+"','"+\
            QString::number(m_columna)+"','"+\
            QString::number(m_num_cert)+\
            "');";
    qDebug()<<cadena;
    m_consulta.exec(cadena);
}

void UndoEditarMedicion::redo()
{
    QString idfila = ObtenerIdPorPosicion();
    QString cadena = "SELECT modificar_campo_medcert('"+\
            m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+"','"+\
            m_datoNuevo.toString()+"','"+\
            idfila+"','"+\
            QString::number(m_columna)+"','"+\
            QString::number(m_num_cert)+\
            "');";
    qDebug()<<cadena;
    m_consulta.exec(cadena);
}

QString UndoEditarMedicion::ObtenerIdPorPosicion()
{
    QString cadenaconsultarid = "SELECT * FROM id_por_posicion('" + m_tabla + "','" + m_codigopadre + "','" + m_codigohijo + "','"
            + m_posicion + "','" + QString::number(m_num_cert)+ "')";    
    qDebug()<<"CAdena ID "<<cadenaconsultarid;
    m_consulta.exec(cadenaconsultarid);
    QString cadenaid;    
    while (m_consulta.next())
    {
        cadenaid.append(m_consulta.value(0).toString());
    }
    return cadenaid;
}

QString UndoEditarMedicion::ObtenerArrayIdPorPosicion()
{
    QString arraycadenaid;
    arraycadenaid.append("{");
    arraycadenaid.append(ObtenerIdPorPosicion());
    arraycadenaid.append("}");
    return arraycadenaid;
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
    UndoEditarMedicion(nombretabla,codpadre,codhijo,QVariant(),QVariant(),QString::number(pos),-1,fase, descripcion),m_numFilas(num_filas)
{
    qDebug()<<descripcion;
}

void UndoInsertarLineaMedicion::undo()
{
    //en este caso no me interesa guardar las lineas borradas, porque la accion es la contraria al insertado, no un borrado directo
    QString cadenaborrarfilas = "SELECT borrar_lineas_medcert('"+m_tabla+"','"+m_cadenaid+"','" + QString::number(m_num_cert)+ "','f','t')";
    qDebug()<<cadenaborrarfilas;
    m_consulta.exec(cadenaborrarfilas);
}

void UndoInsertarLineaMedicion::redo()
{
    QString cadenainsertar = "SELECT insertar_lineas_medcert('"+m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+"','"+QString::number(m_numFilas)+"','"+
            m_posicion+"','"+QString::number(m_num_cert)+"')";
    qDebug()<<"cadena insertar"<<cadenainsertar;
    m_consulta.exec(cadenainsertar);
    //ahora preparo el array de ids a borrar para la orden redo. En este caso será siempre un array de un solo elemento, ya que la insercion se hace de uno en uno   
    m_cadenaid = ObtenerArrayIdPorPosicion();
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
