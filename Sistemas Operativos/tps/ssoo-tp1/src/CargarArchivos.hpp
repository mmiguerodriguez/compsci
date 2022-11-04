#ifndef HMC_ARCHIVOS_HPP
#define HMC_ARCHIVOS_HPP

#include <ctype.h>
#include <vector>
#include <string>
#include <thread>
// #inclide <pthread.h>

#include "HashMapConcurrente.hpp"

int cargarArchivo(
    HashMapConcurrente &hashMap,
    std::string filePath
);

void cargarMultiplesArchivos(
    HashMapConcurrente &hashMap,
    unsigned int cantThreads,
    std::vector<std::string> filePaths
);

void threadArchivo(unsigned int *i, std::mutex *mutex_archivos, std::vector<std::string> filePaths, HashMapConcurrente &hashMap);

#endif /* HMC_ARCHIVOS_HPP */
