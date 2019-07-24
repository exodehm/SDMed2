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
    qDebug()<<cadenaconsulta;
    m_consulta.exec(cadenaconsulta);
}


/************CANTIDAD*******************/
UndoEditarCantidad::UndoEditarCantidad(const QString &tabla, const QString &codigopadre, const QString &codigohijo,
                                         const QVariant &datoAntiguo, const QVariant &datoNuevo, const QString &tipo_cantidad, const QVariant &descripcion):
    UndoBase(tabla,codigopadre,codigohijo,datoAntiguo,datoNuevo,descripcion), m_columnaCantidad(tipo_cantidad)
{
}

void UndoEditarCantidad::undo()
{
    QString cadenaconsulta;
    if (m_hayMedicion)
    {
        cadenaconsulta = "SELECT restaurar_lineas_borradas('"+m_tabla+"');";
    }
    else
    {
        cadenaconsulta = "SELECT modificar_cantidad('" +m_tabla+ "','" +m_codigopadre + "','" +m_codigohijo+ "','" +
                    m_columnaCantidad +"','t','"+ m_datoAntiguo.toString()+ "');";
        qDebug()<<cadenaconsulta;

    }
    m_consulta.exec(cadenaconsulta);
}

void UndoEditarCantidad::redo()
{
    QString cadenaconsulta = "SELECT modificar_cantidad('" +m_tabla+ "','" +m_codigopadre + "','" +m_codigohijo+ "','" +
            m_columnaCantidad +"','t','"+ m_datoNuevo.toString()+ "');";
    m_consulta.exec(cadenaconsulta);
    qDebug()<<cadenaconsulta;
    while (m_consulta.next())
    {
        m_hayMedicion = m_consulta.value(0).toBool();
    }
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
    cadenaconsulta = "SELECT modificar_precio('"+m_tabla+"','"+m_codigopadre+"','"+m_codigohijo+ "','" +m_datoAntiguo.toString()+"','"+QString::number(opcion)+"','f');";
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
