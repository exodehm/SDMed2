#include "importarBC3.h"
#include <QDebug>
#include <QFile>
#include <iostream>
#include <QSqlError>
#include <QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QSettings>
#include <QDate>
#include <QMessageBox>
#include <QTemporaryDir>

#include "../Dialogos/dialogotipoaperturabc3.h"
#include "../Dialogos/dialogocredencialesconexionadmin.h"

ImportarBC3::ImportarBC3(const QStringList &listadoBC3, bool &abierta)
{
    QStringList registroD;
    QStringList registroM;
    QStringList registroC;
    QStringList registroT;

    TAM_MAX = 20000;
    m_abierta = &abierta;

    foreach (QString linea, listadoBC3)
    {
        if (linea[0]=='C' && linea[1]=='|')
        {
            linea.chop(2);
            linea.remove(0,2);
            //qDebug()<<linea;
            registroC.append(linea);
        }
        if (linea[0]=='D' && linea[1]=='|')
        {
            linea.remove(QRegExp("[\n\r]."));
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
        if (linea[0]=='T' && linea[1]=='|')
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
    tipoImportacion = NORMAL;
    if (res==0)
    {
        abierta = true;
        //establecer el tipo de importacion que vamos a hacer
        if (!HayMediciones(registroM) || listadoBC3.size()>TAM_MAX)
        {
            //tipoImportacion = SIMPLIFICADO;
            DialogoTipoAperturaBC3 *d = new DialogoTipoAperturaBC3;
            if (d->exec())
            {
                if (d->result() == QDialog::Accepted)
                {
                    if (d->ImportacionRapida())
                    {
                        tipoImportacion = SIMPLIFICADO;
                    }
                    else
                    {
                        tipoImportacion = NORMAL;
                    }
                }
                else //si salimos del dialogo cancelando
                {
                    tipoImportacion = NINGUNO;
                }
            }
        }
        /*else
        {
            tipoImportacion = NORMAL;
        }*/
        if (tipoImportacion == SIMPLIFICADO)
        {
            db = QSqlDatabase::addDatabase("QPSQL","admin");
            if (tipoImportacion == eTipoImportacion::SIMPLIFICADO)
            {
                QSettings settings;
                db.setHostName(settings.value("adminrole/servidor").toString());
                db.setPort(settings.value("adminrole/puerto").toInt());
                db.setUserName(settings.value("adminrole/usuario").toString());
                db.setPassword(settings.value("adminrole/password").toString());
                db.setDatabaseName("sdmed");
                if (!db.open())
                {
                    DialogoCredencialesConexionAdmin* d = new DialogoCredencialesConexionAdmin (db);
                    int res = d->exec();
                    if (res==QDialog::Rejected || !db.open())
                    {
                        BorrarIntentoObra(tr("Se necesitan credencialesss de admin para esta acción"));
                    }
                }
            }
        }

        if ((tipoImportacion == eTipoImportacion::SIMPLIFICADO && db.open()) || tipoImportacion == eTipoImportacion::NORMAL)
        {
            CrearHashTexto(registroT);
            if (!procesarConceptos(registroC, tipoImportacion))
            {
                BorrarIntentoObra(tr("Error leyendo el registro C"));
            }
            else if (!procesarRelaciones(registroD, tipoImportacion))
            {
                BorrarIntentoObra(tr("Error leyendo el registro D"));
            }
            else if (!procesarMediciones(registroM))
            {
                BorrarIntentoObra(tr("Error leyendo el registro M"));
            }
            //procesarTexto(registroT);
            EscribirTextoRaiz();
        }
        else
        {
            BorrarIntentoObra(tr("Se cancela el proceso de importación"));
        }
    }
    else
    {
        QMessageBox msgBox;
        msgBox.setText(tr("No ha sido posible crear la obra."));
        msgBox.exec();
    }
}

int ImportarBC3::crearObra(QStringList &registroC)
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
            //qDebug()<<cadenaCrearObra;
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

bool ImportarBC3::procesarConceptos(const QStringList &registroC, eTipoImportacion tipo)
{   
    QTextStream tConceptos;
    QFile file;
    QTemporaryDir tempdir;
    if (tipo == SIMPLIFICADO)
    {        
        if (tempdir.isValid())
        {
            file.setFileName(tempdir.path() + "conceptos.csv");
            file.open(QIODevice::WriteOnly | QIODevice::Text);
            tConceptos.setDevice(&file);
            tConceptos.setCodec("UTF-8");
        }
    }
    foreach (const QString& linea, registroC)
    {
        //qDebug()<<"Registro C: "<<linea;
        QStringList datos = linea.split("|");
        QString codigopartida,ud,resumen,precio,fecha,naturaleza;
        codigopartida=datos.at(0).trimmed();
        bool capitulo = quitarSimbolos(codigopartida);
        ud=datos.at(1).trimmed();
        resumen=datos.at(2).trimmed();
        precio=datos.at(3).trimmed();
        fecha = datos.at(4).trimmed();
        naturaleza=datos.at(5).trimmed();
        if (naturaleza=="0")
        {
            if (capitulo)
            {
                naturaleza = "6";
            }
            else
            {
                naturaleza = "7";
            }
        }
        else
        {
            naturaleza=datos.at(5);
        }
        if (tipo == SIMPLIFICADO)
        {
            tConceptos<<codigopartida<<"\t"<<resumen.left(80).replace(R"(")",R"("\"")")<<"\t"<<hashtexto[codigopartida]<<"\t"<<hashtexto[codigopartida]<<"\t"<<precio<<"\t"<<"NULL"<<"\t"<<naturaleza<<"\t"<<ProcesarCadenaFecha(fecha)<<"\t"<<ud<<"\t"<<precio<<"\n";
            //tConceptos<<codigopartida<<"\t"<<resumen.left(80)<<"\t"<<hashtexto[codigopartida]<<"\t"<<hashtexto[codigopartida]<<"\t"<<precio<<"\t"<<"NULL"<<"\t"<<naturaleza<<"\t"<<ProcesarCadenaFecha(fecha)<<"\t"<<ud<<"\t"<<precio<<"\n";
        }
        else
        {
            QString cadenainsertar = "SELECT insertar_concepto('"+codigo+"','"+codigopartida+"','"+ud+"','"+resumen+"','"+hashtexto[codigopartida]+"','"+precio+"','"+naturaleza+"','"+fecha+"');";
            consulta.exec(cadenainsertar);
            qDebug()<<"Cadena insertar: "<<cadenainsertar;
        }
    }
    if (tipo == SIMPLIFICADO)
    {
        file.close();
        QString cadenaimportar = "SELECT sdmed.importar_bc3_copy('" + codigo + "','" + tempdir.path() + "conceptos.csv" + "','1')";
        QSqlQuery consulta(db);
        if(consulta.prepare(cadenaimportar))
        {
            consulta.exec();
        }
        qDebug()<<consulta.lastError()<<"--"<<consulta.lastQuery();
        while (consulta.next())
        {
            bool ok  = consulta.value(0).toBool();
            return ok;
        }
    }
    return true;
}

bool ImportarBC3::procesarRelaciones(const QStringList &registroD, eTipoImportacion tipo)
{
    //Hay que mirar si el registro tiene 2 o 3 campos
    //3 campos->verson FIEBDC-3/2012->tener en cuenta porcentajes
    //2 campos->version anterior->no considera porcentajes
    //esto hay que implementarlo. Por ahora solo considera 3 campos
    QTextStream tRelaciones;
    QFile file;
    QTemporaryDir tempdir;
    if (tipo == SIMPLIFICADO)
    {
        if (tempdir.isValid())
        {
            file.setFileName(tempdir.path() + "relaciones.csv");
            file.open(QIODevice::WriteOnly | QIODevice::Text);
            tRelaciones.setDevice(&file);
            tRelaciones.setCodec("UTF-8");
        }
    }
    //QTextStream tRelaciones(stdout, QIODevice::WriteOnly);
    int id = 1;
    foreach (const QString& linea, registroD)
    {
        //qDebug()<<"Linea D: "<<linea;
        QStringList lista = linea.split("|");
        //qDebug()<<"Tamaño linea D: "<<lista.size();
        QString padre = lista.at(0);
        //qDebug()<<"PAdre: "<<padre;
        quitarSimbolos(padre);
        int nHijos=(linea.count("\\")/3);
        //qDebug()<<"Hijos nº "<<nHijos;
        int nCampos = lista.size()-1;
        QString resto;
        //qDebug()<<"resto "<<resto;
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
            //qDebug()<<"Vuelta "<<i<<nHijos<<" - "<<relaciones.size()<<"Num hjijos: "<<nHijos;
            for (int j=0;j<3;j++)
            {
                registros[j] = relaciones.first();
                relaciones.pop_front();
            }
            if (tipo == SIMPLIFICADO)
            {
                tRelaciones<<id<<"\t"<<padre<<"\t"<<registros[0]<<"\t"<<registros[2]<<"\t"<<"1"<<"\t"<<i<<"\t"<<"0"<<"\n";
            }
            else
            {
                //qDebug()<<"Padre: "<<padre<<" - "<<"Hijo: "<<registros[0]<<"Cantidad: "<<registros[2];
                QString cadenainsertar = "SELECT insertar_partida('"+ codigo + "','"+padre+"','"+registros[0]+"','-1','"+ registros[2]+"');" ;
                consulta.exec(cadenainsertar);
            }
            id++;
        }
    }
    if (tipo == SIMPLIFICADO)
    {
        file.close();
        QSqlQuery consulta (db);
        QString cadenaimportar = "SELECT sdmed.importar_bc3_copy('" + codigo + "','"+tempdir.path() + "relaciones.csv" + "','2')";
        qDebug()<<cadenaimportar;
        consulta.exec(cadenaimportar);
        qDebug()<<consulta.lastError();
        while (consulta.next())
        {
            bool ok  = consulta.value(0).toBool();
            return ok;
        }
    }
    return  true;
}

bool ImportarBC3::procesarMediciones(QStringList &registroM)
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
        QString num_cert ="0",tipotabla = "0", num_lineas = "1";
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
            cadenainsertarmedicion = "SELECT insertar_lineas_medcert('"+codigo+"','"+padre+"','"+hijo+"','"+num_lineas+"','"+\
                    QString::number(i)+"','"+num_cert+"',"+conceptos[0]+",'"+conceptos[1]+"',"+conceptos[2]+","+conceptos[3]+","+conceptos[4]+","+conceptos[5]+");";
            qDebug()<<"cadena insertar medicion"<<cadenainsertarmedicion;
            consulta.exec(cadenainsertarmedicion);
        }
    }
    return true;
}

