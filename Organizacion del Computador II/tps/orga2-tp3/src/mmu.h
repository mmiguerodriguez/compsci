/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de funciones del manejador de memoria
*/

#ifndef __MMU_H__
#define __MMU_H__

#include "stdint.h"
#include "defines.h"
#include "i386.h"
#include "tss.h"
#include "game.h"

#define PAGE_DIRECTORY_IDX(ptr)	((((uint32_t)(ptr)) & 0xFFC00000) >> 22)
#define PAGE_TABLE_IDX(ptr)	    ((((uint32_t)(ptr)) & 0x003FF000) >> 12)

#define BASE_VALUE(ptr)		      (((uint32_t)(ptr)) & 0xFFFFF000)
#define BASE_PTR(ptr)		        ((uint32_t*)(BASE_VALUE(ptr)))
#define ENTRY_PRESENT(entry)	  (((uint32_t)(entry)) & 0x1 )

void mmu_init();

uint32_t mmu_nextFreeKernelPage();

void mmu_mapPage(uint32_t cr3, uint32_t virtual, uint32_t phy, uint32_t attrs);

void mmu_unmapPage(uint32_t cr3, uint32_t virtual);

uint32_t mmu_initKernelDir();

uint32_t mmu_initTaskDir(enum task_type task, uint8_t x, uint8_t y);

void mmu_copyPage(uint32_t* code, uint32_t phy);

uint32_t mmu_getPhyAddr(uint32_t cr3, uint32_t addr);

#endif	/* !__MMU_H__ */
