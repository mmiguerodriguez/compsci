//
// Created by ryan on 5/9/20.
//

#include "SistemaLineal.hpp"

SistemaLineal::SistemaLineal(vector<vector<double>> matriz, vector<double> independiente) {
    _matriz = matriz;
    _independiente = independiente;
}

vector<vector<double>> SistemaLineal::getMatriz() {
    return _matriz;
}

void SistemaLineal::eliminacionGaussiana() {
    for(int i = 0; i < _matriz.size()-1; i++) {
        for(int j = i+1; j <= _matriz.size()-1; j++) {
            if(_matriz[i][i] != 0) {
                double x = calcularMultiplicador(i, j, i);
                restarFila(j, i, x);
            }
        }
    }
}

double SistemaLineal::calcularMultiplicador(int x, int y, int indice) {
    return _matriz[y][indice]/_matriz[x][indice];
}

void SistemaLineal::restarFila(int fila1, int fila2, double multiplicador) {
    for(int i = 0; i < _matriz[fila1].size(); i++) {
        _matriz[fila1][i] -= _matriz[fila2][i] * multiplicador;
    }
    _independiente[fila1] -= _independiente[fila2] * multiplicador;
}

vector<double> SistemaLineal::getIndependiente() {
    return _independiente;
}

vector<double> SistemaLineal::calcularResultado() {
    this->eliminacionGaussiana();

    int n = _matriz.size();
    vector<double> r(n);

    for (int i = n - 1; i >= 0; i--) {
        r[i] = _independiente[i];
        for (int j = n - 1; j > i; j--) {
            r[i] = r[i] - r[j] * _matriz[i][j];
        }

        if (_matriz[i][i] != 0) {
            r[i] /= _matriz[i][i];
        } else {
            r[i] = 0; // ?
        }
    }

    return r;
}
