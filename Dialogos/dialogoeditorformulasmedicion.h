#ifndef DIALOGOEDITORFORMULASMEDICION_H
#define DIALOGOEDITORFORMULASMEDICION_H

#include <QDialog>

class QSqlQueryModel;

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
    void RellenarListadoPerfiles();
    void RellenarTablasDiferentesPerfiles(int tabla);

private:
    Ui::DialogoEditorFormulasMedicion *ui;
    bool m_comboPerfilesRelleno;
    QSqlQueryModel *modeloPerfiles, *modeloTipoPerfiles;
};

#endif // DIALOGOEDITORFORMULASMEDICION_H
