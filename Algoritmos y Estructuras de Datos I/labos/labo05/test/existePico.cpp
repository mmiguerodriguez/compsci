#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;

TEST(existePicoTest, existenMasDeUnPico){
    vector<int> v = {9, 20, 1, 3, 2};
    ASSERT_TRUE(existePico(v));
}

/*
TEST(existePicoTest, noExistePico){
    vector<int> v = {3, 1, 0};
    ASSERT_FALSE(existePico(v));
}

TEST(existePicoTest, noExistePicoSecuenciaLarga){
    vector<int> v = {-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    ASSERT_FALSE(existePico(v));
}


TEST(existePicoTest, existeUnPico){
    vector<int> v = {3, 4, 2};
    ASSERT_TRUE(existePico(v));
}


TEST(existePicoTest, picoAlPrincipio){
    vector<int> v = {1, 3, 2, 4, 6, 7};
    ASSERT_TRUE(existePico(v));
}

TEST(existePicoTest, picoAlFinal){
    vector<int> v = {1, 2, 3, 4, 7, 6};
    ASSERT_TRUE(existePico(v));
}
*/



