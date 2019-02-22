#ifndef INSTANCIA_H
#define INSTANCIA_H

#include "filter.h"
#include "defs.h"

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
    void AjustarPresupuesto(float cantidades[2]);

    const QString& LeeTabla() const;
    const QString& LeeResumen() const;

public slots:

    void SubirNivel();
    void BajarNivel();    

    void TablaSeleccionarTodo(QWidget* widgetactivo);
    void TablaDeseleccionarTodo(QWidget* widgetactivo);

    void PosicionarTablaP(QModelIndex indice);
    void PosicionarTablaM(QModelIndex indice);
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
    void AnadirCertificacion();
    void Certificar();
    void CambiarEntreMedicionYCertificacion(int n);    
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
    ModeloBase* modeloTablaMed;
    ModeloBase* modeloTablaCert;
    TreeModel* modeloArbol;

    QVBoxLayout* lienzoGlobal;

    QSplitter* separadorPrincipal;
    QSplitter* separadorTablas;

    //tablas, editor y arbol
    QTabWidget* separadorTablasMedicion;

    TablaBase* tablaPrincipal;
    TablaBase* tablaMediciones;
    TablaBase* tablaCertificaciones;
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
