#include <iostream>
#include <vector>
#include <string>
#include "funciones.h"
#include <chrono>
using namespace std;


int main() {
    vector<vector<int>> v = {{1,2,3,4},{5,6,7,8},{9,10,11,12}};
    imprimirMatriz(v);

    vector<vector<int>> a = {{1,2,3},{4,5,6},{7,8,9}};
    vector<vector<int>> b = {{1,2,3},{4,5,6},{7,8,9}};
    int dot = dotProduct(a, b);

    imprimirMatriz(redimensionar(v, 6, 2));

    vector<vector<int>> traspuesta = {{1,2,3},{4,5,6}};
    imprimirMatriz(trasponer(traspuesta));

    int picos = contarPicos(a);
    cout << "Cantidad de picos: " << picos << endl;

    vector<vector<int>> conCeros = {{0,0,0,1},{0,0,1,2},{0,0,0,0},{0,10,0,0}};
    vector<tuple<int, int, int>> tripla = aTriplas(conCeros);

    vector<vector<int>> s = {{5,10,-1,8,40},{10,17,-1,4,8},{-2,1,5,7,6},{4,3,2,8,15},{21,-1,-32,12,4}};
    int mts = 0;
    bool sobresale = sobresalen(s, 10, mts);
    cout << "Sobresale: " << (sobresale == true ? "SI" : "NO") << ", Metros: " << mts << endl;

    tuple<int, int> valle = buscarValleIterativo(s, 0, 3);
    cout << "Posicion del Valle: (" << get<0>(valle) << "," << get<1>(valle) << ")" << endl;

    imprimirMatriz(s);

    vector<vector<int>> terreno = {{-1,-1,1,-1,1},{1,-1,1,1,-1},{1,1,-1,-1,1},{-1,-1,-1,-1,-1}};
    int cIslas = islas(terreno);
    cout << "Cantidad de Islas: " << cIslas << endl;

    vector<vector<char>> partida = {
            {'X','O','O'},
            {'X','O','O'},
            {'X','X','X'}
    };
    string resultado = tateti(partida);
    cout << "Resultado partida: " << resultado << endl;

    vector<vector<char>> tablero = {
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
    };

    vector<vector<char>> tableroT = {
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', 'r'},
            {' ', ' ', 'r', ' '},
            {' ', ' ', ' ', ' '},
    };

    cout << reinasEnAmenaza(tableroT) << endl;

    auto start = chrono::high_resolution_clock::now();
    cout << "NReinas: " << NReinas(8) << endl;
    auto finish = chrono::high_resolution_clock::now();
    chrono::duration<double> elapsed = finish - start;

    cout << "Elapsed time: " << elapsed.count() << " s\n";
    return 0;
}