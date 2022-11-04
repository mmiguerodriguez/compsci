#include "../src/matrices/matrices.h"
#include "gtest.h"

TEST(MatricesQueSumanNTEST, matrizVaciaDevuelveVacio){
    // Descomentar cuando este implementado
    vector<vector<int>> matrizVacia = {};
    vector<int> vectorVacio = {};
    EXPECT_EQ(matricesQueSumanN(matrizVacia,10), vectorVacio);
}

TEST(MatricesQueSumanNTEST, matrizQueNoSumaNDevuelveVacio){
    // Descomentar cuando este implementado
    vector<vector<int>> matrizQueNoSumaCinco = {
            {1,2,3,4},
            {1,1,1,1},
            {0,0,0,0}
    };
    vector<int> vectorVacio = {};
    EXPECT_EQ(matricesQueSumanN(matrizQueNoSumaCinco,5), vectorVacio);
}

TEST(MatricesQueSumanNTEST, matrizQueSumaEnLaSegundaFilaDevuelveDos){
    // Descomentar cuando este implementado
    vector<vector<int>> matrizQueSumaDiez = {
            {1,1,3,10},
            {2,2,3,3},
            {10,10,10,10}
    };
    vector<int> vectorConLaSegundaPosicion = {2};
    EXPECT_EQ(matricesQueSumanN(matrizQueSumaDiez,10), vectorConLaSegundaPosicion);
}

TEST(MatricesQueSumanNTEST, matrizQueSumaEnLaSegundaYTerceraFilaDevuelveDosYTres){
    vector<vector<int>> matrizQueSumaDiez = {
            {1,1,3,10},
            {2,2,3,3},
            {10,0,0,0},
            {10,0,0,10}
    };
    vector<int> vectorConLaSegundaPosicion = {2,3};
    EXPECT_EQ(matricesQueSumanN(matrizQueSumaDiez,10), vectorConLaSegundaPosicion);
}
