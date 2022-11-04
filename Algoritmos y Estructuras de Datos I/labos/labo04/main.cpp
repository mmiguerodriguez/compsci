#include <iostream>
#include <vector>
#include "funciones.h"

using namespace std;

int main() {
    vector<int> a{1,2,3,4,5,6};

    cout << "a: ";
    mostrarVector(a);
    cout << endl;

    int m = 2;
    cout << "Divide el " << m << "?: " << (divide(a, m) ? "true" : "false") << endl;
    cout << "Maximo: " << maximo(a) << endl;
    int elem = 5;
    cout << "Pertenece el " << elem << "?: " << (pertenece(elem, a) ? "true" : "false") << endl;

    vector<int> b;
    b = a;
    cout << "sinImpares: ";
    sinImpares(b);
    mostrarVector(b);

    cout << "limpiarDuplicados: ";
    mostrarVector(limpiarDuplicados(a));

    // mostrarVector
    int r = 2;
    cout << "Rotando " << r << " posiciones: ";
    mostrarVector(rotar(a, r));

    // reverso
    cout << "Reverso: " << endl;
    mostrarVector(reverso(a));
    vector<int> rev;
    mostrarVector(reversoRecursivo(a, rev));

    // factoresPrimos
    int n = 10;
    cout << "Factores primos de " << n << ": ";
    mostrarVector(factoresPrimos(n));

    // estaOrdenado
    cout << "estaOrdenado: " << (estaOrdenado(a) ? "true" : "false") << endl;

    // negar
    vector<bool> c{true,false,true,true,false,true};
    cout << "Original: ";
    mostrarVectorBool(c);
    negar(c);
    cout << "Negado: ";
    mostrarVectorBool(c);

    vector<int> d{1,1,2,1,1,2,3,2,3,3};
    cout << "Apariciones en ";
    mostrarVector(d);
    mostrarVectorPares(apariciones(d));

    return 0;
}