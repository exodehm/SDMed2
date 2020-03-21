#include "dialogogestionobras.h"
#include "./Dialogos/dialogoconexionbbdd.h"
#include "ui_dialogogestionobras.h"
#include "./instancia.h"
#include <QTableWidgetItem>
#include <QtSql/QSqlQuery>
#include <QPushButton>
#include <QCheckBox>
#include <QMessageBox>
#include <QProcess>
#include <QFileDialog>
#include <QDebug>

DialogoGestionObras::DialogoGestionObras(std::list<Instancia *> &ListaObras, QSqlDatabase& db, QWidget *parent) :
    QDialog(parent), ui(new Ui::DialogoGestionObras)
{   
    ui->setupUi(this);
    m_db = &db;
    primer_elemento = ListaObras.begin();
    ultimo_elemento = ListaObras.end();
    QStringList cabecera;
    cabecera<<tr("Código")<<tr("Resumen")<<tr("Abrir")<<tr("Borrar")<<tr("");
    ui->tabla->setColumnCount(cabecera.size());
    ui->tabla->setHorizontalHeaderLabels(cabecera);    
    LlenarTabla();
    QObject::connect(this,SIGNAL(accepted()),SLOT(listaNombreObrasAbrir()));
    QObject::connect(this->ui->botonConectarBBDD,SIGNAL(clicked(bool)),this,SLOT(ConectarBBDD()));
    QObject::connect(this->ui->botonImportarDB,SIGNAL(clicked(bool)),this,SLOT(ImportarDB()));
    QObject::connect(this->ui->botonExportarDB,SIGNAL(clicked(bool)),this,SLOT(ExportadDB()));
}

DialogoGestionObras::~DialogoGestionObras()
{
    delete ui;
}

void DialogoGestionObras::LlenarTabla()
{
    ui->tabla->setRowCount(0);
    QSqlQuery consultaBBDD;
    QString codigo, resumen;
    QString cadenaConsultaBBDD = "SELECT * FROM ver_obras_BBDD()";
    qDebug()<<cadenaConsultaBBDD;
    consultaBBDD.exec (cadenaConsultaBBDD);
    ui->tabla->setRowCount(consultaBBDD.size());
    int fila = 0;
    while (consultaBBDD.next())
    {
        //hallo el codigo
        codigo = consultaBBDD.value(0).toString();
        resumen = consultaBBDD.value(1).toString();
        //ahora relleno la fila
        for (int columna=0;columna<ui->tabla->columnCount();columna++)
        {
            if (columna==eColumnas::CODIGO)// || j==eColumnas::RESUMEN)
            {
                QTableWidgetItem *item = new QTableWidgetItem(codigo);
                item->setFlags(item->flags() ^ Qt::ItemIsEditable);
                ui->tabla->setItem(fila,columna,item);                
            }
            else if (columna==eColumnas::RESUMEN)
            {
                QTableWidgetItem *item = new QTableWidgetItem(resumen);
                item->setFlags(item->flags() ^ Qt::ItemIsEditable);
                ui->tabla->setItem(fila,columna,item);                
            }
            else if (columna==eColumnas::ABRIR)
            {
                QCheckBox* itemcheck = new QCheckBox(this);
                itemcheck->setEnabled(!EstaAbierta(codigo));
                QObject::connect(itemcheck,SIGNAL(clicked(bool)),this,SLOT(listaNombreObrasAbrir()));
                ui->tabla->setCellWidget(fila,columna,itemcheck);                
            }
            else if (columna==eColumnas::BORRAR)
            {
                QPushButton* btn_borrar = new QPushButton(tr("Borrar"));//,ui->tabla);
                btn_borrar->setObjectName(QString("%1").arg(fila));
                QObject::connect(btn_borrar,SIGNAL(clicked(bool)),this,SLOT(Borrar()));
                ui->tabla->setCellWidget(fila,columna,btn_borrar);                
            }
            else if (columna==eColumnas::EXPORTAR)
            {
                QPushButton* btn_exportar = new QPushButton(QIcon(QStringLiteral(":/images/anadir.png")),QString());
                btn_exportar->setObjectName(QString("%1").arg(fila));
                btn_exportar->setCheckable(true);
                btn_exportar->setMaximumWidth(30);
                btn_exportar->setToolTip(m_tooltipAnadir);
                btn_exportar->setStyleSheet("QPushButton{ background-color: lightgreen }");
                QObject::connect(btn_exportar,SIGNAL(clicked(bool)),this,SLOT(ActualizarBotones()));
                ui->tabla->setCellWidget(fila,columna,btn_exportar);
            }
        }
        fila++;//paso a la siguiente fila        
    }    
    ui->tabla->resizeColumnsToContents();
}

