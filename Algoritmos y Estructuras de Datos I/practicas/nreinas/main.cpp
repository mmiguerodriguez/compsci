#include <iostream>
#include <vector>
#include <fstream>
using namespace std;

void visualizar(vector<int> reinas) {
    for (int i = 0; i < reinas.size(); i++) {
        for (int k = 0; k < reinas[i]; k++) {
            cout << "x\t";
        }
        cout << "r\t";
        for (int k = reinas[i] + 1; k < reinas.size(); k++) {
            cout << "x\t";
        }
        cout << endl;
    }
    cout << endl;
}

bool seTocan(vector<int>& reinas) {
    for (int i = 0; i < reinas.size(); i++) {
        for (int j = 0; j < reinas.size(); j++) {
            if (i != j) {
                if (reinas[i] == reinas[j] || (i + reinas[i] == j + reinas[j]) || (i - reinas[i] == j - reinas[j])) return true;
            }
        }
    }

    return false;
}

bool nreinas(int n) {
    vector<int> reinas;

    int i = 0;
    bool corrigiendo = false;

    while (i < n) {
        for (int j = 0; j < n; j++) {
            if (!corrigiendo) {
                reinas.push_back(j);

                if (seTocan(reinas)) {
                    if (j + 1 == n) {
                        if (i > 0) {
                            corrigiendo = true;
                            reinas.pop_back();
                            i--;
                        } else {
                            return false;
                        }
                    } else {
                        reinas.pop_back();
                    }
                } else {
                    i++;
                    break;
                }
            } else {
                bool salgo = false;

                for (int k = reinas[i]; k < n; k++) {
                    if (k + 1 == n) {
                        if (i > 0) {
                            reinas.pop_back();
                            salgo = true;
                            i--;
                            break;
                        } else {
                            return false;
                        }
                    } else {
                        reinas[i] = k + 1;

                        if (!seTocan(reinas)) {
                            corrigiendo = false;
                            salgo = true;
                            i++;
                            break;
                        }
                    }
                }

                if (salgo) break;
            }
        }
    }

    // visualizar(reinas);
    return true;
}

int main() {
    ofstream fout;
    double t0 = 0;
    double t1 = 0;
    double tiempo = 0;

    fout.open("nreinas.txt");
    fout << "n\t" << "tiempo" << endl;

    for (int i = 1; i < 40; i++) {
        t0 = clock();
        bool sePuede = nreinas(i);
        t1 = clock();

        tiempo = (double(t1-t0)/CLOCKS_PER_SEC);
        fout << i << "\t" << tiempo << endl;
    }

    fout.close();
    return 0;
}