//
// Created by clinux01 on 09/09/19.
//
#include <string>
#include <vector>
using namespace std;

#ifndef LABO04_FUNCIONES_H
#define LABO04_FUNCIONES_H

bool divide(vector<int> v, int n);
int maximo(vector<int> v);
bool pertenece(int elem, vector<int> v);
void mostrarVector(vector<int> v);
void mostrarVectorBool(vector<bool> v);
void sinImpares(vector<int>& v);
vector<int> limpiarDuplicados(vector<int> v);
vector<int> rotar(vector<int> v, int k);
vector<int> reverso(vector<int> v);
vector<int> reversoRecursivo(vector<int> v, vector<int> rev);
vector<int> factoresPrimos(int n);
bool estaOrdenado(vector<int> v);
void negar(vector<bool>& v);
vector<pair<int, int> > apariciones(vector<int> v);
int aparicionesEnVector(vector<int> v, int n);
void mostrarVectorPares(vector<pair<int,int>> v);
#endif //LABO04_FUNCIONES_H
