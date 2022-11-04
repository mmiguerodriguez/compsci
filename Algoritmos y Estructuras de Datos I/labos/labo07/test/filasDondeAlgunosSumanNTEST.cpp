#include "../src/matrices/matrices.h"
#include "gtest.h"

TEST(filasDondeAlgunosSumanNTEST, matrizVaciaDevuelveVacio){
    vector<vector<int>> matrizVacia = {};
    vector<int> vectorVacio = {};
    EXPECT_EQ(filasDondeAlgunosSumanN(10, matrizVacia), vectorVacio);
}

TEST(filasDondeAlgunosSumanNTEST, matrizQueTieneQueSumarATodosYSumaCinco){
    vector<vector<int>> matrizQueSumaCinco = {
            {0,1,2,1,0},
            {1,1,1,1,1},
            {0,4,6,3,6},
            {1,1,1,1,1},
            {1,1,1,0,0}
    };
    vector<int> vectorFilasDosYCuatro = {2, 4};
    EXPECT_EQ(filasDondeAlgunosSumanN(5, matrizQueSumaCinco), vectorFilasDosYCuatro);
}

TEST(filasDondeAlgunosSumanNTEST, matrizQueNoSumeEnNinguna){
    vector<vector<int>> matrizQueSumaCinco = {
            {7,3,4,3,4},
            {1,6,2,6,1},
            {0,4,6,3,6},
            {3,3,3,3,3},
            {2,2,2,2,2}
    };
    vector<int> vectorVacio = {};
    EXPECT_EQ(filasDondeAlgunosSumanN(5, matrizQueSumaCinco), vectorVacio);
}

TEST(filasDondeAlgunosSumanNTEST, matrizQueSumaDoceEnVarias){
    vector<vector<int>> matrizQueSumaDoce = {
            {1,6,2,6,1},
            {0,4,6,3,6},
            {3,3,3,3,3},
    };
    vector<int> vectorUnoDosTres = {1,2,3};
    EXPECT_EQ(filasDondeAlgunosSumanN(12, matrizQueSumaDoce) , vectorUnoDosTres);
}

TEST(filasDondeAlgunosSumanNTEST, matrizQueSumaQuinceEnAlgunos){
    vector<vector<int>> matrizQueSumaQuince = {
            {1,6,2,6,1},
            {0,4,6,3,6},
            {3,3,3,3,3},
            {3,3,3,3,4},
            {1,7,6,4,21}
    };
    vector<int> vectorUnoDosTres = {1,2,3};
    EXPECT_EQ(filasDondeAlgunosSumanN(15, matrizQueSumaQuince) , vectorUnoDosTres);
}