#include <algorithm>
#include <gtest/gtest.h>
#include <math.h>
#include "auxiliares.h"
#include <tuple>

// Auxiliares dados
bool vectoresOrdenadosIguales(vector<int> vector1, vector<int> vector2) {
    if(vector1.size() != vector2.size())
        return false;

    for (int i = 0; i < vector1.size(); ++i)
        if (vector1[i] != vector2[i]){return false;}

    return true;
}
bool matricesIguales(vector<vector<int> > mat1, vector<vector<int> > mat2) {
    if(mat1.size() != mat2.size())
        return false;

    for (int i = 0; i < mat1.size(); ++i) {
        sort(mat1[i].begin(), mat1[i].end());
        sort(mat2[i].begin(), mat2[i].end());
    }

    bool res;

    for (int i = 0; i < mat1.size(); ++i){
        res = false;
        for (int j = 0; j < mat2.size(); ++j) {
            if (vectoresOrdenadosIguales(mat1[i], mat2[j])) {
                res = true;
                break;
            }
        }
        if(!res)
            return false;
    }

    return true;
}
void ASSERT_VECTOR(vector<int> vector1, vector<int> vector2) {
    sort(vector1.begin(), vector1.end());
    sort(vector2.begin(), vector2.end());

    ASSERT_TRUE(vectoresOrdenadosIguales(vector1, vector2));
}
void ASSERT_MATRIX(vector<audio> mat1, vector<audio> mat2) {
    ASSERT_TRUE(matricesIguales(mat1, mat2));
}

// formatoValido
bool todosEnRango(vector<int> &s, int p) {
    for(int i = 0; i < s.size(); i++){
        if (s[i] < -pow(2, p - 1) || s[i] > (pow(2, p - 1) - 1)) {
            return false;
        }
    }

    return true;
}

// revertirAudio
void bloqueRevertido(audio& a, int i, int canal, audio& res) {
    for (int j = 0; j < canal; j++) {
        res[a.size() - canal * (i + 1) + j] = a[canal * i + j];
    }
}

// redirigir
int clip(int v1, int v2, int p) {
    int resta = v1 - v2;
    int p1 = -pow(2, p - 1);
    int p2 = pow(2, p - 1) - 1;

    if (p1 <= resta && resta <= p2) {
        return resta;
    } else if (resta < p1) {
        return p1;
    } else {
        return p2;
    }
}
bool estaEnCanal(int posicion, int canal, int canales) {
    return posicion % canales == canal - 1;
}

// reemplazarSubAudio
bool iguales(audio &a, audio &a1, int d, int h) {
    int j = 0;

    if (h < a.size()) {
        while(d <= h && j < a1.size()) {
            if(a[d] != a1[j]) {
                return false;
            }
            d++;
            j++;
        }

        return true;
    } else {
        return false;
    }
}
void reemplazar(audio &a, audio &a2, int d, int h) {
    audio res;
    int i = 0;

    while(i < d) {
        res.push_back(a[i]);
        i++;
    }

    i = 0;

    while (i < a2.size()) {
        res.push_back(a2[i]);
        i++;
    }

    h++;
    while(h < a.size()) {
        res.push_back(a[h]);
        h++;
    }

    a = res;
}

// limpiarAudio
audio ordenar(audio a){
    for(int i = 0; i < a.size(); i++){
        int minPos = findMinPos(a, i, a.size());
        swap(a, i, minPos);
    }
    return a;
}
int findMinPos(audio &s, int d, int h) {
    int min = d;
    for(int i = d+1; i < h; i++){
        if(s[i] < s[min]){
            min = i;
        }
    }
    return min;
}
void swap(audio& s, int i, int minPos) {
    int aux = s[i];
    s[i] = s[minPos];
    s[minPos] = aux;
}
bool esOutlier(audio &ord, int a) {
    int largo = ord.size();
    int umbral = ord[(floor(0.95 * largo))];
    if(a > umbral){
        return true;
    }
    return false;
}
tuple<bool, int> posNoOutIzq(audio a, vector<int> &o, int d) {
    tuple<bool, int> res;
    while(d >= 0){
        if(!(esOutlier(o, a[d]))){
            get<0>(res) = true;
            get<1>(res) = d;
            return res;
        }
        d--;
    }
    get<0>(res) = false;
    get<1>(res) = d;
    return res;
}
tuple<bool, int> posNoOutDer(audio a, vector<int> &o, int d) {
    tuple<bool, int> res;
    while(d < a.size()){
        if(!(esOutlier(o, a[d]))){
            get<0>(res) = true;
            get<1>(res) = d;
            return res;
        }
        d++;
    }
    get<0>(res) = false;
    get<1>(res) = d;
    return res;
}

