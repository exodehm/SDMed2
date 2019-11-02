#include <QApplication>
#include <QStyleFactory>
#include <QFontDatabase>
#include <QDebug>

#include "mainwindow.h"



int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QCoreApplication::setOrganizationName("EGSoft");
    QCoreApplication::setOrganizationDomain("sdsoft.com");
    QCoreApplication::setApplicationName("SDMed2");
    QCoreApplication::setApplicationVersion("0.1 beta");
    //QApplication::setStyle(QStyleFactory::create("Motif"));

    int id = QFontDatabase::addApplicationFont(":/Fuentes/Comfortaa-Regular.ttf");
    qDebug()<<id;
    QString family = QFontDatabase::applicationFontFamilies(id).at(0);
    QFont font(family,10);
    qApp->setFont(font);

    MainWindow m;
    m.show();
    return a.exec();
}
