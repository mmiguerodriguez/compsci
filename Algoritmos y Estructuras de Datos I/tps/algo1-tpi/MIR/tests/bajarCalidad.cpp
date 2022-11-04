#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(bajarCalidadTEST, listaVacia) {
    vector<audio> as = {};
    int profundidad1 = 4;
    int profundidad2 = 2;
    vector<audio> esperado = {};

    bajarCalidad(as, profundidad1, profundidad2);
    ASSERT_MATRIX(as, esperado);
}

TEST(bajarCalidadTEST, listaConCincoAudios) {
    vector<audio> as = {
            {-16, 10, 15, -4, 8, 0},
            {-15, 9, 14, -3, 7, 1},
            {-14, 8, 13, -2, 6, 5},
            {12, -13, 2, 3, 7, 9},
            {8, 10, -10, -9, -8, -7}
    };
    int profundidad1 = 4;
    int profundidad2 = 2;
    vector<audio> esperado = {
            {-4, 2, 3, -1, 2, 0},
            {-4, 2, 3, -1, 1, 0},
            {-4, 2, 3, -1, 1, 1},
            {3, -4, 0, 0, 1, 2},
            {2, 2, -3, -3, -2, -2}
    };

    bajarCalidad(as, profundidad1, profundidad2);
    ASSERT_MATRIX(as, esperado);
}

TEST(bajarCalidadTEST, listaUnica) {
    vector<audio> as = {{12, 4, 5, -10, 20, 25, -2, -4, -6, -15}};
    int profundidad1 = 5;
    int profundidad2 = 3;
    vector<audio> esperado = {{3, 1, 1, -3, 5, 6, -1, -1, -2, -4}};

    bajarCalidad(as, profundidad1, profundidad2);
    ASSERT_MATRIX(as, esperado);
}
