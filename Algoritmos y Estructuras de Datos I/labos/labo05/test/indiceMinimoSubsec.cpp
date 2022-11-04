#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;

TEST(indiceMinimoSubsecTest, unElemento){
    vector<int> v = {56};
    ASSERT_EQ(0, indiceMinimoSubsec(v, 0, 0));
}

TEST(indiceMinimoSubsecTest, dosElementos){
    vector<int> v = {56, -34};
    ASSERT_EQ(1, indiceMinimoSubsec(v, 0, 1));
}

TEST(indiceMinimoSubsecTest, muchosElementosRangoCompleto){
    vector<int> v = {56, -34, 4, 5, 3, 2345, -1, 6, 5, 3, 21, -200, 34, 6, 1, 8, 3};
    ASSERT_EQ(11, indiceMinimoSubsec(v, 0, 16));
}

TEST(indiceMinimoSubsecTest, muchosElementosRangoAcotado){
    vector<int> v = {56, -34, 4, 5, 3, 2345, -1, 6, 5, 3, 21, -200, 34, 6, 1, 8, 3};
    ASSERT_EQ(1, indiceMinimoSubsec(v, 1, 10));
}

TEST(indiceMinimoSubsecTest, muchosElementosRangoAcotado1){
    vector<int> v = {56, -34, 4, 5, 3, 2345, -1, 6, 5, 3, 21, -200, 34, 6, 1, 8, 3};
    ASSERT_EQ(11, indiceMinimoSubsec(v, 1, 11));
}


