cmake_minimum_required(VERSION 3.8)
project(Complejidad)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp ejercicios.cpp ejercicios.h ejercicios_guia.cpp ejercicios_guia.h)
add_executable(Complejidad ${SOURCE_FILES})