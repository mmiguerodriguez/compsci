#include "gtest-1.8.1/gtest.h"
#include "../src/Libreta.h"
#include "../src/Truco.h"
#include <map>
#include <cmath>

using namespace std;

// Ejercicio 4
TEST(Aritmetica, suma) {
    int esperado = 22;
    int suma = 15 + 7;

    ASSERT_EQ(esperado, suma);
}

// Ejercicio 5
TEST(Aritmetica, potencia) {
    float esperado = 100;
    float resultado = pow(10, 2);

    ASSERT_EQ(esperado, resultado);
}

TEST(Aritmetica, potencia_general) {
    for(int i = -5; i <= 5; i++) {
        float n = i * i;
        float r = pow(i, 2);
        ASSERT_EQ(n, r);
    }
}
// Ejercicios 6..9
