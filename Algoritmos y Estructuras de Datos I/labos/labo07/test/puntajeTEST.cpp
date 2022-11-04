#include "../src/puntaje/puntaje.h"
#include "gtest.h"

// Escribir tests aca:
TEST(puntajeTEST, MenorQueDiezYMultipoDeTres) {
    int n = 9;
    int puntos = puntaje(n);

    EXPECT_EQ(puntos, 2*9 + 10);
}

TEST(puntajeTEST, MenorQueDiezYNoMultiplodeTres) {
    int n = 8;
    int puntos = puntaje(n);
    EXPECT_EQ(puntos, 2*8 - 10);
}

TEST(puntajeTEST, MayorQueDiezYMultiplodeTres) {
    int n = 12;
    int puntos = puntaje(n);
    EXPECT_EQ(puntos, 12 + 10);
}

TEST(puntajeTEST, MayorQueDiezYNoMultiplodeTres) {
    int n = 11;
    int puntos = puntaje(n);
    EXPECT_EQ(puntos, 11 - 10);
}