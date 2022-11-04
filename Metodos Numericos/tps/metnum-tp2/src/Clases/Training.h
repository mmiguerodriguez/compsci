#include <iostream>
#include <fstream>
#include <string>
#include "../pca.h"
#include "../eigen.h"
#include <vector>

using namespace std;

class Training {
public:
  Training(vector<string> lines);
  Matrix getTrainingSet();
  Matrix getLabels();

private:
  Matrix trainingSet;
  Matrix labels;
};
