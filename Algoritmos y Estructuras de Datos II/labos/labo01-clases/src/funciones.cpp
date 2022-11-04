#include <vector>
#include "algobot.h"

using namespace std;

// Ejercicio 1
vector<int> quitar_repetidos(vector<int> s) {
    vector<int> r;
    if (s.size() != 0) r.push_back(s[0]);

    for (int i = 1; i < s.size(); i++) {
        bool found = false;

        for(int j = 0; j < r.size(); j++) {
            if (s[i] == r[j]) found = true;
        }

        if (!found) {
            r.push_back(s[i]);
        }
    }

    return r;
}

// Ejercicio 2
vector<int> quitar_repetidos_v2(vector<int> s) {
    set<int> t;
    for (int n : s) {
        t.insert(n);
    }

    vector<int> r;
    for (int n : t) {
        r.push_back(n);
    }

    return r;
}

// Ejercicio 3
bool mismos_elementos(vector<int> a, vector<int> b) {
    bool r = true;

    for (int n : a) {
        bool found = false;

        for (int m : b) {
            if (n == m) found = true;
        }

        if (!found) r = false;
    }

    return r;
}

// Ejercicio 4
bool mismos_elementos_v2(vector<int> a, vector<int> b) {
    bool r = true;
    set<int> s1;
    set<int> s2;

    for (int n : a) {
        s1.insert(n);
    }

    for (int n : b) {
        s2.insert(n);
    }

    for (int n : s1) {
        if (!s2.count(n)) r = false;
    }

    for (int n : s2) {
        if (!s1.count(n)) r = false;
    }

    return r;
}

// Ejercicio 5
map<int, int> contar_apariciones(vector<int> s) {
    map<int, int> r;

    for (int n : s) {
        r[n]++;
    }

    return r;
}

// Ejercicio 6
vector<int> filtrar_repetidos(vector<int> s) {
    map<int, int> m = contar_apariciones(s);
    vector<int> r;

    for(pair<int, int> p : m) {
        if (p.second == 1) {
            r.push_back(p.first);
        }
    }

    return r;
}

// Ejercicio 7
set<int> interseccion(set<int> a, set<int> b) {
    set<int> r;

    for (int n : a) {
        if (b.count(n)) {
            r.insert(n);
        }
    }

    return r;
}

// Ejercicio 8
map<int, set<int>> agrupar_por_unidades(vector<int> s) {
    map<int, set<int>> r;

    for (int n : s) {
        r[n % 10].insert(n);
    }

    return r;
}

// Ejercicio 9
vector<char> traducir(vector<pair<char, char>> tr, vector<char> str) {
    vector<char> r;

    for(char c : str) {
        bool replaced = false;

        for (pair<char, char> p : tr) {
            if (c == p.first) {
                replaced = true;
                r.push_back(p.second);
            }
        }

        if (!replaced) r.push_back(c);
    }

    return r;
}

// Ejercicio 10
bool interseccion_libretas_vacio(set<LU> a, set<LU> b) {
    set<LU> r;

    for (LU libreta: a) {
        if (b.count(libreta)) {
            r.insert(libreta);
        }
    }

    return r.size() == 0;
}

bool integrantes_repetidos(vector<Mail> s) {
    bool r = false;

    for (Mail m : s) {
        for (Mail n : s) {
            if (!(m.libretas() == n.libretas() || interseccion_libretas_vacio(m.libretas(), n.libretas()))) {
                r = true;
            }
        }
    }

    return r;
}

// Ejercicio 11
map<set<LU>, Mail> entregas_finales(vector<Mail> s) {
    map<set<LU>, Mail> r;

    for (Mail m : s) {
        if (m.adjunto()) {
            if (m.fecha() > r[m.libretas()].fecha()) {
                r[m.libretas()] = m;
            }
        }
    }

    return r;
}
