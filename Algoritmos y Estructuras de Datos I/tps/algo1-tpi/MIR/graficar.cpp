#include "graficar.h"
#include "solucion.h"
#include <fstream>
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */

void graficarRevertirAudio() {
    srand (time(NULL));

    audio a = {};
    int profundidad = 4;

    ofstream fout;
    fout.open("graficos/revertirAudio.txt");
    fout << "n\t" << "tiempo" << endl;

    int s = 1000;

    for (int i = 1; i < 100; i++) {
        int t = s * i;
        audio a(t);
        for (int j = 0; j < t; j++) {
            a[j] = 1;
        }

        int canal = floor(t/2);

        double t0 = clock();
        revertirAudio(a, canal, profundidad);
        double t1 = clock();
        double tiempo = (double(t1-t0)/CLOCKS_PER_SEC);
        fout << t << "\t" << tiempo << endl;
    }

    fout.close();
}

void graficarLimpiarAudio() {
    srand (time(NULL));

    audio a = {};

    int profundidad = 4;
    vector<int> outliers;

    ofstream fout;
    fout.open("graficos/limpiarAudio.txt");
    fout << "n\t" << "tiempo" << endl;

    int s = 1000;

    for (int i = 0; i < 100; i++) {
        int t = s * i;
        audio a(t);
        for (int j = 0; j < t; j++) {
            a[j] = 1;
        }

        double t0 = clock();
        limpiarAudio(a, profundidad, outliers);
        double t1 = clock();
        double tiempo = (double(t1 - t0)/CLOCKS_PER_SEC);
        fout << t << "\t" << tiempo << endl;
    }

    fout.close();
}
