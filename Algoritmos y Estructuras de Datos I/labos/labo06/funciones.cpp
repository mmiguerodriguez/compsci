//
// Created by clinux01 on 30/09/19.
//

#include "funciones.h"

void imprimirMatriz(vector<vector<int>> v) {
    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v[i].size(); j++) {
            cout << v[i][j] << "\t";
        }
        cout << endl;
    }
    cout << endl;
}

void imprimirMatriz(vector<vector<char>> v) {
    cout << endl;

    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v[i].size(); j++) {
            if (v[i][j] == 'r') {
                cout << v[i][j] << "\t";
            } else {
                cout << 'x' << "\t";
            }
        }
        cout << endl;
    }
    cout << endl;
}

int dotProduct(vector<vector<int>> a, vector<vector<int>> b) {
    int prod = 0;

    for (int i = 0; i < a.size(); i++) {
        for (int j = 0; j < a[i].size(); j++) {
            prod += a[i][j] * b[i][j];
        }
    }

    return prod;
}

vector<vector<int>> multiplicarPorTraspuesta(vector<vector<int>> v) {
    //
}

int agarrarValor(vector<vector<int>> v, int m) {
    int i = m / v[0].size();
    int j = m % v[0].size();

    return v[i][j];
}
vector<vector<int>> redimensionar(vector<vector<int>> v, int n, int m) {
    vector<vector<int>> r(m, vector<int>(n, 0));

    for (int i = 0; i < r.size(); i++) {
        for (int j = 0; j < r[i].size(); j++) {
            r[i][j] = agarrarValor(v, i * r[i].size() + j);
        }
    }

    return r;
}

vector<vector<int>> trasponer(vector<vector<int>> m) {
    vector<vector<int>> r(m[0].size(), vector<int>(m.size(), 0));

    for (int i = 0; i < r.size(); i++) {
        for (int j = 0; j < r[i].size(); j++) {
            r[i][j] = m[j][i];
        }
    }

    return r;
}

bool esPico(vector<vector<int>> m, int i, int j) {
    bool pico = true;

    int a = (i - 1 < 0) ? 0 : i - 1;
    for (; a <= i + 1 && a < m.size(); a++) {
        int b = (j - 1 < 0) ? 0 : j - 1;
        for (; b <= j + 1 &&  b < m[i].size(); b++) {
            if (m[i][j] <= m[a][b] && (i != a || j != b)) {
                pico = false;
            }
        }
    }

    return pico;
}
int contarPicos(vector<vector<int>> m) {
    int res = 0;

    for (int i = 0; i < m.size(); i++) {
        for (int j = 0; j < m[i].size(); j++) {
            if (esPico(m, i, j)) {
                res++;
            }
        }
    }

    return res;
}

vector<tuple<int, int, int>> aTriplas(vector<vector<int>> m) {
    vector<tuple<int,int,int>> v;

    for (int i = 0; i < m.size(); i++) {
        for (int j = 0; j < m[i].size(); j++) {
            if (m[i][j] != 0) {
                tuple <int,int,int> x(i, j, m[i][j]);
                v.push_back(x);
            }
        }
    }

    return v;
}
vector<vector<int>> aMatriz(vector<tuple<int, int, int>> m, int x, int y) {
    vector<vector<int>> v(x, vector<int>(y, 0));

    for (int i = 0; i < m.size(); i++) {
        int j = get<0>(m[i]);
        int k = get<1>(m[i]);
        int val = get<2>(m[i]);

        v[j][k] = val;
    }

    return v;
}
void transponerDispersa(vector<tuple<int, int, int>>& m) {
    for (int i = 0; i < m.size(); i++) {
        int aux = get<0>(m[i]);
        get<0>(m[i]) = get<1>(m[i]);
        get<1>(m[i]) = aux;
    }
}

// opcionales

vector<vector<int>> promedioPorZona(vector<vector<vector<int>>> v) {
    vector<vector<int>> r(v.size(), vector<int>(v[0].size(), 0));

    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v[i].size(); j++) {
            for (int k = 0; k < v[i][j].size(); k++) {
                r[i][j] += v[i][j][k];
            }
        }

    }

    for (int i = 0; i < r.size(); i++) {
        for (int j = 0; j < r[i].size(); j++) {
            r[i][j] /= v.size();
        }
    }

    return r;
}
vector<int> promedioPorTiempo(vector<vector<vector<int>>> v) {
    vector<int> r(v.size(), 0);

    for (int tiempo = 0; tiempo < v[0][0].size(); tiempo++) {
        int suma = 0;
        int mediciones = 0;

        for (int f = 0; f < v.size(); f++) {
            for (int c = 0; c < v[f].size(); c++) {
                suma += v[f][c][tiempo];
                mediciones++;
            }
        }

        suma /= mediciones;
        r[tiempo] = suma;
    }
    return r;
}

void elevar(vector<vector<int>> &terreno, int x) {
    for (int i = 0; i < terreno.size(); i++) {
        for (int j = 0; j < terreno[i].size(); j++) {
            terreno[i][j] += x;
        }
    }
}

