#include "../src/matrices/matrices.h"
#include "gtest.h"

TEST(TemperaturaPromedioZTest, TemperaturaPromedioZ_TensorSinMedicionesDevuelveVacio_Test) {
    vector<vector<vector<float>>> tensorVacio= {};
    vector<float> promedios= temperaturaPromedioZona(tensorVacio);

    vector<float> promedio_vacios= {};
    EXPECT_EQ(promedios, promedio_vacios);
}

// COMPLETAR CON MAS TESTS
