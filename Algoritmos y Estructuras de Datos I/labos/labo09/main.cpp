#include <iostream>
#include "funciones.h"

int main() {
    vector<string> ejercicio55 = {"hola", "esto", "es", "una", "prueba"};
    vector<string> ejercicio55_ordenado = ordenarPorFrec(ejercicio55);

    string p1 = "adelante";
    string p2 = "etnaleda";
    bool ejercicio56_ordenamiento = esAnagramaOrdenamiento(p1, p2);
    bool ejercicio56_primos = esAnagramaPrimos(p1, p2);
    bool ejercicio56_otroMetodo = esAnagramaOtroMetodo(p1, p2);

    vector<int> a = {1, 3, 5, 7, 9};
    vector<int> b = {2, 4, 6, 8, 10};
    double ejercicio57_ordenamiento = medianaOrdenamiento(a, b);
    double ejercicio57_apareamiento = medianaApareamiento(a, b);
    double ejercicio57_sinOrdenar = medianaSinOrdenar(a, b);

    string v1 = "version-1.9";
    string v2 = "version-1.11";

    esMenor(v1, v2);

    return 0;
}