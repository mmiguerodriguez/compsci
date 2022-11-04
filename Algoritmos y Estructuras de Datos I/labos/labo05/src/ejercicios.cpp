#include <iostream>
#include "ejercicios.h"
#include <math.h>

using namespace std;

/************* Ejercicio 1 *************/
bool estaOrdenadoAsc(vector<int> v){
    int i=0;
    int longitud = v.size();
    bool esMenor = true;
    while(i<=longitud-2 && esMenor){
        esMenor = v[i]<=v[i+1];
        i++;
    }
    return i==longitud-1;
}

bool estaOrdenadoDesc(vector<int> v){
    int longitud = v.size();
    int i=0;
    bool esMayor = true;
    while(i<=longitud-2 && esMayor){
        esMayor = v[i]>=v[i+1];
        i++;
    }

    return i==longitud-1;
}
bool estaOrdenado(vector<int> v){
    int longitud = v.size();
    if (longitud==0 || longitud==1)
        return true;
    else
        return estaOrdenadoDesc(v) || estaOrdenadoAsc(v);
}

/************* Ejercicio 2 *************/
bool pertenece(int elemento, vector<int> v){
    int longitud = v.size();
    if(longitud==0)
        return false;
    else {
        int i=0;
        bool sigo = true;
        while((i<longitud) && sigo){
            sigo = v[i]!=elemento;
            i++;
        }
        return i<longitud || !sigo;
    }
}

/************* Ejercicio 3 *************/
long fibonacci(int k){
    if(k==0)
        return 0;
    else if(k==1)
        return 1;
    else{
        long i=0;
        long j=1;
        long m = 0;
        int nesimo;
        for(nesimo=1; nesimo<k; nesimo++){
            m = j;
            j = i+j;
            i = m;
        }
        return j;
    }
}

/************* Ejercicio 4 *************/

int sumaDoble(vector<int> s){
    // Pc = { i = 0 ∧ res = 0 }
    // Qc = { res = \sum_{k=0}^{|s| - 1} (if (s[k] mod 2 = 0 && s[k] >= 0) then (s[k] * 2) else 0 fi }
    // I := { 0 ≤ i ≤ |s| &&_L res = \sum_{k=0}^{i - 1} (if (s[k] mod 2 = 0 && s[k] >= 0) then (s[k] * 2) else 0 fi }

    int res = 0;
    int i = 0;
    while(i < s.size()){
        if(s[i] >= 0 && s[i] % 2 == 0 )
            res = res + (s[i]*2);
        i++;
    }
    return res;
}


/************* Ejercicio 5 *************/

int todosImpares(vector<int> s){
    // Pc = { res = true ∧ i = |s| - 1}
    // Qc = { res = true ↔ (∀k:Z)(0 ≤ k < |s| →L s[k] mod 2 = 1) }
    // I := { -1 ≤ i < |s| ∧L res = true ↔ (∀k:Z)(i < k < |s| →L s[k] mod 2 = 1) }

    bool res = true;
    int i = s.size() - 1;
    while(i >= 0) {
        res = res && (s[i] % 2 == 1);
        i--;
    }
    return res;
}


/************* >=Ejercicio 6 *************/
bool existePico(vector<int> s){
    // Pc = { i = 1 ∧ res = false }
    // Qc = { res = true ↔ (∃k:Z)(1 ≤ k < (|s| - 1) ∧L (s[k] > s[k − 1] ∧ s[k] > s[k + 1])) }
    // I := { 1 ≤ i < |s| ∧L res = true ↔ (∃k:Z)(1 ≤ k < i ∧L (s[k] > s[k − 1] ∧ s[k] > s[k + 1])) }

    // B = { i < |s| - 1 }
    // !B = { i >= |s| - 1 } => i = |s| - 1

    // (I ∧ !B) => Qc
    // (1 ≤ i < |s| ∧L res = true ↔ (∃k:Z)(1 ≤ k < i ∧L (s[k] > s[k − 1] ∧ s[k] > s[k + 1])) ∧ i >= |s| - 1) => Qc
    // i = |s| - 1 ∧L res = true ↔ (∃k:Z)(1 ≤ k < (|s| - 1) ∧L (s[k] > s[k − 1] ∧ s[k] > s[k + 1])) => Qc? si :)
    int i = 1;
    bool res = false;
    while(i < s.size() - 1){
        res = res || (s[i] > s[i-1] && s[i] > s[i+1]);
        i++;
    }

    return res;
}


/************* Ejercicio 7 *************/
int indiceMinimoSubsec(vector<int> v, int i, int j){
    int res = i;

    for (; i <= j; i++) {
        if (v[i] < v[res]) {
            res = i;
        }
    }

    return res;
}


/************* Ejercicio 8 *************/
int sumatoria(vector<int> v) {
    int res = 0;

    if (v.size() % 2 != 1) return 0;
    if (v.size() == 0) return 0;

    res = v[v.size()/2];

    for (int i = 1; i < v.size() / 2 + 1; i++) {
        res += v[v.size() / 2 - i] + v[v.size() / 2 + i];
    }

    return res;
}


/************* Ejercicio 9 *************/

void ordenar(vector<int>& v){
    for (int i = 0; i < v.size(); i++) {
        int min = indiceMinimoSubsec(v, i, v.size() - 1);
        int aux = v[i];
        v[i] = v[min];
        v[min] = aux;
    }
}