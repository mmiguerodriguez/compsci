; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
; definicion de rutinas de atencion de interrupciones

%include "print.mac"

BITS 32

sched_task_offset:     dd 0x0000
sched_task_selector:   dw 0x00000000

extern sched_kill_current_task
extern game_save_exception_info

extern print_scancode
extern screen_drawTasks
extern game_enablePortalGuns
extern game_kill_current_task
extern game_checkEndOfGame

;; PIC
extern pic_finish1

;; Sched
extern sched_nextTask

;; MMU
extern mmu_getPhyAddr

;;
;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

extern debug_mode
extern game_show_debug_info

%macro ISR 1
global _isr%1

_isr%1:
  cmp byte [debug_mode], 0
  je .skip_excep%1
  pushad
  mov eax, [esp + 36] ; pushea eip
  push eax
  pushfd
  push cs
  push ds
  push es
  push gs
  push ss
  push fs
  mov eax, cr0
  push eax
  mov eax, cr2
  push eax
  mov eax, cr3
  push eax
  mov eax, cr4
  push eax
  mov eax, %1
  push eax
  push esp
  call game_save_exception_info
  call game_show_debug_info
  .skip_excep%1:
  call game_kill_current_task
  call sched_kill_current_task

%endmacro


;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;
ISR 0
ISR 1
ISR 2
ISR 3
ISR 4
ISR 5
ISR 6
ISR 7
ISR 8
ISR 9
ISR 10
ISR 11
ISR 12
ISR 13
ISR 14
ISR 15
ISR 16
ISR 17
ISR 18
ISR 19

;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;
global _isr32

extern game_finished
extern screen_incTaskClocks
_isr32:
  pushad

  call pic_finish1

  ; cmp dword [errorEnable], 1
  ; je .fin

  cmp byte [game_finished], 1
  je .fin

  call game_enablePortalGuns
  call nextClock
  call screen_incTaskClocks
  call screen_drawTasks
  call game_checkEndOfGame

  ; Proxima tarea a ejecutar
  call sched_nextTask

  str bx
  cmp ax, bx
  je .fin

  ;xchg bx,bx
  mov word [sched_task_selector], ax
  jmp far [sched_task_offset]

.fin:
  popad
  iret

;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;
global _isr33

_isr33:
  pushad
  call pic_finish1

  in al, 0x60

  push eax
  call print_scancode
  add esp, 4

  popad
  iret

;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;
global _isr137
global _isr138
global _isr139

; usePortalGun(int32_t x, int32_t y, uint32_t cross, uint32_t withMorty)
; x = eax
; y = ebx
; cross = ecx
; withMorty = edx

; eax = worked
; 0 => didn't work
; 1 => worked

extern game_usePortalGun

_isr137:
  push edx
  push ecx
  push ebx
  push eax

  call game_usePortalGun

  add esp, 4 * 4
  iret

extern game_IamRick

; IamRick
_isr138:
  push ax
  call game_IamRick
  add esp, 2
  iret

extern game_whereIsMorty

; whereIsMorty
_isr139:
  sub esp, 4 * 2
  push esp
  call game_whereIsMorty
  add esp, 4 * 1
  pop eax
  pop ebx
  iret


;; Funciones Auxiliares
;; -------------------------------------------------------------------------- ;;
isrNumber:           dd 0x00000000
isrClock:            db '|/-\'
nextClock:
        pushad
        inc DWORD [isrNumber]
        mov ebx, [isrNumber]
        cmp ebx, 0x4
        jl .ok
                mov DWORD [isrNumber], 0x0
                mov ebx, 0
        .ok:
                add ebx, isrClock
                print_text_pm ebx, 1, 0x0f, 49, 79
                popad
        ret
