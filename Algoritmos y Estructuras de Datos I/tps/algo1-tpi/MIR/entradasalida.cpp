#include "entradasalida.h"
#include "definiciones.h"
#include <fstream>

using namespace std;

void escribirAudio(audio a, int canal, string nombreArchivo) {
    ofstream fout;
    fout.open(nombreArchivo);

    fout << canal;
    for (int i = 0; i < a.size(); i++) {
        fout << " " << a[i];
    }

    fout.close();
}

tuple<int, audio> leerAudio(string nombreArchivo) {
    ifstream fin;
    fin.open(nombreArchivo);

    int canal;
    fin >> canal;

    audio a;
    while (!fin.eof()) {
        int e;
        fin >> e;

        a.push_back(e);
    }

    fin.close();

    tuple<int, audio> res = {canal, a};
    return res;
}

