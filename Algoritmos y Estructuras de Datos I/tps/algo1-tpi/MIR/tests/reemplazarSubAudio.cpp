#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(reemplazarSubAudioTEST, unElementoYPresente) {
    audio a = {1};
    audio a1 = {1};
    audio a2 = {3};
    int profundidad = 5;
    audio esperado = {3};

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}

TEST(reemplazarSubAudioTEST, a1_EnElMedio) {
    audio a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
    audio a1 = {4, 5, 6};
    audio a2 = {2, 3};
    audio esperado = {1, 2, 3, 2, 3, 7, 8, 9, 10, 11};
    int profundidad = 10;

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}

TEST(reemplazarSubAudioTEST, a1_AlPrincipio) {
    audio a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
    audio a1 = {1, 2, 3};
    audio a2 = {18, 23, 12, 22};
    int profundidad = 10;
    audio esperado = {18, 23, 12, 22, 4, 5, 6, 7, 8, 9, 10, 11};

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}

TEST(reemplazarSubAudioTEST, a1_AlFinal){
    audio a = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
    audio a1 = {9, 10, 11};
    audio a2 = {18, 23, 12, 22};
    int profundidad = 10;
    audio esperado = {1, 2, 3, 4, 5, 6, 7, 8, 18, 23, 12, 22};

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}

TEST(reemplazarSubAudioTEST, a1_noAparece){
    audio a = {1, 2, 3, 4, 5, 6, 7};
    audio a1 = {8,9};
    audio a2 = {10,11};
    int profundidad = 10;
    audio esperado = {1, 2, 3, 4, 5, 6, 7};

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}

TEST(reemplazarSubAudioTEST, a1_esIgualA_a){
    audio a = {1, 2, 3, 4, 5, 6, 7};
    audio a1 = {1, 2, 3, 4, 5, 6, 7};
    audio a2 = {10,11};
    int profundidad = 10;
    audio esperado = {10,11};

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}

TEST(reemplazarSubAudioTEST, a1_esIgualA_a2){
    audio a = {1, 2, 3, 4, 5, 6, 7};
    audio a1 = {3, 4, 5};
    audio a2 = {3, 4, 5};
    int profundidad = 10;
    audio esperado = {1, 2, 3, 4, 5, 6, 7};

    reemplazarSubAudio(a, a1, a2, profundidad);

    ASSERT_EQ(a, esperado);
}