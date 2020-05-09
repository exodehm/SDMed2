#include "dialogotablaopcionesimpresion.h"
#include "ui_dialogotablaopcionesimpresion.h"

#include <QTableWidgetItem>
#include <QComboBox>
#include <QDebug>

DialogoTablaOpcionesImpresion::DialogoTablaOpcionesImpresion(const OpcionesListado &opc, QWidget *parent) :
    QDialog(parent), m_opciones(opc),
    ui(new Ui::DialogoTablaOpcionesImpresion)
{
    ui->setupUi(this);
    ui->tableWidget->setRowCount(m_opciones.size());
    auto it = m_opciones.begin();
    int fila = 0;
    while (it<m_opciones.end())
    {
        ui->tableWidget->setItem(fila,0,new QTableWidgetItem(it->first));
        QComboBox* combo = new QComboBox;
        combo->addItems(it->second);
        ui->tableWidget->setCellWidget(fila,1,combo);
        fila ++;
        it++;
    }
    setWindowFlags(Qt::Window | Qt::CustomizeWindowHint);
}

DialogoTablaOpcionesImpresion::~DialogoTablaOpcionesImpresion()
{
    //delete ui;
}

QList<QPair<QString, QString> > DialogoTablaOpcionesImpresion::OpcionesSeleccionadas()
{
    QList<QPair<QString, QString> > toReturn;
    for (int fila = 0;fila<ui->tableWidget->model()->rowCount();fila++)
    {
        QPair<QString, QString> par;
        for (int columna = 0;columna<ui->tableWidget->model()->columnCount();columna++)
        {
            if (columna==0)
            {
                par.first = ui->tableWidget->model()->index(fila,columna).data().toString();
            }
            if (columna==1)
            {
                QComboBox* c = dynamic_cast<QComboBox*>(ui->tableWidget->cellWidget(fila,columna));
                if (c)
                {
                    par.second = c->currentText();
                }
            }
        }
        toReturn.append(par);
    }
    return toReturn;
}
