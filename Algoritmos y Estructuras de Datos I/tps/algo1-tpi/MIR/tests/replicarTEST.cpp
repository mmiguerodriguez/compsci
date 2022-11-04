#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(replicarTEST, unCanal){
    audio a = {1, 2, 3, -5, -2, -10, 0};
    int canal = 1;
    int profundidad = 6;

    audio esperado = {1, 2, 3, -5, -2, -10, 0};

    ASSERT_EQ(replicar(a, canal, profundidad), esperado);
}

TEST(replicarTEST, dosCanales){
    audio a = {1, 2, 3, -5, -2, -10, 0};
    int canal = 2;
    int profundidad = 6;

    audio esperado = {1, 1, 2, 2, 3, 3, -5, -5, -2, -2, -10, -10, 0, 0};

    ASSERT_EQ(replicar(a, canal, profundidad), esperado);
}

TEST(replicarTEST, variosCanales){
    audio a = {1,2,-3,4,5};
    int canal = 3;
    int profundidad = 3;
    audio esperado = {1,1,1,2,2,2,-3,-3,-3,4,4,4,5,5,5};

    ASSERT_EQ(replicar(a, canal, profundidad), esperado);
}
