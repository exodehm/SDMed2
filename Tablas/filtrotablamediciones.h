#ifndef FILTROTABLAMEDICIONES_H
#define FILTROTABLAMEDICIONES_H

#include <QObject>
#include <QModelIndex>
#include <QItemSelection>
#include <QRect>

#include "./filtrotablabase.h"

class QPushButton;
class Marca;
class Marco;


class FiltroTablaMediciones : public FiltroTablaBase
{
    Q_OBJECT
public:
    explicit FiltroTablaMediciones(TablaBase* table, QObject* parent=nullptr);
    bool eventFilter(QObject *obj, QEvent *event) override;
    QRect DibujarMarcasSeleccionRestringida();

private slots:
    void FiltrarColumnaSeleccion();
    void AbrirDialogoEdicionFormulas();

private:
    Marca* m_marca;
    Marco* m_marcoSeleccionRestringida;
    QModelIndex m_currentIndex;
    QPushButton * m_botonFormula;
    bool m_modoRestringido;
    int m_tamMarca;
    bool m_botonPulsado;
};

#endif // FILTROTABLAMEDICIONES_H
