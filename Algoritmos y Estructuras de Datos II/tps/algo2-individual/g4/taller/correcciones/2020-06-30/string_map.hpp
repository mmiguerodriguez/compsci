
#include "string_map.h"

template <typename T>
string_map<T>::string_map(){
    _raiz = new Nodo();
}

template <typename T>
string_map<T>::string_map(const string_map<T>& aCopiar) : string_map() {
    *this = aCopiar; // Provisto por la catedra: utiliza el operador asignacion para realizar la copia.
}

template <typename T>
string_map<T>& string_map<T>::operator=(const string_map<T>& d) {
    // Itero todas las claves en d e inserto en el actual
    for(auto key : d._keys) {
        insert(make_pair(key, d.at(key)));
    }

    return *this;
}

template <typename T>
string_map<T>::~string_map(){
    // Elimino recursivamente
    _delete_recursive(_raiz);
}

template <typename T>
T& string_map<T>::operator[](const string& clave){
    // Si existe la clave, retorno su referencia
    // Si no existe la clave, inserto con el generador T() y luego retorno su referencia
    if (_keys.count(clave)) {
        return at(clave);
    } else {
        insert(make_pair(clave, T())); // Insertamos con T()
        return at(clave);
    }
}


template <typename T>
int string_map<T>::count(const string& clave) const{
    // Retorno set.count() que funciona igual como deberia esta funcion
    return _keys.count(clave);
}

/**
 * Devuelve la referencia const o no const al valor asignado a una clave
 * Depende de que tipo de diccionario (const o no const) llame a la funcion
 */
template <typename T>
const T& string_map<T>::at(const string& clave) const {
    int i = 0;
    Nodo* n = _raiz;

    while(n && i < clave.length()) {
        n = n->siguientes[clave[i]];
        i++;
    }

    return *n->definicion;
}

template <typename T>
T& string_map<T>::at(const string& clave) {
    int i = 0;
    Nodo* n = _raiz;

    while(n && i < clave.length()) {
        n = n->siguientes[clave[i]];
        i++;
    }

    return *n->definicion;
}

template <typename T>
void string_map<T>::erase(const string& clave) {
    // Borro la definicion de una clave
    // Ademas lo borro de la lista de claves
    int i = 0;
    Nodo* n = _raiz;

    while(n && i < clave.length()) {
        n = n->siguientes[clave[i]];
        i++;
    }

    delete n->definicion;
    n->definicion = nullptr;
    _keys.erase(clave);
}

template <typename T>
int string_map<T>::size() const {
    return _keys.size();
}

template <typename T>
bool string_map<T>::empty() const {
    return _keys.size() == 0;
}

template<typename T>
void string_map<T>::_delete_recursive(Nodo* n) {
    // Elimino recursivamente sus nodos si estan definidos
    // Ademas elimino su definicion que es un puntero/nueva memoria alocada !!
    if (n) {
        for (int i = 0; i < 256; i++) {
            if (n->siguientes[i]) {
                _delete_recursive(n->siguientes[i]);
            }
        }
        delete n->definicion;
        delete n;
    }
}

template<typename T>
void string_map<T>::insert(const pair<string, T>& value_type) {
    // Aloco memoria para el nuevo valor a insertar
    // Voy bajando hasta la posicion donde insertar la definicion
    // En caso de que ya este definido, borro la definicion
    // Seteo el nuevo valor e inserto la clave en el conjunto de claves
    string key = value_type.first;
    T* value = new T(value_type.second);

    int i = 0;
    Nodo* n = _raiz;

    while(n && i < key.length()) {
        Nodo* m = n->siguientes[key[i]];
        if (!m) {
            m = new Nodo();
            n->siguientes[key[i]] = m;
        }

        n = m;
        i++;
    }

    delete n->definicion; // Borro si ya estaba definido
    n->definicion = value;
    _keys.insert(key);
}
