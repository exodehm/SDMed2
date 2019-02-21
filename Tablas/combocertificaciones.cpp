#include "combocertificaciones.h"

#include <QComboBox>
#include <QCheckBox>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QDebug>


ComboCertificaciones::ComboCertificaciones()
{
    setSizeAdjustPolicy(QComboBox::AdjustToContents);
}

void ComboCertificaciones::ActualizarDatos(QString tabla)
{
    /*QString cadenaconsultacertificaciones = "SELECT fecha from \"" + tabla + "_Certificaciones" + "\" ORDER BY num_certificacion";
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
    this->setModel(model);*/
}
