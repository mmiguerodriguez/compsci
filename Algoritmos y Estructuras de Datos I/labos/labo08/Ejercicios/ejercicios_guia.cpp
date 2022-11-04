//
// Created by clinux01 on 21/10/19.
//

#include "ejercicios_guia.h"
#include "ejercicios.h"

void ejercicio49() {
    ofstream fout;
    double t0, t1, tiempo;

    fout.open("ej49.txt");
    fout << "n\t" << "tiempo" << endl;

    int n = 100;

    for (int i = 0 ; i < 100; i++) {
        vector<int> v = construir_vector(i * n, "asc");
        t0 = clock();
        bool hayDup = hayDuplicados(v);
        t1 = clock();
        tiempo = (double(t1-t0)/CLOCKS_PER_SEC);

        fout << i * n << "\t" << tiempo << endl;
    }

    fout.close();
}

void ejercicio50() {
    ofstream fout;
    double t0, t1, tiempo;

    fout.open("ej50.txt");
    fout << "n\t" << "tiempo" << endl;

    int n = 500;

    for (int i = 0; i <= 20; i++) {
        vector<int> v = construir_vector(i * n, "azar");
        t0 = clock();
        bool hayDup = hayDuplicados(v);
        t1 = clock();
        tiempo = (double(t1-t0)/CLOCKS_PER_SEC);

        fout << i * n << "\t" << tiempo << endl;
    }

    fout.close();
}

void ejercicio53() {
    ofstream fout;
    double t0, t1, tiempo;
    int lim = 1000;

    vector<int> v = {};

    fout.open("vector.size.txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        v.size();
        t1 = clock();
        tiempo = (double(t1 - t0) / CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    fout.open("vector.push_back.txt");
    fout << "n\t" << "tiempo" << endl;
    int e = 10;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        v.push_back(e);
        t1 = clock();
        tiempo = (double(t1-t0)/CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    fout.open("vector.pop_back.txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        v.pop_back();
        t1 = clock();
        tiempo = (double(t1-t0)/CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    int n = 10000;
    for (int i = 0; i <= n; i++) {
        v.push_back(i);
    }

    fout.open("vector[0].txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        int a = v[0];
        t1 = clock();
        tiempo = (double(t1 - t0) / CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    fout.open("vector[n].txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        int a = v[n];
        t1 = clock();
        tiempo = (double(t1 - t0) / CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    fout.open("vector[0].set(e).txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        v[0] = e;
        t1 = clock();
        tiempo = (double(t1 - t0) / CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    fout.open("vector[i].set(e).txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        t0 = clock();
        v[i] = e;
        t1 = clock();
        tiempo = (double(t1 - t0) / CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

    fout.open("vector.flip.txt");
    fout << "n\t" << "tiempo" << endl;
    for (int i = 0; i < lim; i++) {
        vector<bool> vb(100, false);
        t0 = clock();
        vb.flip();
        t1 = clock();
        tiempo = (double(t1 - t0) / CLOCKS_PER_SEC);
        fout  << "i\t" << tiempo << endl;
    }
    fout.close();

}

void ejercicio54() {
    ofstream fout;
    double t0, t1, tiempo;

    fout.open("ej54.txt");
    fout << "n\t" << "tiempo" << endl;

    int n = 1;
    int e = 1e10;

    for (int i = 0 ; i < 100; i++) {
        vector<int> v = construir_vector(i * n, "asc");
        t0 = clock();
        bool algunoSuma = algunSubconjSuma(v, e);
        t1 = clock();
        tiempo = (double(t1-t0)/CLOCKS_PER_SEC);

        fout << i * n << "\t" << tiempo << endl;
    }

    fout.close();
}
