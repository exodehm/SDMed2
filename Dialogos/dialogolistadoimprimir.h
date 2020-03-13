#ifndef DIALOGOLISTADOIMPRIMIR_H
#define DIALOGOLISTADOIMPRIMIR_H

#include <QDialog>
#include <QFileInfoList>
#include <QSqlDatabase>

namespace Ui {
class DialogoListadoImprimir;
}

class QRadioButton;
class QVBoxLayout;

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
      QRadioButton* boton;
    };
    explicit DialogoListadoImprimir(const QString &ruta, QSqlDatabase db, QWidget *parent = nullptr);
    ~DialogoListadoImprimir();

    bool LeerJSON(sTipoListado &tipoL, const QString &nombrefichero);

public slots:
    void Imprimir();

private:
    Ui::DialogoListadoImprimir *ui;
    QList<sTipoListado> m_lista;
    QVBoxLayout* m_botoneralayout[nTipoListados];
    QSqlDatabase m_db;
    QString m_ruta;
};

#endif // DIALOGOLISTADOIMPRIMIR_H
