//
// Created by RONI EZEQUIEL CAMJALLI on 05/09/2020.
//

#include "Partida.h"

Partida::Partida(int fecha, int idEquipo1, int golesEquipo1, int idEquipo2, int golesEquipo2) {
    _fecha = fecha;
    _idEquipo1 = idEquipo1;
    _golesEquipo1 = golesEquipo1;
    _idEquipo2 = idEquipo2;
    _golesEquipo2 = golesEquipo2;
}

int Partida::equipo1() {
    return _idEquipo1;
}

int Partida::equipo2() {
    return _idEquipo2;
}

int Partida::ganador() {
    return _golesEquipo1 > _golesEquipo2 ? _idEquipo1 : _idEquipo2;
}

int Partida::golesEquipo1() {
    return _golesEquipo1;
}

int Partida::golesEquipo2() {
    return _golesEquipo2;
}
