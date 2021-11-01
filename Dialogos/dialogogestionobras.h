#ifndef DIALOGOTABLASLISTADOOBRAS_H
#define DIALOGOTABLASLISTADOOBRAS_H

#include <QDialog>
#include <QSqlDatabase>

class Instancia;
class QTableWidgetItem;

namespace Ui {
class DialogoGestionObras;
}

class DialogoGestionObras : public QDialog
{
    Q_OBJECT
    enum eColumnas{CODIGO,RESUMEN,ABRIR,BORRAR,EXPORTAR};
public:    
    explicit DialogoGestionObras(std::list<Instancia*>&ListaObras, QSqlDatabase& db, QWidget *parent = nullptr);
    ~DialogoGestionObras();
    void LlenarTabla();
    bool EstaAbierta(const QString& codigo);

public slots:
    QList<QStringList> listaNombreObrasAbrir();
    void Borrar();
    void ActualizarBotones();    

private slots:
    //bool ConectarBBDD();
    void ExportadDB();
    void ImportarDB();

signals:
    void BorrarObra(QStringList datosobra);
    void ActivarBotones(bool);
    //void CambiarResumenObra(QString codigo, QString resumen);

private:
    Ui::DialogoGestionObras *ui;
    QSqlDatabase* m_db;
    std::list<Instancia*> m_listaobras;
    std::list<Instancia*>::iterator primer_elemento;
    std::list<Instancia*>::iterator ultimo_elemento;
    QStringList m_listaObrasBackup;
    QString m_role = "sdmed";
    QString m_schema = "sdmed";
    QString m_tooltipAnadir = "Marcar para añadir a copia de respaldo";
    QString m_tooltipQuitar = "Quitar de la copia de respaldo";
};

#endif // DIALOGOTABLASLISTADOOBRAS_H
