#ifndef CHM_CPP
#define CHM_CPP

#include <thread>
// alternativamente #include <pthread.h>
#include <iostream>
#include <fstream>

#include "HashMapConcurrente.hpp"

HashMapConcurrente::HashMapConcurrente() {
    for (unsigned int i = 0; i < HashMapConcurrente::cantLetras; i++) {
        tabla[i] = new ListaAtomica<hashMapPair>();
        mutex_hashmap[i] = new std::mutex();
        tiempos_threads[i] = 0;
    }
}

unsigned int HashMapConcurrente::hashIndex(std::string clave) {
    return (unsigned int)(clave[0] - 'a');
}

// Completar (Ejercicio 2)
void HashMapConcurrente::incrementar(std::string clave) {
    unsigned int tableIndex = hashIndex(clave);
    bool existe = false;
    unsigned int index = 0;

    mutex_hashmap[tableIndex]->lock();

    for (unsigned int i = 0; i < tabla[tableIndex]->longitud(); i++) {
      if ((*tabla[tableIndex])[i].first == clave) {
        existe = true;
        index = i;
        break;
      }
    }

    if (existe) {
      (*tabla[tableIndex])[index].second++;
    } else {
      hashMapPair element = std::make_pair(clave, 1);
      tabla[tableIndex]->insertar(element);
    }

    mutex_hashmap[tableIndex]->unlock();
}

// Completar (Ejercicio 2)
std::vector<std::string> HashMapConcurrente::claves() {
  std::vector<std::string> res;

  for (unsigned int i = 0; i < HashMapConcurrente::cantLetras; i++) {
    for (unsigned int j = 0; j < tabla[i]->longitud(); j++) {
      res.push_back((*tabla[i])[j].first);
    }
  }

  return res;
}

// Completar (Ejercicio 2)
unsigned int HashMapConcurrente::valor(std::string clave) {
  unsigned int tableIndex = hashIndex(clave);

  for (unsigned int i = 0; i < tabla[tableIndex]->longitud(); i++) {
    if ((*tabla[tableIndex])[i].first == clave) {
      return (*tabla[tableIndex])[i].second;
    }
  }

  return 0;
}

// duda
hashMapPair HashMapConcurrente::maximo() {
  hashMapPair *max = new hashMapPair();
  max->second = 0;

  for (unsigned int i = 0; i <  HashMapConcurrente::cantLetras; i++) {
    mutex_hashmap[i]->lock();
  }

  for (unsigned int index = 0; index < HashMapConcurrente::cantLetras; index++) {
    for (auto &p : *tabla[index]) {
      if (p.second > max->second) {
        max->first = p.first;
        max->second = p.second;
      }
    }
  }

  for (unsigned int i = 0; i <  HashMapConcurrente::cantLetras; i++) {
    mutex_hashmap[i]->unlock();
  }
  // Aca rompe??
  return *max;
}

void HashMapConcurrente::threadMaximo(int i) {
  struct timespec start, stop;
  clock_gettime(CLOCK_REALTIME, &start);
  while (true) {
    mutex_fila.lock();
    int fila = prox_fila;
    prox_fila++;
    mutex_fila.unlock();

    if (fila >= 26) {
      clock_gettime(CLOCK_REALTIME, &stop);
      double thread_time = (stop.tv_sec - start.tv_sec) * 1e9 + (stop.tv_nsec - start.tv_nsec);
      tiempos_threads[i] += thread_time;
      return;
    }

    hashMapPair *max = new hashMapPair();
    max->second = 0;

    for (auto &p : *tabla[fila]) {
      if (p.second > max->second) {
        max->first = p.first;
        max->second = p.second;
      }
    }

    mutex_max_cmp.lock();
    if (max->second > maximoGlobal.second) {
      maximoGlobal = *max;
    }
    mutex_max_cmp.unlock();
  }
}

// Completar (Ejercicio 3)
hashMapPair HashMapConcurrente::maximoParalelo(unsigned int cant_threads) {
  for (unsigned int i = 0; i < HashMapConcurrente::cantLetras; i++) {
    mutex_hashmap[i]->lock();
  }

  prox_fila = 0;
  std::vector<std::thread> threads(cant_threads);

  int i = 0;
  for (std::thread &t : threads) {
    t = std::thread([this, i] {
      this->threadMaximo(i);
    });
    i++;
  }


  for (auto &t : threads) {
    t.join();
  }

  for (unsigned int i = 0; i <  HashMapConcurrente::cantLetras; i++) {
    mutex_hashmap[i]->unlock();
  }

  for (unsigned int i = 0; i < cant_threads; i++) {
    if (i == cant_threads - 1) {
      std::clog << tiempos_threads[i];
    } else {
      std::clog << tiempos_threads[i] << " ";
    }
  }
  std::clog << std::endl;

  return maximoGlobal;
}

#endif
