//
// Created by RONI EZEQUIEL CAMJALLI on 05/09/2020.
//

#ifndef SRC_TORNEO_H
#define SRC_TORNEO_H
#include <vector>
#include "Partida.h"
#include "Equipo.h"

using namespace std;

class Torneo {
public:
    Torneo(vector<Partida> &partidas, int cantidadEquipos);

    vector<double> ratingEquiposWP();
    vector<double> ratingEquiposCMM();
    //TODO: rename with algorith name
    vector<double> ratingEquiposCustom();
private:
    vector<Partida> _partidas;
    vector<Equipo> _equipos;
};


#endif //SRC_TORNEO_H
