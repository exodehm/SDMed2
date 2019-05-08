#include "undoeditarprincipal.h"
#include "./defs.h"
#include <QDebug>
#include <QTextDocument>


/************CODIGO*******************/
UndoEditarCodigo::UndoEditarCodigo(const QString &tabla, const QString &codigopadre, const QString &codigohijo,
                                         const QVariant &datoAntiguo, const QVariant &datoNuevo, const QVariant &descripcion):
    UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion){}

//EN ESTE CASO SOLO NOS INTERESA EL codigohijo y el datoNuevo
void UndoEditarCodigo::undo()
{
    QString cadenaconsulta = "SELECT modificar_codigo('" +m_tabla+ "','" +m_datoNuevo.toString()+ "','" +m_codigohijo+ "');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarCodigo::redo()
{
    QString cadenaconsulta = "SELECT modificar_codigo('" +m_tabla+ "','" +m_codigohijo+ "','" +m_datoNuevo.toString()+ "');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

/************UNIDAD*******************/
UndoEditarUnidad::UndoEditarUnidad(const QString &tabla, const QString &codigopadre, const QString &codigohijo,
                                         const QVariant &datoAntiguo, const QVariant &datoNuevo, const QVariant &descripcion):
    UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion)
{
}

void UndoEditarUnidad::undo()
{
    QString cadenaconsulta = "SELECT modificar_unidad('" +m_tabla+ "','" +m_codigohijo+ "','" +m_datoAntiguo.toString()+ "');";
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarUnidad::redo()
{
    QString cadenaconsulta = "SELECT modificar_unidad('" +m_tabla+ "','" +m_codigohijo+ "','" +m_datoNuevo.toString()+ "');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

/************RESUMEN*******************/
UndoEditarResumen::UndoEditarResumen(const QString &tabla, const QString &codigopadre, const QString &codigohijo,
                                         const QVariant &datoAntiguo, const QVariant &datoNuevo, const QVariant &descripcion):
    UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion)
{
}

void UndoEditarResumen::undo()
{
    QString cadenaconsulta = "SELECT modificar_resumen('" +m_tabla+ "','" +m_codigohijo+ "','" +m_datoAntiguo.toString()+ "');";
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarResumen::redo()
{
    QString cadenaconsulta = "SELECT modificar_resumen('" +m_tabla+ "','" +m_codigohijo+ "','" +m_datoNuevo.toString()+ "');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

/************NATURALEZA*******************/
UndoEditarNaturaleza::UndoEditarNaturaleza(const QString &tabla, const QString &codigopadre, const QString &codigohijo, const QVariant &datoAntiguo, const QVariant &datoNuevo, const QVariant &descripcion):
    UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion)
{
}

void UndoEditarNaturaleza::undo()
{
    QString cadenaconsulta = "SELECT modificar_naturaleza('" +m_tabla+ "','" +m_codigohijo+ "'," +m_datoAntiguo.toString()+ ");";
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarNaturaleza::redo()
{
    QString cadenaconsulta = "SELECT modificar_naturaleza('" +m_tabla+ "','" +m_codigohijo+ "'," +m_datoNuevo.toString()+ ");";
    m_consulta.exec(cadenaconsulta);
}


/************CANTIDAD*******************/
UndoEditarCantidad::UndoEditarCantidad(const QString &tabla, const QString &codigopadre, const QString &codigohijo,
                                         const QVariant &datoAntiguo, const QVariant &datoNuevo, const QString &tipo_cantidad, const QVariant &descripcion):
    UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion), m_columnaCantidad(tipo_cantidad)
{
    QString cadenaGuardarLineasMediciom = "SELECT * from ver_lineas_medicion('"+tabla+"','"+codigopadre+"','"+codigohijo+"');";
    //qDebug()<<cadenaGuardarLineasMediciom;
    m_consulta.exec(cadenaGuardarLineasMediciom);
    QList<QVariant>linea;
    while (m_consulta.next()) {
        for (int i=0;i<6;i++)
        {
            //qDebug()<<consulta.value(i);
            linea.append(m_consulta.value(i));
        }
        m_lineasMedicion.append(linea);
        linea.clear();
    }
}

void UndoEditarCantidad::undo()
{
    if (m_lineasMedicion.isEmpty())//si no hay medicion guardada pongo el antiguo valor
    {
        qDebug()<<"Repongo la cantidad antigua";
        QString cadenaconsulta = "SELECT modificar_cantidad('" +m_tabla+ "','" +m_codigopadre + "','" +m_codigohijo+ "','" + m_columnaCantidad +"','" + m_datoAntiguo.toString()+ "');";
        qDebug()<<cadenaconsulta;
        m_consulta.exec(cadenaconsulta);
    }
    else//si la hay, repongo la medicion
    {
        qDebug()<<"Repongo las lineas de medicion";
        foreach (const QList<QVariant>&linea, m_lineasMedicion)
        {
            QString cadenainsertarlineasmedicion = "SELECT insertar_medicion('"+ m_tabla +"','"+ m_codigopadre +"','"+\
                    m_codigohijo+"','"+linea.at(0).toString()+\
                    "','"+ linea.at(1).toString()+\
                    "','"+ linea.at(2).toString()+\
                    "','"+ linea.at(3).toString()+\
                    "','"+ linea.at(4).toString()+\
                    "','"+ linea.at(5).toString()+"');";
            qDebug()<<cadenainsertarlineasmedicion;
            m_consulta.exec(cadenainsertarlineasmedicion);
        }
    }
}

void UndoEditarCantidad::redo()
{   
    /*QString cadenaborrarlineasmedicion = "SELECT borrar_lineas_medcert('"+tabla+"','"+codigopadre+"','"+codigohijo+"');";
    qDebug()<<"cadenaborrarlineasmedicion"<<cadenaborrarlineasmedicion;
    consulta.exec(cadenaborrarlineasmedicion);*/
    QString cadenaconsulta = "SELECT modificar_cantidad('" +m_tabla+ "','" +m_codigopadre + "','" +m_codigohijo+ "','" + m_columnaCantidad +"','t','" + m_datoNuevo.toString()+ "');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}


/************PRECIO*******************/
UndoEditarPrecio::UndoEditarPrecio(const QString &tabla, const QString &codigopadre, const QString &codigohijo,
                                         const QVariant &datoAntiguo, const QVariant &datoNuevo, int opc, const QVariant &descripcion):
    opcion(opc), UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion)
{
}

void UndoEditarPrecio::undo()
{
    QString cadenaconsulta;    
    cadenaconsulta = "SELECT modificar_precio('"+m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+ "','" +m_datoNuevo.toString()+"','"+QString::number(opcion)+"','f');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarPrecio::redo()
{
    QString cadenaconsulta;
    cadenaconsulta = "SELECT modificar_precio('"+m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+ "','" +m_datoNuevo.toString()+"','"+QString::number(opcion)+"','t');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

/************TEXTO*******************/
UndoEditarTexto::UndoEditarTexto(const QString &tabla, const QString &cod_padre, const QString &cod_hijo, const QString &_textoantiguo,
                                         const QString &_textonuevo, const QVariant &descripcion):
    textoantiguo(_textoantiguo), textonuevo(_textonuevo),
    UndoBase(tabla, cod_padre, cod_hijo, QVariant(), QVariant(),descripcion)
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
    QString cadenaconsulta = "SELECT modificar_texto('" +m_tabla+ "','" +m_codigohijo+ "','" +textoantiguoplano+ "','"+textoantiguo+"');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarTexto::redo()
{
    QString cadenaconsulta = "SELECT modificar_texto('" +m_tabla+ "','" +m_codigohijo+ "','" +textonuevoplano+ "','"+textonuevo+"');";
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}
