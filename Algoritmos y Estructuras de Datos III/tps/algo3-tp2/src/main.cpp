#include <iostream>
#include <vector>
#include <bits/stdc++.h>
#include <chrono>
#include <ctime>
#include <stdlib.h>
#include <time.h>

using namespace std;

// Definiciones para vertices/aristas/grafo
typedef int Vertice;
typedef pair<Vertice, Vertice> Arista;
typedef int Peso;
struct Vecino {
  Vertice dst;
  Peso peso;
  Vecino(Vertice d, Peso p): dst(d), peso(p) {}
};
typedef vector<vector<Vecino>> Grafo;
typedef pair<vector<Vertice>, Peso> Solucion;

// Construimos el grafo a partir de n vertices y m aristas
Grafo leerGrafo(int n, int m) {
  Grafo G(n, vector<Vecino>());
  for (int i = 0; i < m; i++) {
    int v, w, peso;
    cin >> v >> w >> peso;
    G[v - 1].push_back(Vecino(w - 1, peso));
    G[w - 1].push_back(Vecino(v - 1, peso));
  }
  return G;
}

// Retorna el peso de un ciclo dentro de un grafo G
Peso peso(Grafo &G, vector<Vertice> &C) {
  Peso total = 0;
  for (int i = 0; i < C.size(); i++) {
    Vertice v = C[i];
    Vertice w = i == C.size() - 1 ? 0 : C[i + 1];

    for (Vecino &y: G[v]) {
      if (y.dst == w) {
        total += y.peso;
      }
    }
  }

  return total;
}

/* Vecino Mas Cercano */
// Verificar si un vertice no pertenece al circuito actual
bool noPerteneceACircuito(vector<bool> &usados, Vertice &v) {
  return !usados[v];
}
Solucion vecinoMasCercano(Grafo &G) {
  vector<Vertice> H;
  Vertice v = 0;
  H.push_back(v);

  vector<bool> usados(G.size(), false);
  usados[0] = true;

  int pesoTotal = 0;
  while (H.size() < G.size()) {
    Vertice w = -1;
    int min = INT_MAX;
    // Buscamos al vecino de menor peso que no este en el circuito
    for (Vecino &vecino: G[v]) {
      if (vecino.peso < min && noPerteneceACircuito(usados, vecino.dst)) {
        min = vecino.peso;
        w = vecino.dst;
      }
    }

    // Agrego al vecino de menor peso y sumo al pesototal
    pesoTotal += min;
    H.push_back(w);
    usados[w] = true;
    v = w;
  }

  // Sumamos el peso entre el vertice final y el inicial
  for (Vecino &v : G[v]) {
    if (v.dst == 0) {
      pesoTotal += v.peso;
    }
  }

  // Formateamos el circuito
  for (Vertice &v: H) {
    v += 1;
  }

  return make_pair(H, pesoTotal);
}

/* Arista mas corta */
// Calcula grado de un vertice en el circuito actual
int grado(vector<int> &grados, Vertice &v) {
  return grados[v];
}

