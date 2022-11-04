#ifndef HMC_HPP
#define HMC_HPP

#include <mutex>
#include <array>
#include <atomic>
#include <string>
#include <vector>

#include "ListaAtomica.hpp"

typedef std::pair<std::string, unsigned int> hashMapPair;

class HashMapConcurrente {
 public:
    static constexpr int cantLetras = 26;

    HashMapConcurrente();

    void incrementar(std::string clave);
    std::vector<std::string> claves();
    unsigned int valor(std::string clave);

    hashMapPair maximo();
    hashMapPair maximoParalelo(unsigned int cantThreads);
 private:
    ListaAtomica<hashMapPair> *tabla[HashMapConcurrente::cantLetras];

    static unsigned int hashIndex(std::string clave);

    std::mutex *mutex_hashmap[HashMapConcurrente::cantLetras];
    double tiempos_threads[HashMapConcurrente::cantLetras];

    unsigned int prox_fila;
    std::mutex mutex_fila;
    std::mutex mutex_max_cmp;

    hashMapPair maximoGlobal;
    void threadMaximo(int i);
};

#endif  /* HMC_HPP */
