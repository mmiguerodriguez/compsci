#include "Conjunto.h"

template <class T>
Conjunto<T>::Conjunto() {
    _size = 0;
    _raiz = NULL;
}

template <class T>
Conjunto<T>::~Conjunto() {
    _destruir(_raiz);
}

template<class T>
void Conjunto<T>::_destruir(Nodo* n) {
    if (n != NULL) {
        _destruir(n->izq);
        _destruir(n->der);
        delete n;
    }
}

template <class T>
bool Conjunto<T>::pertenece(const T& clave) const {
    Nodo* n = _raiz;
    while (n) {
        T value = n->valor;
        if (value == clave) {
            return true;
        } else if (clave > value) {
            n = n->der;
        } else {
            n = n->izq;
        }
    }

    return false;
}

template <class T>
void Conjunto<T>::insertar(const T& clave) {
    if (pertenece(clave)) return;

    Nodo* i = new Nodo(clave);
    _size++;

    if (!_raiz) {
        _raiz = i;
    } else {
        Nodo* n = _raiz;
        while (n) {
            T value = n->valor;
            if (clave > value) {
                if (!n->der) {
                    n->der = i;
                    return;
                }
                n = n->der;
            } else {
                if (!n->izq) {
                    n->izq = i;
                    return;
                }
                n = n->izq;
            }
        }
    }
}

template <class T>
void Conjunto<T>::remover(const T& clave) {
    if (!pertenece(clave)) return;

    Nodo* p = NULL; // padre
    Nodo* n = _raiz;
    bool s = false; // lado por el que entre la ultima vez (0 = izq, 1 = der)

    while (n) {
        T value = n->valor;
        if (value == clave) {
            if (n->izq && n->der) {
                T next = siguiente(clave);
                remover(next); // borro de la lista el siguiente
                n->valor = next;
            } else if (n->izq) {
                if (n == _raiz) {
                    _raiz = n->izq;
                } else {
                    if (!s) p->izq = n->izq;
                    else p->der = n->izq;
                }

                _size--;
                delete n;
            } else if (n->der) {
                if (n == _raiz) {
                    _raiz = n->der;
                } else {
                    if (!s) p->izq = n->der;
                    else p->der = n->der;
                }

                _size--;
                delete n;
            } else {
                if (n == _raiz) {
                    _raiz = NULL;
                } else {
                    if (!s) p->izq = NULL;
                    else p->der = NULL;
                }

                _size--;
                delete n;
            }

            return;
        } else if (clave > value) {
            p = n;
            n = n->der;
            s = true;
        } else {
            p = n;
            n = n->izq;
            s = false;
        }
    }

    assert(false);
}

template <class T>
const T& Conjunto<T>::siguiente(const T& clave) {
    Nodo* n = _raiz; // Nodo iterador
    Nodo* s = _raiz; // Nodo siguiente

    while (n) {
        // Reemplazamos el siguiente por el iterador en 2 casos
        // 1 => el valor del siguiente > iterador > clave (iterador tiene un siguente mas chico)
        // 2 => el valor del siguente <= clave (no es el siguiente)
        if (n->valor > clave) {
            if (s->valor > n->valor && s->valor > clave || !(s->valor > clave)) {
                s = n;
            }
            n = n->izq;
        } else {
            n = n->der;
        }
    }

    return s->valor;
}

template <class T>
const T& Conjunto<T>::minimo() const {
    Nodo* n = _raiz;
    while (n) {
        if (!n->izq) return n->valor;
        n = n->izq;
    }
}

template <class T>
const T& Conjunto<T>::maximo() const {
    Nodo* n = _raiz;
    while (n) {
        if (!n->der) return n->valor;
        n = n->der;
    }
}

template <class T>
unsigned int Conjunto<T>::cardinal() const {
    return _size;
}

template <class T>
void Conjunto<T>::mostrar(std::ostream&) const {
    assert(false);
}
