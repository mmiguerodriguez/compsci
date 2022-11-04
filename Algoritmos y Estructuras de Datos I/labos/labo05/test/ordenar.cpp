#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;



TEST(ordenarTest, unElemento){
    vector<int> v={23};
    vector<int> res={23};

    ordenar(v);
    ASSERT_EQ(v.size(),res.size());

    for (int i = 0; i < res.size(); ++i) {
        ASSERT_EQ(v[i],res[i]);
    }


}

TEST(ordenarTest, dosElementos){
    vector<int> v = {56, -34};
    vector<int> res={-34, 56};
    ordenar(v);
    ASSERT_EQ(v.size(),res.size());

    for (int i = 0; i < res.size(); ++i) {
        ASSERT_EQ(v[i],res[i]);
    }
}

TEST(ordenarTest, muchosElementos){
    vector<int> v = {56, -34, 4, 5, 3, 2345, -1, 6, 5, 3, 21, -200, 34, 6, 1, 8, 3};
    vector<int> res = {-200, -34, -1, 1, 3, 3, 3, 4, 5, 5, 6, 6, 8, 21, 34, 56,  2345};
    ordenar(v);
    ASSERT_EQ(v.size(),res.size());

    for (int i = 0; i < res.size(); ++i) {
        ASSERT_EQ(v[i],res[i]);
    }
}
