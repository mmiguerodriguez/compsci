//
// Created by migue on 24/6/20.
//

#ifndef TP3_SIMCITY_CONSTRUCCION_H
#define TP3_SIMCITY_CONSTRUCCION_H

#include <tuple>
#include "Tipos.h"

using namespace std;

class Construccion {
public:
    Construccion(Casilla c);

    void aumentarAntiguedad();
    void setAntiguedad(int antiguedad);
    Casilla getCasilla();
    int getAntiguedad();

private:
    Casilla _casilla;
    int _antiguedad;
};


#endif //TP3_SIMCITY_CONSTRUCCION_H
