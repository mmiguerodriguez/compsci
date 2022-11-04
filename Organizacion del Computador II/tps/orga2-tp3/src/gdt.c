/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================
  definicion de la tabla de descriptores globales
*/

#include "gdt.h"

gdt_entry gdt[GDT_COUNT] = {
    /*
    BASE: Direccion a partir de donde comienza el segmento
    LIMIT: Maximo offset que puede tener un segmento
    TYPE: Read/Write/Execute/ExpandDown
    S: System. 0 => kernel, 1 => codigo/datos
    DPL: Descriptor de privilegios. 0 => mas privilegios
    P: Presente en RAM
    DB: Default Big. Tamano del segmento. 0 => 16 bits, 1 => 32 bits
    G: Granularidad. 0 => limite queda igual, 1 => limite = limite * 4096
    AVL: No se usa
    L: Modo de ejecucion. (dejar en 0)
    */

    // Descriptor Nulo
    [GDT_IDX_NULL_DESC] = (gdt_entry) {
      .base_15_0 = 0x0000,
      .base_23_16 = 0x00,
      .base_31_24 = 0x00,
      .limit_15_0 = 0x0000,
      .limit_19_16 = 0x0,
      .type = 0b0000,
      .s = 0,
      .dpl = 0,
      .p = 0,
      .db = 0,
      .g = 0,
      .avl = 0,
      .l = 0
    },

    // Memoria para segmentos de Kernel y Usuario
    // 0x0 -> 0x88FFFFF = 137 MiB
    // DPL: KERNEL = 0, USER = 3
    // TYPE: CODE = R/E, DATA = R/W
    [GDT_IDX_KERNEL_CODE] = {
      .base_15_0 = 0x0000,
      .base_23_16 = 0x00,
      .base_31_24 = 0x00,
      .limit_15_0 = 0x88FF,
      .limit_19_16 = 0x0,
      .type = 0b1010, // Read/Execute
      .s = 1,
      .dpl = 0,
      .p = 1,
      .db = 1,
      .g = 1,
      .avl = 0,
      .l = 0
    },
    [GDT_IDX_KERNEL_DATA] = {
      .base_15_0 = 0x0000,
      .base_23_16 = 0x00,
      .base_31_24 = 0x00,
      .limit_15_0 = 0x88FF,
      .limit_19_16 = 0x0,
      .type = 0b0010, // Read/Write
      .s = 1,
      .dpl = 0,
      .p = 1,
      .db = 1,
      .g = 1,
      .avl = 0,
      .l = 0
    },
    [GDT_IDX_USER_CODE] = {
      .base_15_0 = 0x0000,
      .base_23_16 = 0x00,
      .base_31_24 = 0x00,
      .limit_15_0 = 0x88FF,
      .limit_19_16 = 0x0,
      .s = 1,
      .type = 0b1010, // Read/Execute
      .dpl = 3,
      .p = 1,
      .db = 1,
      .g = 1,
      .avl = 0,
      .l = 0
    },
    [GDT_IDX_USER_DATA] = {
      .base_15_0 = 0x0000,
      .base_23_16 = 0x00,
      .base_31_24 = 0x00,
      .limit_15_0 = 0x88FF,
      .limit_19_16 = 0x0,
      .type = 0b0010, // Read/Write
      .s = 1,
      .dpl = 3,
      .p = 1,
      .db = 1,
      .g = 1,
      .avl = 0,
      .l = 0
    },
    // Memoria para segmento de Video
    // 0xB8000 -> 0xB9F3F = 80 * 50 * 2 bytes = SCREEN_SIZE * BYTES_PER_PIXEL
    [GDT_IDX_VIDEO] = {
      .base_15_0 = 0x8000,
      .base_23_16 = 0x0B,
      .base_31_24 = 0x00,
      .limit_15_0 = 0x1F3F,
      .limit_19_16 = 0x0,
      .type = 0b0010, // Read/Write
      .s = 1,
      .dpl = 0,
      .p = 1,
      .db = 1,
      .g = 0,
      .avl = 0,
      .l = 0
    },
};

gdt_descriptor GDT_DESC = {
    sizeof(gdt) - 1,
    (uint32_t) &gdt
};
