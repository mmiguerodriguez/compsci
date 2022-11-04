#include <algorithm>
//#include <chrono>
#include <iostream>
#include "knn.h"

using namespace std;


KNNClassifier::KNNClassifier(unsigned int n_neighbors)
{
  _neighbors = n_neighbors;
}

void KNNClassifier::fit(Matrix X, Matrix y)
{
  training_set = X;
  validation_set = y;
}


Vector KNNClassifier::predict(Matrix X)
{
    // Creamos vector columna a devolver
    auto ret = Vector(X.rows());

    for (unsigned k = 0; k < X.rows(); ++k) {
        ret(k) = predict_image_number(X.row(k));
    }

    return ret;
}

unsigned int KNNClassifier::predict_image_number(Matrix image) {
  // cout << image.squaredNorm() << endl;
  //image R 1xGG
  //para cada fila de training set hago:
  //    normas[i] = ||training_set[i] - image||
  //busco k mins y me guardo los valores de validation_set para eso k min.
  // retorno el valor mas repetido de esos
  vector<tuple<double,int>> normas;
  for(int i = 0; i < training_set.rows(); i++){
      Matrix resta = training_set.row(i) - image.row(0);
      normas.emplace_back(make_tuple(resta.norm(),validation_set(i,0)));
  }

  sort(normas.begin(),normas.end());
  vector<int> votes(10);
  int k = _neighbors > normas.size() ? normas.size() : _neighbors;

  for(int i = 0; i < k; i++){
      int validate = get<1>(normas[i]);
      if (validate < 10) {
          votes[validate]++;
      }
  }

  int predict = 0;
  int count = votes[predict];
  for(unsigned int i = 1; i < votes.size(); i++){
      if(count < votes[i]){
          count = votes[i];
          predict = i;
      }
  }

  return predict;
}
