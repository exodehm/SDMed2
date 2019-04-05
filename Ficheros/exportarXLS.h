#ifndef EXPORTARXLS_H
#define EXPORTARXLS_H

/*
class ExportarXLS
{
public:
    ExportarXLS(const std::string& _tabla, const std::string nombrefichero, QSqlQuery consulta);
    ~ExportarXLS();
};*/

class QString;

namespace XLS {

int crearFuncion(QString nombrefichero, const QList<QList<QString>>&datos);

}

#endif // EXPORTARXLS_H
