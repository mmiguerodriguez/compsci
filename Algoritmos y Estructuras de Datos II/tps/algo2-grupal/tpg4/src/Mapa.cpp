//
// Created by migue on 24/6/20.
//

#include "Mapa.h"

Mapa::Mapa() {

}

// O(#(verticales) + #(horizontales))
bool Mapa::hayRio(Casilla c) const {
    return (_verticales.count(c.first) || _horizontales.count(c.second));
}

// O(1)
void Mapa::agregarRio(Direccion d, int p) {
    if (d == Horizontal) {
        _horizontales.insert(_horizontales.end(), p);
    } else {
        _verticales.insert(_verticales.end(), p);
    }
}

// O(#(m.horizontales) + #(m.verticales))
void Mapa::unirMapa(Mapa m) {
    for (auto h : m._horizontales) {
        agregarRio(Horizontal, h);
    }

    for (auto v : m._verticales) {
        agregarRio(Vertical, v);
    }
}