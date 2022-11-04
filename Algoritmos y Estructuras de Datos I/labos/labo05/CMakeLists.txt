cmake_minimum_required(VERSION 3.8)
project(Labo04)

set(CMAKE_CXX_STANDARD 11)

add_subdirectory(lib/googletest-master)
include_directories(lib/googletest-master/googletest/include)

set(SOURCE_FILES
        main.cpp src/ejercicios.cpp
        test/estaOrdenada.cpp
        test/pertenece.cpp
        test/fibonacci.cpp
        test/existePico.cpp
        test/indiceMinimoSubsec.cpp
        test/sumatoria.cpp
        test/ordenar.cpp
        test/sumaDoble.cpp
        test/todosImpares.cpp)
add_executable(Labo04 ${SOURCE_FILES})

target_link_libraries(Labo04 gtest gtest_main)
