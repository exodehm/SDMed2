#ifndef DIALOGOSUPRIMIRMEDICION_H
#define DIALOGOSUPRIMIRMEDICION_H

#include <QDialog>
#include <QString>

namespace Ui {
class DialogoSuprimirMedicion;
}

class DialogoSuprimirMedicion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoSuprimirMedicion(QString titulo, QString tipocantidad, QWidget *parent = nullptr);
    ~DialogoSuprimirMedicion();
    bool Suprimir() const;

private:
    Ui::DialogoSuprimirMedicion *ui;    
};

#endif // DIALOGOSUPRIMIRMEDICION_H
