//
// Created by ryan on 5/9/20.
//

#ifndef UNTITLED_MATRIZ_HPP
#define UNTITLED_MATRIZ_HPP

#include <vector>
#include<algorithm>
using namespace std;

class SistemaLineal {
public:
    SistemaLineal(vector<vector<double>> matriz, vector<double> independiente);
    vector<vector<double>> getMatriz();
    vector<double> getIndependiente();
    vector<double> calcularResultado();
    void eliminacionGaussiana();

private:
    vector<vector<double>> _matriz;
    vector<double> _independiente;
    double calcularMultiplicador(int x, int y, int indice);
    void restarFila(int j, int i, double multiplicador);
};


#endif //UNTITLED_MATRIZ_HPP
