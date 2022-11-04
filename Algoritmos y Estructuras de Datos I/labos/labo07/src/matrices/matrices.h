//
// Created by Diego Raffo on 2019-10-05.
//

#ifndef MI_PROYECTO_MATRICES_H
#define MI_PROYECTO_MATRICES_H

#endif //MI_PROYECTO_MATRICES_H

#include <vector>
using namespace std;

void trasponer(vector<vector<int> > &m);

vector<vector<float>> temperaturaPromedio(vector<vector<vector<float>>> tensor);
vector<float> temperaturaPromedioZona(vector<vector<vector<float>>> tensor);
void elevar(vector<vector<int>> &terreno, int x);
vector<int> matricesQueSumanN(vector<vector<int>> matriz, int n);
vector<int> filasDondeAlgunosSumanN(int n, vector<vector<int>> matriz);

int sopaDeLetras(vector<vector<char>> sopa);