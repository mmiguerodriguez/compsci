#include "../src/matrices/matrices.h"
#include "gtest.h"

TEST(sopaDeLetrasTEST, NoHayNingunaSopa) {
    vector<vector<char>> sopa = {
            {'a','b','c'},
            {'d','e','f'},
            {'g','h','i'}
    };
    
    int cantidad = sopaDeLetras(sopa);
    EXPECT_EQ(cantidad, 0);
}

TEST(sopadeLetrasTEST, IzquierdaADerecha) {
    vector<vector<char>> sopa = {
            {'a','b', 'c', 'd'},
            {'s','o','p','a'},
            {'e', 'f', 'g', 'h'}
    };
    int cantidad = sopaDeLetras(sopa);
    EXPECT_EQ(cantidad,1);
}

TEST(sopadeLetrasTEST, ArribaAbajo) {
    vector<vector<char>> sopa = {
            {'p','s', 'c', 'd'},
            {'a','o','p','a'},
            {'p', 'p', 'g', 'h'},
            {'a', 'a', 'g', 'h'}
    };
    int cantidad = sopaDeLetras(sopa);
    EXPECT_EQ(cantidad,  1);
}

TEST(sopadeLetrasTEST, IzquierdaADerechaYArribaAbajo) {
    vector<vector<char>> sopa = {
            {'p','s', 'c', 'd'},
            {'s','o','p','a'},
            {'p', 'p', 'g', 'h'},
            {'a', 'a', 'g', 'h'}
    };
    int cantidad = sopaDeLetras(sopa);
    EXPECT_EQ(cantidad,  2);
}

TEST(sopadeLetrasTEST, IzquierdaADerechaYArribaAbajoEnElFinal) {
    vector<vector<char>> sopa = {
            {'a', 'p', 'o', 'c', 'd'},
            {'b', 's', 'o', 'p', 's'},
            {'c', 'p', 'p', 'g', 'o'},
            {'d', 'a', 'a', 'g', 'p'},
            {'u', 's', 'o', 'p', 'a'}
    };
    int cantidad = sopaDeLetras(sopa);
    EXPECT_EQ(cantidad,  2);
}
