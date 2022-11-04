#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(maximosTemporalesTEST, ejemploBasicoTPE) {
    audio a = {31, 25, -1, 3, 1};
    vector<int> tiempos = {3, 2};

    int profundidad = 6;

    vector<int> maximosEsperados = {31, 3, 31, 3, 1};
    vector<pair<int, int>> intervalosEsperados = {{0,2},{3,5},{0,1},{2,3},{4,5}};

    vector<int> maximos = {};
    vector<pair<int, int>> intervalos = {};

    maximosTemporales(a, profundidad, tiempos, maximos, intervalos);

    ASSERT_EQ(maximos, maximosEsperados);
    ASSERT_EQ(intervalos, intervalosEsperados);
}

TEST(maximosTemporalesTEST, tiempoDeLargoN) {
    audio a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    vector<int> tiempos = {10};

    int profundidad = 6;

    vector<int> maximosEsperados = {10};
    vector<pair<int, int>> intervalosEsperados = {{0, 9}};

    vector<int> maximos = {};
    vector<pair<int, int>> intervalos = {};

    maximosTemporales(a, profundidad, tiempos, maximos, intervalos);

    ASSERT_EQ(maximos, maximosEsperados);
    ASSERT_EQ(intervalos, intervalosEsperados);
}

TEST(maximosTemporalesTEST, tiempoDeLargoUno) {
    audio a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    vector<int> tiempos = {1};

    int profundidad = 6;

    vector<int> maximosEsperados = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    vector<pair<int, int>> intervalosEsperados = {{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}, {6, 6}, {7, 7}, {8, 8}, {9, 9}};

    vector<int> maximos = {};
    vector<pair<int, int>> intervalos = {};

    maximosTemporales(a, profundidad, tiempos, maximos, intervalos);

    ASSERT_EQ(maximos, maximosEsperados);
    ASSERT_EQ(intervalos, intervalosEsperados);
}

TEST(maximosTemporalesTEST, tiemposQueSuperanN) {
    audio a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    vector<int> tiempos = {6, 7, 8, 9};

    int profundidad = 6;

    vector<int> maximosEsperados = {6, 10, 7, 10, 8, 10, 9, 10};
    vector<pair<int, int>> intervalosEsperados = {
            {0, 5}, {6, 11},
            {0, 6}, {7, 13},
            {0, 7}, {8, 15},
            {0, 8}, {9, 17}
    };

    vector<int> maximos = {};
    vector<pair<int, int>> intervalos = {};

    maximosTemporales(a, profundidad, tiempos, maximos, intervalos);

    ASSERT_EQ(maximos, maximosEsperados);
    ASSERT_EQ(intervalos, intervalosEsperados);
}
