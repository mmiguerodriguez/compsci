#include <iostream>

using namespace std;

// Ejercicio 1

class Rectangulo {
    public:
        Rectangulo(uint alto, uint ancho);
        uint alto();
        uint ancho();
        float area();

    private:
        int alto_;
        int ancho_;

};

Rectangulo::Rectangulo(uint alto, uint ancho) {
    alto_ = alto;
    ancho_ = ancho;
}

uint Rectangulo::alto() {
    return alto_;
}

uint Rectangulo::ancho() {
    return ancho_;
}

float Rectangulo::area() {
    return ancho_ * alto_;
}

// Ejercicio 2

const float PI = 3.14;

class Elipse {
    public:
        Elipse(uint a, uint b);
        uint r_a();
        uint r_b();
        float area();

    private:
        uint r_a_;
        uint r_b_;
};

Elipse::Elipse(uint a, uint b) {
    r_a_ = a;
    r_b_ = b;
}

uint Elipse::r_a() {
    return r_a_;
}

uint Elipse::r_b() {
    return r_b_;
}

float Elipse::area() {
    return PI * r_a_ * r_b_;
}

// Ejercicio 3

class Cuadrado {
    public:
        Cuadrado(uint lado);
        uint lado();
        float area();

    private:
        Rectangulo r_;
};

Cuadrado::Cuadrado(uint lado): r_(lado, lado) {}

uint Cuadrado::lado() {
    return r_.alto();
}

float Cuadrado::area() {
    return r_.area();
}

// Ejercicio 4

// Clase Circulo
class Circulo {
    public:
        Circulo(uint radio);
        uint radio();
        float area();
    private:
        uint radio_;
};

Circulo::Circulo(uint radio):  radio_(radio) {}

uint Circulo::radio() {
    return radio_;
}

float Circulo::area() {
    return PI * radio_ * radio_;
}

// Ejercicio 5

ostream& operator<<(ostream& os, Rectangulo r) {
    os << "Rect(" << r.alto() << ", " << r.ancho() << ")";
    return os;
}

// ostream Elipse

ostream& operator<<(ostream& os, Elipse e) {
    os << "Elipse(" << e.r_a() << ", " << e.r_b() << ")";
    return os;
}


// Ejercicio 6

ostream& operator<<(ostream& os, Cuadrado c) {
    os << "Cuad(" << c.lado() << ")";
    return os;
}


ostream& operator<<(ostream& os, Circulo c) {
    os << "Circ(" << c.radio() << ")";
    return os;
}

