#include "dialogotablaopcionesimpresion.h"
#include "ui_dialogotablaopcionesimpresion.h"

#include <QTableWidgetItem>
#include <QComboBox>

DialogoTablaOpcionesImpresion::DialogoTablaOpcionesImpresion(const OpcionesListado &opc, QWidget *parent) :
    QDialog(parent), m_opciones(opc),
    ui(new Ui::DialogoTablaOpcionesImpresion)
{
    ui->setupUi(this);
    //ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::ResizeToContents);
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
