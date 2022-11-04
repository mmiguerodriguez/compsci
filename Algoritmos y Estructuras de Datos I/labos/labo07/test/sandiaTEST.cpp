#include "sandia.h"
#include "gtest.h"

// Escribir tests aca:

TEST(sandiaTEST, MenorQue4){
    int n = 0;
    bool sePuede = sandia(n);
    EXPECT_EQ(false, sePuede);
}

TEST(sandiaTEST, IgualQue4){
    int n = 4;
    bool sePuede = sandia(n);
    EXPECT_TRUE(sePuede);
}

TEST(sandiaTEST, MayorQue4Impar) {
    int n = 7;
    bool sePuede = sandia(n);
    EXPECT_FALSE(sePuede);
}

TEST(sandiaTEST, MayorQue4Par) {
    int n = 8;
    bool sePuede = sandia(n);
    EXPECT_TRUE(sePuede);
}