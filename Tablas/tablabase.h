#ifndef TABLABASE_H
#define TABLABASE_H

#include <QTableView>
#include <QStyledItemDelegate>
#include <QMenu>
#include <QSignalMapper>
#include <QHeaderView>
#include <QItemSelectionModel>

#include "../Delegados/delegadobase.h"
#include "../Delegados/delegadocolumnasbloqueadas.h"
#include "../Delegados/delegadoiconos.h"
#include "../Delegados/delegadonumerosbase.h"
#include "../Delegados/delegadonumerostablaprincipal.h"
#include "../Delegados/delegadonumerostablamedcert.h"
#include "../Delegados/delegadoformulasmedicion.h"
#include "../Delegados/delegadocodigos.h"
//#include "../Modelos/MedCertModel.h"
#include "../Modelos/PrincipalModel.h"

class ModeloBase;
class QPushButton;

class TablaBase : public QTableView
{
    Q_OBJECT

public:
    TablaBase(QWidget *parent=nullptr);
    ~TablaBase();
    bool columnaBloqueada(int columna);
    QHeaderView* CabeceraDeTabla();
    int limiteIzquierdo;
    int limiteDerecho;
    void PonerDelegadoOriginal(int columna);
    virtual void ActualizarDatos(const QStringList& ruta);

private slots:
    void Bloquear(int columna);


public slots:    

    void Certificar();

    void SeleccionarTodo();

    virtual void MostrarMenuCabecera(const QPoint& pos)=0;
    virtual void MostrarMenuLateralTabla(const QPoint& pos)=0;
    virtual void MostrarMenuTabla(const QPoint& pos)=0;


signals:
    void Copiar();
    void Pegar();
    void CambiaFila(QModelIndex ind);    
    void CopiarFilas(QList<int>indices);
    void PegarContenido();
    void CertificarLineasMedicion();    

protected:
    ModeloBase* modelo;
    QHeaderView* cabeceraHorizontal;
    QHeaderView* alturaFilas;
    QHeaderView* cabeceraVertical;
    DelegadoBase* dlgBA;    
    DelegadoNumerosTablaPrincipal* dlgNumTablaP;
    DelegadoNumerosTablaMedCert* dlgNumTablaMC;
    DelegadoColumnasBloqueadas* dlgCB;
    DelegadoFormulasMedicion* dlgFM;
    DelegadoIconos* dlgIco;
    DelegadoCodigos* dlgCO;
    bool* celdaBloqueada;
    QSignalMapper* mapperH;
    QSignalMapper* mapperV;

    QPushButton* btn;
};

#endif // TABLABASE_H
