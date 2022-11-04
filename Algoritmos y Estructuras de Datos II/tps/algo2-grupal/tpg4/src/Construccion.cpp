//
// Created by migue on 24/6/20.
//

#include "Construccion.h"

Construccion::Construccion(Casilla c) {
    _casilla = c;
    _antiguedad = 0;
}

void Construccion::aumentarAntiguedad() {
    _antiguedad++;
}

Casilla Construccion::getCasilla() {
    return _casilla;
}

int Construccion::getAntiguedad() {
    return _antiguedad;
}

void Construccion::setAntiguedad(int antiguedad) {
    _antiguedad = antiguedad;
}
