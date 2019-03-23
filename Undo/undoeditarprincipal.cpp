#include "undoeditarprincipal.h"
#include "./defs.h"
#include <QDebug>
#include <QTextDocument>


UndoEditarPrincipal::UndoEditarPrincipal(QString tabla, QString cod_padre, QString cod_hijo,
                                         QVariant dato_antiguo, QVariant dato_nuevo, QVariant descripcion):
    tabla(tabla), codigopadre(cod_padre), codigohijo(cod_hijo), datoAntiguo(dato_antiguo),datoNuevo(dato_nuevo)
{
    qDebug()<<"Descripcion: "<<descripcion;
}

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
    qDebug()<<cadenaconsulta;
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
                                         QVariant dato_antiguo, QVariant dato_nuevo, QString tipo_cantidad, QVariant descripcion):
    UndoEditarPrincipal(tabla,cod_padre,cod_hijo,dato_antiguo,dato_nuevo,descripcion), columnaCantidad(tipo_cantidad)
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
        qDebug()<<"Repongo la cantidad antigua";
        QString cadenaconsulta = "SELECT modificar_cantidad('" +tabla+ "','" +codigopadre + "','" +codigohijo+ "','" + columnaCantidad +"','" + datoAntiguo.toString()+ "');";
        qDebug()<<cadenaconsulta;
        consulta.exec(cadenaconsulta);
    }
    else//si la hay, repongo la medicion
    {
        qDebug()<<"Repongo las lineas de medicion";
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
    /*QString cadenaborrarlineasmedicion = "SELECT borrar_lineas_medcert('"+tabla+"','"+codigopadre+"','"+codigohijo+"');";
    qDebug()<<"cadenaborrarlineasmedicion"<<cadenaborrarlineasmedicion;
    consulta.exec(cadenaborrarlineasmedicion);*/
    QString cadenaconsulta = "SELECT modificar_cantidad('" +tabla+ "','" +codigopadre + "','" +codigohijo+ "','" + columnaCantidad +"','t','" + datoNuevo.toString()+ "');";
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
    cadenaconsulta = "SELECT modificar_precio('"+tabla+"','"+codigopadre+"','"+codigohijo+ "','" +datoNuevo.toString()+"','"+QString::number(opcion)+"','f');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);

}

void UndoEditarPrecio::redo()
{
    QString cadenaconsulta;
    cadenaconsulta = "SELECT modificar_precio('"+tabla+"','"+codigopadre+"','"+codigohijo+ "','" +datoNuevo.toString()+"','"+QString::number(opcion)+"','t');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}

/************TEXTO*******************/
UndoEditarTexto::UndoEditarTexto(const QString &tabla, const QString &cod_padre, const QString &cod_hijo, const QString &_textoantiguo,
                                         const QString &_textonuevo, const QVariant &descripcion):
    textoantiguo(_textoantiguo), textonuevo(_textonuevo),
    UndoEditarPrincipal(tabla, cod_padre, cod_hijo, QVariant(), QVariant(),descripcion)
{
    QTextDocument temp;
    temp.setHtml(textoantiguo);
    textoantiguoplano = temp.toPlainText();
    temp.setHtml(textonuevo);
    textonuevoplano = temp.toPlainText();
    //para escapar las comillas para la cadena de texto
    textoantiguo.replace("'","''");
    textonuevo.replace("'","''");
}

void UndoEditarTexto::undo()
{
    QString cadenaconsulta = "SELECT modificar_texto('" +tabla+ "','" +codigohijo+ "','" +textoantiguoplano+ "','"+textoantiguo+"');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}

void UndoEditarTexto::redo()
{
    QString cadenaconsulta = "SELECT modificar_texto('" +tabla+ "','" +codigohijo+ "','" +textonuevoplano+ "','"+textonuevo+"');";
    qDebug()<<cadenaconsulta;
    consulta.exec(cadenaconsulta);
}
