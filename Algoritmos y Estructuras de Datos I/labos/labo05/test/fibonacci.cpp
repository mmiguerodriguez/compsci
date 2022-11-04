#include "../src/ejercicios.h"
#include "gtest/gtest.h"

using namespace std;

TEST(fibonacciTest, cero){

    ASSERT_EQ(0, fibonacci(0));
}

TEST(fibonacciTest, uno){

    ASSERT_EQ(1, fibonacci(1));
}

TEST(fibonacciTest, dos){

    ASSERT_EQ(1, fibonacci(2));
}

TEST(fibonacciTest, tres){

    ASSERT_EQ(2, fibonacci(3));
}

TEST(fibonacciTest, cuatro){

    ASSERT_EQ(3, fibonacci(4));
}

TEST(fibonacciTest, cinco){

    ASSERT_EQ(5, fibonacci(5));
}

TEST(fibonacciTest, siete){

    ASSERT_EQ(13, fibonacci(7));
}

TEST(fibonacciTest, quince){

    ASSERT_EQ(610, fibonacci(15));
}

TEST(fibonacciTest, cincuenta){

    ASSERT_EQ(12586269025, fibonacci(50));
}

TEST(fibonacciTest, dieciseis){

    ASSERT_EQ(987, fibonacci(16));
}

TEST(fibonacciTest, cuarentaYCinco){

    ASSERT_EQ(1134903170, fibonacci(45));
}
