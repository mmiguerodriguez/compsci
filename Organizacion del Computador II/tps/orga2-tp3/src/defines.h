/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

    Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Bool */
/* -------------------------------------------------------------------------- */
#define TRUE                    0x00000001
#define FALSE                   0x00000000
#define ERROR                   1

/* Atributos paginas */
/* -------------------------------------------------------------------------- */
#define MMU_FREE_PAGES_START    0x100

#define PAG_P                   0x00000001
#define PAG_R                   0x00000000
#define PAG_RW                  0x00000002
#define PAG_S                   0x00000000
#define PAG_US                  0x00000004

/* Misc */
/* -------------------------------------------------------------------------- */
#define SIZE_X                  80
#define SIZE_Y                  40

#define PAGE_SIZE               4096
#define TASK_SIZE               8192

/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_COUNT               40

#define GDT_IDX_NULL_DESC       0

#define GDT_IDX_KERNEL_CODE     8
#define GDT_IDX_KERNEL_DATA     9
#define GDT_IDX_USER_CODE       10
#define GDT_IDX_USER_DATA       11

#define GDT_IDX_VIDEO           12

#define GDT_IDX_INITIAL_TASK    13
#define GDT_IDX_IDLE_TASK       14

/* Offsets en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_OFF_NULL_DESC       (GDT_IDX_NULL_DESC << 3)

#define GDT_OFF_KERNEL_CODE     (GDT_IDX_KERNEL_CODE << 3)
#define GDT_OFF_KERNEL_DATA     (GDT_IDX_KERNEL_DATA << 3)
#define GDT_OFF_USER_CODE       (GDT_IDX_USER_CODE << 3)
#define GDT_OFF_USER_DATA       (GDT_IDX_USER_DATA << 3)

#define GDT_OFF_VIDEO           (GDT_IDX_VIDEO << 3)

#define GDT_OFF_INITIAL_TASK    (GDT_IDX_INITIAL_TASK << 3)
#define GDT_OFF_IDLE_TASK       (GDT_IDX_IDLE_TASK << 3)

/* Atributos de interrupciones */
#define INTERRUPT_0_ATTRS       0x8E00
#define INTERRUPT_3_ATTRS       0xEE00
/* -------------------------------------------------------------------------- */

/* Texto de excepciones */
#define EXCEPTION_0             "0 Divide Error"
#define EXCEPTION_1             "1 Debug"
#define EXCEPTION_2             "2 NMI Interrupt"
#define EXCEPTION_3             "3 Breakpoint"
#define EXCEPTION_4             "4 Overflow"
#define EXCEPTION_5             "5 BOUND Range Exceeded"
#define EXCEPTION_6             "6 Invalid Opcode"
#define EXCEPTION_7             "7 Device Not Available"
#define EXCEPTION_8             "8 Double Fault"
#define EXCEPTION_9             "9 Coprocessor Segment Overrun"
#define EXCEPTION_10            "10 Invalid TSS"
#define EXCEPTION_11            "11 Segment Not Present"
#define EXCEPTION_12            "12 Stack Segment Fault"
#define EXCEPTION_13            "13 General Protection Fault"
#define EXCEPTION_14            "14 Page Fault"
#define EXCEPTION_15            "15 Reserved"
#define EXCEPTION_16            "16 x87 FPU Floating-Point Error"
#define EXCEPTION_17            "17 Alignment Check"
#define EXCEPTION_18            "18 Machine Check"
#define EXCEPTION_19            "19 SIMD Floating-Point Exception"
/* -------------------------------------------------------------------------- */

/* Selectores de segmentos */
/* -------------------------------------------------------------------------- */

/* Direcciones de memoria */
/* -------------------------------------------------------------------------- */
#define BOOTSECTOR               0x00001000 /* direccion fisica de comienzo del bootsector (copiado) */
#define KERNEL                   0x00001200 /* direccion fisica de comienzo del kernel */
#define VIDEO                    0x000B8000 /* direccion fisica del buffer de video */

#define MAP_START                0x00400000
/* -------------------------------------------------------------------------- */

/* Direcciones virtuales de código, pila y datos */
/* -------------------------------------------------------------------------- */
#define TASK_CODE                0x08000000 /* direccion virtual del codigo */
/* -------------------------------------------------------------------------- */

/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<i>_CODE_ADDR.
 */
enum task_type {
  TASK_RICK_C137,
  TASK_MORTY_C137,
  TASK_RICK_D248,
  TASK_MORTY_D248,
  TASK_CRONENBERG
};

#define TASK_RICK_C137_CODE1		 0x10000
#define TASK_RICK_C137_CODE2		 0x11000
#define TASK_MORTY_C137_CODE1		 0x12000
#define TASK_MORTY_C137_CODE2		 0x13000
#define TASK_RICK_D248_CODE1		 0x14000
#define TASK_RICK_D248_CODE2		 0x15000
#define TASK_MORTY_D248_CODE1		 0x16000
#define TASK_MORTY_D248_CODE2		 0x17000
#define TASK_CRONENBERG_CODE1    0x18000
#define TASK_CRONENBERG_CODE2    0x19000
#define TASK_IDLE_CODE           0x1A000

#define TASK_CODE1		           0x08000000
#define TASK_CODE2		           0x08001000

/* -------------------------------------------------------------------------- */

/* Direcciones fisicas de directorios y tablas de paginas del KERNEL */
/* -------------------------------------------------------------------------- */
#define KERNEL_PAGE_DIR          0x00027000
#define KERNEL_PAGE_TABLE_0      0x00028000
#define CRYSTALS_MAP             0x00029000
/* -------------------------------------------------------------------------- */

#endif  /* !__DEFINES_H__ */
