#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <chrono>
#include <set>
#include <map>
#include <utility> // std::pair

using namespace std;

int UNDEFINED = -1; // Valor para indicar que no hubo solución.
int n; // Cantidad de productos
int resistencia_total; // Resistencia total del jambotubo
vector<pair<int,int>> productos; // Lista de productos <peso, resistencia>

bool esJambotuboValido(vector<pair<int, int>> jambotubo) {
  int pesototal = 0;

  for (int i = jambotubo.size() - 1; i >= 0; i--) {
    if (pesototal > jambotubo[i].second) {
      return false;
    }

    pesototal += jambotubo[i].first;

    if (pesototal > resistencia_total) {
      return false;
    }
  }

  return true;
}
int pesoJambotubo(vector<pair<int,int>> jambotubo) {
  int pesototal = 0;

  for (int i = 0; i < jambotubo.size(); i++) {
    pesototal += jambotubo[i].first;
  }

  return pesototal;
}

// Fuerza Bruta
// i: cantidad de productos revisados
// k: lista de productos agregada
int FB(int i, vector<pair<int, int>> k) {
  if (i == n) {
    return esJambotuboValido(k) ? k.size() : -1;
  }

  int noAgrego = FB(i + 1, k);
  k.push_back(productos[i]);
  int agrego = FB(i + 1, k);

  return max(agrego, noAgrego);
}

// Backtracking
// i: cantidad de productos revisados
// k: lista de productos agregada
bool poda_factibilidad = true;
bool poda_optimalidad = true;
int K = UNDEFINED; // Mejor solucion hasta el momento.

int BT(int i, vector<pair<int,int>> agregados) {
  if (poda_factibilidad && !esJambotuboValido(agregados)) return -1;
  if (poda_optimalidad) {
    int restan = agregados.size() + n - i;
    if (K > restan) return -1;
  }

  if (i == n) {
    if (!esJambotuboValido(agregados)) return -1;
    K = K > agregados.size() ? K : agregados.size();
    return agregados.size();
  }

  int noAgrego = BT(i + 1, agregados);
  agregados.push_back(productos[i]);
  int agrego = BT(i + 1, agregados);

  return max(agrego, noAgrego);
}

vector<vector<int>> M; // Memoria de PD.

// Implementacion Top-down
// i: cantidad de productos por visitar
// w: Peso acumulado de los productos agregados
int PD(int i, int w) {
  if (w > resistencia_total) return -1;

  if (M[i][w] == -1) {
    if (productos[i-1].second < (resistencia_total - w) || productos[i-1].first > w) {
      M[i][w] = PD(i - 1, w);
    } else {
      M[i][w] = max(PD(i - 1, w), PD(i - 1, w - productos[i-1].first) + 1);
    }
  }

  return M[i][w];
}

// Recibe por parámetro qué algoritmos utilizar para la ejecución separados por espacios.
// Imprime por clog la información de ejecución de los algoritmos.
// Imprime por cout el resultado de algun algoritmo ejecutado.
int main(int argc, char** argv) {
	// Leemos el parametro que indica el algoritmo a ejecutar.
	map<string, string> algoritmos_implementados = {
		{"FB", "Fuerza Bruta"}, {"BT", "Backtracking con podas"}, {"BT-F", "Backtracking con poda por factibilidad"},
		{"BT-O", "Backtracking con poda por optimalidad"}, {"DP", "Programacion dinámica"}
	};

	// Verificar que el algoritmo pedido exista.
	if (argc < 2 || algoritmos_implementados.find(argv[1]) == algoritmos_implementados.end()) {
		cerr << "Algoritmo no encontrado: " << argv[1] << endl;
		cerr << "Los algoritmos existentes son: " << endl;
		for (auto& alg_desc: algoritmos_implementados) cerr << "\t- " << alg_desc.first << ": " << alg_desc.second << endl;
		return 0;
	}

	string algoritmo = argv[1];

  // Leemos el input.
  cin >> n >> resistencia_total;
  for (int i = 0; i < n; ++i) {
    int peso;
    int resistencia;
    cin >> peso >> resistencia;

    pair<int, int> producto = make_pair(peso, resistencia);
    productos.push_back(producto);
  }

  // Ejecutamos el algoritmo y obtenemos su tiempo de ejecución.
	int optimum = UNDEFINED;

	auto start = chrono::steady_clock::now();

	if (algoritmo == "FB") {
		optimum = FB(0, vector<pair<int,int>>());
	} else if (algoritmo == "BT") {
		K = UNDEFINED;
		poda_optimalidad = poda_factibilidad = true;
		optimum = BT(0, vector<pair<int,int>>());
	}	else if (algoritmo == "BT-F") {
		K = UNDEFINED;
		poda_optimalidad = false;
		poda_factibilidad = true;
		optimum = BT(0, vector<pair<int,int>>());
	} else if (algoritmo == "BT-O") {
		K = UNDEFINED;
		poda_optimalidad = true;
		poda_factibilidad = false;
		optimum = BT(0, vector<pair<int,int>>());
	} else if (algoritmo == "DP") {
    // Precomputamos la solucion para los estados.
		M = vector<vector<int>>(n + 1, vector<int>(resistencia_total + 1, UNDEFINED));

    for (int j = 0; j < n + 1; j++) {
      M[j][0] = 0;
    }

		for (int j = 0; j < resistencia_total + 1; j++) {
      M[0][j] = 0;
    }

		// Obtenemos la solucion optima.
		optimum = PD(n, resistencia_total);
	}

	auto end = chrono::steady_clock::now();
	double total_time = chrono::duration<double, milli>(end - start).count();

	// Imprimimos el tiempo de ejecución por stderr.
	clog << total_time << endl;

  // Imprimimos el resultado por stdout.
  cout << optimum << endl;

  return 0;
}
