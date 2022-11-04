//
// Created by clinux01 on 28/10/19.
//

#include "auxiliares.h"
#include <vector>
using namespace std;

const vector<int> primos = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97};

int letraAPrimo(char c) {
    int primo = c - 97;
    return primos[primo];
}

vector<int> merge(vector<int>& a, vector<int>& b) {
    vector<int>c(a.size() + b.size(), 0);
    int i = 0;
    int j = 0;

    for(int k = 0; k < c.size(); k++) {
        if(j >= b.size() || (i < a.size() && a[i] < b[j])) {
            c[k] = a[i];
            i++;
        } else {
            c[k] = b[j];
            j++;
        }
    }
    return c;
}

double mediana(vector<int> v) {
    if (v.size() % 2 == 0) {
        int x = v[v.size()/2];
        int y = v[v.size()/2 - 1];
        return (x + y)/2.0f;
    } else {
        return v[v.size()/2];
    }
}

int findMinPosition(vector<int>&s, int d, int h) {
    int min = d;
    for(int i = d + 1; i < h; i++) {
        if (s[i] < s[min]) {
            min = i;
        }
    }
    return min;
}

void swap(vector<int>& s, int i, int minPos) {
    int aux = s[i];
    s[i] = s[minPos];
    s[minPos] = aux;
}

void selectionSort(vector<int>& s) {
    for(int i = 0; i < s.size(); i++) {
        int minPos = findMinPosition(s, i, s.size());
        swap(s, i, minPos);
    }
}