// Retorna si agregando una arista no estamos formando un circuito
bool noFormaCircuito(vector<Arista> &Xt, Arista e) {
  Arista actual(-1, -1);

  // Buscamos la primer arista que contenga al vertice "u" de e = (u,v)
  for (int i = 0; i < Xt.size(); i++) {
    if (Xt[i].first == e.first) {
      actual = Xt[i];
    } else if (Xt[i].second == e.first) {
      actual = make_pair(e.first, Xt[i].first);
    }
  }

  // Si no existe, no forma circuito
  if (actual.first == -1) return true;

  // Recorremos el camino para ver si forma un circuito
  int i = 0;
  while (i < Xt.size()) {
    for (Arista arista: Xt) {
      if (actual.second == arista.first && actual.first != arista.second) {
        actual = arista;
        break;
      } else if (actual.second == arista.second && actual.first != arista.first) {
        actual = make_pair(arista.second, arista.first);
        break;
      }
    }

    if (actual.first == e.second || actual.second == e.second) {
      return false;
    }

    i++;
  }

  return true;

}
Solucion aristaMasCorta(Grafo &G) {
  vector<Arista> Xt;
  int i = 1;
  Peso total = 0;

  vector<int> grados(G.size(), 0);

  // Para cada iteracion encontramos la arista e = (u,v) de menor peso que cumpla
  // - Ambos vertices u,v tengan grado en el camino actual (Xt) <= 1
  // - La arista e no forma un circuito en el camino actual (Xt)
  while (i <= G.size() - 1) {
    pair<Vertice, Vertice> e;
    Peso minimo = INT_MAX;

    for (int u = 0; u < G.size(); u++) {
      int grado_u = grado(grados, u);
      for (Vecino &v: G[u]) {
        int grado_v = grado(grados, v.dst);
        if (v.peso < minimo && grado_u <= 1 && grado_v <= 1 && noFormaCircuito(Xt, make_pair(u, v.dst))) {
          e = make_pair(u, v.dst);
          minimo = v.peso;
        }
      }
    }

    total += minimo;
    grados[e.first]++;
    grados[e.second]++;
    Xt.push_back(e);
    i++;
  }

  // Agrega la ultima arista que cierra el circuito
  for (int u = 0; u < G.size(); u++) {
    for (Vecino &v: G[u]) {
      if (grado(grados, u) == 1 && grado(grados, v.dst) == 1) {
        total += v.peso;
        grados[u]++;
        grados[v.dst]++;
        Xt.push_back(make_pair(u, v.dst));
      }
    }
  }

  // Formateo del circuito
  vector<Vertice> circuito;
  i = 0;
  Arista actual = make_pair(-1, -1);

  // Buscamos la arista inicial
  while (actual.first == -1) {
    if (Xt[i].first == 0) {
      actual = Xt[i];
    } else if (Xt[i].second == 0) {
      actual = make_pair(Xt[i].second, Xt[i].first);
    }
    i++;
  }

  circuito.push_back(1);
  i = 0;

  // Dada la arista inicial recorremos el camino en orden
  while (actual.second != 0) {
    if (Xt[i].first == actual.second && Xt[i].second != actual.first) {
      actual = Xt[i];
      circuito.push_back(actual.first + 1);
      i = 0;
    } else if (Xt[i].second == actual.second && Xt[i].first != actual.first) {
      actual = make_pair(actual.second, Xt[i].first);
      circuito.push_back(actual.first + 1);
      i = 0;
    } else {
      i++;
    }
  }

  return make_pair(circuito, total);
}

/* Heuristica AGM */
Grafo agm(Grafo &G) {
  vector<Arista> Xt;
  vector<Peso> pesos;
  int i = 1;

  vector<int> grados(G.size(), 0);

  // Generamos AGM al estilo Kruskal
  while (i <= G.size() - 1) {
    pair<Vertice, Vertice> e;
    Peso minimo = INT_MAX;

    for (int u = 0; u < G.size(); u++) {
      for (Vecino &v: G[u]) {
        if (v.peso < minimo && grado(grados, u) <= 1 && grado(grados, v.dst) <= 1 && noFormaCircuito(Xt, make_pair(u, v.dst))) {
          e = make_pair(u, v.dst);
          minimo = v.peso;
        }
      }
    }

    pesos.push_back(minimo);
    grados[e.first]++;
    grados[e.second]++;
    Xt.push_back(e);
    i++;
  }

  // Creamos el grafo a partir del AGM con los mismos pesos para las aristas
  Grafo res(G.size(), vector<Vecino>());
  for (int i = 0; i < Xt.size(); i++) {
    res[Xt[i].first].push_back(Vecino(Xt[i].second, pesos[i]));
    res[Xt[i].second].push_back(Vecino(Xt[i].first, pesos[i]));
  }

  return res;
}
// Se fija si existe un vecino del vertice i que no este en la lista l y lo retorna
Vertice vecinoNoVisitado(Vertice &i, vector<Vertice> &l, Grafo &T) {
  for (Vecino &j: T[i]) {
    bool esta = false;

    for (Vertice &v: l) {
      if (v == j.dst) {
        esta = true;
      }
    }

    if (!esta) {
      return j.dst;
    }
  }

  return -1;
}
// DFS sobre un grafo
vector<Vertice> dfs(Grafo &T) {
  vector<Vertice> orden;
  vector<Vertice> lista;
  lista.push_back(0);
  orden.push_back(0);

  while(lista.size() != 0) {
    Vertice i = lista[lista.size() - 1];
    // si existe un arco i,j tal que j no en lista
    Vertice j = vecinoNoVisitado(i, orden, T);
    if (j != -1) {
      orden.push_back(j);
      lista.push_back(j);
    } else {
      lista.pop_back();
    }
  }

  orden.push_back(0);
  return orden;
}
Solucion arbolGeneradorMinimo(Grafo &G) {
  Grafo T = agm(G);
  vector<Vertice> D = dfs(T);

  // Obtenemos el peso total del camino D
  Peso total = 0;
  for (int i = 0; i < D.size() - 1; i++) {
    for (Vecino &v: G[D[i]]) {
      if (v.dst == D[i + 1]) {
        total += v.peso;
        break;
      }
    }
  }

  // Borramos el nodo inicial
  D.pop_back();

  for (Vertice &v: D) {
    v++;
  }

  return make_pair(D, total);
}

