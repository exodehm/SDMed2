#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QHeaderView>
#include <QDir>
#include <QtSql>

namespace Ui {
class MainWindow;
}

class Instancia;
class QLabel;
class QComboBox;
class QLabel;
class QComboBox;
class QPushButton;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    QString strippedName(const QString &fullFileName);
    QString CodigoBC3(const QString& nombrefichero);
    QList<QList<QVariant> > VerObrasEnBBDD();

private slots:
    /*********MENU***************/
    void ActionNuevo();
    bool ActionImportar();
    bool ActionAbrirBBDD();
    bool BorrarBBDD(QStringList datosobra);    
    bool ActionGuardarComo(QString nombreobra);
    bool GuardarObra(QString nombreFichero);
    void ActionCerrar();
    void ActionSalir();
    void ActionCopiar();
    void ActionPegar();
    void ActionCortar();

    void ActionUndo();
    void ActionRedo();

    void ActionAdelante();
    void ActionAtras();
    void ActionInicio();
    void ActionVerArbol();

    void ActionSeleccionarTodo();
    void ActionDeseleccionarTodo();

    void ActionAjustarPresupuesto();

    void AcercaDe();
    void AcercaDeQt();
    /**********OTROS**************/
    void CambiarObraActual(int indice);
    void CambiarMedCert(int indice);
    /*void NuevaCertificacion();
    void CambiarCertificacionActual(int actual);*/

    /*bool ActionAbrirDesdeReciente();
    void updateArchivosRecientesActions();*/

    void ActivarDesactivarBotonesPila(int indice);

protected:
    void setupActions();
    void closeEvent(QCloseEvent* event);

private:

    QSqlDatabase db;    
    std::list<Instancia*>ListaObras;
    std::list<Instancia*>::iterator obraActual;
    QString rutaarchivo;
    //menu abrir reciente
    QStringList recentFiles;
    enum { MaxRecentFiles = 5 };
    QAction *recentFileActions[MaxRecentFiles];
    QAction *separatorAction;
    //fin de menu abrir reciente
    Ui::MainWindow *ui;

    bool ConfirmarContinuar();
    void AnadirObraAVentanaPrincipal(QString _codigo, QString _resumen);

    bool HayObra();
    //combo ver medicion/certificacion
    //el combo he de annadirlo a mano porque no se puede insertar un widget a una qToolBar desde QtDesigner
    QLabel* labelVerMedCert;
    QComboBox* comboMedCert;
    //boton nueva certificacion
    QPushButton* botonNuevaCertificacion;
    //combo certificacion actual
    QLabel* labelCertificacionActual;
    QComboBox* comboCertificacionActual;

    QDir ruta;
    //listas para copiar y pegar
    //std::list<std::pair<pArista,pNodo>>ListaNodosCopiarPegar;
    //Medicion ListaMedicionCopiarPegar;

    void writeSettings();
    void readSettings();
};
#endif // MAINWINDOW_H
