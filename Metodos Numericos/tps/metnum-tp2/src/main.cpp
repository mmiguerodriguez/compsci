//
// Created by pachi on 5/6/19.
//

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "pca.h"
#include "eigen.h"
#include "knn.h"
#include "Clases/Training.h"
#include "Clases/Test.h"

using namespace std;

struct arguments {
  unsigned int method;
  string train_set;
  string test_set;
  string classif;
};

bool parse_arguments(int argc, char** argv, arguments& args) {
  if (argc < 9) {
    return false;
  }

  for(int i = 1; i < argc; i += 2) {
    string command = argv[i];
    string argument = argv[i + 1];

    if (command == "-m"){
      args.method = stoi(argument);
    } else if(command == "-i"){
      args.train_set = argument;
    } else if(command == "-q"){
      args.test_set = argument;
    } else if(command == "-o"){
      args.classif = argument;
    } else {
      cerr << "Input no valido." << endl;
      return false;
    }
  }

  if (args.train_set.empty() || args.test_set.empty() || args.classif.empty()) {
    return false;
  }

  return true;
}

int main(int argc, char** argv) {
  // Parsing de argumentos
  arguments args;
  bool parse_good = parse_arguments(argc, argv, args);
  if (!parse_good) {
    return 1;
  }

  // Leer training y test set y pasarlo a Matrix
  fstream fin;
  string line;
  fin.open(args.train_set);
  getline(fin, line); // Skip primer linea

  vector<string> trainingSetLines;
  while(getline(fin, line)) { trainingSetLines.push_back(line); }

  fin.close(); // Cierro training set
  fin.open(args.test_set); // Abro test set
  getline(fin, line); // Skip primer linea

  vector<string> testSetLines;
  while(getline(fin, line)) { testSetLines.push_back(line); }

  fin.close(); // Cierro test set

  Training trainingSet(trainingSetLines);
  Test testSet(testSetLines);

  int k = 25;
  int alpha = 28;
  Vector predictions;

  if (args.method == 0) {
    KNNClassifier knn(k);
    knn.fit(trainingSet.getTrainingSet(), trainingSet.getLabels());
    predictions = knn.predict(testSet.getTestSet());
  } else if (args.method == 1) {
    PCA pca(alpha);
    pca.fit(trainingSet.getTrainingSet());
    Matrix trainingSetTrans = pca.transform(trainingSet.getTrainingSet());
    Matrix testSetTrans = pca.transform(testSet.getTestSet());

    KNNClassifier knn(k);
    knn.fit(trainingSetTrans, trainingSet.getLabels());
    predictions = knn.predict(testSetTrans);
  } else {
    cerr << "Este metodo no existe" << endl;
    return 1;
  }

  ofstream fout;
  fout.open(args.classif);
  fout << "ImageId,Label" << endl;
  for (unsigned int i = 0; i < predictions.rows(); i++) {
    fout << i + 1 << "," << predictions(i,0) << endl;
  }
  fout.close();

  cout << "Parametros utilizados: " << endl;
  cout << "Metodo: " << (args.method == 0 ? "KNN" : "KNN + PCA") << endl;
  cout << "K: " << k << endl;
  if (args.method == 1) cout << "Alpha: " << alpha << endl;

  return 0;
}
