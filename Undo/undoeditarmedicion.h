#ifndef UNDOEDITARMEDICION_H
#define UNDOEDITARMEDICION_H

#include "./defs.h"

#include "./undobase.h"
#include <QVariant>
#include <QSqlQuery>

class UndoEditarMedicion : public UndoMedicionBase
{
public:
    UndoEditarMedicion(const QString& nombretabla, const QString& id_padre, const QString& id_hijo,
                       const QVariant& dato_antiguo, const QVariant& dato_nuevo, const int& pos,
                       const int& nombrecolumna, const int& num_cert, const QVariant& descripcion);

    void undo();
    void redo();    

protected:
    QVariant m_datoAntiguo, m_datoNuevo;
    int m_columna;    
};

/*************BORRAR LINEA MEDICION******************/
class UndoBorrarLineasMedicion : public UndoMedicionBase
{
public:
    UndoBorrarLineasMedicion(const QString& nombretabla,const QString& id_padre,const QString& id_hijo,
                             const QList<int>&lineas,const int& num_cert,const QVariant& descripcion);

    void undo();
    void redo();

private:
    QString m_array_lineas_borrar;
};

/*************INSERTAR LINEA MEDICION******************/
class UndoInsertarLineaMedicion : public UndoMedicionBase
{
public:
    UndoInsertarLineaMedicion(const QString& nombretabla,const QString& id_padre, const QString& id_hijo, const int num_filas, const int& pos,
                              int fase, QVariant descripcion);

    void undo();
    void redo();

private:
    QString m_id, m_cadenaid;
    int m_numFilas;
};

/*************PEGAR LINEA MEDICION******************/
class UndoPegarLineasMedicion : public UndoMedicionBase
{
public:
    UndoPegarLineasMedicion(const QString& nombretabla,const QString& id_padre,const QString& id_hijo,
                           const int& num_cert,const int& pos,const QVariant& descripcion);

    void undo();
    void redo();

private:
    bool esPrimerRedo;
    QString m_cadenaid;
};



/*************CERTIFICAR LINEA MEDICION******************/
class UndoCertificarLineaMedicion : public UndoMedicionBase
{
public:
    UndoCertificarLineaMedicion(const QString& nombretabla,const QString& id_padre,const QString& id_hijo,
                                const QList<int>&lineas,const int& num_cert,const QVariant& descripcion);

    void undo();
    void redo();

private:
    QString m_array_lineas_certificar;
    QString m_certActual;
};


#endif // UNDOEDITARMEDICION_H
