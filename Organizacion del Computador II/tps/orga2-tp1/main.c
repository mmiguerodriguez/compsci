#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include "lib.h"

char* randomString(uint32_t l) {
  char* s = malloc(l + 1);

  for(uint32_t i = 0; i < (l + 1); i++) {
    s[i] = (char)(33 + (rand()%(126 - 33)));
  }

  s[l] = 0;
  return s;
}

void test_string(FILE* pfile) {
  fprintf(pfile, "===== String\n");

  char* a;
  char* b;
  char* c;

  fprintf(pfile,"==> Clone\n");
  a = strClone("ORGA2");
  b = strClone("TP1");
  strPrint(a, pfile); fprintf(pfile, "\n");
  strPrint(b,pfile); fprintf(pfile, "\n");

  fprintf(pfile,"==> Concat\n");
  c = strConcat(a, b);
  strPrint(c, pfile); fprintf(pfile, "\n");

  fprintf(pfile, "==> Cmp\n");
  fprintf(pfile, "cmp(%s, %s) = %d", c, c, strCmp(c, c)); fprintf(pfile, "\n");
  fprintf(pfile, "cmp(%s, %s) = %d", "a", "b", strCmp("a", "b")); fprintf(pfile, "\n");
  fprintf(pfile, "cmp(%s, %s) = %d", "b", "a", strCmp("b", "a")); fprintf(pfile, "\n");

  strDelete(c);

  fprintf(pfile, "\n");
}

void test_lista(FILE *pfile) {
  fprintf(pfile, "===== List\n");

  list_t* l = listNew();
  for (int i = 0; i < 10; i++) {
    listAddFirst(l, randomString(i));
  }

  listPrint(l, pfile, (funcPrint_t*)&strPrint); fprintf(pfile, "\n");
  listDelete(l, (funcDelete_t*)&strDelete);

  fprintf(pfile, "\n");
}

void test_sorter(FILE *pfile) {
  fprintf(pfile, "===== Sorter\n");

  sorter_t* s = sorterNew(5, (funcSorter_t*)&fs_sizeModFive, (funcCmp_t*)&strCmp);
  for (int i = 0; i < 5; i++) {
    sorterAdd(s, randomString(i));
  }

  sorterPrint(s, pfile, (funcPrint_t*)&strPrint);
  sorterDelete(s, (funcDelete_t*)strDelete);
}

int main (void){
    srand(12345);

    FILE *pfile = fopen("salida.caso.propios.txt", "w");

    test_string(pfile);
    test_lista(pfile);
    test_sorter(pfile);

    fclose(pfile);
    return 0;
}
