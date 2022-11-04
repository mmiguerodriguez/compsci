#ifndef AED2_SIMCITY_H
#define AED2_SIMCITY_H

#include <iostream>
#include <set>
#include "aed2_Mapa.h"
#include "SimCity.h"

using namespace std;

using SimCity = SimCity; /* Completar con su clase implementada de SimCity */

class aed2_SimCity {
public:
    // Generadores:
    aed2_SimCity(const aed2_SimCity& sc);   // Constructor por copia
    aed2_SimCity(aed2_Mapa m);              // Constructor con mapa
    ~aed2_SimCity();                        // Destructor
    void agregarCasa(Casilla c);            // Precondicion: Se puede construir en la Casilla c
    void agregarComercio(Casilla c);        // Precondicion: Se puede construir en la Casilla c
    void avanzarTurno();                    // Precondicion: Hubo construccion en el turno actual
    void unir(aed2_SimCity sc);             // Precondicion: No se solapan las construcciones con los rios
                                            //  ni las construcciones de nivel maximo de ambas partidas

    // Observadores:
    aed2_Mapa mapa() const;
    set<Casilla> casas() const;
    set<Casilla> comercios() const;
    Nat nivel(Casilla c) const;             // Precondicion: Hay construccion en la Casilla p
    bool huboConstruccion() const;
    Nat popularidad() const;
    Nat antiguedad() const;

    // Conversiones:
    SimCity simCity();  // Esta función sirve para convertir del SimCity de la cátedra al SimCity
                        // implementado por ustedes

private:
    SimCity* _simCity;
};

#endif // AED2_SIMCITY_H
