#include <QApplication>

#include "mainwindow.h"



int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QCoreApplication::setOrganizationName("EGSoft");
    QCoreApplication::setOrganizationDomain("sdsoft.com");
    QCoreApplication::setApplicationName("SDMed2");
    QCoreApplication::setApplicationVersion("0.1 beta");
    QSettings::setDefaultFormat(QSettings::IniFormat);

    MainWindow m;
    m.show();
    return a.exec();
}
