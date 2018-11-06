#include "abrirguardarbc3.h"
#include <QDebug>
#include <QFile>

AbrirGuardarBC3::AbrirGuardarBC3(const QStringList &listadoBC3, bool &abierta)
{
    QStringList registroD;
    QStringList registroM;
    QStringList registroC;
    QStringList registroT;
    foreach (QString linea, listadoBC3)
    {
        if (linea[0]=='C')
        {
            linea.chop(2);
            linea.remove(0,2);
            //qDebug()<<linea;
            registroC.append(linea);
        }
        if (linea[0]=='D' && linea[1]=='|')
        {
            linea.chop(2);
            linea.remove(0,2);
            //qDebug()<<linea;
            registroD.append(linea);
        }
        if (linea[0]=='M' && linea[1]=='|')
        {
            linea.chop(2);
            linea.remove(0,2);
            //qDebug()<<linea;
            registroM.append(linea);
        }
        if (linea[0]=='T')
        {
            linea.chop(2);
            linea.remove(0,2);
            //qDebug()<<linea;
            registroT.append(linea);
        }
    }
    qDebug()<<"Total lineas Registro C: "<<registroC.size();
    qDebug()<<"Total lineas Registro D: "<<registroD.size();
    qDebug()<<"Total lineas Registro M: "<<registroM.size();
    qDebug()<<"Total lineas Registro T: "<<registroT.size();
    //empezamos con el registro C
    int res = crearObra(registroC);
    if (res==0)
    {
        abierta = true;
        procesarConceptos(registroC);
        procesarRelaciones(registroD);
        procesarMediciones(registroM);
        procesarTexto(registroT);
    }
    else
    {
        abierta = false;
    }
}

int AbrirGuardarBC3::crearObra(QStringList &registroC)
{
    //la funcion lee del registroC la linea con doble almohadilla ## y crea la obra en la BBDD con los datos
    //de este concepto. Luego elimina esa linea porque el registroC será usado más adelante para llenar la tabla de conceptos
    int res=0;
    auto it = registroC.begin();
    while (it != registroC.end())
    {
        if (it->contains("##"))
        {
            QStringList datos = it->split("|");
            codigo = datos.at(0);
            codigo.remove('#');
            resumen = datos.at(2);
            qDebug()<<"encontrada la linea del codigo "<<codigo<<" - "<<resumen;
            QString cadenaCrearObra = "SELECT crear_obra ('"+codigo+"','"+resumen+"');";
            qDebug()<<cadenaCrearObra;
            consulta.exec(cadenaCrearObra);
            while (consulta.next())
            {
                   res =  consulta.value(0).toInt();
            }
            if (res !=0)//por ahora solo tratamos el 0 y aqui. Susceptible de corregir
            {
                return res;
            }
            registroC.erase(it);
            break;
        }
        else
        {
            ++it;
        }
    }
    return res;
}

void AbrirGuardarBC3::procesarConceptos(QStringList &registroC)
{
    foreach (const QString& linea, registroC)
    {
        //qDebug()<<"Registro C: "<<linea;
        QStringList datos = linea.split("|");
        QString codigopartida,ud,resumen,precio,fecha,naturaleza;
        codigopartida=datos.at(0);
        quitarSimbolos(codigopartida);
        ud=datos.at(1);
        resumen=datos.at(2);
        precio=datos.at(3);
        fecha = datos.at(4);
        naturaleza=datos.at(5);
        QString cadenainsertar = "SELECT insertar_concepto('"+codigo+"','"+codigopartida+"','"+ud+"','"+resumen+"','"+precio+"','"+naturaleza+"','"+fecha+"');";
        //qDebug()<<"Cadena insertar: "<<cadenainsertar;
        consulta.exec(cadenainsertar);
    }
}

