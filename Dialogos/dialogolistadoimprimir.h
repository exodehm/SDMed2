#ifndef DIALOGOLISTADOIMPRIMIR_H
#define DIALOGOLISTADOIMPRIMIR_H

#include <QDialog>
#include <QFileInfoList>

namespace Ui {
class DialogoListadoImprimir;
}

class QRadioButton;

class DialogoListadoImprimir : public QDialog
{
    Q_OBJECT

public:
    static const int nTipoListados = 4;
    enum eTipo {LISTADO,MEDICION,CERTIFICACION,GENERAL};
    struct sTipoListado
    {
      QString nombre;
      QString ruta;
      eTipo tipo;
    };
    explicit DialogoListadoImprimir(QString ruta, QWidget *parent = nullptr);
    ~DialogoListadoImprimir();

    QFileInfoList ComprobarFicheros(const QString& ruta);
    bool LeerJSON(sTipoListado &tipoL, const QString &nombrefichero);

private:
    Ui::DialogoListadoImprimir *ui;
    QRadioButton** botones;
    QList<sTipoListado> lista;
};

#endif // DIALOGOLISTADOIMPRIMIR_H
