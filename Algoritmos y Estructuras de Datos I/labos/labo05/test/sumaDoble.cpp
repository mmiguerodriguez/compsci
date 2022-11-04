#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;

TEST(sumaDobleTest, muchosElementos){
    vector<int> v = {-2, 2,  6, 4};
    ASSERT_EQ(24, sumaDoble(v));
}



TEST(sumaDobleTest, muchosElementos1){
    vector<int> v = {-2, -1,  1, 2, 3, 4, 5, 6, 7};
    ASSERT_EQ(24, sumaDoble(v));
}


TEST(sumaDobleTest, secuenciaVacia){
    vector<int> v;
    ASSERT_EQ(0, sumaDoble(v));
}


TEST(sumaDobleTest, unElementoSuma){
    vector<int> v = {2};
    ASSERT_EQ(4, sumaDoble(v));
}

TEST(sumaDobleTest, unElementoNoSuma){
    vector<int> v = {3};
    ASSERT_EQ(0, sumaDoble(v));
}
