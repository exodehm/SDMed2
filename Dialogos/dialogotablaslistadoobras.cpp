#include "dialogotablaslistadoobras.h"
#include "ui_dialogotablaslistadoobras.h"
#include "metaobra.h"
#include <QTableWidgetItem>
#include <QtSql/QSqlQuery>
#include <QPushButton>
#include <QCheckBox>
#include <QDebug>

DialogoTablaListadosObras::DialogoTablaListadosObras(const QList<QList<QVariant>>& listadoobrasenBBDD, QWidget *parent) : QDialog(parent), ui(new Ui::DialogoTablasListadoObras)
{   
    ui->setupUi(this);
    setWindowTitle(tr("Obras en la BBDD"));
    QStringList cabecera;
    cabecera<<"Código"<<"Resumen"<<"Abrir"<<"Borrar";
    ui->tabla->setRowCount(listadoobrasenBBDD.size());
    ui->tabla->setColumnCount(listadoobrasenBBDD.at(0).size()+1);
    ui->tabla->setHorizontalHeaderLabels(cabecera);
    for (int i=0;i<ui->tabla->rowCount();i++)
    {
        for (int j=0;j<ui->tabla->columnCount();j++)
        {
            if (j==eColumnas::CODIGO || j==eColumnas::RESUMEN)
            {
                QTableWidgetItem* algo = new QTableWidgetItem(listadoobrasenBBDD.at(i).at(j).toString());
                ui->tabla->setItem(i,j,algo);
            }
            else if (j==eColumnas::ABRIR)
            {
                QCheckBox* itemcheck = new QCheckBox(this);
                itemcheck->setEnabled(!listadoobrasenBBDD.at(i).at(j).toBool());
                QObject::connect(itemcheck,SIGNAL(clicked(bool)),this,SLOT(listaNombreObrasAbrir()));
                ui->tabla->setCellWidget(i,j,itemcheck);             
            }
            else if (j==eColumnas::BORRAR)
            {
                QPushButton* btn_borrar = new QPushButton(tr("Borrar"));//,ui->tabla);
                btn_borrar->setObjectName(QString("%1").arg(i));
                QObject::connect(btn_borrar,SIGNAL(clicked(bool)),this,SLOT(Borrar()));
                ui->tabla->setCellWidget(i,j,btn_borrar);
            }
        }
    }
    ui->tabla->resizeColumnsToContents();
    QObject::connect(this,SIGNAL(accepted()),SLOT(listaNombreObrasAbrir()));
}

DialogoTablaListadosObras::~DialogoTablaListadosObras()
{
    delete ui;
}

QList<QStringList> DialogoTablaListadosObras::listaNombreObrasAbrir()
{
    QList<QStringList> listado;
    QStringList listalinea;
    for (int i=0;i<ui->tabla->rowCount();i++)
    {
        QCheckBox* c = qobject_cast<QCheckBox*>(ui->tabla->cellWidget(i,2));
        if (c->isChecked())
        {
            listalinea.append(ui->tabla->item(i,0)->data(Qt::DisplayRole).toString());
            listalinea.append(ui->tabla->item(i,1)->data(Qt::DisplayRole).toString());
            listado.append(listalinea);
            listalinea.clear();
        }
    }
    return listado;
}

void DialogoTablaListadosObras::Borrar()
{
    int fila = sender()->objectName().toInt();
    QString codigoobra = ui->tabla->item(fila,0)->data(Qt::DisplayRole).toString();
    QString resumenobra = ui->tabla->item(fila,1)->data(Qt::DisplayRole).toString();
    QStringList datosobra;
    datosobra<<codigoobra<<resumenobra;
    emit BorrarObra(datosobra);
}
