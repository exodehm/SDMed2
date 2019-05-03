#ifndef INSTANCIA_H
#define INSTANCIA_H

#include "filter.h"
#include "defs.h"

#include <QSqlQuery>

class QUndoStack;
class QSplitter;
class MedCertModel;
class ModeloBase;
class TreeModel;
class VistaArbol;

class Instancia : public QWidget
{
    Q_OBJECT

public:
    explicit Instancia(QString cod, QString res, QWidget *parent=nullptr);
    ~Instancia();

    void GenerarUI();
    void EscribirTexto();    
    QUndoStack* Pila();
    void Mover(int tipomovimiento);
    void VerArbol();
    void AjustarPresupuesto();

    const QString& LeeTabla() const;
    const QString& LeeResumen() const;
    const float LeePrecio(const QString& codigo = "");
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

signals:
    void CopiarP();
    void PegarP();
    void CopiarM();
    void PegarM();
    void ActivarBoton(int);
    void CambiarLabelCertActual(QStringList);

private:
    QHeaderView* cabeceraTablaP;
    //modelos
    ModeloBase* modeloTablaP;   
    TreeModel* modeloArbol;

    QVBoxLayout* lienzoGlobal;

    QSplitter* separadorPrincipal;
    QSplitter* separadorTablas;

    //tablas, editor y arbol
    QTabWidget* separadorTablasMedicion;

    TablaBase* tablaPrincipal;
    QList<TablaBase*>Listadotablasmedcert;
    Editor* editor;
    VistaArbol* arbol;

    QModelIndex indiceActual;

    QUndoStack* pila;

    QString codigopadre,codigohijo;
    QSqlQuery consulta;
    QString tabla,resumen;
    QString textoPartidaInicial;

    QStringList ruta, certActual;
};

#endif // INSTANCIA_H
