#include <iostream>
#include "pca.h"
#include "eigen.h"

using namespace std;


PCA::PCA(unsigned int n_components) {
    _n_components = n_components;
}

void PCA::fit(Matrix X) {
    //mat cov:
    // X' = X - Mean cols
    // cov_mat = X'.T * X' / (X.rows()-1)
    // obtengo los n_components autovectores y autovalores de cov_mat (metodo potencia y deflacion)
    // pongo los autovector en las columnas de una matriz  V € mxn_components
    // Multiplico X * V y lo guardo
    // Guardo V

    Matrix Y = X;

    for(int i = 0; i < Y.cols(); i++){
        Y.col(i) = Y.col(i) - Vector::Ones(Y.rows()) * Y.col(i).mean();
    }

    Y = Y.transpose() * Y;
    Y /= X.rows() - 1;

    Matrix V = eigenMatrix(Y);

    _train = X;
    _transformation = V;
}


Matrix PCA::transform(Matrix X) {
    return X * _transformation;
}

tuple<Vector, double> PCA::powerIteration(Matrix X, int nIter, double eps) {
    Vector v = Vector::Ones(X.cols());

    for (int i = 0; i < nIter; i++) {
        Vector prevV = v;
        v = X * v;
        v /= v.norm();

        double cosAngle = v.dot(prevV);
        if (1 - eps < cosAngle && cosAngle <= 1) break;
    }

    double eigenvalue = v.dot(X * v);
    return make_tuple(v, eigenvalue);
}

Matrix PCA::eigenMatrix(Matrix X) {
    Matrix Y = X;
    Matrix eigenvectorsMatrix(X.rows(), _n_components);

    for (unsigned int i = 0; i < _n_components; i++) {
        tuple<Vector, double> eigen = powerIteration(Y, 1000, 1e-6);
        eigenvectorsMatrix.col(i) = get<0>(eigen);
        Matrix resta = get<1>(eigen) * (get<0>(eigen) * get<0>(eigen).transpose());
        Y = Y - resta;
    }
    return eigenvectorsMatrix;
}