/* Taboo Search basado en últimas soluciones exploradas */
// Dar vuelta un vector de vertices
vector<Vertice> darVuelta(vector<Vertice> v) {
  for(int i = 0; i < v.size() / 2; i++) {
    Vertice mem = v[i];
    v[i] = v[v.size() - 1 - i];
    v[v.size() - 1 - i] = mem;
  }

  return v;
}
// Retorna una lista de n2 ciclos vecinos usannod 2opt
vector<vector<Vertice>> dos_opt(vector<Vertice> v) {
  vector<vector<Vertice>> res;

  for (int i = 1; i < v.size(); i++) {
    for (int j = i + 1; j < v.size(); j++) {
      vector<Vertice> inicio = {v.begin(), v.begin() + i};
      vector<Vertice> invertirMedio = darVuelta({v.begin() + i, v.begin() + j + 1});
      vector<Vertice> fin = {v.begin() + j + 1, v.end()};

      vector<Vertice> nuevo;
      nuevo.insert(nuevo.end(), inicio.begin(), inicio.end());
      nuevo.insert(nuevo.end(), invertirMedio.begin(), invertirMedio.end());
      nuevo.insert(nuevo.end(), fin.begin(), fin.end());
      res.push_back(nuevo);
    }
  }

  return res;
}
// Retorna si un ciclo esta en la memoria tabu
bool estaEnMemoria(vector<Vertice> &ciclo, vector<vector<Vertice>> &memoria) {
  for (int i = 0; i < memoria.size(); i++) {
    bool esIgual = true;
    for (int j = 0; j < memoria[i].size(); j++) {
      if (ciclo[j] != memoria[i][j]) {
        esIgual = false;
      }
    }
    if (esIgual) return true;
  }

  return false;
}
// Retorna el ciclo de menor peso de una lista de ciclos
vector<Vertice> mejorVecino(vector<vector<Vertice>> vecinos, vector<vector<Vertice>> &memoria, Grafo &G, int cant_vecinos) {
  vector<vector<Vertice>> mejoresVecinos;

  for (int j = 0; j < cant_vecinos && vecinos.size() > 0; j++) {
    int mejorVecinoIndice = 0;
    vector<Vertice> mejorVecinoActual = vecinos[0];
    Peso menorPeso = peso(G, mejorVecinoActual);

    for (int i = 1; i < vecinos.size(); i++) {
      int pesoVecino = peso(G, vecinos[i]);
      if (pesoVecino < menorPeso && !estaEnMemoria(vecinos[i], memoria)) {
        mejorVecinoIndice = i;
        mejorVecinoActual = vecinos[i];
        menorPeso = pesoVecino;
      }
    }

    mejoresVecinos.push_back(mejorVecinoActual);
    vecinos.erase(vecinos.begin() + mejorVecinoIndice);
  }

  int indice_random = rand() % mejoresVecinos.size() + 0;
  return mejoresVecinos[indice_random];
}
Solucion tabuSearch(Grafo &G, int tam_memoria, int cant_vecinos, int cant_iteraciones) {
  vector<Vertice> s = arbolGeneradorMinimo(G).first;
  for (Vertice &v: s) { v--; }

  vector<Vertice> s_opt = s;
  vector<vector<Vertice>> memoria(tam_memoria);
  memoria[0] = s;

  int i = 1;
  int iteraciones = 0;

  // Vemos vecinos de la solucion, si no hay mejoras en base al mejor encontrado no seguimos buscando
  while (iteraciones < cant_iteraciones) {
    vector<vector<Vertice>> vecinos = dos_opt(s); // s_local,
    s = mejorVecino(vecinos, memoria, G, cant_vecinos);

    if (peso(G, s) < peso(G, s_opt)) {
      s_opt = s;
    }

    if (i == tam_memoria) i = 0;
    memoria[i] = s;
    i++;
    iteraciones++;
  }

  Peso total = peso(G, s_opt);
  for (Vertice &v: s_opt) { v++; }

  return make_pair(s_opt, total);
}

