#include "dialogogoopcionespagina.h"
#include "ui_dialogogoopcionespagina.h"

#include <QDebug>

DialogogoOpcionesPagina::DialogogoOpcionesPagina(QWidget *parent): QDialog(parent), ui(new Ui::DialogogoOpcionesPagina){}
DialogogoOpcionesPagina::DialogogoOpcionesPagina(const sOpcionesPagina &opciones, QWidget *parent): QDialog(parent), ui(new Ui::DialogogoOpcionesPagina)
{
    ui->setupUi(this);
    ui->spinDer->setValue(opciones.mDer);
    ui->spinIzq->setValue(opciones.mIzq);
    ui->spinSup->setValue(opciones.mSup);
    ui->spinInf->setValue(opciones.mInf);
    ui->spinPaginaInicial->setValue(opciones.mPagInicial);
}

DialogogoOpcionesPagina::~DialogogoOpcionesPagina()
{
    delete ui;
}

sOpcionesPagina DialogogoOpcionesPagina::LeerDatos()
{
    sOpcionesPagina toReturn;
    toReturn.mDer = ui->spinDer->value();
    toReturn.mIzq = ui->spinIzq->value();
    toReturn.mSup = ui->spinSup->value();
    toReturn.mInf = ui->spinInf->value();
    toReturn.mPagInicial = ui->spinPaginaInicial->value();
    return toReturn;
}

QString DialogogoOpcionesPagina::LeeDatosS()
{
    QString toReturn = "[";
    toReturn.append(QString::number(ui->spinDer->value())).append(",");
    toReturn.append(QString::number(ui->spinIzq->value())).append(",");
    toReturn.append(QString::number(ui->spinSup->value())).append(",");
    toReturn.append(QString::number(ui->spinInf->value())).append(",");
    toReturn.append(QString::number(ui->spinPaginaInicial->value()));
    toReturn.append("]");
    return toReturn;
}