vector<vector<int>> _elevar(vector<vector<int>> terreno, int x) {
    for (int i = 0; i < terreno.size(); i++) {
        for (int j = 0; j < terreno[i].size(); j++) {
            terreno[i][j] += x;
        }
    }
    return terreno;
}
int cantidadBajoElAgua(vector<vector<int>> v) {
    int count = 0;

    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v[i].size(); j++) {
            if (v[i][j] < 0) count++;
        }
    }

    return count;
}
int maximo(vector<vector<int>> v) {
    int m = v[0][0];
    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v[i].size(); j++) {
            if (v[i][j] > m) m = v[i][j];
        }
    }
    return m;
}
int minimo(vector<vector<int>> v) {
    int m = v[0][0];
    for (int i = 0; i < v.size(); i++) {
        for (int j = 0; j < v[i].size(); j++) {
            if (v[i][j] < m) m = v[i][j];
        }
    }
    return m;
}
bool sobresalen(vector<vector<int>> terreno, int n, int& mts) {
    bool sobresale = false;
    int min = minimo(terreno);
    int max = maximo(terreno);
    int i = 0;


    if (max > -min) i = -max;
    else i = min;

    while (i <= max && !sobresale) {
        if (cantidadBajoElAgua(_elevar(terreno, i)) == n) {
            mts = i;
            sobresale = true;
        }
        i++;
    }
    return sobresale;
}

bool esTerreno(int n) {
    return n >= 0;
}
bool fueEncontrado(int n) {
    return n > 0;
}
void mirarAdyacentes(vector<vector<int>> terreno, vector<vector<int>>& terrenos, int i, int j, int c) {
    terrenos[i][j] = c;

    if (i - 1 >= 0) {
        if (esTerreno(terreno[i - 1][j]) && !fueEncontrado(terrenos[i - 1][j])) {
            mirarAdyacentes(terreno, terrenos, i - 1, j, c);
        }
    }

    if (i + 1 < terrenos.size()) {
        if (esTerreno(terreno[i + 1][j]) && !fueEncontrado(terrenos[i + 1][j])) {
            mirarAdyacentes(terreno, terrenos, i + 1, j, c);
        }
    }

    if (j - 1 >= 0) {
        if (esTerreno(terreno[i][j - 1]) && !fueEncontrado(terrenos[i][j - 1])) {
            mirarAdyacentes(terreno, terrenos, i, j - 1, c);
        }
    }

    if (j + 1 < terrenos[i].size()) {
        if (esTerreno(terreno[i][j + 1]) && !fueEncontrado(terrenos[i][j + 1])) {
            mirarAdyacentes(terreno, terrenos, i, j + 1, c);
        }
    }

}
int islas(vector<vector<int>> terreno) {
    vector<vector<int>> terrenos(terreno.size(), vector<int>(terreno[0].size(), 0));

    int c = 0;
    for (int i = 0; i < terreno.size(); i++) {
        for (int j = 0; j < terreno[i].size(); j++) {
            if (esTerreno(terreno[i][j]) && !fueEncontrado(terrenos[i][j])) {
                c++;
                mirarAdyacentes(terreno, terrenos, i, j, c);
            }
        }
    }

    cout << "Mapa de Islas" << endl;
    imprimirMatriz(terrenos);

    return c;
}

bool esValle(vector<vector<int>> terreno, int i, int j) {
    // implementacion parecida a esPico
    bool valle = true;

    int a = (i - 1 < 0) ? 0 : i - 1;
    for (; a <= i + 1 && a < terreno.size(); a++) {
        int b = (j - 1 < 0) ? 0 : j - 1;
        for (; b <= j + 1 &&  b < terreno[i].size(); b++) {
            if (terreno[i][j] >= terreno[a][b] && (i != a || j != b)) {
                valle = false;
            }
        }
    }

    return valle;
}
tuple<int, int> buscarValleIterativo(vector<vector<int>> terreno, int i, int j) {
    bool hayValle = false;
    tuple<int, int> valle(0, 0);

    for (; i < terreno.size() && !hayValle; i++) {
        for (; j < terreno[i].size() && !hayValle; j++) {
            if (esValle(terreno, i, j)) {
                hayValle = true;
                get<0>(valle) = i;
                get<1>(valle) = j;
            }
        }
        j = 0;
    }

    return valle;
}