void AbrirGuardarBC3::procesarRelaciones(const QStringList &registroD)
{
    //Hay que mirar si el registro tiene 2 o 3 campos
    //3 campos->verson FIEBDC-3/2012->tener en cuenta porcentajes
    //2 campos->version anterior->no considera porcentajes
    //esto hay que implementarlo. Por ahora solo considera 3 campos
    foreach (const QString& linea, registroD)
    {
        QStringList lista = linea.split("|");
        QString padre = lista.at(0);
        quitarSimbolos(padre);
        int nHijos=(linea.count("\\")/3);
        int nCampos = lista.size()-1;
        QString resto;
        if (nCampos == 2)
        {
            resto = lista.at(1);
        }
        else
        {
            resto = lista.at(2);
        }
        QString registros[3]; //nombrehijo, factor, cantidad
        QStringList relaciones = resto.split("\\");
        for (int i=0; i<nHijos; i++)
        {
            qDebug()<<"Vuelta "<<i<<nHijos<<" - "<<relaciones.size()<<"Num hjijos: "<<nHijos;
            for (int j=0;j<3;j++)
            {
                registros[j] = relaciones.first();
                relaciones.pop_front();
            }
            qDebug()<<"Padre: "<<padre<<" - "<<"Hijo: "<<registros[0]<<"Cantidad: "<<registros[2];
            QString cadenainsertar = "SELECT insertar_partida('"+ codigo + \
                    +"','"+padre+"','"+registros[0]+"','"+QString::number(i)+"','','',NULL,"+registros[2]+");" ;

            qDebug()<<"Cadena insertar: "<<cadenainsertar;
            consulta.exec(cadenainsertar);            
        }
    }
}

void AbrirGuardarBC3::procesarMediciones(QStringList &registroM)
{
    foreach (const QString &linea, registroM)
    {
        QStringList datos = linea.split("|");
        QStringList padrehijo = datos.at(0).split("\\");
        QString padre = padrehijo.at(0);
        quitarSimbolos(padre);
        QString hijo = padrehijo.at(1);
        QStringList medicion = datos.at(3).split("\\");
        int lineasmedicion = medicion.size()/6;
        QString conceptos[6];//TIPO[0]/COMENTARIO{ # ID_BIM }[1]/UNIDADES[2]/LONGITUD[3]/LATITUD[4]/ALTURA[5]
        //qDebug()<<"Padre: "<<padre<<"hijo: "<<hijo;
        QString cadenainsertarmedicion;
        for (int i=0;i<lineasmedicion;i++)
        {
            for (int j=0;j<6;j++)
            {
                conceptos[j]= medicion.first();
                medicion.pop_front();
                if (conceptos[j].isEmpty())
                {
                    conceptos[j]="NULL";
                }
            }
            qDebug()<<"Insertar "<<conceptos[0]<<"','"<<conceptos[1]<<"','"<<conceptos[2]<<"','"<<conceptos[3]<<"','"<<conceptos[4]<<"','"<<conceptos[5]<<"en la posicion: "<<i;
            cadenainsertarmedicion = "SELECT insertar_medicion('"+codigo+"','"+padre+"','"+hijo+"','"+QString::number(i)+"',"+conceptos[0]+",'"+conceptos[1]+"',"+conceptos[2]+","+conceptos[3]+","+conceptos[4]+","+conceptos[5]+");";
            qDebug()<<"cadena insertar medicion"<<cadenainsertarmedicion;
            consulta.exec(cadenainsertarmedicion);
        }
    }
}

void AbrirGuardarBC3::procesarTexto(const QStringList& registroT)
{
    QString linea;
    foreach (linea, registroT)
    {
        QStringList datos = linea.split("|");
        QString codigotexto = datos.at(0);
        codigotexto.remove('#');
        QString cadenainsertartexto = "SELECT insertar_texto('"+ codigo + "','"+codigotexto+"','"+datos.at(1)+"');";
        consulta.exec(cadenainsertartexto);
    }
}

void AbrirGuardarBC3::quitarSimbolos (QString& codigo)
{
    //int posicion=-1;
    int posicion = codigo.indexOf('#');
    if (posicion>0 || posicion==0)
    {
        codigo.truncate(posicion);
    }
}


QString AbrirGuardarBC3::LeeCodigo() const
{
    return codigo;
}

QString AbrirGuardarBC3::LeeResumen() const
{
    return resumen;
}

