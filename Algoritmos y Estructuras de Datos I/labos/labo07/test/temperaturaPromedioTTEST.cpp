#include "../src/matrices/matrices.h"
#include "gtest.h"

TEST(TemperaturaPromedioTTest, TemperaturaPromedio_TensorSinMedicionesDevuelveVacio_Test) {
    vector<vector<vector<float>>> tensorVacio= {};
    vector<vector<float>> promedios= temperaturaPromedio(tensorVacio);

    vector<vector<float>> promedio_vacios= {};
    EXPECT_EQ(promedios, promedio_vacios);
}

TEST(TemperaturaPromedioTTest2, TemperaturaPromedio_TensorDeSoloUnaDimension_Test) {
    vector<vector<vector<float>>> tensorConUnSoloInstante= {
            {
                    {1,2,3},
                    {4,5,6},
                    {7,8,9}
            }
    };
    vector<vector<float>> promedios_esperados= {
            {1,2,3},
            {4,5,6},
            {7,8,9}
    };

    vector<vector<float>> promedios = temperaturaPromedio(tensorConUnSoloInstante);

    vector<vector<float>> promedio_vacios= {};
    EXPECT_EQ(promedios, promedios_esperados);
}

// COMPLETAR CON MAS TESTS