bool DialogoGestionObras::EstaAbierta(QString codigo)
{
    auto it = primer_elemento;
    while (it!= ultimo_elemento)
    {
        if ((*it)->LeeTabla()==codigo)
        {
            return true;
        }
        it++;
    }
    return false;
}

QList<QStringList> DialogoGestionObras::listaNombreObrasAbrir()
{
    QList<QStringList> listado;
    QStringList listalinea;
    for (int i=0;i<ui->tabla->rowCount();i++)
    {
        QCheckBox* c = qobject_cast<QCheckBox*>(ui->tabla->cellWidget(i,2));
        if (c->isChecked())
        {
            listalinea.append(ui->tabla->item(i,eColumnas::CODIGO)->data(Qt::DisplayRole).toString());//codigo
            listalinea.append(ui->tabla->item(i,eColumnas::RESUMEN)->data(Qt::DisplayRole).toString());//resumen
            listado.append(listalinea);
            listalinea.clear();
        }
    }
    return listado;
}

void DialogoGestionObras::Borrar()
{
    int fila = sender()->objectName().toInt();
    QString codigoobra = ui->tabla->item(fila,eColumnas::CODIGO)->data(Qt::DisplayRole).toString();
    QString resumenobra = ui->tabla->item(fila,eColumnas::RESUMEN)->data(Qt::DisplayRole).toString();
    QStringList datosobra;
    datosobra<<codigoobra<<resumenobra;
    emit BorrarObra(datosobra);
    ui->tabla->removeRow(fila);
    ui->tabla->resizeColumnsToContents();
}

void DialogoGestionObras::ActualizarBotones()
{
    QPushButton* btn = qobject_cast<QPushButton*>(sender());
    if (btn->isChecked())
    {
        btn->setStyleSheet("QPushButton{ background-color: red }");
        btn->setIcon(QIcon(QStringLiteral(":/images/quitar.png")));
        btn->setToolTip(m_tooltipQuitar);
    }
    else
    {
        btn->setStyleSheet("QPushButton{ background-color: lightgreen }");
        btn->setIcon(QIcon(QStringLiteral(":/images/anadir.png")));
        btn->setToolTip(m_tooltipAnadir);
    }
    m_listaObrasBackup.clear();
    for (int i = 0;i < ui->tabla->rowCount();i++)
    {
        QPushButton* btn1 = qobject_cast<QPushButton*>(ui->tabla->cellWidget(i,eColumnas::EXPORTAR));
        if (btn1 && btn1->isChecked())
        {
            //qDebug()<< ui->tabla->item(i,eColumnas::CODIGO)->data(Qt::DisplayRole).toString();
            QString tabla = "^\"""" + ui->tabla->item(i,eColumnas::CODIGO)->data(Qt::DisplayRole).toString() + "\"""*";
            m_listaObrasBackup<<"--table"<<tabla;
        }
    }
    ui->botonExportarDB->setEnabled(!m_listaObrasBackup.isEmpty());
}

void DialogoGestionObras::AnadirObrasABackup()
{


}

bool DialogoGestionObras::ConectarBBDD()
{
    DialogoConexionBBDD* d = new DialogoConexionBBDD(m_db, this);
    if (d->exec()==1)
    {
        LlenarTabla();        
    }
    emit ActivarBotones(d->HayConexion());
    return true;
}

