//
// Created by DESKTOP-MIGUE on 10/21/2019.
//

#include "ejercicios.h"

// O(n^2)
vector<vector<int>> ejercicio14(vector<vector<int>> m) {
    int n = m.size() - 1;
    vector<vector<int>> v(m.size(), vector<int>(m.size(), 0));

    v[n][n] = m[n][n];

    for (int i = n; i >= 0; i--) {
        for (int j = n; j >= 0; j--) {
            if (!(i == n && j == n)) {
                if (j == n) {
                    v[i][j] = m[i][j] + v[i + 1][j];
                } else {
                    if (i == n) {
                        v[i][j] = m[i][j] + v[i][j + 1];
                    } else {
                        if (v[i][j + 1] < v[i + 1][j]) {
                            v[i][j] = m[i][j] + v[i][j + 1];
                        } else {
                            v[i][j] = m[i][j] + v[i + 1][j];
                        }
                    }
                }
            }
        }
    }

    vector<vector<int>> r(m.size(), vector<int>(m.size(), 0));
    r[0][0] = 1;
    r[n][n] = 1;

    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= n; j++) {
            if (!(i == n && j == n) && r[i][j] == 1) {
                if (j == n) {
                    r[i + 1][j] = 1;
                } else {
                    if (i == n) {
                        r[i][j + 1] = 1;
                    } else {
                        if (v[i][j + 1] < v[i + 1][j]) {
                            r[i][j + 1] = 1;
                        } else {
                            r[i + 1][j] = 1;
                        }
                    }
                }
            }
        }
    }

    return r;
}

// Sin usar un vector auxiliar
vector<bool> ejercicio16(vector<vector<bool>> m) {
    vector<bool> result(m[0].size(), false);

    for (int j = 0; j < m[0].size(); j++) {
        int t = 0;
        int f = 0;

        for (int i = 0; i < m.size(); i++) {
            if (m[i][j]) t++;
            else f++;
        }

        if (t % 2 != 0) result[j] = true;
        else result[j] = false;
    }

    return result;
}