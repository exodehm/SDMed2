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
    explicit DialogoEditorFormulasMedicion(const QVariant& uds, const QVariant& longitud, const QVariant& anchura, const QVariant& altura, const QVariant& formula, QWidget *parent = nullptr);
    ~DialogoEditorFormulasMedicion();

    bool ComboVacio(const QComboBox* combo);    

public slots:
    void SincronizarWidgets();
    void RellenarListadoPerfiles();
    void RellenarTablasDiferentesPerfiles(const QString &tipo);
    void SeleccionarPeso(const QString &tam);
    QString LeeFormula();
    QString LeeUd();
    QString LeeLong();
    QString LeeAnc();
    QString LeeAlt();
    void Evaluar();

private:
    Ui::DialogoEditorFormulasMedicion *ui;
    QSqlQueryModel *modeloPerfiles, *modeloTipoPerfiles;
};

#endif // DIALOGOEDITORFORMULASMEDICION_H
