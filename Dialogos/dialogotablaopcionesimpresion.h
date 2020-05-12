#ifndef DIALOGOTABLAOPCIONESIMPRESION_H
#define DIALOGOTABLAOPCIONESIMPRESION_H

#include <QDialog>

class QPushButton;
class QTableWidget;

namespace Ui {
class DialogoTablaOpcionesImpresion;
}

using OpcionesListado = QList<QPair<QString,QStringList>>;

class DialogoTablaOpcionesImpresion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoTablaOpcionesImpresion(const OpcionesListado& opc, QWidget *parent = nullptr);
    ~DialogoTablaOpcionesImpresion();
    QString OpcionesSeleccionadas();

private:
    Ui::DialogoTablaOpcionesImpresion *ui;
    OpcionesListado m_opciones;
};

#endif // DIALOGOTABLAOPCIONESIMPRESION_H
