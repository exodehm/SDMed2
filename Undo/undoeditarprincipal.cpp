#include "undoeditarprincipal.h"
#include <QDebug>

UndoEditarPrincipal::UndoEditarPrincipal(QString resumenantiguo, QString resumennuevo, QString descripcion):
    datoAntiguo(resumenantiguo),datoNuevo(resumennuevo)
{
    qDebug()<<"Dato antiguo: "<<datoAntiguo<<" : Dato nuevo: "<<datoNuevo<<" <->Descripcion: "<<descripcion;
}

void UndoEditarPrincipal::undo()
{
    qDebug()<<"Dato antiguo: "<<datoAntiguo;
}

void UndoEditarPrincipal::redo()
{
    qDebug()<<"Dato nuevo: "<<datoNuevo;
}

