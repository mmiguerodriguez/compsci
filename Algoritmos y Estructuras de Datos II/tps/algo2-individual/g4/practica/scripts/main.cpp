#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <algorithm>
#include <set>
#include <time.h>
#include <stdlib.h>
using namespace std;

vector<int> merge(vector<int> a, vector<int> b, int& operaciones) {
    vector<int> c(a.size() + b.size(), 0);
    int i = 0;
    int j = 0;

    for (int k = 0; k < c.size(); k++) {
        if (j >= b.size() || (i < a.size() && a[i] < b[j])) {
            c[k] = a[i];
            i++;
        } else {
            c[k] = b[j];
            j++;
        }
    }

    operaciones += c.size();

    return c;
}

bool hayRepetidos(vector<int> A) {
    for (int i = 0; i < A.size() - 1; i++) {
        if (A[i] == A[i + 1]) {
            return true;
        }
    }
    return false;
}

vector<int> sonDisjuntosAux(vector<set<int>>& a, int start, int end, int& operaciones) {
    operaciones++;
    if (start == end) {
        vector<int> res;
        for (auto x : a[start]) {
            res.push_back(x);
        }
        return res;
    }

    int h = (start + end)/2;
    vector<int> s1 = sonDisjuntosAux(a, start, h, operaciones);
    vector<int> s2 = sonDisjuntosAux(a, h + 1, end, operaciones);

    vector<int> res = merge(s1, s2, operaciones);
    return res;
}

bool sonDisjuntos(vector<set<int>>& a, int& operaciones) {
    vector<int> res = sonDisjuntosAux(a, 0, a.size() - 1, operaciones);

    return (!hayRepetidos(res));
}

// Usage: ./main.out N M
int main(int argc, char * argv[]) {
  vector<set<int>> v;
  int n_lim = atoi(argv[1]);
  int m_lim = atoi(argv[2]);
  ofstream outfile;

  outfile.open("data_N=" + to_string(n_lim) + "_M=" + to_string(m_lim) + ".txt", ios::app );
  outfile << "n" << "\ttime" << endl;

  for (int n = 1; n <= n_lim; n++) {
    set<int> s;
    for (int m = 0; m < m_lim; m++) {
      int r = rand() % 10000 + 1;
      s.insert(r);
    }

    v.push_back(s);

    int operaciones = 0;
    bool resultado = sonDisjuntos(v, operaciones);
    outfile << n << "\t" << to_string(operaciones) << endl;
  }

  outfile.close();
  return 0;
}
