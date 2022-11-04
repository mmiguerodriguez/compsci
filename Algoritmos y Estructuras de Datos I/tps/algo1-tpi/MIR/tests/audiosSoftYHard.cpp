#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(audiosSoftYHardTEST, listaVacia){
    vector<audio> as = {};
    int profundidad = 8;
    int longitud = 2;
    int umbral = 2;
    vector<audio> soft = {};
    vector<audio> hard = {};

    vector<audio> esperadoSoft = {};
    vector<audio> esperadoHard = {};

    audiosSoftYHard(as, profundidad, longitud, umbral, soft, hard);

    ASSERT_MATRIX(soft, esperadoSoft);
    ASSERT_MATRIX(hard, esperadoHard);
}

TEST(audiosSoftYHardTEST, listaConDosHardYDosSoftIntercalados) {
    vector<audio> as = {
            {3, 3, 3, 1},
            {1, -1, -1, 0},
            {1, 3, 3, 3},
            {2, 2, 2, 2}
    };
    int profundidad = 8;
    int longitud = 2;
    int umbral = 2;
    vector<audio> soft = {};
    vector<audio> hard = {};

    vector<audio> esperadoSoft = {{1, -1, -1, 0}, {2, 2, 2, 2}};
    vector<audio> esperadoHard = {{3, 3, 3, 1}, {1, 3, 3, 3}};

    audiosSoftYHard(as, profundidad, longitud, umbral, soft, hard);

    ASSERT_MATRIX(soft, esperadoSoft);
    ASSERT_MATRIX(hard, esperadoHard);
}

TEST(audiosSoftYHardTEST, listaConTodosHard) {
    vector<audio> as = {
            {3, 3, 3, 1, 1},
            {1, 3, 3, 3, 1},
            {1, 1, 3, 3, 3},
            {10, 10, 5, 10, 10}
    };
    int profundidad = 8;
    int longitud = 2;
    int umbral = 2;
    vector<audio> soft = {};
    vector<audio> hard = {};

    vector<audio> esperadoSoft = {};
    vector<audio> esperadoHard = {{3, 3, 3, 1, 1}, {1, 3, 3, 3, 1}, {1, 1, 3, 3, 3}, {10, 10, 5, 10, 10}};

    audiosSoftYHard(as, profundidad, longitud, umbral, soft, hard);

    ASSERT_MATRIX(soft, esperadoSoft);
    ASSERT_MATRIX(hard, esperadoHard);
}

TEST(audiosSoftYHardTEST, listaConTodosSoft) {
    vector<audio> as = {
            {10, 10, 1, 1, 1},
            {-3, -3, 10, 10, -7},
            {-5, -5, -5, 1, 5},
            {2, 2, 2, 5, 5}
    };
    int profundidad = 8;
    int longitud = 2;
    int umbral = 2;
    vector<audio> soft = {};
    vector<audio> hard = {};

    vector<audio> esperadoSoft = {{10, 10, 1, 1, 1}, {-3, -3, 10, 10, -7}, {-5, -5, -5, 1, 5}, {2, 2, 2, 5, 5}};
    vector<audio> esperadoHard = {};

    audiosSoftYHard(as, profundidad, longitud, umbral, soft, hard);

    ASSERT_MATRIX(soft, esperadoSoft);
    ASSERT_MATRIX(hard, esperadoHard);
}

TEST(audiosSoftYHardTEST, listaConSoftEnBordes) {
    vector<audio> as = {
            {7, 7, 6, 7, 7},
            {8, 6, 7, 6, 8}
    };
    int profundidad = 8;
    int longitud = 2;
    int umbral = 6;
    vector<audio> soft = {};
    vector<audio> hard = {};

    vector<audio> esperadoSoft = {{7, 7, 6, 7, 7}, {8, 6, 7, 6, 8}};
    vector<audio> esperadoHard = {};

    audiosSoftYHard(as, profundidad, longitud, umbral, soft, hard);

    ASSERT_MATRIX(soft, esperadoSoft);
    ASSERT_MATRIX(hard, esperadoHard);
}

TEST(audiosSoftYHardTEST, ejemploBasicoTPE) {
    vector<audio> as = {
            {10, 12, 5, 9, 35},
            {12, 15, 11, 13, 10, 1, 10},
            {10, 12, 5, 9},
            {-5, 2, 10, 12, 3, 4}
    };
    int profundidad = 8;
    int longitud = 4;
    int umbral = 5;
    vector<audio> soft = {};
    vector<audio> hard = {};

    vector<audio> esperadoSoft = {{10, 12, 5, 9, 35}, {10, 12, 5, 9}, {-5, 2, 10, 12, 3, 4}};
    vector<audio> esperadoHard = {{12, 15, 11, 13, 10, 1, 10}};

    audiosSoftYHard(as, profundidad, longitud, umbral, soft, hard);

    ASSERT_MATRIX(soft, esperadoSoft);
    ASSERT_MATRIX(hard, esperadoHard);
}