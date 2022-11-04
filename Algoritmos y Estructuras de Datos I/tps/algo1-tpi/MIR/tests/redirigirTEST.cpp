#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(redirigirTEST, canal1EnRango){
    audio a = {1, 2, 3, -5, -2, -10};
    int canal = 1;
    int profundidad = 6;
    audio esperado = {1, 1, 3, -8, -2, -8};

    ASSERT_EQ(redirigir(a, canal, profundidad), esperado);
}

TEST(redirigirTEST, canal1FueraDeRango){
    audio a = {31, -5, 27, -10, -30, 4};
    int canal = 1;
    int profundidad = 6;
    audio esperado = {31, -32, 27, -32, -30, 31};

    ASSERT_EQ(redirigir(a, canal, profundidad), esperado);
}

TEST(redirigirTEST, canal2EnRangoYFueraDeRango){
    audio a = {10, 15, 13, -10, 15, -20, -21, 21, 12, -15};
    int canal = 2;
    int profundidad = 6;
    audio esperado = {5, 15, -23, -10, -32, -20, 31, 21, -27, -15};

    ASSERT_EQ(redirigir(a, canal, profundidad), esperado);
}