//
// Created by RONI EZEQUIEL CAMJALLI on 05/09/2020.
//

#include <set>
#include "Torneo.h"
#include "SistemaLineal.hpp"

Torneo::Torneo(vector<Partida> &partidas, int cantidadEquipos) {
    _partidas = vector<Partida>(partidas);
    _equipos = vector<Equipo>();

    set<int> idEquipos;
    for (int i = 0; i < _partidas.size(); i++) {
        idEquipos.insert(_partidas[i].equipo1());
        idEquipos.insert(_partidas[i].equipo2());
    }

    for(std::set<int>::iterator idEquipo = idEquipos.begin(); idEquipo != idEquipos.end(); idEquipo++){
        vector<Partida> partidasJugadas;
        for (int j = 0; j < _partidas.size(); j++){
            if(_partidas[j].equipo1() == *idEquipo || _partidas[j].equipo2() == *idEquipo){
                partidasJugadas.push_back(_partidas[j]);
            }
        }
        _equipos.emplace_back(Equipo(partidasJugadas, *idEquipo));
    }
}

vector<double> Torneo::ratingEquiposCMM() {
    int n = _equipos.size();

    vector<vector<double>> data(n, vector<double>(n, 0));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (i == j) {
                data[i][j] = 2 + _equipos[i].cantJugados();
            } else {
                data[i][j] = -_equipos[i].cantJugadosVs(_equipos[j].getId());
            }
        }
    }

    vector<double> b(n);
    for (int i = 0; i < n; i++) {
        b[i] = 1 + (_equipos[i].getCantGanados() - _equipos[i].getCantPerdidos())/2.0f;
    }

    SistemaLineal *sistemaLineal = new SistemaLineal(data, b);
    return sistemaLineal->calcularResultado();
}

vector<double> Torneo::ratingEquiposCustom() {
    vector<double> res;

    for(Equipo equipo : _equipos) {
        double rating = ((double)equipo.getCantGanados() * 4 + equipo.getPuntosBonus()) /
                (equipo.cantJugados() * 5);
        res.push_back(rating);
    }

    return res;
}

vector<double> Torneo::ratingEquiposWP() {
    vector<double> res;

    for(Equipo equipo : _equipos) {
        double rating = (double)equipo.getCantGanados() / equipo.cantJugados();
        res.push_back(rating);
    }

    return res;
}