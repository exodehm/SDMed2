#include "dialogodatosgenerales.h"
#include "ui_dialogodatosgenerales.h"
#include "./Delegados/delegadocolumnasbloqueadas.h"
#include "./Tablas/tablapropiedades.h"

#include <QSqlQueryModel>
#include <QSqlQuery>
#include <QDebug>
#include <QSqlTableModel>


DialogoDatosGenerales::DialogoDatosGenerales(const QString& tabla, QSqlDatabase db, QWidget *parent) : m_tabla(tabla), QDialog(parent), ui(new Ui::DialogoDatosGenerales)
{
    ui->setupUi(this);
    m_tabla_propiedades = new TablaPropiedades(tabla);
    m_tabla_propiedades->setObjectName(QStringLiteral("tablaDatos"));
    ui->verticalLayout->addWidget(m_tabla_propiedades);
    //m_modelo_tabla_datos = new QSqlTableModel(this);
    QSqlQueryModel * modeloCombo=new QSqlQueryModel(this);
    QSqlQuery *consulta=new QSqlQuery(db);
    consulta->prepare("SELECT propiedades->>'Propiedad' FROM \"" + tabla + "_Propiedades\" ORDER BY id");
    consulta->exec();
    //qDebug()<<consulta->executedQuery();
    modeloCombo->setQuery(*consulta);
    ui->comboBox_Datos->setModel(modeloCombo);
    //ui->tablaDatos->setModel(m_modelo_tabla_datos);
    //RellenarTabla(ui->comboBox_Datos->currentText());
    QString propiedad = ui->comboBox_Datos->currentText();
    m_tabla_propiedades->ActualizarDatosPropiedades(propiedad);
    QObject::connect(ui->pushButton_Ok,SIGNAL(clicked(bool)),this,SLOT(accept()));
    QObject::connect(ui->comboBox_Datos,SIGNAL(currentIndexChanged(QString)),m_tabla_propiedades,SLOT(ActualizarDatosPropiedades(QString)));
}

DialogoDatosGenerales::~DialogoDatosGenerales()
{
    delete ui;
}

void DialogoDatosGenerales::RellenarTabla(const QString &propiedad)
{
    QString cadenaConsulta = "SELECT propiedad->>'Variable' AS \"Variable\", propiedad->>'Tipo' AS \"Tipo\", "
                             "propiedad->>'Valor' AS \"Valor\", propiedad->>'Nombre' AS \"Nombre\" "
                             "FROM (SELECT json_array_elements(propiedades->'Valor') AS propiedad FROM \""  + m_tabla + "_Propiedades\" "
                            "WHERE propiedades->>'Propiedad'= '"+ propiedad + "') AS pp";
    //qDebug()<<"Rellenar la tabla con la consulta: "<<cadenaConsulta;
    //m_consulta->exec(cadenaConsulta);
    m_modelo_tabla_datos->setQuery(cadenaConsulta);
}
