#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;



TEST(perteneceTest, casoStandard1){
    vector<int> enteros= {5, -323, 253, 0, -7, 100};

    ASSERT_TRUE(pertenece(0, enteros));
}

TEST(perteneceTest, casoStandard2){
    vector<int> enteros= {5, -323, 253, 0, -7, 100};

    ASSERT_FALSE(pertenece(7, enteros));
}

TEST(perteneceTest, alFinal){
    vector<int> enteros= {5, -323, 253, 0, -7, 100};

    ASSERT_TRUE(pertenece(100, enteros));
}

TEST(perteneceTest, menorACero){
    vector<int> enteros= {5, -323, 253, 0, -7, 100};

    ASSERT_TRUE(pertenece(-323, enteros));
}

TEST(perteneceTest, vacio){
    vector<int> vacio= {};

    ASSERT_FALSE(pertenece(1, vacio));
}

TEST(perteneceTest, todosIgualesAUno1){
    vector<int> todosIguales = {1,1,1,1,1,1,1,1,1,1,1};

    ASSERT_TRUE(pertenece(1, todosIguales));
}

TEST(perteneceTest, todosIgualesAUno2){
    vector<int> todosIguales = {1,1,1,1,1,1,1,1,1,1,1};

    ASSERT_FALSE(pertenece(4, todosIguales));
}

