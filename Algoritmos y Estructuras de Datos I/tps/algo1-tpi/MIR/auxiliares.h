#ifndef RECUPERACIONINFORMACIONMUSICAL_AUXILIARES_H
#define RECUPERACIONINFORMACIONMUSICAL_AUXILIARES_H

#include "definiciones.h"

// Auxiliares dados
bool vectoresOrdenadosIguales(vector<int> vector1, vector<int> vector2);
void ASSERT_VECTOR(vector<int> vector1, vector<int> vector2);
void ASSERT_MATRIX(vector<audio> mat1, vector<audio> mat2);

// formatoValido
bool todosEnRango(audio &s, int p);

// revertirAudio
void bloqueRevertido(audio& a, int i, int canal, audio& res);

// redirigir
int clip(int v1, int v2, int p);
bool estaEnCanal(int posicion, int canal, int canales);

// reemplazarSubAudio
bool iguales(audio &a, audio &a1, int d, int h);
void reemplazar(audio &a, audio &a2, int d, int h);

// limpiarAudio
audio ordenar(audio a);
int findMinPos(audio &s, int d, int h);
void swap(audio &s, int i, int minPos);
bool esOutlier(vector<int> &v, int k);
tuple<bool, int> posNoOutIzq(audio a, vector<int> &o, int d);
tuple<bool, int> posNoOutDer(audio a, vector<int> &o, int d);

#endif //RECUPERACIONINFORMACIONMUSICAL_AUXILIARES_H
