#ifndef DIALOGOEDITORFORMULASMEDICION_H
#define DIALOGOEDITORFORMULASMEDICION_H

#include <QDialog>

namespace Ui {
class DialogoEditorFormulasMedicion;
}

class DialogoEditorFormulasMedicion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoEditorFormulasMedicion(QVariant uds, QVariant longitud, QVariant anchura, QVariant altura, QWidget *parent = nullptr);
    ~DialogoEditorFormulasMedicion();

public slots:
    void SincronizarWidgets();

private:
    Ui::DialogoEditorFormulasMedicion *ui;
};

#endif // DIALOGOEDITORFORMULASMEDICION_H
