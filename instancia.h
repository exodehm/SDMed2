#ifndef INSTANCIA_H
#define INSTANCIA_H

#include "defs.h"

#include <QSqlQuery>
#include <QWidget>
#include <QModelIndex>

class MiUndoStack;
class QSplitter;
class QHBoxLayout;
class QVBoxLayout;
class QTabWidget;
class QPushButton;

class MedCertModel;
class ModeloBase;
class TreeModel;
class VistaArbol;
class TablaBase;
class Editor;
class QIcon;

class Instancia : public QWidget
{
    Q_OBJECT

public:
    explicit Instancia(QString cod, QString res, QWidget *parent=nullptr);
    ~Instancia();

    void GenerarUI();
    void EscribirTexto();    
    MiUndoStack* Pila();
    void Mover(int tipomovimiento);
    void VerArbol();
    void AjustarPresupuesto();

    const QString& LeeTabla() const;
    const QString& LeeResumen() const;
    void CambiarCodigoObra (const QString& nuevocodigo);
    double LeePrecio(const QString& codigo = "");
    //certificaciones    
    bool HayCertificacion();
    void ActualizarCertificacionEnModelo();    
    void InsertarTablaMedCert(int num_certif);
    void ExportarXLSS(QString nombreFichero);

public slots:

    void SubirNivel();
    void BajarNivel();    

    void TablaSeleccionarTodo(QWidget* widgetactivo);
    void TablaDeseleccionarTodo(QWidget* widgetactivo);

    void MostrarDeSegun(int indice);
    void Undo();
    void Redo();
    void RefrescarVista();
    void RefrescarVistaTablaPrincipal();
    void RefrescarVistaArbol();


    void Copiar();
    void Pegar();
    void CopiarMedicionTablaM();    
    void PegarPartidasTablaP();
    void PegarMedicionTablaM();
    void CopiarElementosTablaPortapapeles(const QModelIndexList &lista, TablaBase* tabla);
    void AdministrarCertificaciones();
    void BorrarCertificacion (QString fecha_certificacion);
    void AnadirCertificacion (QString fecha_certificacion);
    QStringList LeerCertifActual();
    void Certificar();     
    void ActivarDesactivarUndoRedo(int indice);
    void GuardarTextoPartidaInicial();
    void GuardarTextoPartida();
    void SincronizarArbolTablal();
    void ActualizarTablaMedCertActiva(int indice);
    void MaxMinPanel();

signals:
    void CopiarP();
    void PegarP();
    void CopiarM();
    void PegarM();
    void ActivarBoton(int);
    void CambiarLabelCertActual(QStringList);

private:
    //modelos
    ModeloBase* modeloTablaP;   
    TreeModel* modeloArbol;

    QVBoxLayout* lienzoGlobal;

    QSplitter* separadorPrincipal;
    QSplitter* separadorTablas;

    //panel superior (tabla principal)
    QWidget *m_PanelTablaP;
    QHBoxLayout* m_botoneraTablaPrincipal;
    QVBoxLayout* m_lienzoTablaPrincipal;
    QPushButton *m_BtnmaxminTablaP;
    TablaBase* tablaPrincipal;
    //panel intermedio (tablas mediciones y certificaciones)
    QWidget *m_PanelTablasMC;
    QHBoxLayout* m_botoneraTablaMediciones;
    QVBoxLayout* m_lienzoTablaMediciones;
    QPushButton* m_BtnmaxminTablaMC;
    QTabWidget* m_TabWidgetTablasMedCert;
    //panel inferior (editor)
    Editor* m_editor;
    //panel derecho (arbol)
    VistaArbol* m_arbol;

    QList<TablaBase*>Listadotablasmedcert;
    bool m_Maximizado;
    QIcon *m_IconMax, *m_IconMin;
    //QModelIndex indiceActual;

    MiUndoStack* m_pila;

    QString m_codigopadre,m_codigohijo;
    QSqlQuery m_consulta;
    QString m_tabla,m_resumen;
    QString m_textoPartidaInicial;
    QStringList m_ruta, m_certActual;
    int m_tablamedcertactiva;
};

#endif // INSTANCIA_H
