#ifndef ICONOS_H
#define ICONOS_H

#include <map>
#include <QIcon>
#include <QDebug>
#include "./defs.h"

//enum class Naturaleza{SIN_CLASIFICAR, MANO_DE_OBRA, MAQUINARIA, MATERIALES, COMP_RESIDUO,CLASIF_RESIDUO, CAPITULO, PARTIDA};
using IconsMap = std::map<Naturaleza,QIcon>;

class RepoIconos
{
private:
    static IconsMap _iconos;
    static IconsMap initMap()
    {
        return
        {
            std::make_pair(Naturaleza::SIN_CLASIFICAR, QIcon(QStringLiteral(":/Iconos/sinclasificar.png"))),
            std::make_pair(Naturaleza::MANO_DE_OBRA, QIcon(QStringLiteral(":/Iconos/engineer.png"))),
            std::make_pair(Naturaleza::MAQUINARIA, QIcon(QStringLiteral(":/Iconos/trucking.png"))),
            std::make_pair(Naturaleza::MATERIALES, QIcon(QStringLiteral(":/Iconos/brick.png"))),
            std::make_pair(Naturaleza::COMP_RESIDUO, QIcon(QStringLiteral(":/Iconos/delete.png"))),
            std::make_pair(Naturaleza::CLASIF_RESIDUO, QIcon(QStringLiteral(":/Iconos/delete.png"))),
            std::make_pair(Naturaleza::CAPITULO, QIcon(QStringLiteral(":/Iconos/folder.png"))),
            std::make_pair(Naturaleza::PARTIDA, QIcon(QStringLiteral(":/Iconos/file.png")))
        };
    }

public:
    RepoIconos()=delete;//no debe haber constructor disponible al ser clase estática
    static QIcon GetIcon(Naturaleza type)
    {
        if(_iconos.empty())
        {
            _iconos = initMap();
        }
        auto it = _iconos.find(type);
        if(it == _iconos.end())
        {
            it = _iconos.find(Naturaleza::SIN_CLASIFICAR);
        }
        return it->second;
    }

    static QIcon GetIcon(int pos)
    {
        if(_iconos.empty())
        {
            _iconos = initMap();
        }
        auto it = _iconos.begin();
        for (int i=0;i<pos;i++)
        {
            it++;
        }
        return it->second;
    }

    static int tam()
    {
        if(_iconos.empty())
        {
            _iconos = initMap();
        }
        return _iconos.size();
    }
 };

namespace DatosIconos
{
    static const int ImageIndexRole = Qt::UserRole+1;
}
#endif // ICONOS_H
