#ifndef DIALOGOPRECIO_H
#define DIALOGOPRECIO_H

#include "../defs.h"

#include <QDialog>

namespace Ui {
class DialogoPrecio;
}

class DialogoPrecio : public QDialog
{
    Q_OBJECT

public:

    explicit DialogoPrecio(QString titulo, QWidget *parent = nullptr);
    ~DialogoPrecio();
    int Respuesta();

private:
    Ui::DialogoPrecio *ui;
};

#endif // DIALOGOPRECIO_H
