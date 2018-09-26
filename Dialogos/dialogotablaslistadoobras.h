#ifndef DIALOGOTABLASLISTADOOBRAS_H
#define DIALOGOTABLASLISTADOOBRAS_H

#include <QDialog>

class MetaObra;

namespace Ui {
class DialogoTablasListadoObras;
}

class DialogoTablaListadosObras : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoTablaListadosObras(const QList<QList<QVariant> > &listadoobrasenBBDD, QWidget *parent = nullptr);
    ~DialogoTablaListadosObras();

public slots:
    QList<QStringList> listaNombreObrasAbrir();

private:
    Ui::DialogoTablasListadoObras *ui;
};

#endif // DIALOGOTABLASLISTADOOBRAS_H
