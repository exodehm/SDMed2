#ifndef INSTANCIA_H
#define INSTANCIA_H

//#include <QWidget>

/*#include "./Ficheros/abrirguardar.h"
#include "./Ficheros/abrirguardarbc3.h"
#include "./Ficheros/abrirguardarseg.h"*/


//#include "./Undo/undoajustarpresupuesto.h"

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
    /*TEXTO TextoPartidaInicial();

    PrincipalModel* ModeloTablaPrincipal();
    TablaBase* LeeTablaPrincipal();*/

    QUndoStack* Pila();
    void Mover(int tipomovimiento);
    void VerArbol();
    void AjustarPresupuesto(float cantidades[2]);

    const QString& LeeTabla() const;
    const QString& LeeResumen() const;

    //int TipoFichero(TEXTO nombrefichero);

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
    void CopiarMedicionTablaM();
    void CopiarPartidas(const QList<int>&indices);
    void PegarPartidasTablaP();
    void PegarMedicionTablaM();
    //void PegarPartidas(const Obra::ListaAristasNodos &listaNodosCopiarPegar);
    void CopiarMedicionPortapapeles(const QModelIndexList &lista);
    void CopiarPartidasPortapapeles(const QModelIndexList &lista);
    //void CopiarMedicion(Medicion& listaMedicionCopiarPegar);
    //void PegarMedicion(const Medicion& ListaMedicion);
    void Certificar();
    void CambiarEntreMedicionYCertificacion(int n);    
    void ActivarDesactivarUndoRedo(int indice);
    void GuardarTextoPartidaInicial();
    void GuardarTextoPartida();

signals:
    void CopiarP();
    void PegarP();
    void CopiarM();
    void PegarM();
    void ActivarBoton(int);

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

    QStringList ruta;
};

#endif // INSTANCIA_H
