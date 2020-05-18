#ifndef DIALOGOCONFIGURACION_H
#define DIALOGOCONFIGURACION_H

#include <QDialog>

namespace Ui {
class DialogoConfiguracion;
}

class DialogoConfiguracion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoConfiguracion(QWidget *parent = nullptr);
    ~DialogoConfiguracion();
    void ReadSettings();

public slots:
    void DefinirRuta();
    void GuardarDatosConexion();

private:
    Ui::DialogoConfiguracion *ui;
    QString m_rutaPython;
};

#endif // DIALOGOCONFIGURACION_H
