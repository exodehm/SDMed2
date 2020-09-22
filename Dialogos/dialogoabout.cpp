#include <QApplication>
#include <QDate>
#include "dialogoabout.h"
#include "ui_dialogoabout.h"

DialogoAbout::DialogoAbout(QWidget *parent) : QDialog(parent), ui(new Ui::DialogoAbout)
{
    ui->setupUi(this);
    QString m_nombre_programa = QApplication::applicationName()+" v "+QApplication::applicationVersion();
    ui->labelTitulo->setText(m_nombre_programa);
    QString m_anno = QString::number(QDate::currentDate().year());
    ui->label->setText("<html><head/><body>\
                       <p align=\"center\"><br/></p><p align=\"center\"><span style=\" font-weight:600;\">"+m_nombre_programa+"</span> es un programa de mediciones y presupuestos multiplataforma</p>\
                       <p align=\"center\">bajo servidor PostgreSQL y cliente programado en Qt y Python </p><p align=\"center\"><br/></p>\
                       <p align=\"center\">Copyright © 2017-"+m_anno+"</p><p align=\"center\">David E. de las Heras Moreno</p>\
                       <p align=\"center\">Código fuente disponbile en <a href=\"https://github.com/exodehm/SDMed2\"><span style=\" text-decoration: underline; color:#0000ff;\">GitHub</span></a></p>\
                       <p align=\"center\">Dudas, problemas, sugerencias u otros escribir a:</p>\
                       <p align=\"center\"><a href=\"mailto:SDMed.contacto@gmail.com\"><span style=\" text-decoration: underline; color:#0000ff;\">sdmed.contacto@gmail.com</span></a></p>\
                       <p align=\"center\"><br/></p></body></html>");


    ui->label->setAlignment(Qt::AlignHCenter);
    ui->label->setOpenExternalLinks(true);
    QObject::connect(ui->botonCreditos,SIGNAL(clicked(bool)),this,SLOT(VerCreditos()));
    QObject::connect(ui->botonLicencia,SIGNAL(clicked(bool)),this,SLOT(VerLicencia()));
}

DialogoAbout::~DialogoAbout()
{
    delete ui;
}

void DialogoAbout::VerCreditos()
{
    DialogoCreditos* d = new DialogoCreditos(this);
    d->show();
}

void DialogoAbout::VerLicencia()
{
    DialogoLicencia* d = new DialogoLicencia(this);
    d->show();
}
