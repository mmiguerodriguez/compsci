cmake_minimum_required(VERSION 3.5)
project(mi_proyecto)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "-pthread")

include_directories(lib/gtest)
include_directories(src/puntaje)
include_directories(src/sandia)
add_library(gtest lib/gtest/gtest-all.cc
        src/matrices/matrices.cpp
        src/matrices/matrices.h
        src/puntaje/puntaje.cpp
        test/temperaturaPromedioTTEST.cpp
        test/temperaturaPromedioZTest.cpp
        test/elevarTEST.cpp
        test/matricesQueSumanNTEST.cpp
        test/sopaDeLetrasTEST.cpp
        test/filasDondeAlgunosSumanNTEST.cpp)

add_executable(mi_proyecto
        src/sandia/sandia.cpp
        src/sandia/sandia.h
        test/puntajeTEST.cpp
        test/sandiaTEST.cpp
        test/temperaturaPromedioTTEST.cpp
        test/temperaturaPromedioZTest.cpp
        test/matricesQueSumanNTEST.cpp
        test/correrTests.cpp
        test/sopaDeLetrasTEST.cpp
        test/filasDondeAlgunosSumanNTEST.cpp)


set_target_properties(mi_proyecto PROPERTIES COMPILE_FLAGS "-g --coverage")
set_target_properties(mi_proyecto PROPERTIES LINK_FLAGS "-g --coverage")

target_link_libraries(mi_proyecto gtest)



# Para corre LCOV:
# lcov --capture --directory taller --output-file coverage.info
# genhtml coverage.info --output-directory cobertura
# Y luego abrir la carpeta COBERTURA y explorar los archivos HTML.
