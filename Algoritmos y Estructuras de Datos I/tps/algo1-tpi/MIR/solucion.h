#ifndef RECUPERACIONINFORMACIONMUSICAL_SOLUCION_H
#define RECUPERACIONINFORMACIONMUSICAL_SOLUCION_H
#include "definiciones.h"

bool formatoValido(audio &a, int canal, int profundidad);
audio replicar(audio a, int canal, int profundidad);
audio revertirAudio(audio a, int canal, int profundidad);
void magnitudAbsolutaMaxima(audio a, int canal, int profundidad, vector<int> &maximos, vector<int> &posicionesMaximos);
audio redirigir(audio a, int canal, int profundidad);
void bajarCalidad(vector<audio> & as, int profundidad1, int profundidad2);
void audiosSoftYHard(vector<audio> as, int profundidad, int longitud, int umbral, vector<audio>& soft, vector<audio>& hard);
void reemplazarSubAudio(audio& a, audio a1, audio a2, int profundidad);
void maximosTemporales(audio a, int profundidad, vector<int> tiempos, vector<int>& maximos, vector<pair<int,int>> &intervalos);
void limpiarAudio(audio& a, int profundidad, vector<int>& outliers);

#endif //RECUPERACIONINFORMACIONMUSICAL_SOLUCION_H
