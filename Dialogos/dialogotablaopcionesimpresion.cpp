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

QString DialogoTablaOpcionesImpresion::OpcionesSeleccionadas()
{
    QString toReturn = "[";
    for (int fila = 0;fila<ui->tableWidget->model()->rowCount();fila++)
    {
        QComboBox* c = dynamic_cast<QComboBox*>(ui->tableWidget->cellWidget(fila,1));//columna == 1
        if (c)
        {
            toReturn.append("'").append(c->currentText()).append("'");
            if (fila < ui->tableWidget->model()->rowCount() - 1)
            {
                toReturn.append(",");
            }
        }
    }
    toReturn.append("]");
    return toReturn;
}
