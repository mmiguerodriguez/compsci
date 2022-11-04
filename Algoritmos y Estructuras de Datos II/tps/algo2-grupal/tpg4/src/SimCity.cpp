//
// Created by migue on 24/6/20.
//

#include "SimCity.h"

/*
 * Cuando usamos insert en un set<>, le pasamos como primer parametro la posicion
 * en donde insertar (hint) para que sea O(1) amortizado.
 * Ej: _casas.insert(_casas.end(), casa)
 *                        ^
 *                       hint
 */

// Sin uso
SimCity::SimCity() {

}

/*
 * Constructor por copia
 * Copia todos los datos de otro simCity y se ejecuta recursivamente para las uniones.
 */
SimCity::SimCity(SimCity* s) {
    _rios = s->_rios;
    _turnoActual = s->_turnoActual;
    _popularidad = s->_popularidad;
    _huboConstruccion = s->_huboConstruccion;

    for (auto casa : s->_casas) {
        Construccion* c = new Construccion(casa->getCasilla());
        c->setAntiguedad(casa->getAntiguedad());
        _casas.insert(c);
    }

    for (auto comercio : s->_comercios) {
        Construccion* c = new Construccion(comercio->getCasilla());
        c->setAntiguedad(comercio->getAntiguedad());
        _comercios.insert(c);
    }

    for (auto u : s->_uniones) {
        SimCity* uni = new SimCity(u);
        _uniones.insert(uni);
    }
}


// O(1)
SimCity::SimCity(Mapa m) {
    _rios = m;
    _turnoActual = 0;
    _popularidad = 0;
    _huboConstruccion = false;
}

// O(1)
void SimCity::agregarCasa(Casilla c) {
    Construccion* constr = new Construccion(c);
    _casas.insert(_casas.end(), constr);
    _huboConstruccion = true;
}

// O(1)
void SimCity::agregarComercio(Casilla c) {
    Construccion* constr = new Construccion(c);
    _comercios.insert(_comercios.end(), constr);
    _huboConstruccion = true;
}

/*
 * Recorrer todas las casas y todas las uniones del simcity y de sus uniones
 * O(#(casas()) + #(comercios()))
 */
void SimCity::avanzarTurno() {
    for (auto casa : _casas) {
        casa->aumentarAntiguedad();
    }

    for (auto comercio : _comercios) {
        comercio->aumentarAntiguedad();
    }

    for (auto u : _uniones) {
        u->avanzarTurno();
    }

    _turnoActual++;
    _huboConstruccion = false;
}

// O(1)
void SimCity::unir(SimCity* s) {
    _uniones.insert(_uniones.end(), s);
    _huboConstruccion |= s->_huboConstruccion;
    _popularidad += s->popularidad() + 1;
    _turnoActual = _turnoActual > s->_turnoActual ? _turnoActual : s->_turnoActual;
}

/*
 * Es el costo de unir el mapa por cada union al mapa del simCity
 * O(#(_uniones) * unirMapa)
 */
Mapa SimCity::mapa() const {
    Mapa res;

    res.unirMapa(_rios);
    for (auto u : _uniones) {
        res.unirMapa(u->mapa());
    }

    return res;
}

// O(aplanarCasas())
set<Casilla> SimCity::casas() const {
    set<Casilla> res;

    for (auto casa : _aplanarCasas()) {
        res.insert(res.end(), casa->getCasilla());
    }

    return res;
}

/*
 * Es el costo de recorrer todas las casas de nuestro simCity y de sus uniones
 * O(#(_casas) + #(_uniones)*#(casas_por_union))
 */
