#pragma once

#include "types.h"


class KNNClassifier {
public:
    KNNClassifier(unsigned int n_neighbors);
    void fit(Matrix X, Matrix y);
    Vector predict(Matrix X);
    unsigned int predict_image_number(Matrix image);
private:
    unsigned int _neighbors;
    Matrix training_set;
    Matrix validation_set;
};
