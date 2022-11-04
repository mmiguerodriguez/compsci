#include <iostream>
#include <time.h>

#include "HashMapConcurrente.hpp"
#include "CargarArchivos.hpp"

int main(int argc, char **argv) {
    if (argc < 4) {
        std::cout << "Error: faltan argumentos." << std::endl;
        std::cout << std::endl;
        std::cout << "Modo de uso: " << argv[0] << " <threads_lectura> <threads_maximo>" << std::endl;
        std::cout << "    " << "<archivo1> [<archivo2>...]" << std::endl;
        std::cout << std::endl;
        std::cout << "    threads_lectura: "
            << "Cantidad de threads a usar para leer archivos." << std::endl;
        std::cout << "    threads_maximo: "
            << "Cantidad de threads a usar para computar máximo." << std::endl;
        std::cout << "    archivo1, archivo2...: "
            << "Archivos a procesar." << std::endl;
        return 1;
    }
    int cantThreadsLectura = std::stoi(argv[1]);
    int cantThreadsMaximo = std::stoi(argv[2]);

    std::vector<std::string> filePaths = {};
    for (int i = 3; i < argc; i++) {
        filePaths.push_back(argv[i]);
    }

    HashMapConcurrente hashMap{}; // = HashMapConcurrente();

    struct timespec start, stop;
    double loadingHashmap_time;
    double maximo_time;

    clock_gettime(CLOCK_REALTIME, &start);
    cargarMultiplesArchivos(hashMap, cantThreadsLectura, filePaths);
    clock_gettime(CLOCK_REALTIME, &stop);

    loadingHashmap_time = (stop.tv_sec - start.tv_sec) * 1e9 + (stop.tv_nsec - start.tv_nsec);

    clock_gettime(CLOCK_REALTIME, &start);
    auto maximo = hashMap.maximoParalelo(cantThreadsMaximo);
    clock_gettime(CLOCK_REALTIME, &stop);

    maximo_time = (stop.tv_sec - start.tv_sec) * 1e9 + (stop.tv_nsec - start.tv_nsec);

    std::cout << maximo.first << " " << maximo.second << std::endl;

    // Imprimimos el tiempo de ejecución por stderr.
    std::clog << loadingHashmap_time << " " << maximo_time << std::endl;

    return 0;
}
