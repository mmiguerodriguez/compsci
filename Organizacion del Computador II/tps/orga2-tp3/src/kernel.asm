; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================

%include "print.mac"

; Define
%define KERNEL_PAGE_DIR  (0x00027000)
%define DATA0_SEGMENT    (9 << 3)
%define VIDEO_SEGMENT    (12 << 3)
%define TSS_INIT_SEGMENT (13 << 3)
%define TSS_IDLE         (14 << 3)

; Globales
global start

; Externas
extern GDT_DESC

extern IDT_DESC
extern idt_init
extern pic_reset
extern pic_enable

extern mmu_init
extern mmu_initKernelDir
extern mmu_mapPage
extern mmu_unmapPage
extern mmu_initTaskDir

extern tss_init
extern tss_init_idle_task

extern sched_init

extern game_init

;; Saltear seccion de datos
jmp start

;;
;; Seccion de datos.
;; -------------------------------------------------------------------------- ;;
start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

;;
;; Seccion de código.
;; -------------------------------------------------------------------------- ;;

;; Punto de entrada del kernel.
BITS 16
start:
    ; Deshabilitar interrupciones
    cli

    ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida
    print_text_rm start_rm_msg, start_rm_len, 0x07, 0, 0

    ; Habilitar A20
    call A20_enable

    ; Cargar la GDT
    lgdt [GDT_DESC]

    ; Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Saltar a modo protegido
    jmp 0x40:modo_protegido

BITS 32
modo_protegido:
    ; Establecer selectores de segmentos
    xor eax, eax
    mov ax, DATA0_SEGMENT
    mov ds, ax
    mov es, ax
    mov gs, ax
    mov ss, ax

    mov ax, VIDEO_SEGMENT
    mov fs, ax

    ; Establecer la base de la pila
    mov ebp, 0x27000
    mov esp, 0x27000

    ; Imprimir mensaje de bienvenida
    print_text_pm start_pm_msg, start_pm_len, 0x07, 0, 0

    ; Inicializar pantalla
    call map_init

    ; Inicializar el manejador de memoria
    call mmu_init

    ; Inicializar el directorio de paginas
    call mmu_initKernelDir

    ; Cargar directorio de paginas
    mov cr3, eax

    ; Habilitar paginacion
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    ; Inicializar la IDT
    call idt_init

    ; Cargar IDT
    lidt [IDT_DESC]

    ; Configurar controlador de interrupciones
    call pic_reset
    call pic_enable

    ; Inicializar tss
    call tss_init

    ; Inicializar tss de la tarea Idle
    call tss_init_idle_task

    ; Inicializar el scheduler
    call sched_init

    ; Inicializar game
    call game_init

    ; Cargar tarea inicial
    mov ax, TSS_INIT_SEGMENT
    ltr ax

    ; Habilitar interrupciones
    sti

    ; Saltar a la primera tarea: Idle
    jmp TSS_IDLE:0x0

    ; Ciclar infinitamente (por si algo sale mal...)
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

;; -------------------------------------------------------------------------- ;;

%include "a20.asm"
%include "map.asm"
