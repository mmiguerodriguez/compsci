#include "Training.h"
Training::Training(vector<string> lines) {
  trainingSet = Matrix(lines.size(), 28 * 28);
  labels = Matrix(lines.size(),1);

  for (unsigned int k = 0; k < lines.size(); k++) {
    string line = lines[k];
    unsigned int i = 0;

    //Obtengo la validacion
    string label = "";
    while(line[i] != ',' && i < line.length()){
        label += line[i];
        i++;
    }
    labels(k,0) = stod(label);

    // Obtengo los 28x28 pixeles
    string numParcial = "";
    unsigned int j = i + 1;
    unsigned int l = 0;
    while (j < line.length()){
        if (line[j] != ','){
            numParcial += line[j];
        } else {
            trainingSet(k, l) = stod(numParcial);
            numParcial = "";
            l++;
        }
        j++;
    }
    trainingSet(k, l) = stod(numParcial);
  }
}

Matrix Training::getLabels() {
    return labels;
}

Matrix Training::getTrainingSet() {
    return trainingSet;
}
