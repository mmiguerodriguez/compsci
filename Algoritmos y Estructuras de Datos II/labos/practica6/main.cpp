#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <algorithm>

using namespace std;

// Ejercicio 1: Izquierdista
template<class T>
vector<vector<T>> split(vector<T> A) {
    vector<vector<T>> res{vector<T>{}, vector<T>{}};

    for (int i = 0; i < A.size()/2; i++) {
        res[0].push_back(A[i]);
    }

    for (int i = A.size()/2; i < A.size(); i++) {
        res[1].push_back(A[i]);
    }

    return res;
}
bool esIzquierdista(vector<int> A, vector<int> B, int& xd) { // O((n * log_2(n))/2)
    if (A.size() == 1) {
        xd++;
        return A[0] > B[0];
    } else {
        vector<int> suma{0, 0};
        for (int i = 0; i < A.size(); i++) {
            xd++;
            suma[0] += A[i];
            suma[1] += B[i];
        }

        return (
                suma[0] > suma[1] &&
                esIzquierdista(split(A)[0], split(A)[1], xd) &&
                esIzquierdista(split(B)[0], split(B)[1], xd)
        );


    }
}

// Ejercicio 2:
vector<vector<int>> multiplicar(vector<vector<int>> A, vector<vector<int>> B) {
    vector<vector<int>> res;
    vector<vector<int>> temp = {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0}
    };

    for (int i = 0; i < A.size(); i++) {
        for (int j = 0; j < A[i].size(); j++) {
            for (int k = 0; k < A.size(); k++) {
                temp[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    return temp;
}
void ej2(vector<vector<int>> A, int n, vector<vector<vector<int>>>& res, int &xd) {
    if (n == 2) {
        res.push_back(A); // A^1
        res.push_back(multiplicar(A, A)); // A^2
        xd++;
    } else {
        ej2(A, n/2, res, xd);

        vector<vector<int>> ultimoMayor = res[res.size() - 1];
        vector<vector<int>> G = multiplicar(ultimoMayor, ultimoMayor);
        xd++;

        for (int i = 0; i < n/2 - 1; i++) {
            vector<vector<int>> p2 = multiplicar(res[i], ultimoMayor);
            res.push_back(p2);
        }

        res.push_back(G);
    }
}

// Ejercicio 3:
class Arbol {
public:
    Arbol(int valor);
    void agregar(int valor);

    struct Nodo {
        int valor;
        Nodo* izq;
        Nodo* der;

        Nodo(const int& v);
    };

    Nodo* raiz;
private:
};
Arbol::Nodo::Nodo(const int &v) {
    valor = v;
    izq = NULL;
    der = NULL;
}
Arbol::Arbol(int valor) {
    Nodo* n = new Nodo(valor);
    raiz = n;
}
void Arbol::agregar(int valor) {
    Nodo* n = raiz;
    Nodo* i = new Nodo(valor);

    while (n) {
        int value = n->valor;
        if (valor > value) {
            if (!n->der) {
                n->der = i;
                return;
            }
            n = n->der;
        } else {
            if (!n->izq) {
                n->izq = i;
                return;
            }
            n = n->izq;
        }
    }
}
vector<int> ej3(Arbol::Nodo* tree, int i)  { // <valor, distancia a padre>
    if (tree->der && tree->izq) { // dos raices
        vector<int> izq = ej3(tree->izq, 0);
        vector<int> der = ej3(tree->der, 0);


    } else if (tree->der && !tree->izq) { // raiz der

    } else if (!tree->der && tree->izq) { // raiz izq

    } else { // sin hijos // el mas lejano es el padre

    }
}

// Ejercicio 8:
// Suponemos que es O(1)
vector<vector<vector<bool>>> split4D(vector<vector<bool>> M) {
    vector<vector<vector<bool>>> res;

    vector<vector<bool>> peppaPig = {};
    for (int i = 0; i < M.size()/2; i++) {
        vector<bool> miniPeppa = {};
        for (int j = 0; j < M[i].size()/2; j++) {
            miniPeppa.push_back(M[i][j]);
        }
        peppaPig.push_back(miniPeppa);
    }
    res.push_back(peppaPig);

    peppaPig = {};
    for (int i = 0; i < M.size()/2; i++) {
        vector<bool> miniPeppa = {};
        for (int j = M[i].size()/2; j < M[i].size(); j++) {
            miniPeppa.push_back(M[i][j]);
        }
        peppaPig.push_back(miniPeppa);
    }
    res.push_back(peppaPig);

    peppaPig = {};
    for (int i = M.size()/2; i < M.size(); i++) {
        vector<bool> miniPeppa = {};
        for (int j = 0; j < M[i].size()/2; j++) {
            miniPeppa.push_back(M[i][j]);
        }
        peppaPig.push_back(miniPeppa);
    }
    res.push_back(peppaPig);

    peppaPig = {};
    for (int i = M.size()/2; i < M.size(); i++) {
        vector<bool> miniPeppa = {};
        for (int j = M[i].size()/2; j < M[i].size(); j++) {
            miniPeppa.push_back(M[i][j]);
        }
        peppaPig.push_back(miniPeppa);
    }
    res.push_back(peppaPig);

    return res;
}
bool conjuncionSubmatriz(vector<vector<bool>>M, int i0, int i1, int j0, int j1) {
    bool res = true;
    for (int k = i0; k <= i1; k++) {
        for (int l = j0; l <= j1; l++) {
            res &= M[k][l];
        }
    }
    return res;
}
// T(n) = O(1)          si |M| = 1
//      = T(n/4) + O(1) si |M| > 1
//
// c = 4 (particiones del problema)
// a = 1 (subproblemas a resolver)
// => log_c(a) = 0
// O(n^(log_c(a)) * log(n)) si f(n) in O(n^(log_c(a)) => n^(log_c(a)) = n^0 => f(n) in O(1)
// O(log(n)) con n = |M|^2
pair<int, int> ej8(vector<vector<bool>> M) {
    // Caso base
    if (M.size() == 1) {
        return make_pair(0, 0);
    }

    vector<vector<vector<bool>>> cuatroD = split4D(M);

    // Divido en 4
    pair<int, int> res;
    if (!(conjuncionSubmatriz(M, 0, M.size()/2 - 1, 0, M[0].size()/2 - 1))) {
        res = ej8(cuatroD[0]);
        return make_pair(res.first, res.second);
    } else if (!(conjuncionSubmatriz(M, 0, M.size()/2 - 1, M[0].size()/2, M[0].size() - 1))) {
        res = ej8(cuatroD[1]);
        return make_pair(M.size()/2 + res.first, res.second);
    } else if (!(conjuncionSubmatriz(M, M.size()/2, M.size() - 1, 0, M[0].size()/2 - 1))) {
        res = ej8(cuatroD[2]);
        return make_pair(res.first, M[0].size()/2 + res.second);
    } else if (!(conjuncionSubmatriz(M, M.size()/2, M.size() - 1, M[0].size()/2, M[0].size() - 1))) {
        res = ej8(cuatroD[3]);
        return make_pair(M.size()/2 + res.first, M[0].size()/2 + res.second);
    }

}

// Ejercicio 9:
// Calculo de complejidad: maximoDesdeRaiz
// k = 1: tamaño del caso base
// a = 1: cantidad de subproblemas a resolver
// c = 2: cantidad de particiones
// f(n) = O(1): Costo de lo que se hace en cada llamado
// caso base = O(1)
// log_c(a) = 0
//
// Demostracion por Teorema Maestro (TM)
// 1. No vale. f(n) e O(1) y no hay epsilon t.q. O(n^(-e)) tenga sentido
// 2. Vale. f(n) e O(n^0) = O(1) => O(log(n) * n^log_c(a)) = O(log(n) * 1) = O(log(n))
//
// T(n) = O(log(n))
int iesimoMergeAux(vector<int>&A, vector<int>&B, int i, int start, int end) {
    // Caso base
    if (end == start) {
        if (start * 2 >= i) {
            return min(A[start], B[start]);
        } else {
            return max(A[start], B[start]);
        }
    }

    //
    int half = (start + end)/2 + 1;
    int arribaDerecha = A[half];
    int arribaIzq = A[half - 1];
    int abajoDerecha = B[half];
    int abajoIzq = B[half - 1];

    if (arribaDerecha > abajoIzq && arribaIzq < abajoDerecha) {
        if (half * 2 > i) {
            return iesimoMergeAux(A, B, i, start, half - 1);
        } else {
            return iesimoMergeAux(A, B, i, half, end);
        }
    } else {
        // Siguientes 10 lineas son feas. Pero son O(1)!!!
        if (arribaDerecha < abajoIzq) {
            B[half - 1] = arribaDerecha;
            A[half] = abajoIzq;
        }
        if (abajoDerecha < arribaIzq) {
            B[half] = arribaIzq;
            A[half - 1] = abajoDerecha;
        }

        return iesimoMergeAux(A, B, i, start, half - 1);
    }
}

int iesimoMerge(vector<int>&A, vector<int>&B, int i) {
    // A.size() == B.size()
    int max_size = (i > B.size() - 1) ? B.size() - 1 : i;
    return iesimoMergeAux(A, B, i, 0, max_size);
}

// Ejercicio 10:
// n = size(A) = size(B)
// O(log(n)) ?
// T(n) = O(1)      si n = 1
//      = T(n/2)    si n > 1
//
// c = 2 (particiones del problema)
// a = 1 (subproblemas a resolver)
// => log_c(a) = 0
// O(n^(log_c(a)) * log(n)) si f(n) in O(n^(log_c(a)) => n^(log_c(a)) = n^0 => f(n) in O(1)
// O(log(n))
int minDif(vector<int> A, vector<int> B) {
    // Caso base
    // O(1)
    if (A.size() == 1) {
        return abs(A[0] - B[0]);
    }

    // Caso no base
    // T(n/2)
    vector<int> menoresA = split(A)[0];
    vector<int> mayoresA = split(A)[1];
    vector<int> mayoresB = split(B)[0];
    vector<int> menoresB = split(B)[1];

    if (abs(menoresA[menoresA.size() - 1] - mayoresB[0]) < abs(mayoresA[0] - menoresB[menoresB.size() - 1])) {
        return minDif(menoresA, mayoresB);
    } else if (abs(menoresA[menoresA.size() - 1] - mayoresB[0]) > abs(mayoresA[0] - menoresB[menoresB.size() - 1])) {
        return minDif(mayoresA, menoresB);
    } else {
        return min(minDif(menoresA, mayoresB), minDif(mayoresA, menoresB));
    }
}

// Ejercicio 11:
// Suponemos que existe esta funcion y se ejecuta en O(sqrt(j - i + 1))
bool aparece(vector<int> A, int i, int j, int e) {
    for (int k = i; k <= j; k++) {
        if (A[k] == e) return true;
    }
    return false;
}
// T(n) = O(1)                  si |n| <= 1
//      = T(n/2) + O(sqrt(n)) si n > 1
//
// O(log_2(n) * sqrt(n))
int ubicar(vector<int> A, int e) {
    // O(1)
    if (A.size() == 1) {
        if (A[0] == e) {
            return 0;
        }
    }

    vector<vector<int>> B = split(A); // Divido el array en 2 mitades <Mitad1, Mitad2>
    if (aparece(B[0], 0, B[0].size() - 1, e)) { // O(sqrt(n/2 + 1)) = O(sqrt(n/2)) = O(sqrt(n))
        return ubicar(B[0], e); // T(n/2)
    } else if (aparece(B[1], 0, B[1].size() - 1, e)) { // O(sqrt(n/2 + 1)) = O(sqrt(n/2)) = O(sqrt(n))
        return ubicar(B[1], e) + B[0].size(); // T(n/2)
    } else {
        return -1;
    }
}

// Ejercicio 12:
void print(vector<vector<int>> vec) {
    for (int i = 0; i < vec.size(); i++) {
        for (int j = 0; j < vec[i].size(); j++) {
            cout << vec[i][j] << "\t";
        }
        cout << endl;
    }
    cout << endl;
}
void ej12(vector<vector<int>>& vec, int n, int i, int j, pair<int, int> fila, pair<int, int> columna, int& c, int cuadrante) {
    // T(n) = { O(4)               si n^2 <= 4 }
    //      = { 4T(n/4) + O(4)     si n^2 > 4 }
    // O(n) = n (donde n = filas * columnas)

    if (fila.second - fila.first == 2) {
        for (int k = fila.first; k < fila.second; k++) {
            for (int l = columna.first; l < columna.second; l++) {
                if (!(k == i && l == j)) {
                    vec[k][l] = c;
                }
            }
        }
    } else {
        ej12(vec, n, i, j, make_pair(fila.first, (fila.first + fila.second)/2), make_pair(columna.first, (columna.first + columna.second)/2), c, 1);
        ej12(vec, n, i, j, make_pair(fila.first, (fila.first + fila.second)/2), make_pair((columna.first + columna.second)/2, columna.second), c, 2);
        ej12(vec, n, i, j, make_pair((fila.first + fila.second)/2, fila.second), make_pair(columna.first, (columna.first + columna.second)/2), c, 3);
        ej12(vec, n, i, j, make_pair((fila.first + fila.second)/2, fila.second), make_pair((columna.first + columna.second)/2, columna.second), c, 4);

        // Para el medio (arregla todo)
        // Si en mi cuadrante

        //
        int sub = 0;
        for (int k = (fila.first + fila.second)/2 - 1; k < (fila.first + fila.second)/2 + 1; k++) {
            for (int l = (columna.first + columna.second)/2 - 1; l < (columna.first + columna.second)/2 + 1; l++) {
                sub++;
                if (!(k == i && l == j)) {
                    if (cuadrante == 1) {
                        if (i >= fila.first && i < fila.second && j >= columna.first && j < columna.second) {
                            if(sub == 1 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if(sub == 2 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            } else if(sub == 3 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if (sub == 4 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            }
                        } else {
                            if (k != (fila.first + fila.second)/2 || l != (columna.first + columna.second)/2) {
                                vec[k][l] = c;
                            }
                        }
                    } else if (cuadrante == 2) {
                        if (i >= fila.first && i < fila.second && j >= columna.first && j < columna.second) {
                            if(sub == 1 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if(sub == 2 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            } else if(sub == 3 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if (sub == 4 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            }
                        } else {
                            if (k != (fila.first + fila.second)/2 || l != (columna.first + columna.second)/2 - 1) {
                                vec[k][l] = c;
                            }
                        }
                    } else if (cuadrante == 3) {
                        if (i >= fila.first && i < fila.second && j >= columna.first && j < columna.second) {
                            if(sub == 1 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if(sub == 2 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            } else if(sub == 3 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if (sub == 4 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            }
                        } else {
                            if (k != (fila.first + fila.second)/2 - 1|| l != (columna.first + columna.second)/2) {
                                vec[k][l] = c;
                            }
                        }
                    } else if (cuadrante == 4) {
                        if (i >= fila.first && i < fila.second && j >= columna.first && j < columna.second) {
                            if(sub == 1 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if(sub == 2 && !(i >= fila.first && i < (fila.second+fila.first)/2 && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            } else if(sub == 3 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= columna.first && j < (columna.second+columna.first)/2)) {
                                vec[k][l] = c;
                            } else if (sub == 4 && !(i >= (fila.second+fila.first)/2 && i < fila.second && j >= (columna.second+columna.first)/2 && j < columna.second)) {
                                vec[k][l] = c;
                            }
                        } else {
                            if (k != (fila.first + fila.second)/2 - 1 || l != (columna.first + columna.second)/2 - 1) {
                                vec[k][l] = c;
                            }
                        }
                    }
                }
            }
        }
    }

    c++;
}

// Ejercicio maximoSumaCamino
bool comp(int a, int b) { return (a < b); }
// Calculo de complejidad: maximoDesdeRaiz
// k = 1: tamaño del caso base
// a = 2: cantidad de subproblemas a resolver
// c = 2: cantidad de particiones
// f(n) = O(1): Costo de lo que se hace en cada llamado
// caso base = O(1)
// log_c(a) = 1
//
// Demostracion por Teorema Maestro (TM)
// 1. Vale. f(n) e O(1) => existe epsilon > 0 t.q. f(n) e O(n^(1-e))
// ...
// T(n) = O(n)
int maximoDesdeRaiz(Arbol::Nodo* n) {
    if (n == NULL) return 0;

    int res1 = n->valor + maximoDesdeRaiz(n->izq);
    int res2 = n->valor + maximoDesdeRaiz(n->der);

    return max({res1, res2, 0}, comp);
}
// Calculo de complejidad: maximaSumaCamino
// k = 1: tamaño del caso base
// a = 2: cantidad de subproblemas a resolver
// c = 2: cantidad de particiones
// f(n) = O(n): Costo de lo que se hace en cada llamado
// caso base = O(1)
// log_c(a) = 1
//
// Demostracion por Teorema Maestro (TM)
// 1. No vale. Ya que f(n) = O(n^1) => no existe E > 0 t.q. f(n) e O(n^(1-e))
// 2. Vale. f(n) e O(n^1) => T(n) = O(n^1 * log(n))
// 3. ...
// T(n) = O(1)              si |n| = 1
//      = 2 * T(n/2) + O(n) si |n| > 1
//
//      => O(n * log(n))
int maximaSumaCamino(Arbol::Nodo* n) {
    if (n == NULL) return 0; // O(1)

    int res1 = maximaSumaCamino(n->izq); // T(n/2)
    int res2 = maximaSumaCamino(n->der); // T(n/2)
    int res3 = n->valor + maximoDesdeRaiz(n->izq) + maximoDesdeRaiz(n->der); // O(n)

     if (n->izq && n->der) {
         return max({res1, res2, res3}, comp);
     } else if (n->izq && !n->der) {
         return max({res1, res3}, comp);
     } else if (n->der && !n->izq) {
         return max({res2, res3}, comp);
     } else {
         return res3;
     }
}

int main() {
    // Ejercicio 1: Izquierdista
    vector<int> vector_ej1{8, 6, 7, 4, 5, 1, 3, 2, 8, 6, 7, 4, 5, 1, 3, 1, 8, 6, 7, 4, 5, 1, 3, 2, 8, 6, 7, 4, 5, 1, 3, 0};
    int contador_ej1 = 0;
    bool res = esIzquierdista(split(vector_ej1)[0], split(vector_ej1)[1], contador_ej1);

    // Ejercicio 2:
    int n_ej2 = 128;
    int contador_ej2 = 0;
    vector<vector<vector<int>>> vector_res_ej2;
    vector<vector<int>> vector_ej2 = {
            {1, 2, 3, 4},
            {1, 2, 3, 4},
            {1, 2, 3, 4},
            {1, 2, 3, 4}
    };
    ej2(vector_ej2, n_ej2, vector_res_ej2, contador_ej2);

    // Ejercicio 3:
    Arbol* tree = new Arbol(10);
    tree->agregar(8);
    tree->agregar(15);
    tree->agregar(16);
    tree->agregar(17);
    tree->agregar(18);
    tree->agregar(14);
    tree->agregar(13);
    tree->agregar(12);
    tree->agregar(11);

    //vector<int> res_ej3 = ej3(tree->raiz, 0);

    // Ejercicio 9:
    vector<int> vec_ej9_A{1,2,5,6,15};
    vector<int> vec_ej9_B{3,4,7,8,18};
    int index_ej9 = 0;
    vector<int> vec_res_ej9;
    for(int i = 0;i < vec_ej9_B.size() * 2; i++) {
        vec_res_ej9.push_back(iesimoMerge(vec_ej9_A, vec_ej9_B, i));
    }

    // Ejercicio 8:
    vector<vector<bool>> vec_ej8 {
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, true},
            {true, true, true, true, true, true, true, false},
    };
    pair<int, int> res_ej8 = ej8(vec_ej8);

    // Ejercicio 10:
    vector<int> vecA_ej10 {1,2,3,4,5};
    vector<int> vecB_ej10 {6,5,4,3,2};
    int res_ej10 = minDif(vecA_ej10, vecB_ej10);

    // Ejercicio 11:
    vector<int> vec_ej11;
    for(int i = 0; i < 1048576; i++) {
        vec_ej11.push_back(i);
    }
    int res_ej11 = ubicar(vec_ej11, 1048575);

    // Ejercicio 12:
    int n = 8;
    vector<vector<int>> vec(n, vector<int>(n, -1));
    int i = 3;
    int j = 1;
    int c = 1;
    vec[i][j] = 0;
    ej12(vec, n, i, j, make_pair(0, n), make_pair(0, n), c, 1);

    // Ejercicio aparte
    vector<int> arbol_test{10,9,1,2,3,4,5,6,7,8,15,12,11,13,14,16};
    Arbol* arbol_ej = new Arbol(arbol_test[0]);
    for (int i = 1; i < arbol_test.size(); i++) arbol_ej->agregar(arbol_test[i]);
    int res_2 = maximaSumaCamino(arbol_ej->raiz);

    return 0;
}