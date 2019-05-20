#ifndef DIALOGOEDITORFORMULASMEDICION_H
#define DIALOGOEDITORFORMULASMEDICION_H

#include <QDialog>

class QSqlQueryModel;
class QComboBox;

namespace Ui {
class DialogoEditorFormulasMedicion;
}

class DialogoEditorFormulasMedicion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoEditorFormulasMedicion(QVariant uds, QVariant longitud, QVariant anchura, QVariant altura, QWidget *parent = nullptr);
    ~DialogoEditorFormulasMedicion();

    bool ComboVacio(const QComboBox* combo);

public slots:
    void SincronizarWidgets();
    void RellenarListadoPerfiles();
    void RellenarTablasDiferentesPerfiles(int tabla);
    void SeleccionarPeso();
    QString LeeFormula();

private:
    Ui::DialogoEditorFormulasMedicion *ui;
    QSqlQueryModel *modeloPerfiles, *modeloTipoPerfiles;
};

#endif // DIALOGOEDITORFORMULASMEDICION_H
