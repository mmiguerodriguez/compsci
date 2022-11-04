Funciones a implementar en lenguaje ensamblador

- String

char* strClone(char* a)

uint32_t strLen(char* a)

int32_t strCmp(char* a, char* b)

char* strConcat(char* a, char* b)

void strDelete(char* a)

void strPrint(char* a, FILE *pFile)

- List

list_t* listNew()

void listAddFirst(list_t* l, void* data)

void listAddLast(list_t* l, void* data)

void listAdd(list_t* l, void* data, funcCmp_t* fc)

list_t* listClone(list_t* l, funcDup_t* fn)

void listDelete(list_t* l, funcDelete_t* fd)

void listPrint(list_t* l, FILE *pFile, funcPrint_t* fp)


- Sorter

sorter_t* sorterNew(uint16_t slots, funcSorter_t* fs, funcCmp_t* fc)

void sorterAdd(sorter_t* sorter, void* data)

void sorterRemove(sorter_t* sorter, void* data, funcDelete_t* fd)

list_t* sorterGetSlot(sorter_t* sorter, uint16_t slot, funcDup_t* fn)

char* sorterGetConcatSlot(sorter_t* sorter, uint16_t slot)

void sorterCleanSlot(sorter_t* sorter, uint16_t slot, funcDelete_t* fd)

void sorterDelete(sorter_t* sorter, funcDelete_t* fd)

void sorterPrint(sorter_t* sorter, FILE *pFile, funcPrint_t* fp)

- Funciones Sorter

uint16_t fs_sizeModFive(char* s)

uint16_t fs_firstChar(char* s)

uint16_t fs_bitSplit(char* s)

Funciones a implementar en C

void listRemoveFirst(list_t* l, funcDelete_t* fd)

void listRemoveLast(list_t* l, funcDelete_t* fd)

void listRemove(list_t* l, void* data, funcCmp_t* fc, funcDelete_t* fd)


