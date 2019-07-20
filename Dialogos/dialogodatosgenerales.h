#ifndef DIALOGODATOSGENERALES_H
#define DIALOGODATOSGENERALES_H

#include <QDialog>
#include <QSqlDatabase>

class TablaPropiedades;
class QSqlQueryModel;

namespace Ui {
class DialogoDatosGenerales;
}

class DialogoDatosGenerales : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoDatosGenerales(const QString& tabla, QSqlDatabase db, QWidget *parent = nullptr);
    ~DialogoDatosGenerales();

private slots:
    void RellenarTabla(const QString& propiedad);

private:
    Ui::DialogoDatosGenerales *ui;
    QString m_tabla;
    //QSqlQuery* m_consulta;
    //QSqlTableModel* m_modelo_tabla_datos;
    QSqlQueryModel * m_modelo_tabla_datos;
    TablaPropiedades* m_tabla_propiedades;
};

#endif // DIALOGODATOSGENERALES_H
