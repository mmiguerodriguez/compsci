//
// Created by RONI EZEQUIEL CAMJALLI on 05/09/2020.
//

#include "Equipo.h"

Equipo::Equipo(vector<Partida> &partidasJugadas, int idEquipo) {
    _partidasJugadas = vector<Partida>(partidasJugadas);
    _idEquipo = idEquipo;
    _cantGanados = 0;
    _cantPerdidos = 0;
    _puntosBonus = 0;
    for(int i = 0; i < _partidasJugadas.size(); i++){
        Partida *p = &_partidasJugadas[i];
        int dif = abs(p->golesEquipo1() - p->golesEquipo2());
        if (p->ganador() == idEquipo){
            _cantGanados++;
            if(dif > 10) {
                _puntosBonus++;
            }
        } else {
            _cantPerdidos++;
            if(dif <= 10) {
                _puntosBonus++;
            }
        }
    }
}

int Equipo::cantJugados() {
    return _cantPerdidos + _cantGanados;
}

int Equipo::getCantGanados() {
    return _cantGanados;
}

int Equipo::getCantPerdidos() {
    return _cantPerdidos;
}

int Equipo::cantGanadosVs(int idEquipo) {
    int res = 0;
    for(int i = 0; i < _partidasJugadas.size(); i++){
        Partida *p = &_partidasJugadas[i];
        if (p->ganador() == _idEquipo && (p->equipo1() == idEquipo || p->equipo2() == idEquipo)){
            res++;
        }
    }
    return res;
}

int Equipo::cantPerdidosVs(int idEquipo) {
    int res = 0;
    for(int i = 0; i < _partidasJugadas.size(); i++){
        Partida *p = &_partidasJugadas[i];
        if (p->ganador() == idEquipo){
            res++;
        }
    }
    return res;
}

int Equipo::cantJugadosVs(int idEquipo) {
    int res = 0;
    for(int i = 0; i < _partidasJugadas.size(); i++){
        Partida *p = &_partidasJugadas[i];
        if (p->equipo1() == idEquipo || p->equipo2() == idEquipo){
            res++;
        }
    }
    return res;
}

int Equipo::getPuntosBonus() {
    return _puntosBonus;
}

int Equipo::getId() {
    return _idEquipo;
}
