#include "undoeditarmedicion.h"
#include <QDebug>

UndoEditarMedicion::UndoEditarMedicion(const QString &nombretabla, const QString &id_padre, const QString &id_hijo,
                                       const QVariant &dato_antiguo, const QVariant &dato_nuevo, const int &pos,
                                       const int &nombrecolumna, const int &num_cert, const QVariant &descripcion):

    UndoMedicionBase(nombretabla,id_padre,id_hijo,num_cert,pos,descripcion),m_datoAntiguo(dato_antiguo),m_datoNuevo(dato_nuevo),m_columna(nombrecolumna)

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

/*************BORRAR LINEA MEDICION******************/
UndoBorrarLineasMedicion::UndoBorrarLineasMedicion(const QString& nombretabla, const QString& id_padre, const QString& id_hijo,
                                                   const QList<int>&lineas, const int& num_cert, const QVariant& descripcion):
    UndoMedicionBase(nombretabla,id_padre,id_hijo,num_cert,int(),descripcion)
{
    m_array_lineas_borrar.append("{");
    foreach (const int&dato, lineas)
    {
        m_array_lineas_borrar.append(QString::number(dato));
        qDebug()<<"lineas a borrar: "<<dato;
        m_array_lineas_borrar.append(",");
    }
    m_array_lineas_borrar.chop(1);//le quito la ultima coma
    m_array_lineas_borrar.append("}");

}

void UndoBorrarLineasMedicion::undo()
{
    QString cadenaborrarfilas = "SELECT restaurar_lineas_borradas('"+m_tabla+"')";
    qDebug()<<cadenaborrarfilas;
    m_consulta.exec(cadenaborrarfilas);

}

void UndoBorrarLineasMedicion::redo()
{

    QString cadenaborrarfilas = "SELECT borrar_lineas_medcert('"+ m_tabla +"','"+ m_codigopadre +"','"+ m_codigohijo +"','"+
            QString::number(m_num_cert) + "','" + m_array_lineas_borrar  + "','t','t')";
    qDebug()<<cadenaborrarfilas;
    m_consulta.exec(cadenaborrarfilas);
}

/*************INSERTAR LINEA MEDICION/CERTIFICACION******************/
UndoInsertarLineaMedicion::UndoInsertarLineaMedicion(const QString& nombretabla, const QString& id_padre, const QString& id_hijo,
                                                     const int num_filas, const int &pos, int fase, QVariant descripcion):
    UndoMedicionBase(nombretabla,id_padre,id_hijo,fase, pos, descripcion),m_numFilas(num_filas)
{
    qDebug()<<descripcion;
}

void UndoInsertarLineaMedicion::undo()
{
    //en este caso no me interesa guardar las lineas borradas, porque la accion es la contraria al insertado, no un borrado directo+
    //hago uso de la version de borrar que usa directamente las ids de las lineas a borrar
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

/*************PEGAR LINEA MEDICION******************/

UndoPegarLineasMedicion::UndoPegarLineasMedicion(const QString &nombretabla, const QString &id_padre, const QString &id_hijo, const int &num_cert, const int &pos, const QVariant &descripcion):
    UndoMedicionBase(nombretabla,id_padre,id_hijo,num_cert,pos,descripcion)
{
    esPrimerRedo = true;
}

void UndoPegarLineasMedicion::undo()
{
    QString cadenaborrar = "SELECT borrar_lineas_medcert('"+m_tabla+"','"+m_cadenaid+"',"+QString::number(m_num_cert)+",'t','t');";
    qDebug()<<cadenaborrar;
    m_consulta.exec(cadenaborrar);
}

void UndoPegarLineasMedicion::redo()
{
    if (esPrimerRedo == true)
    {
        esPrimerRedo = false;
        QString cadenaconsulta = "SELECT pegar_medicion('"+m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+"','"+QString::number(m_num_cert)+"','"+QString::number(m_posicion)+"');";
        qDebug()<<cadenaconsulta;
        m_consulta.exec(cadenaconsulta);
        while(m_consulta.next())
        {
            m_cadenaid = m_consulta.value(0).toString();
        }
        qDebug()<<"Insertadas las ides: "<<m_cadenaid;
    }
    else
    {
        QString cadenaconsulta = "SELECT restaurar_lineas_borradas('"+m_tabla+"','1')";
        qDebug()<<cadenaconsulta;
        m_consulta.exec(cadenaconsulta);
    }
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
