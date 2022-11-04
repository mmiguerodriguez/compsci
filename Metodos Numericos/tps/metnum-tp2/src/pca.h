#pragma once
#include "types.h"
#include <tuple>
using namespace std;

class PCA {
public:
    PCA(unsigned int n_components);

    void fit(Matrix X);

    Matrix transform(Matrix X);
private:
    unsigned int _n_components;
    Matrix _train;
    Matrix _transformation;

    Matrix eigenMatrix(Matrix X);
    tuple<Vector, double> powerIteration(Matrix X, int nIter, double eps);
};
