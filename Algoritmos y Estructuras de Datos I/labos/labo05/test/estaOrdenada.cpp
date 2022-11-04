#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;




TEST(estaOrdenadoTest, ordenDescendente){
    vector<int> ordDesc = {123, 3, 0, -1, -123};

    ASSERT_TRUE(estaOrdenado(ordDesc));
}

TEST(estaOrdenadoTest, ordenAscendente){
    vector<int> ordAsc = {-501, 0, 12, 456, 501, 99999};

    ASSERT_TRUE(estaOrdenado(ordAsc));
}

TEST(estaOrdenadoTest, vacio){
    vector<int> vacio = {};

    ASSERT_TRUE(estaOrdenado(vacio));
}


TEST(estaOrdenadoTest, desordenado){
    vector<int> desord = {-1, 0, 1, -1, 56, 98, 10};

    ASSERT_FALSE(estaOrdenado(desord));
}

TEST(estaOrdenadoTest, unoSolo){
    vector<int> unoSolo = {23};

    ASSERT_TRUE(estaOrdenado(unoSolo));
}

TEST(estaOrdenadoTest, soloDos){
    vector<int> soloDos = {1,2};

    ASSERT_TRUE(estaOrdenado(soloDos));
}


TEST(estaOrdenadoTest, dosPicos){
    vector<int> dosPicos = {0,1,2,3,4,3,2,1,0,1,2,3,4,3,2,1};

    ASSERT_FALSE(estaOrdenado(dosPicos));
}


TEST(estaOrdenadoTest, iguales){
    vector<int> iguales = {0,0,0,0,0,0,0,0,0,0};

    ASSERT_TRUE(estaOrdenado(iguales));
}


