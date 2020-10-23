#ifndef DIALOGOCONFIGURACION_H
#define DIALOGOCONFIGURACION_H

#include <QDialog>
#include <QFile>

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
    void BuscarAutomaticaRutaDatos();
    void ActivarDirectorioInstalacion(int indice);
    void ActivarBotonInstalarExtension();
    void InstalarExtension();
    void CopiarExtensionPermisos(QFile &fichero_origen, const QString &ruta_destino, QString passw = "");
    void Salir();

private:
    Ui::DialogoConfiguracion *ui;
    QString m_rutaPython;
    QString m_rutaExtensiones;
};

#endif // DIALOGOCONFIGURACION_H
