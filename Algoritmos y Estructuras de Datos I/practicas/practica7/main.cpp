#include <iostream>
#include "ejercicios.h"

int main() {
    vector<vector<int>> n = {
            {1, 7, 12, 9},
            {4, 2, 10, 1},
            {3, 4, 3, 9},
            {3, 5, 4, 0}
    };

    ejercicio14(n);

    vector<vector<bool>> b = {
            {true, false, true, false},
            {true, true, false, false},
            {true, true, false, false},
            {true, true, true, false},
            {true, false, true, false},
            {true, true, true, false},
            {false, true, false, true}
    };

    vector<bool> result = ejercicio16(b);

    return 0;
}