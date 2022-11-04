#include <iostream>
#include <fstream>
#include <string>
#include "../pca.h"
#include "../eigen.h"
#include <vector>

using namespace std;

class Test {
public:
  Test(vector<string> lines);
  Matrix getTestSet();
private:
  Matrix test_set;
};