set<Construccion*> SimCity::_aplanarCasas() const {
    set<Construccion*> res;

    for (auto casa : _casas) {
        res.insert(res.end(), casa);
    }

    for (auto u : _uniones) {
        for (auto casaUnion : u->_aplanarCasas()) { // TODO: preguntar
            bool esta = false;
            for (auto casa : res) {
                if (casa->getCasilla() == casaUnion->getCasilla()) {
                    esta = true;
                    if (casaUnion->getAntiguedad() > casa->getAntiguedad()) {
                        casa->setAntiguedad(casaUnion->getAntiguedad()); // Si en una union, la antiguedad es mayor.
                    }

                }
            }
            if (!esta) {
                res.insert(res.end(), casaUnion);
            }
        }
    }

    return res;
}

// O(aplanarComercios() * aplanarCasas())
set<Casilla> SimCity::comercios() const {
    set<Casilla> res;

    for (auto comercio : _aplanarComercios()) {
        bool checkeado = false;

        for (auto casa : _aplanarCasas()) {
            if (comercio->getCasilla() == casa->getCasilla()) {
                checkeado = true;
            }
        }

        if (!checkeado) res.insert(res.end(), comercio->getCasilla());
    }

    return res;
}

/*
 * Es el costo de recorrer todas los comercios de nuestro simCity y de sus uniones
 * O(#(_comercios) + #(_uniones) * #(comercios_por_union))
 */
set<Construccion*> SimCity::_aplanarComercios() const {
    set<Construccion*> res;

    for (auto comercio : _comercios) {
        res.insert(res.end(), comercio);
    }

    for (auto u : _uniones) {
        for (auto comercioUnion : u->_aplanarComercios()) {
            bool esta = false;
            for (auto comercio : res) {
                if (comercio->getCasilla() == comercioUnion->getCasilla()) {
                    esta = true;
                    if (comercioUnion->getAntiguedad() > comercio->getAntiguedad()) {
                        comercio->setAntiguedad(comercioUnion->getAntiguedad()); // Si en una union, la antiguedad es mayor.
                    }

                }
            }
            if (!esta) {
                res.insert(res.end(), comercioUnion);
            }
        }
    }

    return res;
}

/*
 * O(2 * aplanarCasas() + aplanarComercios())
 * O(aplanarCasas() + aplanarComercios())
 */
Nat SimCity::nivel(Casilla c) const {
    for (auto casa : _aplanarCasas()) {
        if (casa->getCasilla() == c) {
            return casa->getAntiguedad();
        }
    }

    Nat res = 0;
    for (auto comercio : _aplanarComercios()) {
        if (comercio->getCasilla() == c) {
            if (res < comercio->getAntiguedad()) res = comercio->getAntiguedad();

            for (auto casa : _aplanarCasas()) {
                if (
                        _distanciaManhattan(casa->getCasilla(), comercio->getCasilla()) <= 3 &&
                        _distanciaManhattan(casa->getCasilla(), comercio->getCasilla()) > 0 &&
                        casa->getAntiguedad() > comercio->getAntiguedad() &&
                        res < casa->getAntiguedad()
                        ) {
                    res = casa->getAntiguedad();
                }
            }
        }
    }

    return res;
}

// O(1)
bool SimCity::huboConstruccion() const {
    return _huboConstruccion;
}

// O(1)
Nat SimCity::popularidad() const {
    return _popularidad;
}

// O(1)
Nat SimCity::antiguedad() const {
    return _turnoActual;
}

// O(1)
int SimCity::_distanciaManhattan(Casilla c1, Casilla c2) const {
    return (abs(c1.first - c2.first) + abs(c1.second - c2.second));
}

SimCity::~SimCity() {
    _borrarRecursivo();
}

/*
 * Borra todos los datos de un simCity que se hayan usado malloc o new()
 * En nuestro caso son todos los objetos de tipo Construccion y los SimCity de las uniones
 * Va a ser recursivamente ya que por cada union se va a llamar a su destructor.
 */
void SimCity::_borrarRecursivo() {
    for (auto casa : _casas) delete casa;
    for (auto comercio : _comercios) delete comercio;
    for (auto u : _uniones) delete u;
}
