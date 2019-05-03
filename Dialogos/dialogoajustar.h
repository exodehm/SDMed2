#ifndef DIALOGOAJUSTAR_H
#define DIALOGOAJUSTAR_H

#include <QDialog>

namespace Ui {
class DialogoAjustar;
}

class DialogoAjustar : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoAjustar(const QString& codigoraiz, const QString& resumenraiz, const float& precioinicial, QWidget *parent = nullptr);
    QString LeePrecioParaAjustar();
    ~DialogoAjustar();

public slots:
    void PonerValoresDefecto();
    void ModificarCantidad(QString porcentaje);
    void ModificarPorcentaje(QString cantidad);
    void HabilitarBotonAceptar();

private:
    Ui::DialogoAjustar *ui;
    QString codigo,resumen;
    float precio_inicial, precio_final, porcentaje;
};

#endif // DIALOGOAJUSTAR_H