/* Tabu Search basado en aristas */
// 2-opt pero solo obteniendo las aristas
vector<pair<Arista, Arista>> dos_opt_aristas(vector<Vertice> v) {
  vector<pair<Arista, Arista>> res;

  for (int i = 1; i < v.size(); i++) {
    for (int j = i + 1; j < v.size() - 1; j++) {
      pair<Arista, Arista> newRes = make_pair(make_pair(v[i - 1], v[i]), make_pair(v[j], v[j + 1]));
      res.push_back(newRes);
    }
    pair<Arista, Arista> newRes = make_pair(make_pair(v[i - 1], v[i]), make_pair(v[v.size() - 1], v[0]));
    res.push_back(newRes);
  }

  return res;
}
vector<pair<Arista, Arista>> rotarAristas(vector<Vertice> v) {
  vector<pair<Arista, Arista>> res;
  for (int i = 1; i < v.size() - 2; i++) {
    res.push_back(make_pair(make_pair(v[i - 1], v[i]), make_pair(v[i + 1], v[i + 2])));
  }
  return res;
}
int posicionEnCiclo(vector<Vertice> &v, Vertice u) {
  for (int i = 0; i < v.size(); i++) {
    if (v[i] == u) {
      return i;
    }
  }
  return -1; // nunca deberia pasar
}
bool estaEnMemoriaArista(pair<Arista, Arista> &vecino, vector<pair<Arista, Arista>> &memoria) {
  for (int i = 0; i < memoria.size(); i++) {
    if (vecino.first == memoria[i].first && vecino.second == memoria[i].second) {
      return true;
    }
  }

  return false;
}
vector<Vertice> armar_dos_opt(vector<Vertice> &v, int i, int j) {
  vector<Vertice> inicio = {v.begin(), v.begin() + i};
  vector<Vertice> invertirMedio = darVuelta({v.begin() + i, v.begin() + j + 1});
  vector<Vertice> fin = {v.begin() + j + 1, v.end()};

  vector<Vertice> nuevo;
  nuevo.insert(nuevo.end(), inicio.begin(), inicio.end());
  nuevo.insert(nuevo.end(), invertirMedio.begin(), invertirMedio.end());
  nuevo.insert(nuevo.end(), fin.begin(), fin.end());

  return nuevo;
}

Peso pesoArista(Grafo &G, Arista a) {
  for(Vecino x: G[a.first]) {
    if(x.dst == a.second) return x.peso;
  }

  return -1;
}

