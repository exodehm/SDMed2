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
class QPushButton;


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    QString strippedName(const QString &fullFileName);
    //QString CodigoBC3(const QString& nombrefichero);
    void writeSettings();
    void readSettings();



private slots:
    /*********MENU***************/
    void ActionNuevo();
    bool ActionImportar();
    bool ActionAbrirBBDD();
    bool BorrarBBDD(QStringList datosobra);
    //bool Guardar();
    bool Exportar(QString nombreFichero=QString());
    bool GuardarObra(QString nombreFichero);
    void ActionImprimir();
    //void ExportarBC3();
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
    void ActionPropiedadesObra();
    void ActionConfigurar();

    void AcercaDe();
    void AcercaDeQt();
    /**********OTROS**************/
    void CambiarObraActual(int indice);
    void CambiarMedCert(int indice);
    void NuevaCertificacion();
    void CambiarLabelCertificacionActual(QStringList certActual);

    void ActivarDesactivarBotonesPila(int indice);

    void ActivarBotonesBasicos(bool activar);

    void ActualizarDatosObra();

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

    void AnadirObraAVentanaPrincipal(QString _codigo, QString _resumen);

    bool HayObrasAbiertas();
    //combo ver medicion/certificacion
    //el combo he de annadirlo a mano porque no se puede insertar un widget a una qToolBar desde QtDesigner
    QLabel* labelVerMedCert;
    QComboBox* comboMedCert;
    //boton nueva certificacion
    QPushButton* botonCertificaciones;
    //combo certificacion actual
    QLabel* labelCertificacionActual[2];

    QDir ruta;
};
#endif // MAINWINDOW_H
