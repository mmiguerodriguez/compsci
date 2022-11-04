#include <iostream>
#include <vector>
#include <tuple>
#include <string>
using namespace std;

#ifndef LABO05_FUNCIONES_H
#define LABO05_FUNCIONES_H

void imprimirMatriz(vector<vector<int>> v);
void imprimirMatriz(vector<vector<char>> v);

int dotProduct(vector<vector<int>> a, vector<vector<int>> b);
vector<vector<int>> multiplicarPorTraspuesta(vector<vector<int>> a);

vector<vector<int>> redimensionar(vector<vector<int>> v, int n, int m);

vector<vector<int>> trasponer(vector<vector<int>> m);

int contarPicos(vector<vector<int>> m);

vector<tuple<int, int, int>> aTriplas(vector<vector<int> > m);
vector<vector<int>> aMatriz(vector<tuple<int, int, int>> m, int x, int y);
void transponerDispersa(vector<tuple<int, int, int>>& m);

// opcionales
vector<vector<int>> promedioPorZona(vector<vector<vector<int>>> v);
vector<int> promedioPorTiempo(vector<vector<vector<int>>> v);

void elevar(vector<vector<int>> &terreno, int x);
bool sobresalen(vector<vector<int>> terreno, int n, int& mts);
int islas(vector<vector<int>> terreno);

tuple<int, int> buscarValleIterativo(vector<vector<int>> terreno, int i, int j);

string tateti(vector<vector<char>> partida);

bool reinasEnAmenaza(vector<vector<char>>& tablero);
bool NReinas(int n);

#endif //LABO05_FUNCIONES_H
