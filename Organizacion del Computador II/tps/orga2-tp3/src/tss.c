/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de estructuras para administrar tareas
*/

#include "tss.h"

tss tss_initial;
tss tss_idle;

void tss_init_gdt_entry(uint32_t index, uint32_t base) {
  gdt[index].base_15_0 = base & 0xFFFF ;
  gdt[index].base_23_16 = (base >> 16) & 0xFF;
  gdt[index].base_31_24 = (base >> 24) & 0xFF;
  gdt[index].limit_15_0 = sizeof(tss) - 1;
  gdt[index].limit_19_16 = 0x0;
  gdt[index].type = 0b1001;
  gdt[index].s = 0;
  gdt[index].dpl = 0;
  gdt[index].p = 1;
  gdt[index].db = 0;
  gdt[index].g = 0;
  gdt[index].avl = 0;
  gdt[index].l = 0;
}

void tss_init() {
  tss_init_gdt_entry(GDT_IDX_INITIAL_TASK, (uint32_t)&tss_initial);
}

void tss_init_idle_task() {
  tss_init_gdt_entry(GDT_IDX_IDLE_TASK, (uint32_t)&tss_idle);

  tss_idle.esp 		= KERNEL_PAGE_DIR;
  tss_idle.ebp 		= 0x00000000; // KERNEL_PAGE_DIR;
  tss_idle.eip  	= TASK_IDLE_CODE;
  tss_idle.cr3 		= KERNEL_PAGE_DIR;
  tss_idle.es 		= GDT_OFF_KERNEL_DATA;
  tss_idle.cs 		= GDT_OFF_KERNEL_CODE;
  tss_idle.ss 		= GDT_OFF_KERNEL_DATA;
  tss_idle.ds 		= GDT_OFF_KERNEL_DATA;
  tss_idle.fs 		= GDT_OFF_KERNEL_DATA;
  tss_idle.gs 		= GDT_OFF_KERNEL_DATA;
  tss_idle.eflags = 0x00000202;
  tss_idle.iomap 	= 0xFFFF;
}

uint32_t tss_init_task(enum task_type task, uint32_t index_gdt, uint8_t x, uint8_t y) {
  // Uso memoria del area libre del kernel para el TSS de la tarea
  tss* task_tss = (tss*) mmu_nextFreeKernelPage();

  // Hago lo mismo para tener un stack nivel 0
  uint32_t kernel_stack =  mmu_nextFreeKernelPage();

  // Me guardo el puntero al directorio de paginas de la tarea
  uint32_t task_page_directory = mmu_initTaskDir(task, x, y);

  // Inicializo su entrada en la gdt con su base
  tss_init_gdt_entry(index_gdt, (uint32_t) task_tss);

  // TSS de la tarea
	(*task_tss).ptl 	   = 0x0000;
  (*task_tss).esp0 	   = kernel_stack + 0x1000; // empieza desde el final
  (*task_tss).ss0 		 = GDT_OFF_KERNEL_DATA;
  (*task_tss).esp1     = 0x00000000;
  (*task_tss).ss1 		 = 0x0000;
  (*task_tss).esp2 	   = 0x00000000;
  (*task_tss).ss2 		 = 0x0000;

  (*task_tss).cr3 		 = task_page_directory;
  (*task_tss).eip 		 = 0x08000000;
  (*task_tss).eflags   = 0x00000202;

  (*task_tss).eax 		 = 0x00000000;
  (*task_tss).ecx 		 = 0x00000000;
  (*task_tss).edx 		 = 0x00000000;
  (*task_tss).ebx 		 = 0x00000000;
  (*task_tss).esp 		 = 0x08002000;
  (*task_tss).ebp 		 = 0x00000000;
  (*task_tss).esi 		 = 0x00000000;
  (*task_tss).edi 		 = 0x00000000;

  (*task_tss).es       = GDT_OFF_USER_DATA | 0x3;
  (*task_tss).cs 		   = GDT_OFF_USER_CODE | 0x3;
  (*task_tss).ss 		   = GDT_OFF_USER_DATA | 0x3;
  (*task_tss).ds 		   = GDT_OFF_USER_DATA | 0x3;
  (*task_tss).fs 		   = GDT_OFF_USER_DATA | 0x3;
  (*task_tss).gs 		   = GDT_OFF_USER_DATA | 0x3;

  (*task_tss).ldt 		 = 0x0000;
  (*task_tss).dtrap 	 = 0x0000;
	(*task_tss).iomap 	 = 0xFFFF;

  (*task_tss).unused0  = 0x0000;
  (*task_tss).unused1  = 0x0000;
  (*task_tss).unused2  = 0x0000;
  (*task_tss).unused3  = 0x0000;
  (*task_tss).unused4  = 0x0000;
  (*task_tss).unused5  = 0x0000;
  (*task_tss).unused6  = 0x0000;
  (*task_tss).unused7  = 0x0000;
  (*task_tss).unused8  = 0x0000;
  (*task_tss).unused9  = 0x0000;
  (*task_tss).unused10 = 0x0000;

  return task_page_directory;
}
