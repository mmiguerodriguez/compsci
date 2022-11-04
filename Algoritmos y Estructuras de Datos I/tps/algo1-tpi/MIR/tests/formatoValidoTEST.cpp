#include "../solucion.h"
#include "../auxiliares.h"
#include "gtest/gtest.h"

using namespace std;

TEST(formatoValidoTEST, longitudErronea){
    audio a = {1,2,3,4,5};
    int canal = 3;
    int profundidad = 4;

    EXPECT_FALSE(formatoValido(a, canal, profundidad));
}

TEST(formatoValidoTEST, profundidadErronea){
    audio a = {1,2,3,8};
    int canal = 1;
    int profundidad = 3;
    bool b = formatoValido(a, canal, profundidad);
    EXPECT_FALSE(b);
}

TEST(formatoValidoTEST, profundidadLimite){
    audio a = {1,2,-8,7};
    int canal = 1;
    int profundidad = 4;
    bool b = formatoValido(a, canal, profundidad);
    EXPECT_TRUE(b);
}


TEST(formatoValidoTEST, audioVacio){
    audio a = {};
    int canal = 1;
    int profundidad = 1;
    bool b = formatoValido(a, canal, profundidad);
    EXPECT_FALSE(b);
}

TEST(formatoValidoTEST, audioCorrecto){
    audio a = {1,-2,3,-4,5,6};
    int canal = 2;
    int profundidad = 4;
    bool b = formatoValido(a, canal, profundidad);
    EXPECT_TRUE(b);
}
