#ifndef CHM_CPP
#define CHM_CPP

#include <vector>
#include <iostream>
#include <fstream>
#include <pthread.h>

#include "CargarArchivos.hpp"

int cargarArchivo(
    HashMapConcurrente &hashMap,
    std::string filePath
) {
    std::fstream file;
    int cant = 0;
    std::string palabraActual;

    // Abro el archivo.
    file.open(filePath, file.in);
    if (!file.is_open()) {
        std::cerr << "Error al abrir el archivo '" << filePath << "'" << std::endl;
        return -1;
    }

    // Completar (Ejercicio 4)
    while (file >> palabraActual) {
        hashMap.incrementar(palabraActual);
        cant++;
    }

    // Cierro el archivo.
    if (!file.eof()) {
        std::cerr << "Error al leer el archivo" << std::endl;
        file.close();
        return -1;
    }
    file.close();

    return cant;
}

void threadArchivo(unsigned int *i, std::mutex *mutex_archivos, std::vector<std::string> filePaths, HashMapConcurrente &hashMap) {
  while(true) {
    mutex_archivos->lock();
    unsigned int archivo = *i;
    (*i)++;
    mutex_archivos->unlock();

    if (archivo >= filePaths.size()) return;

    cargarArchivo(hashMap, filePaths[archivo]);
  }
}

// Completar (Ejercicio 4)
void cargarMultiplesArchivos(
    HashMapConcurrente &hashMap,
    unsigned int cantThreads,
    std::vector<std::string> filePaths
) {
  std::mutex mutex_archivos;
  unsigned int prox_archivo = 0;
  std::vector<std::thread> threads(cantThreads);

  for (std::thread &t : threads) {
    t = std::thread(threadArchivo, &prox_archivo, &mutex_archivos, filePaths, std::ref(hashMap));
  }

  for (auto &t : threads) {
    t.join();
  }
}

#endif