void ImportarBC3::procesarTexto(const QStringList& registroT)
{
    QString linea;
    foreach (linea, registroT)
    {
        QStringList datos = linea.split("|");
        QString codigotexto = datos.at(0);
        codigotexto.remove('#');
        QString cadenainsertartexto = "SELECT insertar_texto('"+ codigo + "','"+codigotexto+"','"+datos.at(1)+"');";
        qDebug()<<cadenainsertartexto;
        consulta.exec(cadenainsertartexto);
    }
}

bool ImportarBC3::quitarSimbolos(QString& codigo)
{
    //quita el caracter # en caso de que lo hubiera y retorna true. Si no lo hay se limita a retornar false
    int posicion = codigo.indexOf('#');
    if (posicion>0 || posicion==0)
    {
        codigo.truncate(posicion);
        return true;
    }
    return false;
}

QString ImportarBC3::ProcesarCadenaFecha(const QString &cadena)
{
    //la cadena debe contener solo numeros y estar entre 2 y 8 caracteres
    QRegExp re("[0-9]{2,8}$");
    if (re.exactMatch(cadena))
    {
        QString anno,mes,dia;
        if (cadena.size()==8)
        {
            anno = cadena.right(4);
            mes = cadena.mid(2,2);
            dia = cadena.left(2);
        }
        else if (cadena.size() == 5 || cadena.size() == 6)
        {
            anno = cadena.right(2);
            mes = cadena.mid(cadena.size()-4,2);
            dia = cadena.left(cadena.size()-4);
        }
        else if (cadena.size() == 3 || cadena.size() == 4)
        {
            anno = cadena.right(2);
            mes = cadena.left(cadena.size()-2);
            dia = "01";
        }
        else if (cadena.size() == 2)
        {
            anno = cadena;
            mes = "01";
            dia = "01";
        }
        if (anno.size()==2)
        {
            QString aux = anno;
            if (aux.at(0)<"8")
            {
                anno = "20" + aux;
            }
            else
            {
                anno = "19" + aux;
            }
        }
        if (mes.size()==1)
        {
            mes = "0"+mes;
        }
        if (dia.size()==1)
        {
            dia = "0"+dia;
        }
        return dia+"-"+mes+"-"+anno;
    }
    return QDate::currentDate().toString("yyyy-MM-dd");
}

