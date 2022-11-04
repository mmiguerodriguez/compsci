
#include "ColaPrior.h"

template<class T>
ColaPrior<T>::ColaPrior() {

}

template<class T>
int ColaPrior<T>::tam() const {
	return _heap.size();
}

template<class T>
void ColaPrior<T>::encolar(const T& elem) {
	_heap.push_back(elem);
	_siftUp(tam() - 1);
}

template<class T>
const T& ColaPrior<T>::proximo() const {
	return _heap[0];
}

template<class T>
void ColaPrior<T>::desencolar() {
//    Reemplazar la ra´ız del ´arbol por el “´ultimo” elemento,respetando la forma del heap.
//    Borrar el “´ultimo” elemento.
//    (Sift down) desde la raiz

    // Swap
    int n = tam() - 1;
    swap(_heap[0], _heap[n]);

    _heap.pop_back();

    _siftDown(0);
}

template<class T>
ColaPrior<T>::ColaPrior(const vector<T>& elems) {
    for (int i = 0; i < elems.size(); i++) {
	    _heap.push_back(elems[i]);
	}

    int n = _heap.size();

    for (int i = n/2; i >= 0; i--) {
        _siftDown(i);
    }
}

template<class T>
int ColaPrior<T>::_left(int i) {
    return 2 * i;
}

template<class T>
int ColaPrior<T>::_right(int i) {
    return 2 * i + 1;
}

template<class T>
int ColaPrior<T>::_parent(int i) {
    return i / 2;
}

template<class T>
void ColaPrior<T>::_siftDown(int i) {
//    siftDown (arreglo v, nat i) O(log n)
//      Si v[i] no es hoja
//        m = max(v[hijo izq(i)], v[hijo der(i)])
//        Si m > v[i]
//          swap(v[i],m)
//          siftDown(v,´ındice(m))

    if (!_esHoja(i)) {
        int idx = _left(i);
        T m = _heap[_left(i)];
        if (_right(i) < tam()) {
            if (_heap[_left(i)] < _heap[_right(i)]) {
                idx = _right(i);
                m = _heap[_right(i)];
            }
        }

        if (m > _heap[i]) {
            swap(_heap[idx], _heap[i]);
            _siftDown(idx);
        }
    }
}

template<class T>
void ColaPrior<T>::_siftUp(int i) {
//    siftUp (arreglo v, nat i) O(log n)
//    Si i != 0 y v[i] > v[padre(i)]
//      swap(v[i],v[padre(i)])
//      siftUp(v,padre(i))

    int parent = _parent(i);

    if (i != 0 && _heap[i] > _heap[parent]) {
        swap(_heap[i], _heap[parent]);
        _siftUp(parent);
    }
}

template<class T>
bool ColaPrior<T>::_esHoja(int i) {
    return (_right(i) >= tam() && _left(i) >= tam());
}

