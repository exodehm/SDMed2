#ifndef COMBOCERTIFICACIONES_H
#define COMBOCERTIFICACIONES_H

//#include <QObject>
#include <QComboBox>

class ComboCertificaciones : public QComboBox
{
public:
    ComboCertificaciones();
    void ActualizarDatos(QString tabla);

private:
    //QString tabla;
};

#endif // COMBOCERTIFICACIONES_H
