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
    void WriteSettings();

public slots:
    void DefinirRutaScripts();
    void BuscarManualRutaExtension();
    void BuscarAutomaticaRutaExtension();
    void ActivarDirectorioInstalacion(int indice);
    void ActivarBotonInstalarExtension();
    void CopiarExtension();
    void Salir();

private:
    Ui::DialogoConfiguracion *ui;
    QString m_rutaPython;
    QString m_rutaExtensiones;
};

#endif // DIALOGOCONFIGURACION_H