pair<Arista, Arista> mejorVecinoAristas(vector<Vertice> s, vector<pair<Arista, Arista>> &vecinos, vector<pair<Arista, Arista>> &memoria, Grafo &G, int cant_vecinos) {
  vector<pair<Arista, Arista>> mejoresVecinos;

  for (int j = 0; j < cant_vecinos && vecinos.size() > 0; j++) {
    pair<Arista, Arista> mejorArista = vecinos[0];
    int mejorVecinoIndice = 0;

    Peso pesoS = peso(G, s);
    Peso menorPeso = pesoS -
            pesoArista(G, vecinos[0].first) -
            pesoArista(G, vecinos[0].second) +
            pesoArista(G, make_pair(vecinos[0].first.first, vecinos[0].second.first)) +
            pesoArista(G, make_pair(vecinos[0].first.second, vecinos[0].second.second));

    for (int i = 1; i < vecinos.size(); i++) {
      vector<Vertice> resParcial;

      Peso pesoVecino = pesoS -
                        pesoArista(G, vecinos[i].first) -
                        pesoArista(G, vecinos[i].second) +
                        pesoArista(G, make_pair(vecinos[i].first.first, vecinos[i].second.first)) +
                        pesoArista(G, make_pair(vecinos[i].first.second, vecinos[i].second.second));
      if (pesoVecino < menorPeso && !estaEnMemoriaArista(vecinos[i], memoria)) {
        mejorVecinoIndice = i;
        mejorArista = vecinos[i];
        menorPeso = pesoVecino;
      }
    }

    mejoresVecinos.push_back(mejorArista);
    vecinos.erase(vecinos.begin() + mejorVecinoIndice);

  }

  int indice_random = rand() % mejoresVecinos.size() + 0;
  return mejoresVecinos[indice_random];
}
Solucion tabuSearchAristas(Grafo &G, int tam_memoria, int cant_vecinos, int cant_iteraciones) {
  vector<Vertice> s = arbolGeneradorMinimo(G).first;
  for (Vertice &v: s) { v--; }

  vector<Vertice> s_opt = s;
  vector<pair<Arista, Arista>> memoria(tam_memoria);

  int i = 0;
  int iteraciones = 0;

  while (iteraciones < cant_iteraciones) {
    vector<pair<Arista, Arista>> vecinos = dos_opt_aristas(s);
    pair<Arista, Arista> swap = mejorVecinoAristas(s, vecinos, memoria, G, cant_vecinos);

    int a = posicionEnCiclo(s, swap.first.second);
    int b = posicionEnCiclo(s, swap.second.first);

    s = armar_dos_opt(s, a, b);

    if (peso(G, s) < peso(G, s_opt)) {
      s_opt = s;
    }

    if (i == tam_memoria) i = 0;
    memoria[i] = swap;
    i++;
    iteraciones++;
  }

  Peso total = peso(G, s_opt);
  for (Vertice &v: s_opt) { v++; }

  return make_pair(s_opt, total);
}

/* Auxiliares */
void print(Solucion s) {
  cout << s.first.size() << " " << s.second << endl;
  for (Vertice &v: s.first) {
    cout << v << " ";
  }
  cout << endl;
}

int main(int argc, char** argv) {
  if (argc < 2) {
    cout << "ERROR" << endl;
    return 1;
  }

  srand (time(NULL));

  int N;
  int M;
  cin >> N >> M;

  Grafo G = leerGrafo(N, M);

  auto start = std::chrono::system_clock::now();
  Solucion s;
  if (!strcmp(argv[1], "VMC")) {
    s = vecinoMasCercano(G);
  } else if (!strcmp(argv[1], "AMC")) {
    s = aristaMasCorta(G);
  } else if (!strcmp(argv[1], "AGM")) {
    s = arbolGeneradorMinimo(G);
  } else if (!strcmp(argv[1], "TS")) {
    int tam_memoria = stoi(argv[2]);
    int cant_vecinos = stoi(argv[3]);
    int cant_iteraciones = stoi(argv[4]);
    s = tabuSearch(G, tam_memoria, cant_vecinos, cant_iteraciones);
  } else if (!strcmp(argv[1], "TSA")) {
    int tam_memoria = stoi(argv[2]);
    int cant_vecinos = stoi(argv[3]);
    int cant_iteraciones = stoi(argv[4]);
    s = tabuSearchAristas(G, tam_memoria, cant_vecinos, cant_iteraciones);
  }
  auto end = std::chrono::system_clock::now();

  print(s);

  chrono::duration<double> elapsed_seconds = end - start;
  time_t end_time = chrono::system_clock::to_time_t(end);

  clog << elapsed_seconds.count() << " " << s.second << endl;

  return 0;
}
