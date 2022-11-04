#include "Lista.h"

Lista::Lista() {
    _first = NULL;
    _last = NULL;
    _length = 0;
}

Lista::Lista(const Lista& l) : Lista() {
    //Inicializa una lista vacía y luego utiliza operator= para no duplicar el código de la copia de una lista.
    *this = l;
}

Lista::~Lista() {
    Nodo* node = _first;
    while (node) {
        Nodo* sig = node->sig;
        delete node;
        node = sig;
    }

    _first = NULL;
    _last = NULL;
    _length = 0;
}

Lista& Lista::operator=(const Lista& aCopiar) {
    // Borro lo que haya
    // Decidi no llamar al destructor y hacerlo manualmente porque no se si es una buena practica.
    Nodo* node = _first;
    while (node) {
        Nodo* sig = node->sig;
        delete node;
        node = sig;
    }
    _first = NULL;
    _last = NULL;
    _length = 0;

    int length = aCopiar.longitud();

    // Seteo nuevos valores copiados
    for(int i = 0; i < length; i++) {
        this->agregarAtras(aCopiar.iesimo(i));
    }

    _length = length;

    return *this;
}

void Lista::agregarAdelante(const int& elem) {
    Nodo* node = new Nodo();
    node->data = elem;

    if (_first) {
        _first->ant = node;
        node->sig = _first;
    }

    if (!_last) {
        _last = node;
    }

    _first = node;
    _length++;
}

void Lista::agregarAtras(const int& elem) {
    Nodo* node = new Nodo();
    node->data = elem;

    if (_last) {
        _last->sig = node;
        node->ant = _last;
    }

    if (!_first) {
        _first = node;
    }

    _last = node;
    _length++;
}

void Lista::eliminar(Nat i) {
    Nodo* node = _first;
    Nat j = 0;

    while (node) {
        Nodo* sig = node->sig;

        /* Busco el nodo a eliminar
        Casos:
          - Es el primero
            - Calcular nuevo primero
            - Si hay, le seteo el anterior como NULL
          - Es el ultimo
            - Calcular nuevo ultimo
            - Si hay, le seteo el siguiente como NULL
          - Es uno en el medio
            - Setear los valores de los adyacentes
        */
        if (j == i) {
            if (i == 0) {
                if (_first) {
                    Nodo* newFirst = _first->sig;
                    if (newFirst) {
                        newFirst->ant = NULL;
                    }
                    delete _first;
                    _first = newFirst;
                }
            } else if (!sig) {
                Nodo* newLast = _last->ant;
                newLast->sig = NULL;
                delete _last;
                _last = newLast;
            } else {
                node->ant->sig = node->sig;
                node->sig->ant = node->ant;
                delete node;
            }

            break;
        }

        j++;
        node = sig;
    }

    _length--;
}

int Lista::longitud() const {
    return _length;
}

/*
  En iesimo recorro la lista hasta encontrar el indice
  que me piden, y luego retorno el valor encontrado

  Podria agregar un checkeo que i < _length que los tests
  no tienen en cuenta
*/

const int& Lista::iesimo(Nat i) const {
    Nodo* node = _first;
    Nat j = 0;

    while (node) {
        if (i == j) {
            return node->data;
        }
        node = node->sig;
        j++;
    }

    assert(false);
}

int& Lista::iesimo(Nat i) {
    Nodo* node = _first;
    Nat j = 0;

    while (node) {
        if (i == j) {
            return node->data;
        }
        node = node->sig;
        j++;
    }

    assert(false);
}

void Lista::mostrar(ostream& o) {
    o << "[";
    Nodo* node = _first;

    while (node) {
        o << node->data;
        node = node->sig;
        if (node) {
            o << ", ";
        }
    }

    o << "]" << endl;
}
