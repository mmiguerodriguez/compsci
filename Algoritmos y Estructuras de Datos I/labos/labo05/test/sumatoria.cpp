#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;

TEST(sumatoriaTest, vacia){
    vector<int> v;
    ASSERT_EQ(0, sumatoria(v));
}

TEST(sumatoriaTest, unElemento){
    vector<int> v={23};
    ASSERT_EQ(23, sumatoria(v));
}

TEST(sumatoriaTest, dosElementos) {
    vector<int> v = {56, -34};
    ASSERT_EQ(0, sumatoria(v));
}

TEST(sumatoriaTest, muchosElementos){
    vector<int> v = {56, -34, 4, 5, 3, 2345, -1, 6, 5, 3, 21, -200, 34, 6, 1, 8, 3};
    ASSERT_EQ(2265, sumatoria(v));
}
