#include "dialogogestionobras.h"
#include <QTableWidgetItem>
#include <QtSql/QSqlQuery>
#include <QPushButton>
#include <QCheckBox>
#include <QProcess>
#include <QFileDialog>
#include <QDebug>

#include "ui_dialogogestionobras.h"
#include "./instancia.h"
#include "../Dialogos/dialogodatosconexion.h"

DialogoGestionObras::DialogoGestionObras(std::list<Instancia *> &ListaObras, QSqlDatabase& db, QWidget *parent) : m_listaobras(ListaObras),
    QDialog(parent), ui(new Ui::DialogoGestionObras)
{   
    ui->setupUi(this);
    m_db = &db;
    m_dialogoDatosConexion = nullptr;
    primer_elemento = ListaObras.begin();
    ultimo_elemento = ListaObras.end();
    LlenarTabla();    
    QObject::connect(this,SIGNAL(accepted()),SLOT(listaNombreObrasAbrir()));    
    QObject::connect(this->ui->botonImportarDB,SIGNAL(clicked(bool)),this,SLOT(ImportarDB()));
    QObject::connect(this->ui->botonExportarDB,SIGNAL(clicked(bool)),this,SLOT(ExportadDB()));
    QObject::connect(this->ui->botonConfigurarDatosConexion,SIGNAL(clicked(bool)),this, SLOT(ConfigurarDatosConexion()));
}

DialogoGestionObras::~DialogoGestionObras()
{
    delete ui;
}

void DialogoGestionObras::LlenarTabla()
{
    ui->tabla->clear();
    QStringList cabecera;
    cabecera<<tr("Código")<<tr("Resumen")<<tr("Abrir")<<tr("Borrar")<<tr("");
    ui->tabla->setColumnCount(cabecera.size());
    ui->tabla->setHorizontalHeaderLabels(cabecera);
    QSqlQuery consultaBBDD;
    QString codigo, resumen;
    QString cadenaConsultaBBDD = "SELECT * FROM ver_obras_BBDD()";
    qDebug()<<cadenaConsultaBBDD;
    consultaBBDD.exec (cadenaConsultaBBDD);
    qDebug()<<"Tamaño de filas "<<consultaBBDD.size();
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

bool DialogoGestionObras::EstaAbierta(const QString& codigo)
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
    /*int fila = sender()->objectName().toInt();
    qDebug()<<"Borrar fila en tabla BBDD "<<fila;*/
    QString codigoobra = ui->tabla->item(ui->tabla->currentRow(),eColumnas::CODIGO)->data(Qt::DisplayRole).toString();
    QString resumenobra = ui->tabla->item(ui->tabla->currentRow(),eColumnas::RESUMEN)->data(Qt::DisplayRole).toString();
    QStringList datosobra;
    datosobra<<codigoobra<<resumenobra;
    emit BorrarObra(datosobra);
    ui->tabla->removeRow(ui->tabla->currentRow());
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
            QString tabla = "^\"""" + ui->tabla->item(i,eColumnas::CODIGO)->data(Qt::DisplayRole).toString() + "\"""*";
            m_listaObrasBackup<<"--table"<<tabla;
        }
    }
    ui->botonExportarDB->setEnabled(!m_listaObrasBackup.isEmpty());
}

void DialogoGestionObras::ConfigurarDatosConexion()
{
    if (!m_dialogoDatosConexion)
    {
        m_dialogoDatosConexion = new DialogoDatosConexion(*m_db,this);
        m_dialogoDatosConexion->show();
        if (m_dialogoDatosConexion->exec())
        {
            /*QStringList l = m_dialogoDatosConexion->LeeDatosConexion();
            foreach (QString s, l )
            {
                qDebug()<<"Leyendo del dialogo: "<<s;
            }*/
        }
    }
}

/*bool DialogoGestionObras::ConectarBBDD()
{
    DialogoConexionBBDD* d = new DialogoConexionBBDD(m_db, this);
    if (d->exec()==1)
    {
        LlenarTabla();
    }
    emit ActivarBotones(d->HayConexion());
    return true;
}*/

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
#if defined(Q_OS_WIN) || defined(Q_OS_MAC)
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
#endif  // Q_OS_MAC || Q_OS_WIN
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
        qDebug()<<"problema "<<started;
    }
    LlenarTabla();
    int exitCode = programa.exitCode();
    qDebug()<<"exit status"<<exitCode;
    QString stdOutput = QString::fromLocal8Bit(programa.readAllStandardOutput());
    QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
    qDebug()<<"Salida: "<<stdOutput;
    qDebug()<<"Errores: "<<stdError;
}
