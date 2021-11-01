#ifndef DIALOGOLISTADOIMPRIMIR_H
#define DIALOGOLISTADOIMPRIMIR_H

#include <QDialog>
#include <QFileInfoList>
#include <QSqlDatabase>
#include <QHash>
#include <QRadioButton>
#include <QPushButton>

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

class DialogoTablaOpcionesImpresion;
using OpcionesListado = QList<QPair<QString,QStringList>>;

class DialogoListadoImprimir : public QDialog
{
    Q_OBJECT

public:
    static const int nTipoListados = 4;
    enum eTipo {LISTADO,MEDICION,CERTIFICACION,GENERAL};
    struct CustomPushButton : public QPushButton
    {
        CustomPushButton (QWidget* parent=nullptr):QPushButton(parent){}
        CustomPushButton(const QString &text, QWidget *parent = nullptr):QPushButton(text,parent){}
        OpcionesListado* opciones;
        QString *opcionesSelecionadas;
        DialogoTablaOpcionesImpresion* d;
    };

    struct CustomRadioButton : public QRadioButton
    {
        CustomRadioButton(const QString &text, QWidget *parent = nullptr):QRadioButton(text,parent){}
        CustomRadioButton (QWidget* parent=nullptr):QRadioButton(parent){}
        QPushButton* botonPropiedades;
        OpcionesListado* opciones;        
    };

    struct sTipoListado
    {
      QString nombre;
      QString ruta;
      eTipo tipo;
      OpcionesListado opciones;
      CustomRadioButton* boton;
      QString opcionesSelecionadas;
    };
    explicit DialogoListadoImprimir(const QString &obra, QSqlDatabase db, QWidget *parent = nullptr);
    ~DialogoListadoImprimir();

    bool LeerJSON(sTipoListado &tipoL, const QString &nombrefichero);

public slots:
    void Previsualizar();
    void ActualizarBotonPrevisualizar();
    void ActualizarBotonAnadir();
    void DesactivarBotones();
    void OpcionesPagina();
    void MostrarTablaOpciones();
    void AnadirListadoImpresion();

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
    QString m_listadosImpresion;
    QString m_tituloListadoImprimir;
    QHash<QString, QString> m_lista_extensiones;
    sOpcionesPagina m_opciones_pagina;    
};

#endif // DIALOGOLISTADOIMPRIMIR_H
