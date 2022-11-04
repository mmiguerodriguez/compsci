//
// Created by clinux01 on 28/10/19.
//

#include "funciones.h"
#include "auxiliares.h"

// Ejercicio 55
vector<string> ordenarPorFrec(vector<string> s) {
    vector<vector<string>> acum(41, vector<string>(0, ""));

    for (int j = 0; j < s.size(); j++) {
        acum[s[j].length()].push_back(s[j]);
    }

    vector<string> res;
    for (int i = 0; i < acum.size(); i++) {
        for (int j = 0; j < acum[i].size(); j++) {
            res.push_back(acum[i][j]);
        }
    }

    return res;
}

// Ejercicio 56
bool esAnagramaOrdenamiento(string p1, string p2) {
    if (p1.length() != p2.length()) return false;

    string p1_ordenada = "";
    string p2_ordenada = "";

    for (int i = 'a'; i <= 'z'; i++) {
        for (int j = 0; j < p1.length(); j++) {
            if (p1[j] == i) p1_ordenada += i;
        }
        for (int j = 0; j < p2.length(); j++) {
            if (p2[j] == i) p2_ordenada += i;
        }
    }

    for (int i = 0; i < p1.length(); i++) {
        if (p1_ordenada[i] != p2_ordenada[i]) {
            return false;
        }
    }

    return true;
}

bool esAnagramaPrimos(string p1, string p2) {
    if (p1.length() != p2.length()) return false;

    int p1_mult = 1;
    int p2_mult = 1;

    for (int i = 0; i < p1.length(); i++) {
        p1_mult *= letraAPrimo(p1[i]);
    }

    for (int i = 0; i < p2.length(); i++) {
        p2_mult *= letraAPrimo(p2[i]);
    }

    return p1_mult == p2_mult;
}

bool esAnagramaOtroMetodo(string p1, string p2) {
    if (p1.length() != p2.length()) return false;

    vector<int> p1_alf(26, 0);
    vector<int> p2_alf(26, 0);

    for (int i = 0; i < p1.length(); i++) {
        p1_alf[p1[i] - 97]++;
    }

    for (int i = 0; i < p2.length(); i++) {
        p2_alf[p2[i] - 97]++;
    }

    for (int i = 0; i < p1_alf.size(); i++) {
        if (p1_alf[i] != p2_alf[i]) return false;
    }

    return true;
}

// Ejercicio 57
double medianaOrdenamiento(vector<int> a, vector<int> b) {
    vector<int> c;

    for (int i = 0; i < a.size(); i++) c.push_back(a[i]);
    for (int i = 0; i < b.size(); i++) c.push_back(b[i]);

    selectionSort(c);

    return mediana(c);
}

double medianaApareamiento(vector<int> a, vector<int> b) {
    return mediana(merge(a, b));
}

double medianaSinOrdenar(vector<int> a, vector<int> b) {
    int minA = a[0];
    int minB = b[0];

    int maxA = a[a.size() - 1];
    int maxB = a[b.size() - 1];

    int medA = mediana(a);
    int medB = mediana(b);


    if (maxA <= minB) {
        vector<int> c = {maxA, minB};
        return mediana(c);
    }

    if (maxB <= minA) {
        vector<int> c = {minA, maxB};
        return mediana(c);
    }


}

// Ejercicio 58
bool esMenor(string a, string b) {
    int c;

    if (a.size() > b.size()) c = a.size();
    else c = b.size();

    string::size_type sz;
    string versionA = "";
    string versionB = "";

    for (int i = 0; i < c; i++) {
        if (i )
        if ((a[i] >= '0' && a[i] <= '9') || a[i] == '.') {
            versionA += a[i];
        } else {
            /*
            if (versionA.length() > 0) {
                float f = stof(versionA, &sz);
                versionA = "";
            }*/
            // if (a[i] > b[i]) return false;
        }
    }
}

vector<string> natSorted(vector<string>) {

}
