#include "aed2_SimCity.h"

/*
 * Constructor por copia
 * Usa el constructor por copia de SimCity
 */
aed2_SimCity::aed2_SimCity(const aed2_SimCity& sc) {
    _simCity = new SimCity(sc._simCity);
}

aed2_SimCity::aed2_SimCity(aed2_Mapa m) {
    _simCity = new SimCity(m.mapa());
}

void aed2_SimCity::agregarCasa(Casilla c) {
    _simCity->agregarCasa(c);
}

void aed2_SimCity::agregarComercio(Casilla c) {
    _simCity->agregarComercio(c);
}

void aed2_SimCity::avanzarTurno() {
    _simCity->avanzarTurno();
}

/*
 * Generamos una copia del parametro pasado por copia (ya que este va a ser destruido
 * y eso produce que su SimCity* _simCity tambien sea destruido.
 */
void aed2_SimCity::unir(aed2_SimCity sc) {
    SimCity* n = new SimCity(sc._simCity);
    _simCity->unir(n);
}

aed2_Mapa aed2_SimCity::mapa() const {
    return aed2_Mapa(_simCity->mapa());
}

set<Casilla> aed2_SimCity::casas() const {
    return _simCity->casas();
}

set<Casilla> aed2_SimCity::comercios() const {
    return _simCity->comercios();
}

Nat aed2_SimCity::nivel(Casilla c) const {
    return _simCity->nivel(c);
}

bool aed2_SimCity::huboConstruccion() const {
    return _simCity->huboConstruccion();
}

Nat aed2_SimCity::popularidad() const {
    return _simCity->popularidad();
}

Nat aed2_SimCity::antiguedad() const {
    return _simCity->antiguedad();
}

// Sin uso
SimCity aed2_SimCity::simCity() {
    return *_simCity;
}

// Llama al destructor de SimCity
aed2_SimCity::~aed2_SimCity() {
    delete _simCity;
}
