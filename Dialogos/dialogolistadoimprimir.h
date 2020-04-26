#ifndef DIALOGOLISTADOIMPRIMIR_H
#define DIALOGOLISTADOIMPRIMIR_H

#include <QDialog>
#include <QFileInfoList>
#include <QSqlDatabase>
#include <QHash>
#include <QRadioButton>

namespace Ui {
class DialogoListadoImprimir;
}

class QRadioButton;
class QVBoxLayout;

struct sOpcionesPagina
{
  double mSup;
  double mInf;
  double mDer;
  double mIzq;
  int mPagInicial;
};

class DialogoListadoImprimir : public QDialog
{
    Q_OBJECT

public:
    static const int nTipoListados = 4;
    enum eTipo {LISTADO,MEDICION,CERTIFICACION,GENERAL};
    struct CustomRadioButton : public QRadioButton
    {
        CustomRadioButton(const QString &text, QWidget *parent = nullptr):QRadioButton(text,parent){}
        CustomRadioButton (QWidget* parent=nullptr):QRadioButton(parent){}
        QPushButton* botonPropiedades;
    };
    using OpcionesListado = QList<QPair<QString,QStringList>>;
    struct sTipoListado
    {
      QString nombre;
      QString ruta;
      eTipo tipo;
      OpcionesListado opciones;
      CustomRadioButton* boton;
    };
    explicit DialogoListadoImprimir(const QString &obra, QSqlDatabase db, QWidget *parent = nullptr);
    ~DialogoListadoImprimir();

    bool LeerJSON(sTipoListado &tipoL, const QString &nombrefichero);

public slots:
    void Previsualizar();
    void ActualizarBotonPrevisualizar();
    void DesactivarBotones();
    void OpcionesPagina();
    void GenerarTablaOpciones();

private:
    Ui::DialogoListadoImprimir *ui;
    QList<sTipoListado> m_lista;
    QVBoxLayout* m_botoneralayout[nTipoListados];
    QSqlDatabase m_db;
    QString m_ruta;
    QString m_pModulo;
    QString m_pFuncion;
    QString m_obra;
    QString m_layout_pagina;
    QHash<QString, QString> m_lista_extensiones;
    sOpcionesPagina m_opciones_pagina;
};

#endif // DIALOGOLISTADOIMPRIMIR_H
