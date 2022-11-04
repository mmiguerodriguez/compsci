#include "solucion.h"
#include "auxiliares.h"
#include <algorithm>
#include <fstream>
using namespace std;


bool formatoValido(audio &a, int canal, int profundidad){
    return a.size() > 0 && (a.size() % canal) == 0 && todosEnRango(a, profundidad);
}

audio replicar(audio a, int canal, int profundidad) {
    audio res;

    for (int i = 0; i < a.size(); i++) {
        for (int j = 1; j <= canal; j++) {
            res.push_back(a[i]);
        }
    }

    return res;
}

audio revertirAudio(audio a, int canal, int profundidad) {
    audio res(a.size());

    for (int i = 0; i < a.size()/canal; i++) {
        bloqueRevertido(a, i, canal, res);
    }

    return res;
}

void magnitudAbsolutaMaxima(audio a, int canal, int profundidad, vector<int> &maximos, vector<int> &posicionesMaximos) {
    for (int i = 0; i < canal; i++) {
        int maximo = a[i];
        int posMaximo = i;

        for (int j = 1; j < a.size()/canal; j++) {
            int posActual = canal * j + i;
            int actual = a[posActual];

            if (abs(actual) > abs(maximo)) {
                maximo = actual;
                posMaximo = posActual;
            }
        }

        maximos.push_back(maximo);
        posicionesMaximos.push_back(posMaximo);
    }
}

audio redirigir(audio a, int canal, int profundidad) {
    audio result(a.size(), 0);

    for (int i = 0; i < a.size(); i++) {
        if (canal == 1 && estaEnCanal(i, 2, 2)) {
            result[i] = clip(a[i], a[i - 1], profundidad);
        } else if (canal == 2 && estaEnCanal(i, 1, 2)) {
            result[i] = clip(a[i + 1], a[i], profundidad);
        } else {
            result[i] = a[i];
        }
    }

    return result;
}

void bajarCalidad(vector<audio> & as, int profundidad1, int profundidad2) {
    for (int i = 0; i < as.size(); i++) {
        for (int j = 0; j < as[i].size(); j++) {
            as[i][j] = floor(as[i][j]/pow(2, profundidad1 - profundidad2));
        }
    }
}

void audiosSoftYHard(vector<audio> as, int profundidad, int longitud, int umbral, vector<audio>& soft, vector<audio>& hard) {
    for (int i = 0; i < as.size(); i++) {
        int longitudParcial = 0;

        for (int j = 0; j < as[i].size(); j++) {
            if (as[i][j] > umbral) {
                longitudParcial++;

                if (longitudParcial > longitud) {
                    hard.push_back(as[i]);
                    break;
                }
            } else {
                longitudParcial = 0;
            }
        }

        // Si termino de iterar y longitudParcial > longitud => seguro hice push a hard
        // caso contrario, pusheo a soft la lista
        if (longitudParcial <= longitud) {
            soft.push_back(as[i]);
        }
    }
}

void reemplazarSubAudio(audio& a, audio a1, audio a2, int profundidad) {
    int hasta = a1.size() - 1;

    for (int i = 0; i < a.size(); i++) {
        if (iguales(a, a1, i, i + hasta)) {
            reemplazar(a, a2, i, i + hasta);
        }
    }
}

void maximosTemporales(audio a, int profundidad, vector<int> tiempos, vector<int>& maximos, vector<pair<int,int>> &intervalos) {
    for (int i = 0; i < tiempos.size(); i++) {
        int intervalo0 = 0;
        int intervalo1 = 0;
        int maximo = a[0];

        for (int j = 0; j < a.size(); j++) {
            if (a[j] > maximo) {
                maximo = a[j];
            }

            if ((j + 1) % tiempos[i] == 0) { // no quedan mas tiempos (en este intervalo)
                intervalo0 = j - tiempos[i] + 1;
                intervalo1 = j;

                pair<int, int> intervalo = {intervalo0, intervalo1};

                maximos.push_back(maximo);
                intervalos.push_back(intervalo);

                if (j + 1 < a.size()) {
                    maximo = a[j + 1];
                }
            } else {
                if (j + 1 == a.size()) {
                    intervalo0 = j - (j % tiempos[i]);
                    intervalo1 = j + (tiempos[i] - (j % tiempos[i])) - 1;

                    pair<int, int> intervalo = {intervalo0, intervalo1};

                    maximos.push_back(maximo);
                    intervalos.push_back(intervalo);
                }
            }
        }
    }
}

void limpiarAudio(audio &a, int profundidad, vector<int> &outliers) {
    vector<int> ordenado = ordenar(a);
    audio copia_a = a;

    for(int i = 0; i < a.size(); i++) {
        if(esOutlier(ordenado, a[i])) {
            outliers.push_back(i);
        }
    }

    for(int i = 0; i < outliers.size(); i++) {
        tuple<bool, int> aIzquierda = posNoOutIzq(copia_a, ordenado, outliers[i]);
        tuple<bool, int> aDerecha = posNoOutDer(copia_a, ordenado, outliers[i]);

        if (get<0>(aIzquierda) && get<0>(aDerecha)) {
            int izq = get<1>(aIzquierda);
            int der = get<1>(aDerecha);
            a[outliers[i]] = floor((a[izq] + a[der]) / 2);
        }

        if (get<0>(aIzquierda) && !(get<0>(aDerecha))) {
            int izq = get<1>(aIzquierda);
            a[outliers[i]] = a[izq];
        }

        if (!(get<0>(aIzquierda)) && get<0>(aDerecha)) {
            int der = get<1>(aDerecha);
            a[outliers[i]] = a[der];
        }
    }
}
