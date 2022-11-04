//
// Created by RONI EZEQUIEL CAMJALLI on 05/09/2020.
//

#ifndef SRC_PARTIDA_H
#define SRC_PARTIDA_H


class Partida {


public:
    Partida(int fecha, int idEquipo1, int golesEquipo1, int idEquipo2, int golesEquipo2);

    int ganador();
    int equipo1();
    int golesEquipo1();
    int equipo2();
    int golesEquipo2();

private:
    int _fecha;
    int _idEquipo1;
    int _golesEquipo1;
    int _idEquipo2;
    int _golesEquipo2;
};


#endif //SRC_PARTIDA_H