void ImportarBC3::CrearHashTexto(const QStringList &registroT)
{
    QFile file("texto.csv");
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream tTexto(&file);
    tTexto.setCodec("UTF-8");
    QString linea;
    foreach (linea, registroT)
    {
        QStringList datos = linea.split("|");
        QString codigotexto = datos.at(0);
        codigotexto.remove('#');
        QString texto = datos.at(1);
        texto = texto.simplified();
        texto.replace(R"(")",R"("\"")");
        tTexto<<codigotexto<<"\t"<<texto<<"\n";
        hashtexto.insert(codigotexto,texto);        
    }
    file.close();
}

void ImportarBC3::BorrarIntentoObra(const QString &mensajeerror)
{
    QString cadenaBorrarObra = "SELECT borrar_obra ('"+codigo+"');";
    consulta.exec(cadenaBorrarObra);
    QMessageBox::warning(this,
                         tr("Aviso"),
                         tr("No ha sido posible abrir el fichero bc3\n%1").arg(mensajeerror),
                         QMessageBox::Ok);
    *m_abierta = false;
}

bool ImportarBC3::HayMediciones(const QStringList& registroM)
{
    return registroM.size()>0;
}

void ImportarBC3::EscribirTextoRaiz()
{
    QString cadenaescribirtextoraiz = "SELECT insertar_texto('" + codigo + "','" + codigo + "','" + hashtexto[codigo] + "')";
    consulta.exec(cadenaescribirtextoraiz);
}


QString ImportarBC3::LeeCodigo() const
{
    return codigo;
}

QString ImportarBC3::LeeResumen() const
{
    return resumen;
}

