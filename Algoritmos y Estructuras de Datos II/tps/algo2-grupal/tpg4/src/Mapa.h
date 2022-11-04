//
// Created by migue on 24/6/20.
//

#ifndef TP3_SIMCITY_MAPA_H
#define TP3_SIMCITY_MAPA_H

#include <set>
#include "Tipos.h"

using namespace std;

// Nuestro mapa
class Mapa {
public:
    Mapa();
    Mapa(set<int> h, set<int> v);
    bool hayRio(Casilla c) const;
    void agregarRio(Direccion d, int p);
    void unirMapa(Mapa m);

private:
    set<int> _horizontales;
    set<int> _verticales;
};


#endif //TP3_SIMCITY_MAPA_H
