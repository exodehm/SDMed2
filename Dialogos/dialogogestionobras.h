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
    enum eColumnas{CODIGO,RESUMEN,ABRIR,BORRAR};
public:    
    explicit DialogoGestionObras(std::list<Instancia*>&ListaObras, QSqlDatabase& db, QWidget *parent = nullptr);
    ~DialogoGestionObras();
    void LlenarTabla();
    bool EstaAbierta(QString codigo);

public slots:
    QList<QStringList> listaNombreObrasAbrir();
    void Borrar();

private slots:
    bool ConectarBBDD();    

signals:
    void BorrarObra(QStringList datosobra);
    void ActivarBotones(bool);
    //void CambiarResumenObra(QString codigo, QString resumen);

private:
    Ui::DialogoGestionObras *ui;
    QSqlDatabase* m_db;
    std::list<Instancia*>::iterator primer_elemento;
    std::list<Instancia*>::iterator ultimo_elemento;
};

#endif // DIALOGOTABLASLISTADOOBRAS_H
