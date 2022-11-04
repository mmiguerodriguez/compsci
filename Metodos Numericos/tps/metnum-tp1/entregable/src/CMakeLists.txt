cmake_minimum_required(VERSION 3.14.5)
project(src)

set(CMAKE_CXX_STANDARD 14)

add_executable(tp1 main.cpp Clases/Equipo.cpp Clases/Equipo.h Clases/SistemaLineal.cpp Clases/SistemaLineal.hpp Clases/Partida.cpp Clases/Partida.h Clases/Torneo.cpp Clases/Torneo.h)