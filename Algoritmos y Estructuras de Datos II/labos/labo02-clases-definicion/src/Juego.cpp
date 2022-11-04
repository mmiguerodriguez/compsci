#include <utility>
#include <vector>

using namespace std;

// Ejercicio 15

// Juego

using Pos = pair<int, int>;

char ARRIBA = '^';
char ABAJO = 'v'; 
char DERECHA = '<';
char IZQUIERDA = '>';

class Juego {
public:
    Juego(uint casilleros, Pos pos_inicial);
    Pos posicion_jugador();
    uint turno_actual();
    void mover_jugador(char dir);
    void ingerir_pocion(uint movimientos, uint turnos);

private:
    pair<int, int> pos_;
    uint casilleros_;
    uint turno_;
    vector<pair<int, int>> pociones_;
    uint movimientos_gratis_;

    void limpiar_pociones();
    void usar_pociones_disponibles();
};

Juego::Juego(uint casilleros, Pos pos_inicial): casilleros_(casilleros), pos_(pos_inicial), turno_(0), movimientos_gratis_(0) {}

Pos Juego::posicion_jugador() {
    return pos_;
}

uint Juego::turno_actual() {
    return turno_;
}

void Juego::ingerir_pocion(uint movimientos, uint turnos) {
    pociones_.push_back(make_pair(movimientos, turnos));
}

void Juego::mover_jugador(char dir) {
    if (dir == ARRIBA && pos_.first == 0) return;
    if (dir == ABAJO && pos_.first == casilleros_ - 1) return;

    if (dir == IZQUIERDA && pos_.second == 0) return;
    if (dir == DERECHA && pos_.second == casilleros_ - 1) return;

    if (dir == ARRIBA) pos_.first -= 1;
    else if (dir == ABAJO) pos_.first += 1;
    else if (dir == IZQUIERDA) pos_.second -= 1;
    else if (dir == DERECHA) pos_.second += 1;

    if (movimientos_gratis_ == 0) {
        usar_pociones_disponibles();
    }

    if (movimientos_gratis_ != 0) {
        movimientos_gratis_--;
    }

    if (movimientos_gratis_ == 0) {
        turno_++;
    }

    limpiar_pociones();
}

void Juego::limpiar_pociones() {
    for (int i = 0; i < pociones_.size(); i++) {
        if (pociones_[i].second == 0) {
            pociones_.erase(pociones_.begin() + i);
        }
    }
}

void Juego::usar_pociones_disponibles() {
    uint movimientos_gratis = 0;

    for (int i = 0; i < pociones_.size(); i++) {
        movimientos_gratis += pociones_[i].first;
        pociones_[i].second -= 1;
    }

    movimientos_gratis_ = movimientos_gratis;
}