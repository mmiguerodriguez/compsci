#include <algorithm>
//#include <chrono>
#include <pybind11/pybind11.h>
#include <iostream>
#include <exception>
#include "linear_regression.h"

using namespace std;
namespace py = pybind11;

LinearRegression::LinearRegression() {

}

// A^T * A * z = A^T * b
void LinearRegression::fit(Matrix X, Matrix y) {
  A = X;
  b = y;
  x = (A.transpose() * A).colPivHouseholderQr().solve(A.transpose() * b);
}


Matrix LinearRegression::predict(Matrix X) {
    return X * x;
}
