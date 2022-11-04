cmake_minimum_required(VERSION 3.12.3)
project(recuperacionInformacionMusical)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

add_subdirectory(lib/googletest-master)
include_directories(lib/googletest-master/googletest/include)

set(SOURCE_FILES_TEST main.cpp solucion.h solucion.cpp auxiliares.cpp auxiliares.h definiciones.h tests/formatoValidoTEST.cpp tests/replicarTEST.cpp tests/revertirAudioTEST.cpp tests/magnitudAbsolutaMaximaTest.cpp tests/redirigirTEST.cpp tests/bajarCalidad.cpp tests/audiosSoftYHard.cpp tests/reemplazarSubAudio.cpp tests/maximosTemporales.cpp tests/limpiarAudio.cpp entradasalida.cpp entradasalida.h graficar.cpp graficar.h)

add_executable(recuperacionInformacionMusical ${SOURCE_FILES_TEST})

set_target_properties(recuperacionInformacionMusical PROPERTIES COMPILE_FLAGS "-g --coverage")
set_target_properties(recuperacionInformacionMusical PROPERTIES LINK_FLAGS "-g --coverage")

set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE 1)

target_link_libraries(recuperacionInformacionMusical gtest)

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR})