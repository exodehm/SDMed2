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
    void CargarDatos();

    enum eColumnas{CODIGO,RESUMEN,ABRIR,BORRAR};

public slots:
    QList<QStringList> listaNombreObrasAbrir();
    void Borrar();
    void MostrarCambioTitulo(int fila, int columna);

signals:
    void BorrarObra(QStringList datosobra);
    void CambiarResumenObra(QString codigo, QString resumen);

private:
    Ui::DialogoTablasListadoObras *ui;
};

#endif // DIALOGOTABLASLISTADOOBRAS_H
