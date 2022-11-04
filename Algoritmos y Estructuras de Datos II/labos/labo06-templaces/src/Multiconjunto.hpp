//
// Created by migue on 20/5/20.
//

#include "Diccionario.hpp"

#ifndef SOLUCION_MULTICONJUNTO_HPP
#define SOLUCION_MULTICONJUNTO_HPP

template<class T>
class Multiconjunto {
public:
    Multiconjunto();
    void agregar(T x);
    int ocurrencias(T x) const;
    bool operator<=(Multiconjunto<T> otro) const;
private:
    Diccionario<T, int> _multiconj;
};

template<class T>
Multiconjunto<T>::Multiconjunto() {
    _multiconj = Diccionario<T, int>();
}

template<class T>
void Multiconjunto<T>::agregar(T x) {
    if (_multiconj.def(x)) {
        int ocurrencias = _multiconj.obtener(x);
       _multiconj.definir(x, ocurrencias + 1);
    } else {
        _multiconj.definir(x, 1);
    }
}

template<class T>
int Multiconjunto<T>::ocurrencias(T x) const {
    return _multiconj.obtener(x);
}

template<class T>
bool Multiconjunto<T>::operator<=(Multiconjunto<T> otro) const {
    std::vector<T> m1 = _multiconj.claves();

    for(int i = 0; i < m1.size(); i++) {
        if (ocurrencias(m1[i]) > otro.ocurrencias(m1[i])) {
            return false;
        }
    }

    return true;
}

#endif //SOLUCION_MULTICONJUNTO_HPP
