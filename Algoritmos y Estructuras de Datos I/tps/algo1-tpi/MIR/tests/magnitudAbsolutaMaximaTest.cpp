#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(magnitudAbsolutaMaximaTEST, unCanal){
    audio a = {1, 2, 3, -2};
    int canal = 1;
    int profundidad = 6;
    audio maximos, posicionesMaximos = {};

    audio maximosEsperados = {3};
    audio posicionesMaximosEsperados = {2};

    magnitudAbsolutaMaxima(a, canal, profundidad, maximos, posicionesMaximos);

    ASSERT_VECTOR(maximos, maximosEsperados);
    ASSERT_VECTOR(posicionesMaximos, posicionesMaximosEsperados);
}

TEST(magnitudAbsolutaMaximaTEST, muchosCanales){
    audio a = {5, 10, 1, -10, 12, -22, 25, 16, 12, 30, 11, -22, 17, -29};
    int canal = 7;
    int profundidad = 6;
    audio maximos, posicionesMaximos = {};

    audio maximosEsperados = {16, 12, 30, 11, -22, -22, -29};
    audio posicionesMaximosEsperados = {7, 8, 9, 10, 11, 5, 13};

    magnitudAbsolutaMaxima(a, canal, profundidad, maximos, posicionesMaximos);

    ASSERT_VECTOR(maximos, maximosEsperados);
    ASSERT_VECTOR(posicionesMaximos, posicionesMaximosEsperados);
}

TEST(magnitudAbsolutaMaximaTEST, maximosAlFinal){
    audio a = {1, -1, 1, 2, -2, 1, 3, -4, 5, 4, -5, 6};
    int canal = 3;
    int profundidad = 6;
    audio maximos, posicionesMaximos = {};

    audio maximosEsperados = {4, -5, 6};
    audio posicionesMaximosEsperados = {9, 10, 11};

    magnitudAbsolutaMaxima(a, canal, profundidad, maximos, posicionesMaximos);

    ASSERT_VECTOR(maximos, maximosEsperados);
    ASSERT_VECTOR(posicionesMaximos, posicionesMaximosEsperados);
}

TEST(magnitudAbsolutaMaximaTEST, canalesIgualesALongitud){
    audio a = {5, 10, 1, -10, 12, -22, 25, 16, 12, 30, 11, -22, 17, -29};
    int canal = 14;
    int profundidad = 6;
    audio maximos, posicionesMaximos = {};

    audio maximosEsperados = {5, 10, 1, -10, 12, -22, 25, 16, 12, 30, 11, -22, 17, -29};
    audio posicionesMaximosEsperados = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};

    magnitudAbsolutaMaxima(a, canal, profundidad, maximos, posicionesMaximos);

    ASSERT_VECTOR(maximos, maximosEsperados);
    ASSERT_VECTOR(posicionesMaximos, posicionesMaximosEsperados);
}

TEST(magnitudAbsolutaMaximaTEST, maximosAlPrincipio){
    audio a = {4, -5, 6, 1, -1, 1, 2, -2, 1, 3, -4, 5};
    int canal = 3;
    int profundidad = 6;
    audio maximos, posicionesMaximos = {};

    audio maximosEsperados = {4, -5, 6};
    audio posicionesMaximosEsperados = {0, 1, 2};

    magnitudAbsolutaMaxima(a, canal, profundidad, maximos, posicionesMaximos);

    ASSERT_VECTOR(maximos, maximosEsperados);
    ASSERT_VECTOR(posicionesMaximos, posicionesMaximosEsperados);
}