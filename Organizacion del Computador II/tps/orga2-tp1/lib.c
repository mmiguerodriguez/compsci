#include "lib.h"

/** STRING **/
void hexPrint(char* a, FILE *pFile) {
    int i = 0;
    while (a[i] != 0) {
        fprintf(pFile, "%02hhx", a[i]);
        i++;
    }
    fprintf(pFile, "00");
}

/** Lista **/
void listRemove(list_t* l, void* data, funcCmp_t* fc, funcDelete_t* fd) {
  listElem_t* elem = l->first;

  listElem_t* firstNotDeleted = NULL;
  listElem_t* lastNotDeleted = NULL;
  listElem_t* next = NULL;

  while (elem) {
    next = elem->next;

    if (fc(elem->data, data) == 0) {
      if (fd) {
        fd(elem->data);
      }

      free(elem);

      // Si no hay mas nodos, y ademas hubo alguno sin eliminar
      // entonces el ultimo no eliminado es el ultimo
      if (!next && lastNotDeleted) {
        lastNotDeleted->next = NULL;
      }
    } else {
      // Si no hay mas nodos, entonces es el ultimo
      if (!next) {
        elem->next = NULL;
      }

      // El anterior al actual es el ultimo no eliminado
      // Notar que puede ser NULL en el caso que elem sea el primer elemento
      elem->prev = lastNotDeleted;

      // El siguiente del anterior no eliminado es este
      if (lastNotDeleted) {
        lastNotDeleted->next = elem;
      }

      // Si es el primero que no se elimina, entonces es el primero
      if (!firstNotDeleted) {
        firstNotDeleted = elem;
      }

      // Nos guardamos el ultimo nodo que no fue eliminado
      lastNotDeleted = elem;
    }

    elem = next;
  }

  l->first = firstNotDeleted;
  l->last = lastNotDeleted;
}

void listRemoveFirst(list_t* l, funcDelete_t* fd) {
    if (l->first) {
        listElem_t* actual = l->first;
        if (actual->data) {
           if (fd) {
             fd(actual->data);
           }
        }
        actual->next->prev = NULL;
        l->first = actual->next;
        free(actual);
    }
}

void listRemoveLast(list_t* l, funcDelete_t* fd) {
  // Primero checkeo que haya un ultimo
  if (l->last) {
    listElem_t* newLast = l->last->prev;

    if (fd) {
      fd(l->last->data);
    }

    free(l->last);

    // Si habia un anterior al ultimo, actualizamos sus punteros
    // Caso contrario, la lista va a quedar vacia
    if (newLast) {
      l->last = newLast;
      newLast->next = NULL;
    } else {
      l->first = NULL;
      l->last = NULL;
    }
  }
}
