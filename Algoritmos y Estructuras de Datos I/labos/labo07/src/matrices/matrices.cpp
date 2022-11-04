//
// Created by Diego Raffo on 2019-10-05.
//
#include "matrices.h"
#include <string>

//ej38 matrices
vector<vector<float>> temperaturaPromedio(vector<vector<vector<float>>> tensor){
    if (tensor.size() == 0) {
        return {};
    }
    int n = tensor[0].size();
    int m = tensor[0][0].size();
    int cantMediciones = tensor.size();
    vector<vector<float>> promediosPorPunto = vector<vector<float>>(n, vector<float>(m, 0));

    for(int i = 0; i < n; i++){
        for(int j = 0; j < m; j++){
            float acumulado = 0;
            for(int t = 0; t < cantMediciones; t ++){
                acumulado += tensor[t][i][j];
            }
            promediosPorPunto[i][j] = acumulado/cantMediciones;
        }
    }
    return promediosPorPunto;
}

vector<float> temperaturaPromedioZona(vector<vector<vector<float>>> tensor){
    if (tensor.size() == 0) {
        return {};
    }
    int n = tensor[0].size();
    int m = tensor[0][0].size();
    int cantMediciones = tensor.size();
    vector<float> promediosPorZona = {};
    for(int t = 0; t < cantMediciones; t ++){
        float acumulado = 0;
        for(int i = 0; i < n; i++){
            for(int j = 0; j < m; j++){
                acumulado += tensor[t][i][j];
            }
        promediosPorZona.push_back(acumulado/cantMediciones);
        }
    }
    return promediosPorZona;
}


//ej39 Matrices
void elevar(vector<vector<int>> &terreno, int x){
    for(int i = 0; i < terreno.size(); i++){
        for (int j = 0; terreno[i].size(); j++){
            terreno[i][j] += x;
        };
    }
}

vector<int> matricesQueSumanN(vector<vector<int>> matriz, int n){
    vector<int> res = {};

    for (int i = 0; i < matriz.size(); i++) {
        int suma = 0;

        for (int j = 0; j < matriz[i].size(); j++) {
            suma += matriz[i][j];
        }

        if (suma == n) {
            res.push_back(i + 1);
        }
    }

    return res;
}


//SUGERENCIA: Implementar la funcion partes de un conjunto
vector<vector<int>> partes(vector<int> conjunto){
    vector<vector<int>> res = {};
    // IMPLEMENTAR
    return res;
}

bool sumaN(vector<vector<int>> matriz, int i, int j, int n, int suma) {
    bool res = false;
    if (suma == n) {
        return true;
    }

    j = j + 1;
    for (; j < matriz[i].size(); j++) {
        int nuevaSuma = suma + matriz[i][j];
        if (nuevaSuma <= n) {
            res = sumaN(matriz, i, j, n, nuevaSuma);
            if (res) return true;
        }
    }

    return res;
}

vector<int> filasDondeAlgunosSumanN(int n, vector<vector<int>> matriz){
    vector<int> res = {};

    for (int i = 0; i < matriz.size(); i++) {
        for (int j = 0; j < matriz[i].size(); j++) {
            bool suma = false;

            if (matriz[i][j] <= n) {
                suma = sumaN(matriz, i, j, n, matriz[i][j]);

                if (suma) {
                    res.push_back(i + 1);
                    break;
                }
            }
        }
    }

    return res;
}

bool estaEnRangoVertical( int i, int n){
    if (i + 3 < n) {
        return true;
    }

    return false;
}

bool estaEnRangoHorizontal(int j, int m){
    if (j + 3 < m) {
        return true;
    }

    return false;
}

int sopaDeLetras(vector<vector<char>> sopa){
    int n = sopa.size();
    int m = sopa[0].size();

    vector<char> verdaderaSopa = {'s','o','p','a'};

    int cantidad = 0;
    for (int i = 0; i < n; i++){
        for (int j = 0; j < m; j++){
            if (estaEnRangoHorizontal(j, m)) {
                vector<char> v;
                v.push_back(sopa[i][j]);
                v.push_back(sopa[i][j + 1]);
                v.push_back(sopa[i][j + 2]);
                v.push_back(sopa[i][j + 3]);

                if (v == verdaderaSopa) {
                    cantidad++;
                }
            }

            if (estaEnRangoVertical(i, n)) {
                vector<char> v;
                v.push_back(sopa[i][j]);
                v.push_back(sopa[i + 1][j]);
                v.push_back(sopa[i + 2][j]);
                v.push_back(sopa[i + 3][j]);

                if (v == verdaderaSopa) {
                    cantidad++;
                }
            }
        }
    }

    return cantidad;
}

