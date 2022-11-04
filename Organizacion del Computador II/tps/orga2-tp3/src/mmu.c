/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#include "mmu.h"

uint32_t nextFreePage;

void mmu_init() {
  nextFreePage = MMU_FREE_PAGES_START;
}

uint32_t mmu_initKernelDir() {
  uint32_t* page_directory = (uint32_t *) KERNEL_PAGE_DIR;
  uint32_t* page_table_0 = (uint32_t *) KERNEL_PAGE_TABLE_0;

  for (uint32_t i = 0; i < 1024; i++) {
    page_directory[i] = 0;
    page_table_0[i] = (i << 12) | PAG_P | PAG_RW | PAG_S;
  }

  page_directory[0] = BASE_VALUE(KERNEL_PAGE_TABLE_0) | PAG_P | PAG_RW | PAG_S;

  return KERNEL_PAGE_DIR;
}

uint32_t mmu_nextFreeKernelPage() {
  uint32_t* page_table = (uint32_t*) (nextFreePage << 12);

	for (uint32_t i = 0; i < 1024; i++) {
		page_table[i] = 0;
  }

	return ((nextFreePage++) << 12);
}

void mmu_mapPage(uint32_t cr3, uint32_t virtual, uint32_t phy, uint32_t attrs) {
  // Calculo indice de directorio y tabla que busco
	uint32_t page_directory_idx = PAGE_DIRECTORY_IDX(virtual);
  uint32_t page_table_idx = PAGE_TABLE_IDX(virtual);

  // Calculo tabla
	uint32_t page_directory_entry = BASE_PTR(cr3)[page_directory_idx];

  // Si la tabla no esta presente entonces hago una nueva
  uint32_t page_table_entry = BASE_PTR(cr3)[page_directory_idx];
	if (!ENTRY_PRESENT(page_directory_entry)) {
		page_table_entry = mmu_nextFreeKernelPage() | PAG_P | PAG_RW | PAG_US;
		BASE_PTR(cr3)[page_directory_idx] = page_table_entry;
	}

  // Le seteo a la entrada de la tabla la direccion fisica a la que mapea
  // con sus atributos
	uint32_t page_entry = BASE_VALUE(phy) | attrs;
	BASE_PTR(page_table_entry)[page_table_idx] = page_entry;

  tlbflush();
}

void mmu_unmapPage(uint32_t cr3, uint32_t virtual) {
  // Calculo el indice de directorio y la tabla que voy a sacar
  uint32_t page_directory_idx = PAGE_DIRECTORY_IDX(virtual);
  uint32_t page_table_entry = BASE_PTR(cr3)[page_directory_idx];

  // En el caso que este presente, calculo su indice y la seteo en 0
  if (ENTRY_PRESENT(page_table_entry)) {
    uint32_t page_table_idx = PAGE_TABLE_IDX(virtual);
    BASE_PTR(page_table_entry)[page_table_idx] = 0;
  }

  tlbflush();
}

uint32_t mmu_initTaskDir(enum task_type task, uint8_t x, uint8_t y) {
  // Solicito PD y PT
  uint32_t* page_directory = (uint32_t*) mmu_nextFreeKernelPage();
  uint32_t* page_table = (uint32_t*) mmu_nextFreeKernelPage();

  // Seteo la tabla a la que apunta el page directory
  page_directory[0] = BASE_VALUE(page_table) | PAG_P | PAG_RW | PAG_S;

  // Construyo identity mapping para los primeros 4MB
  for (uint32_t i = 0; i < 1024; i++) {
    page_table[i] = (i << 12) | PAG_P | PAG_RW | PAG_S;
  }

  // Identifico codigo de las tareas
  uint32_t* code1;
  uint32_t* code2;
  if (task == TASK_RICK_C137) {
    code1 = (uint32_t*) TASK_RICK_C137_CODE1;
    code2 = (uint32_t*) TASK_RICK_C137_CODE2;
  } else if (task == TASK_MORTY_C137) {
    code1 = (uint32_t*) TASK_MORTY_C137_CODE1;
    code2 = (uint32_t*) TASK_MORTY_C137_CODE2;
  } else if (task == TASK_RICK_D248) {
    code1 = (uint32_t*) TASK_RICK_D248_CODE1;
    code2 = (uint32_t*) TASK_RICK_D248_CODE2;
  } else if (task == TASK_MORTY_D248) {
    code1 = (uint32_t*) TASK_MORTY_D248_CODE1;
    code2 = (uint32_t*) TASK_MORTY_D248_CODE2;
  } else if (task == TASK_CRONENBERG) {
    code1 = (uint32_t*) TASK_CRONENBERG_CODE1;
    code2 = (uint32_t*) TASK_CRONENBERG_CODE2;
  }

  // Identifico la posicion en donde copiar el codigo
  uint32_t phy_pos1 = MAP_START + (x * TASK_SIZE) + (y * SIZE_X * TASK_SIZE);
  uint32_t phy_pos2 = phy_pos1 + PAGE_SIZE;

  // Copiar las dos paginas de la tarea
  mmu_copyPage(code1, phy_pos1);
  mmu_copyPage(code2, phy_pos2);

  // Mapear la tarea copiada
  mmu_mapPage((uint32_t) page_directory, TASK_CODE1, phy_pos1, PAG_P | PAG_RW | PAG_US);
	mmu_mapPage((uint32_t) page_directory, TASK_CODE2, phy_pos2, PAG_P | PAG_RW | PAG_US);

  return (uint32_t) page_directory;
}

void mmu_copyPage(uint32_t* code, uint32_t phy) {
  // Mapear el codigo para poder acceder a esa memoria
  mmu_mapPage(rcr3(), phy, phy, PAG_P | PAG_RW | PAG_S);

  // Copiar el codigo
	for (int i = 0; i < 1024; i++) {
		((uint32_t*) phy)[i] = code[i];
  }

  // Desmapear
	mmu_unmapPage(rcr3(), phy);
}

uint32_t mmu_getPhyAddr(uint32_t cr3, uint32_t addr) {
  // Calculo indice en pagina de directorios
  uint32_t page_directory_idx = ((addr & 0xFFC00000) >> 22);
  // Calculo la entrada de la pagina
  uint32_t page_directory_entry = BASE_PTR(cr3)[page_directory_idx];

  // Calculo indice de pagina
  uint32_t page_table_idx = ((addr & 0x003FF000) >> 12);
  // Calculo donde esta en la tabla de paginas
  uint32_t page_table_entry = BASE_PTR(page_directory_entry)[page_table_idx];
  // Calculo la posicion fisica para el address dado
  uint32_t phy_addr = page_table_entry & 0xFFFFF000;
  return phy_addr;
}
