#include <iostream>
#include <fstream>
#include <map>
#include <assert.h>
#include "Clases/Partida.h"
#include "Clases/Torneo.h"

using namespace std;
void executeWithStandardInput(string algoritmo);
void executeWithExtraArgs(string algoritmo, int argc, char *argv[]);
vector<double> solveRatings(Torneo &t, string algoritmo);

/**
 * Ejecutar el programa con el primer argumento siendo el algoritmo que se quiere ejecutar.
 * Estos pueden ser 0, 1 o 2.
 *
 * Como opcional, se le puede pasar el path a un archivo con el input para el programa.
 */
int main(int argc, char *argv[]) {

    // Leemos el parametro que indica el algoritmo a ejecutar.
    map<string, string> algoritmos_implementados = {
            {"0","CMM"},
            {"1","WP"},
            {"2","Custom"}
    };

    // Verificar que el algoritmo pedido exista.
    if (argc < 2 || algoritmos_implementados.find(argv[1]) == algoritmos_implementados.end()) {
        cerr << "Algoritmo no encontrado: " << argv[1] << endl;
        cerr << "Los algoritmos existentes son: " << endl;
        for (auto &alg_desc: algoritmos_implementados)
            cerr << "\t- " << alg_desc.first << ": " << alg_desc.second << endl;
        return 0;
    }
    string algoritmo = argv[1];

    if (argc >= 3) {
        executeWithExtraArgs(algoritmo, argc, argv);
    } else {
        executeWithStandardInput(algoritmo);
    }

    return 0;
}

void executeWithStandardInput(string algoritmo) {
    int t, p;
    // Leemos el input.
    cin >> t >> p;
    vector<Partida> partidas;

    for (int k = 0; k < p; ++k) {
        int fecha, id1, goles1, id2, goles2;
        cin >> fecha>> id1 >> goles1 >> id2 >> goles2;
        partidas.emplace_back(Partida(fecha,id1,goles1,id2,goles2));
    }

    Torneo torneo(partidas,t);

    vector<double> sol = solveRatings(torneo,algoritmo);
    cout.precision(17);
    for(int i = 0; i < sol.size() - 1; i++){
        cout << sol[i] << endl;
    }
    cout << sol[sol.size() - 1];
}

void executeWithExtraArgs(string algoritmo, int argc, char *argv[]) {
    string fileName = argv[2];


    int t, p;
    // Leemos el input.
    ifstream fin;
    fin.open(fileName, ifstream::in);
    assert(!fin.fail());

    fin >> t >> p;
    vector<Partida> partidas;

    for (int k = 0; k < p; ++k) {
        int fecha, id1, goles1, id2, goles2;
        fin >> fecha>> id1 >> goles1 >> id2 >> goles2;
        partidas.emplace_back(Partida(fecha,id1,goles1,id2,goles2));
    }

    fin.close();

    Torneo torneo(partidas,t);
    vector<double> sol = solveRatings(torneo,algoritmo);

    if (argc >= 4){
        string outputName = argv[3];
        ofstream fout;
        fout.open(outputName);
        fout.precision(17);
        vector<double> sol = solveRatings(torneo,algoritmo);
        for(int i = 0; i < sol.size() - 1; i++){
            fout << sol[i] << endl;
        }
        fout << sol[sol.size() - 1];
        fout.close();
    } else {
        cout.precision(17);
        vector<double> sol = solveRatings(torneo,algoritmo);
        for(int i = 0; i < sol.size() - 1; i++){
            cout << sol[i] << endl;
        }
        cout << sol[sol.size() - 1];
    }
}

vector<double> solveRatings(Torneo &t, string algoritmo) {
    if (algoritmo == "0") {
        return t.ratingEquiposCMM();
    } else if (algoritmo == "1") {
        return t.ratingEquiposWP();
    } else {
        return t.ratingEquiposCustom();
    }
}
