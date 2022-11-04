#include "Test.h"

Test::Test(vector<string> lines) {
  test_set = Matrix(lines.size(), 28 * 28);

  for (unsigned int k = 0; k < lines.size(); k++) {
    string line = lines[k];
    string num_parcial = "";
    unsigned int j = 0;

    for (unsigned int i = 0; i < line.length(); i++) {
      if (line[i] != ',') {
        num_parcial += line[i];
      } else if (line[i] == ',' || i + 1 == line.length()) {
        double n = stod(num_parcial);
        test_set(k, j) = n;
        num_parcial = "";
        j++;
      }
    }
  }
}

Matrix Test::getTestSet() {
    return test_set;
}