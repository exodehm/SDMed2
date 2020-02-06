#ifndef DIALOGOOPERACIONESBBDD_H
#define DIALOGOOPERACIONESBBDD_H

#include <QDialog>

namespace Ui {
class DialogoOperacionesBBDD;
}

class DialogoOperacionesBBDD : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoOperacionesBBDD(QWidget *parent = nullptr);
    ~DialogoOperacionesBBDD();

private:
    Ui::DialogoOperacionesBBDD *ui;
};

#endif // DIALOGOOPERACIONESBBDD_H