tuple<int, int> cantidadXO(vector<vector<char>> partida) {
    tuple<int, int> c(0,0);
    for (int i = 0; i < partida.size(); i++) {
        for (int j = 0; j < partida[i].size(); j++) {
            if (partida[i][j] == 'X') {
                get<0>(c) = get<0>(c) + 1;
            } else if (partida[i][j] == 'O') {
                get<1>(c) = get<1>(c) + 1;
            }
        }
    }
    return c;
}
bool algunoGano(vector<vector<char>> partida, char& ganador) {
    for (int i = 0; i < 3; i++) {
        if (partida[i][0] == partida[i][1] && partida[i][1] == partida[i][2]) {
            ganador = partida[i][0];
        }
    }

    for (int j = 0; j < 3; j++) {
        if (partida[0][j] == partida[1][j] && partida[1][j] == partida[2][j]) {
            if (ganador != 'I' && ganador != partida[0][j]) {
                ganador = 'I';
            } else {
                ganador = partida[0][j];
            }
        }
    }

    if (partida[0][0] == partida[1][1] && partida[1][1] == partida[2][2]) {
        if (ganador != 'I' && ganador != partida[0][0]) {
            ganador = 'I';
        } else {
            ganador = partida[0][0];
        }
    }

    if (partida[0][2] == partida[1][1] && partida[1][1] == partida[2][0]) {
        if (ganador != 'I' && ganador != partida[0][2]) {
            ganador = 'I';
        } else {
            ganador = partida[0][2];
        }
    }

    return ganador != 'I';
}
string tateti(vector<vector<char>> partida) {
    tuple<int, int> c = cantidadXO(partida);
    char ganador = 'I';

    cout << get<0>(c) << " " << get<1>(c) << endl;

    if (get<0>(c) < get<1>(c) || get<1>(c) + 1 < get<0>(c)) return "invalido";
    if (algunoGano(partida, ganador)) return ganador == 'X' ? "cruz" : "circulo";

    if (ganador == 'I') {
        return "invalido";
    }

    return "in progress";
}

bool esReina(char c) {
    return c == 'r';
}
bool amenazasEnDiagonales(vector<vector<char>>& tablero) {
    for (int i = 0; i < tablero.size(); i++) {
        vector<int> cantidadReinas(4, 0);

        for (int j = 0; j < tablero.size() - i; j++) {
            if (esReina(tablero[i + j][j])) {
                cantidadReinas[0]++;
            }

            if (esReina(tablero[j][i + j])) {
                cantidadReinas[1]++;
            }

            if (esReina(tablero[tablero.size() - 1 - j - i][j])) {
                cantidadReinas[2]++;
            }

            if (esReina(tablero[tablero.size() - 1 - j][j + i])) {
                cantidadReinas[3]++;
            }
        }

        if (cantidadReinas[0] > 1 || cantidadReinas[1]  > 1 || cantidadReinas[2] > 1 || cantidadReinas[3] > 1) return true;
    }

    return false;
}
bool amenazasEnColumnas(vector<vector<char>>& tablero) {
    for (int i = 0; i < tablero[0].size(); i++) {
        int cantidadReinas = 0;

        for (int j = 0; j < tablero.size(); j++) {
            if (esReina(tablero[j][i])) {
                cantidadReinas++;
            }
        }

        if (cantidadReinas > 1) return true;
    }

    return false;
}
bool amenazasEnFilas(vector<vector<char>>& tablero) {
    for (int i = 0; i < tablero.size(); i++) {
        int cantidadReinas = 0;

        for (int j = 0; j < tablero[0].size(); j++) {
            if (esReina(tablero[i][j])) {
                cantidadReinas++;
            }
        }

        if (cantidadReinas > 1) return true;
    }

    return false;
}
bool reinasEnAmenaza(vector<vector<char>>& tablero) {
    return amenazasEnFilas(tablero) || amenazasEnColumnas(tablero) || amenazasEnDiagonales(tablero);
}

void limpiarSiguientes(int fila, vector<vector<char>>& tablero, int& n) {
    for (int i = fila; i < n; i++) {
        for (int j = 0; j < n; j++) {
            tablero[i][j] = ' ';
        }
    }
}
int posicionReina(int fila, vector<vector<char>>& tablero, int& n) {
    int columna = 0;

    for (int j = 0; j < n; j++) {
        if (esReina(tablero[fila][j])) {
            columna = j;
        }
    }

    return columna;
}
bool NReinas(int n) {
    vector<vector<char>> tablero(n, vector<char>(n, ' '));

    bool corrigiendo = false;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (!corrigiendo) {
                tablero[i][j] = 'r';

                if (reinasEnAmenaza(tablero)) {
                    if (j + 1 == n) {
                        if (i > 0) {
                            limpiarSiguientes(i, tablero, n);
                            corrigiendo = true;
                            i -= 2;
                            break;
                        } else {
                            return false;
                        }
                    } else {
                        tablero[i][j] = ' ';
                    }
                } else {
                    break;
                }
            } else {
               int reina = posicionReina(i, tablero, n);
               bool salgo = false;

               for (int k = reina; k < n; k++) {
                   if (k + 1 == n) {
                       if (i > 0) {
                           limpiarSiguientes(i, tablero, n);
                           corrigiendo = true;
                           i -= 2;
                           salgo = true;
                           break;
                       } else {
                           return false;
                       }
                   } else {
                       tablero[i][k] = ' ';
                       tablero[i][k + 1] = 'r';

                       if (!reinasEnAmenaza(tablero)) {
                           corrigiendo = false;
                           salgo = true;
                           break;
                       }
                   }
               }

               if (salgo) break;
            }
        }
    }

    imprimirMatriz(tablero);

    return true;
}



