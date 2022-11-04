//
// Created by clinux01 on 09/09/19.
//

#include "funciones.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;

bool divide(vector<int> v, int n) {
    bool result = true;

    for (int i = 0; i < v.size(); i++) {
        if (v[i] % n != 0) {
            result = false;
        }
    }

    return result;
}

int maximo(vector<int> v) {
    int max = v[0];

    for (int i = 0; i < v.size(); i++) {
        if (v[i] > max) {
            max = v[i];
        }
    }

    return max;
}

bool pertenece(int elem, vector<int> v) {
    bool result = false;

    for (int i = 0; i < v.size(); i++) {
        if (v[i] == elem) {
            result = true;
        }
    }

    return result;
}

void mostrarVector(vector<int> v) {
    cout << "[";
    int i = 0;

    while (i < v.size()) {
        cout << v[i];
        i++;
        if (i != v.size()) {
            cout << ", ";
        }
    }

    cout << "]" << endl;
}

void mostrarVectorBool(vector<bool> v) {
    cout << "[";
    int i = 0;

    while (i < v.size()) {
        cout << (v[i] ? "true" : "false");
        i++;
        if (i != v.size()) {
            cout << ", ";
        }
    }

    cout << "]" << endl;
}

void mostrarVectorPares(vector<pair<int,int>> v) {
    cout << "[";
    int i = 0;

    while (i < v.size()) {
        cout << "(" << v[i].first << ", " << v[i].second << ")";
        i++;
        if (i != v.size()) {
            cout << ", ";
        }
    }

    cout << "]" << endl;
}

void sinImpares(vector<int>& v) {
    for (int i = 0; i < v.size(); i++) {
        if (v[i] % 2 == 1) {
            v[i] = 0;
        }
    }
}

vector<int> limpiarDuplicados(vector<int> v) {
    vector<int> result;

    for (int i = 0; i < v.size(); i++) {
        if (!pertenece(v[i], result)) {
            result.push_back(v[i]);
        }
    }

    return result;
}

vector<int> rotar(vector<int> v, int k) {
    k = k % v.size();
    // suponemos k != 0
    vector<int> result(v.size());

    for (int i = 0; i < v.size(); i++) {
        if (i - k < 0) {
            result[v.size() - k + i] = v[i];
        } else {
            result[i - k] = v[i];
        }
    }

    return result;
}

vector<int> reverso(vector<int> v) {
    vector<int> result(v.size());

    for (int i = 0; i < v.size(); i++) {
        result[v.size() - i - 1] = v[i];
    }

    return result;
}

vector<int> reversoRecursivo(vector<int> v, vector<int> rev) {
    rev.push_back(v[v.size() - 1]);
    v.pop_back();

    if (v.size() > 0) {
        return reversoRecursivo(v, rev);
    } else {
        return rev;
    }
}

vector<int> factoresPrimos(int n) {
    vector<int> result;

    int i = 2;
    while (n != 1) {
        if (n % i == 0) {
            if (!pertenece(i, result)) {
                result.push_back(i);
            }
            n /= i;
            i = 2;
        } else {
            i++;
        }
    }

    if (result.size() == 0) {
        result.push_back(n);
    }

    return result;
}

bool estaOrdenado(vector<int> v) {
    // true: creciente, false: decreciente
    bool result = true;

    for (int i = 0; i < v.size() - 1; i++) {
        if (v[i] > v[i + 1]) {
            result = false;
        }
    }

    return result;
}

void negar(vector<bool>& v) {
    for (int i = 0; i < v.size(); i++) {
        v[i] = !v[i];
    }
}

vector<pair<int, int>> apariciones(vector<int> v) {
    vector<pair<int, int>> p;
    vector<int> vistos;

    for (int i = 0; i < v.size(); i++) {
        if (!pertenece(v[i], vistos)) {
            pair<int, int> t;
            t.first = v[i];
            t.second = aparicionesEnVector(v, v[i]);

            p.push_back(t);
            vistos.push_back(v[i]);
        }
    }

    return p;
}

int aparicionesEnVector(vector<int> v, int n) {
    int a = 0;

    for (int i = 0; i < v.size(); i++) {
        if (v[i] == n) {
            a++;
        }
    }

    return a;
}