void DialogoGestionObras::ExportadDB()
{
    QString titulo = "Guardar copia de respaldo";
    QString extension = "Postgres backup (*.backup);;All Files (*)";
    QString path = QString();
    QString fileName;
    QProcess programa;
    QStringList environment = programa.systemEnvironment();
    QString commandToStart= "pg_dump";
    QStringList argumentos;
    QStringList tablasExportar;
    argumentos<<"--host"<<m_db->hostName()<<"--port"<<QString::number(m_db->port())\
             <<"--username"<<m_db->userName()<<"--format"<<"custom"<<"--verbose"<<"--no-password"<<"--file";
#if defined(Q_WS_WIN) || defined(Q_WS_MAC)
    fileName =  QFileDialog::getSaveFileName(this,
                                             titulo,
                                             path,
                                             tr("Postgres backup (*.backup);;All Files (*)"),
                                             &extension);
#else //linux
    QFileDialog dialog(this, titulo, path, extension);
    dialog.setWindowModality(Qt::WindowModal);
    QRegExp filter_regex(QLatin1String("(?:^\\*\\.(?!.*\\()|\\(\\*\\.)(\\w+)"));
    QStringList filters = extension.split(QLatin1String(";;"));
    if (!filters.isEmpty())
    {
        dialog.setNameFilter(filters.first());
        if (filter_regex.indexIn(filters.first()) != -1)
        {
            dialog.setDefaultSuffix(filter_regex.cap(1));
        }
    }
    dialog.setAcceptMode(QFileDialog::AcceptSave);
    if (dialog.exec() == QDialog::Accepted)
    {
        fileName = dialog.selectedFiles().first();
        QFileInfo info(fileName);
        if (info.suffix().isEmpty() && !dialog.selectedNameFilter().isEmpty())
        {
            if (filter_regex.indexIn(dialog.selectedNameFilter()) != -1)
            {
                QString extension = filter_regex.cap(1);
                fileName = fileName + QLatin1String(".") + extension;
            }
        }
    }
#endif  // Q_WS_MAC || Q_WS_WIN*/
    for (int i = 0;i < ui->tabla->rowCount();i++)
    {
        qDebug()<<ui->tabla->cellWidget(i,eColumnas::ABRIR);
        QCheckBox* casilla = qobject_cast<QCheckBox*>(ui->tabla->cellWidget(i,eColumnas::ABRIR));
        if (casilla && casilla->isChecked())
        {
            qDebug()<< ui->tabla->item(i,eColumnas::CODIGO)->data(Qt::DisplayRole).toString();
            QString tabla = "^\"""" + ui->tabla->item(i,eColumnas::CODIGO)->data(Qt::DisplayRole).toString() + "\"""*";
            tablasExportar<<"--table"<<tabla;
        }
    }
    int pos = fileName.lastIndexOf(QChar('/'));
    path = fileName.left(pos);
    qDebug()<<"filename "<<fileName;
    argumentos<<fileName;
    //meto las tablas a exportar
    for (int i = 0;i<tablasExportar.count();i++)
    {
        argumentos.append(tablasExportar.at(i));
    }
    //argumentos<<"--table";
    //argumentos<<"^*pruebas*";
    foreach (const QString& argObra, m_listaObrasBackup)
    {
        argumentos<<argObra;
    }
    argumentos<<m_db->databaseName();
    programa.start(commandToStart,argumentos);
    foreach (const QString& s, programa.arguments()) {
        qDebug()<<s;
    }
    bool started = programa.waitForStarted();
    if (!programa.waitForFinished(10000)) // 10 Second timeout
    {
        programa.kill();
        //qDebug()<<"problema "<<started;
    }
    int exitCode = programa.exitCode();
    qDebug()<<"exit status"<<exitCode;
    QString stdOutput = QString::fromLocal8Bit(programa.readAllStandardOutput());
    QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
    qDebug()<<"Salida: "<<stdOutput;
    qDebug()<<"Errores: "<<stdError;
}

void DialogoGestionObras::ImportarDB()
{
    qDebug()<<"Importar DB";
    QString titulo = "Restaurar copia de respaldo";
    QString extension = "Postgres backup (*.backup);;All Files (*)";
    QString path = QString();
    QString fileName;
    QProcess programa;
    QStringList environment = programa.systemEnvironment();
    QString commandToStart= "pg_restore";
    QStringList argumentos;
    argumentos<<"--host"<<m_db->hostName()<<"--port"<<QString::number(m_db->port())\
             <<"--username"<<m_db->userName()<<"--dbname"<<m_db->databaseName()\
            <<"--role"<<m_role<<"--schema"<<m_schema<<"--verbose";
    fileName =  QFileDialog::getOpenFileName(this,
                                             titulo,
                                             path,
                                             tr("Postgres backup (*.backup);;All Files (*)"),
                                             &extension);
    argumentos<<fileName;
    int pos = fileName.lastIndexOf(QChar('/'));
    path = fileName.left(pos);
    programa.start(commandToStart,argumentos);
    foreach (const QString& s, programa.arguments()) {
        qDebug()<<s;
    }
    bool started = programa.waitForStarted();
    if (!programa.waitForFinished(10000)) // 10 Second timeout
    {
        programa.kill();
        //qDebug()<<"problema "<<started;
    }
    int exitCode = programa.exitCode();
    qDebug()<<"exit status"<<exitCode;
    QString stdOutput = QString::fromLocal8Bit(programa.readAllStandardOutput());
    QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
    qDebug()<<"Salida: "<<stdOutput;
    qDebug()<<"Errores: "<<stdError;
}
