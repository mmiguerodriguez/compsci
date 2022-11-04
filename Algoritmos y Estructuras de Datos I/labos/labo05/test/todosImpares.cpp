#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;

TEST(todosImparesTest, muchosElementos){
    vector<int> v = {3, 7,  5, 4};
    ASSERT_FALSE(todosImpares(v));
}

/*

TEST(todosImparesTest, muchosElementos1){
    vector<int> v = {2, 1,  1, 2, 3, 4, 5, 6, 7};
    ASSERT_FALSE(todosImpares(v));
}

TEST(todosImparesTest, muchosElementosImpares){
    vector<int> v = {5, 1,  1, 3, 3, 17, 5, 11, 7};
    ASSERT_TRUE(todosImpares(v));
}


TEST(todosImparesTest, unElementoImpar){
    vector<int> v = {3};
    ASSERT_TRUE(todosImpares(v));
}

TEST(todosImparesTest, unElementoPar){
    vector<int> v = {2};
    ASSERT_FALSE(todosImpares(v));
}
*/

