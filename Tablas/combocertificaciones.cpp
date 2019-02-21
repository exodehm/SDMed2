#include "combocertificaciones.h"

#include <QComboBox>
#include <QCheckBox>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QDebug>
#include <QStandardItemModel>

ComboCertificaciones::ComboCertificaciones()
{
    setSizeAdjustPolicy(QComboBox::AdjustToContents);
}

void ComboCertificaciones::ActualizarDatos(QString tabla)
{
    QString cadenaconsultacertificaciones = "SELECT fecha from \"" + tabla + "_Certificaciones" + "\" ORDER BY num_certificacion";
    qDebug()<<cadenaconsultacertificaciones;
    QSqlQuery consulta;
    consulta.exec(cadenaconsultacertificaciones);
    int filas = consulta.size();
//    QSqlQueryModel *modelo = new QSqlQueryModel();
    int columnas = 3;
    QStandardItemModel* model = new QStandardItemModel(filas, columnas);
    int fila = 0;
    while (consulta.next())
    {
        QStandardItem* item = new QStandardItem(QString(consulta.value(0).toString()));
        QCheckBox* itemcheck = new QCheckBox(this);
        //item->setFlags(Qt::ItemIsUserCheckable | Qt::ItemIsEnabled);
        item->setData(Qt::Unchecked, Qt::CheckStateRole);
        model->setItem(fila, 0, item);
        //model->setItem(fila,1,itemcheck);
        fila++;
    }
    this->setModel(model);
}
/*for (int j=0;j<ui->tabla->columnCount();j++)
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
}*/
