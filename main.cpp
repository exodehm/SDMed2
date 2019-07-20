#include <QApplication>

#include "mainwindow.h"



int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QCoreApplication::setOrganizationName("SDSoft");
    QCoreApplication::setOrganizationDomain("sdsoft.com");
    QCoreApplication::setApplicationName("SDMed2");
    QCoreApplication::setApplicationVersion(QT_VERSION_STR);
    QSettings::setDefaultFormat(QSettings::IniFormat);

    MainWindow m;
    m.show();
    return a.exec();
}
