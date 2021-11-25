#include <QApplication>
#include <QStyleFactory>
#include <QFontDatabase>
#include <QDebug>

#include "mainwindow.h"

<<<<<<< HEAD
=======

>>>>>>> fec6062a34d9afa39ccba598ecd8eb49ba21d04d
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QCoreApplication::setOrganizationName("EGSoft");
    QCoreApplication::setOrganizationDomain("sdsoft.com");
    QCoreApplication::setApplicationName("SDMed2");
    QCoreApplication::setApplicationVersion("0.2 beta");
    qDebug() << QStyleFactory::keys();
    #if defined(Q_OS_WIN)
        QApplication::setStyle(QStyleFactory::create("Fusion"));
    #elif defined(Q_OS_MAC)
        QApplication::setStyle(QStyleFactory::create("Macintosh"));
    #endif  // Q_OS_MAC || Q_OS_WIN
    int id = QFontDatabase::addApplicationFont(":/Fuentes/Comfortaa-Regular.ttf");
    //qDebug()<<id;
    QString family = QFontDatabase::applicationFontFamilies(id).at(0);
    QFont font(family,10);
    qApp->setFont(font);

    MainWindow m;
    m.show();
    return a.exec();
}
