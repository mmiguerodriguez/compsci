//
// Created by migue on 24/6/20.
//

#ifndef TP3_SIMCITY_SIMCITY_H
#define TP3_SIMCITY_SIMCITY_H

#include <set>
#include "Mapa.h"
#include "Construccion.h"

using namespace std;

class SimCity {
public:
    // Destructor
    ~SimCity();

    // Generadores
    SimCity();
    SimCity(SimCity* s);
    SimCity(Mapa m);
    void agregarCasa(Casilla c);        // Precondicion: Se puede construir en la Casilla c
    void agregarComercio(Casilla c);    // Precondicion: Se puede construir en la Casilla c
    void avanzarTurno();                // Precondicion: Hubo construccion en el turno actual
    void unir(SimCity* sc);             // Precondicion: No se solapan las construcciones con los rios
                                        //  ni las construcciones de nivel maximo de ambas partidas

    // Observadores:
    Mapa mapa() const;
    set<Casilla> casas() const;
    set<Casilla> comercios() const;
    Nat nivel(Casilla c) const;         // Precondicion: Hay construccion en la Casilla c
    bool huboConstruccion() const;
    Nat popularidad() const;
    Nat antiguedad() const;

private:
    Mapa _rios;
    Nat _turnoActual;
    Nat _popularidad;
    bool _huboConstruccion;

    set<Construccion*> _casas;
    set<Construccion*> _comercios;
    set<SimCity*> _uniones;

    set<Construccion*> _aplanarCasas() const;
    set<Construccion*> _aplanarComercios() const;

    int _distanciaManhattan(Casilla c1, Casilla c2) const;
    void _borrarRecursivo();
};


#endif //TP3_SIMCITY_SIMCITY_H
