//
// Created by RONI EZEQUIEL CAMJALLI on 05/09/2020.
//

#ifndef SRC_EQUIPO_H
#define SRC_EQUIPO_H

#include <vector>
#include <stdlib.h>
#include "Partida.h"

using namespace std;

class Equipo {
public:
    /**
     *
     * @param partidasJugadas: PRE idEquipo == equipo1 || idEquipo == equipo2
     * @param idEquipo
     */
    Equipo(vector<Partida> &partidasJugadas, int idEquipo);

    int cantJugados();
    int getCantGanados();
    int getCantPerdidos();
    int getPuntosBonus();
    int getId();

    int cantGanadosVs(int idEquipo);
    int cantPerdidosVs(int idEquipo);
    int cantJugadosVs(int idEquipo);
private:
    int _cantGanados;
    int _cantPerdidos;
    int _idEquipo;
    int _puntosBonus;
    vector<Partida> _partidasJugadas;
};


#endif //SRC_EQUIPO_H
