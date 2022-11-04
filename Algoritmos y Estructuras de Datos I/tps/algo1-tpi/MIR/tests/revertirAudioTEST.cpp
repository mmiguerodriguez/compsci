#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(revertirAudioValidoTEST, unCanal){
    audio a = {1, 2, 3, -5, -2, -10, 0};
    int canal = 1;
    int profundidad = 6;
    audio esperado = {0, -10, -2, -5, 3, 2, 1};

    ASSERT_EQ(revertirAudio(a, canal, profundidad), esperado);
}

TEST(revertirAudioValidoTEST, variosCanales){
    audio a = {1,2,3,-5,10,-3,9,14};
    int canal = 2;
    int profundidad = 5;
    audio esperado = {9,14,10,-3,3,-5,1,2};

    ASSERT_EQ(revertirAudio(a, canal, profundidad), esperado);
}

TEST(revertirAudioValidoTEST, unElemento){
    audio a = {1};
    int canal = 1;
    int profundidad = 2;
    audio esperado = {1};

    ASSERT_EQ(revertirAudio(a, canal, profundidad), esperado);
}

TEST(revertirAudioValidoTEST, revertirCanalesMitadLongitudAudio){
    audio a = {1, 2, 3, -5, -2, -10, 0, 7, 10, -6, 4, 5};
    int canal = 6;
    int profundidad = 6;
    audio esperado = {0, 7, 10, -6, 4, 5, 1, 2, 3, -5, -2, -10};

    ASSERT_EQ(revertirAudio(a, canal, profundidad), esperado);
}

TEST(revertirAudioValidoTEST, revertirCanalesIgualLongitudAudio){
    audio a = {1, 2, 3, -5, -2, -10, 0};
    int canal = 7;
    int profundidad = 6;
    audio esperado = {1, 2, 3, -5, -2, -10, 0};

    ASSERT_EQ(revertirAudio(a, canal, profundidad), esperado);
}
