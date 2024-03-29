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
class DialogoDatosConexion;


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    enum eDatosConexion{BBDD, NOMBRE, HOST, PUERTO, PASSWD};

    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    QString strippedName(const QString &fullFileName);
    //QString CodigoBC3(const QString& nombrefichero);
    void writeSettings();
    void readSettings();
    Instancia *obraActual();
    bool Conectar();
    void ConfigurarDatosConexion();



private slots:
    /*********MENU***************/
    void ActionNuevo();
    bool ActionImportar();
    bool ActionAbrirBBDD();
    bool BorrarBBDD(QStringList datosobra);
    //bool Guardar();
    bool Exportar(QString nombreFichero=QString(),QString obra=QString());
    bool GuardarObra(QString nombreFichero,QString obra=QString());
    void ActionImprimir();
    //void ExportarBC3();
    void ActionCerrar(QString nombreobra = QString());
    void ActionSalir();
    void ActionCopiar();
    void ActionPegar();
    void ActionCortar();
    void GuardarRutaScriptsPython(QString ruta);

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

    void ActivarBotonesBasicos(QSqlDatabase &db);

    void ActualizarDatosObra();

protected:
    void setupActions();
    void closeEvent(QCloseEvent* event);

private:
    std::list<Instancia*>m_ListaObrasAbiertas;
    //std::list<Instancia*>::iterator obraActual;
    std::list<Instancia*>::iterator it;
    QString rutaarchivo;
    //menu abrir reciente
    /*QStringList recentFiles;
    enum { MaxRecentFiles = 5 };
    QAction *recentFileActions[MaxRecentFiles];
    QAction *separatorAction;*/
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

    QString m_nombre;
    QString m_host;
    QString m_puerto;
    QString m_basededatos;
    QString m_password;
    QString m_ruta_scripts_python;
    QSqlDatabase m_db;
    DialogoDatosConexion *m_d;
    quint8 m_tiempoMaximoIntentoConexion;
};
#endif // MAINWINDOW_H
