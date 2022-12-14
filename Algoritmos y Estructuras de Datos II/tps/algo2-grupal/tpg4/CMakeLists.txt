cmake_minimum_required(VERSION 3.5)
project(tp3_simcity)

# Algunos flags para pasar al compilador (gnu++11 en vez de c++11 para que sea cross-plat)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=gnu++11 -ggdb3 -g")

# Dependencia de Google Test
SET(BUILD_GMOCK OFF)
SET(BUILD_GTEST ON)
add_library(gtest STATIC tests/gtest-1.8.1/gtest-all.cc)
add_library(gtest_main STATIC tests/gtest-1.8.1/gtest_main.cc)

# Leemos todos los archivos fuentes en ./src
file(GLOB SOURCE_FILES src/*.cpp src/*.h src/*.hpp)

# Leemos todos los archivos de test en ./tests
file(GLOB TEST_SOURCES tests/*.cpp)

add_executable(correrTestsMapa ${SOURCE_FILES} tests/mapa-tests.cpp)
add_executable(correrTestsSimCity ${SOURCE_FILES} tests/simcity-tests.cpp)

# Necesitamos asociar los archivos del framework de testing
target_link_libraries(correrTestsMapa gtest gtest_main)
target_link_libraries(correrTestsSimCity gtest gtest_main)

# Test suites a ejecutar
add_test(correrTestsMapa mapa_test)
add_test(correrTestsSimCity simcity_test)

# Target para correr Valgrind
add_custom_target(correrValgrindMapa
        valgrind --leak-check=full -v ./correrTestsMapa 2>&1
        DEPENDS correrTestsMapa)
add_custom_target(correrValgrindSimCity
        valgrind --leak-check=full -v ./correrTestsSimCity 2>&1
        DEPENDS correrTestsSimCity)