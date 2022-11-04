; Funciones para inciar mapa

BITS 32

%define WIDTH  80
%define HEIGHT 50

%define C_BG_BLACK              (0x0 << 12)
%define C_BG_BLUE               (0x1 << 12)
%define C_BG_GREEN              (0x2 << 12)
%define C_BG_CYAN               (0x3 << 12)
%define C_BG_RED                (0x4 << 12)
%define C_BG_MAGENTA            (0x5 << 12)
%define C_BG_BROWN              (0x6 << 12)
%define C_BG_LIGHT_GREY         (0x7 << 12)

map_init:
  xor ecx, ecx

  ; Primera fila
  .first_row:
    mov word [fs:ecx], 0
    add ecx, 2
    cmp ecx, WIDTH * 2
    jne .first_row

  ; Tablero
  .board:
    mov word [fs:ecx], C_BG_GREEN
    add ecx, 2
    cmp ecx, WIDTH * 2 * 41
    jne .board

  ; Lo que resta del tablero
  .board_next:
    mov word [fs:ecx], 0
    add ecx, 2
    cmp ecx, WIDTH * 2 * 50
    jne .board_next

  ; Pintar azul y rojo
  ; Azul -> SCREEN[43][3 - 11]
  ; Rojo -> SCREEN[43][38 - 46]

  ; Calcule los offsets a mano de donde deberia ir cada color
  ; segun como estamos iterando
  ; TODO: Cambiar a futuro ?

  xor eax, eax
  xor ebx, ebx

  mov ecx, WIDTH * 2 * 44 + 3 * 2
  .paint_blue:
    mov word [fs:ecx], C_BG_BLUE
    add ecx, 2
    inc eax
    cmp eax, 9
    jne .paint_blue
    add ecx, WIDTH * 2 - 24 * 2
    .paint_red:
    mov word [fs:ecx], C_BG_RED
    add ecx, 2
    inc ebx
    cmp ebx, 9
    jne .paint_red
    xor eax, eax
    xor ebx, ebx
    add ecx, 6 * 2
    cmp ecx, WIDTH * 2 * 47 + 3 * 2
    jne .paint_blue

  ret
