#ifndef DEFS_H
#define DEFS_H

#include <QString>

namespace tipoColumna {
    enum  {CODIGO, NATURALEZA, UD, RESUMEN, CANPRES, CANCERT, PORCERTPRES, PRPRES, PRCERT, IMPPRES, IMPCERT};
    enum  {FASE, COMENTARIO, N, LONGITUD, ANCHURA, ALTURA, FORMULA, PARCIAL, SUBTOTAL,ID};
}

enum class Naturaleza{SIN_CLASIFICAR, MANO_DE_OBRA, MAQUINARIA, MATERIALES, COMP_RESIDUO, CLASIF_RESIDUO, CAPITULO, PARTIDA};

namespace naturaleza {

    static const QString leyenda_nat[]={"Sin clasificar", "Mano de Obra", "Maquinaria", "Materiales", "Comp residuo", "Clasificacion residuo", "Capitulo", "Partida"};
}

namespace tipoTablaMedicion {
    enum{MEDICION,CERTIFICACION};

}

namespace movimiento {
    enum {INICIO, ARRIBA, ABAJO, IZQUIERDA, DERECHA};
}

namespace precio {
    enum {MODIFICAR, SUPRIMIR, BLOQUEAR, AJUSTAR};
}

namespace codigo {
    enum {NUEVO, CAMBIAR, DUPLICAR, NADA};
}

namespace color {
    enum {NORMAL,BLOQUEADO,DESCOMPUESTO};
}

namespace datocelda {
    enum{TEXTO,NUMERO,INT};
}

namespace tipoFichero {
    enum{NOVALIDO, SEG, BC3};
}

namespace partidasSQL{
    enum{CODIGOPADRE, CODIGOHIJO, POSICION, UNIDAD, RESUMEN, DESCRIPCION, PRECIO, CANTIDAD, NATURALEZA, FECHA};
}


#endif // DEFS_H
