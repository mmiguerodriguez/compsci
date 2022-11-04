//
// Created by migue on 20/5/20.
//

#ifndef SOLUCION_DICCIONARIO_HPP
#define SOLUCION_DICCIONARIO_HPP

template<class Clave, class Valor>
class Diccionario {
public:
    Diccionario();
    void definir(Clave k, Valor v);
    bool def(Clave k) const;
    Valor obtener(Clave k) const;
    std::vector<Clave> claves() const;
private:
    std::vector<std::tuple<Clave, Valor>> _asociaciones;
};

template<class Clave, class Valor>
Diccionario<Clave, Valor>::Diccionario() {
    std::vector<std::tuple<Clave, Valor>> vec(0);
    _asociaciones = vec;
}

template<class Clave, class Valor>
void Diccionario<Clave, Valor>::definir(Clave k, Valor v) {
    for (unsigned int i = 0; i < _asociaciones.size(); i++) {
        if (std::get<0>(_asociaciones[i]) == k) {
            std::get<1>(_asociaciones[i]) = v;
            return;
        }
    }
    std::tuple<Clave, Valor> asoc = std::make_tuple(k, v);

    _asociaciones.push_back(asoc);
}

template<class Clave, class Valor>
bool Diccionario<Clave, Valor>::def(Clave k) const {
    for (unsigned int i = 0; i < _asociaciones.size(); i++) {
        if (std::get<0>(_asociaciones[i]) == k) {
            return true;
        }
    }

    return false;
}

template<class Clave, class Valor>
Valor Diccionario<Clave, Valor>::obtener(Clave k) const {
    for (unsigned int i = 0; i < _asociaciones.size(); i++) {
        if (std::get<0>(_asociaciones[i]) == k) {
            return std::get<1>(_asociaciones[i]);
        }
    }
}

template<class Clave, class Valor>
std::vector<Clave> Diccionario<Clave, Valor>::claves() const {
    std::vector<Clave> vec(0);
    if (_asociaciones.size() == 0) return vec;

    for (int i = 0; i < _asociaciones.size(); i++) {
        vec.push_back(std::get<0>(_asociaciones[i]));
    }

    std::vector<Clave> vec2(0);
    Clave min = vec[0];
    int i = 0;
    int minIdx = 0;

    while(i < vec.size()) {
        Clave e = vec[i];
        if (e < min) {
            minIdx = i;
            min = e;
        }

        if (i + 1 == vec.size()) {
            vec.erase(vec.begin() + minIdx);
            vec2.push_back(min);
            min = vec[0];
            i = 0;
            minIdx = 0;
        } else {
            i++;
        }
    }

    return vec2;
}

#endif //SOLUCION_DICCIONARIO_HPP
