#ifndef RECUPERACIONINFORMACIONMUSICAL_ENTRADASALIDA_H
#define RECUPERACIONINFORMACIONMUSICAL_ENTRADASALIDA_H

#include "definiciones.h"

void escribirAudio(audio a, int canal, string nombreArchivo);
tuple<int, audio> leerAudio(string nombreArchivo);

#endif //RECUPERACIONINFORMACIONMUSICAL_ENTRADASALIDA_H
