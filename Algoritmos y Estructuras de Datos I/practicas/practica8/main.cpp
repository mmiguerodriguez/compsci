#include <iostream>
#include <vector>
#include "ejercicios.h"

using namespace std;

int main() {
    int n = 143;
    int r = ejercicio3(n);
    cout << "Raiz de " << n << " = " << r << endl;

    vector<int> s_a = {0, 0, 0, 1, 1, 0, 1, 0, 1};
    int suma_a = ejercicio4_a(s_a);
    cout << "Suma ejercicio 4a = " << suma_a << endl;

    vector<int> s_b = {0,0,0,0,0,0,0,0};
    int suma_b = ejercicio4_b(s_b);
    cout << "Suma ejercicio 4b = " << suma_b << endl;

    vector<int> a = {0, 0, 2, 2, 3, 1, 0};
    vector<int> b =  ejercicio18(a);

    ejercicio11(a);

    return 0;
}