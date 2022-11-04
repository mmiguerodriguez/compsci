#include "ejercicios.h"
#include <math.h>

void swap(vector<int>& a, int i, int j) {
    int aux = a[i];
    a[i] = a[j];
    a[j] = aux;
}

int ejercicio3(int n) {
    int izq = 0;                            // O(1)
    int der = n;                            // O(1)
    int m = izq + (der - izq) / 2;          // O(1)

    int i = 0;
    while (izq + 1 < der) {                 // O(sqrt(n)) ?
        i++;
        if (pow(m, 2) > n) {
            der = m;
            m = (izq + m) / 2;
        } else if (pow(m, 2) < n) {
            izq = m;
            m = (der + m) / 2;
        } else {
            return m;
        }
    }

    return m;
}

int ejercicio4_a(vector<int> s) {
    int sum = 0;

    for (int i = 0; i < s.size(); i++) {
        sum += s[i];
    }

    return sum;
}

int ejercicio4_b(vector<int> s) {
    int izq = 0;
    int der = s.size();
    int mid = izq + (der - izq) / 2;

    while (izq + 1 < der) {
        if(s[mid] == 0) {
            izq = mid;
        } else {
            der = mid;
        }

        mid = izq + (der - izq) / 2;
    }

    if (izq == 0 && s[izq] == 1) {
        return s.size();
    }

    return s.size() - (izq + 1);
}

vector<int> ejercicio18(vector<int> a) {
    vector<int> res;

    for (int i = 0; i < a.size(); i++) {
        for (int j = 0; j < a[i]; j++) {
            res.push_back(i);
        }
    }

    return res;
}

vector<int> ejercicio11(vector<int>& a) {
    int i = 0;
    int j;

    while (i < a.size() - 1) {
        j = 0;
        while (j < a.size() - 1) {
            if (a[j] > a[j + 1]) {
                swap(a, j, j + 1);
            }
            j++;
        }
        i++;
    }

    return a;
}

