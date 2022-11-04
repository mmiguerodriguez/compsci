section .rodata

align 16
; Constante para setear bordes en blanco
white: times 8 dw 0xffff

; Constante que usaremos para calcular la division por 5. 51 ~ 2^8/5
mult: times 8 dw 51

; Constante para setear los alfa en 0xff
error: db 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff,
       db 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff

section .data

section .text
global Zigzag_asm

; void Zigzag_asm
; @params
;   rdi: uint8_t *src
;   rsi: uint8_t *dst
;   rdx: int width
;   rcx: int height
;   r8: int src_row_size
;   r9: int dst_row_size

Zigzag_asm:
  push rbp
  mov rbp, rsp
  push r12
  push r13
  push r14
  push r15

  mov r13, rdi
  mov r14, rsi

  mov r10, rdx ; width (pixeles)
  mov r11, 4 ; contador pixeles
  mov r12, 4
  mov r15, 2 ; contador modulo

  movdqa xmm13, [white]
  movdqa xmm14, [mult]
  movdqa xmm15, [error]

  lea rdi, [rdi + r8*2 + 8] ; Salteamos 2 filas y 8 bytes
  lea rsi, [rsi + r9*2 + 8]

  .loop_img:
    cmp r15, 0
    je .case_mod_even
    cmp r15, 1
    je .case_mod_odd_1
    cmp r15, 2
    je .case_mod_even
    cmp r15, 3
    je .case_mod_odd_3

    ; Usamos movdqa porque siempre van a estar alineados a 16 bytes
    .case_mod_odd_1:
    movdqa xmm0, [rdi - 8] ; xmm0 = | p1 | p0 | p-1 | p-2 |
    jmp .set_value

    .case_mod_odd_3:
    movdqa xmm0, [rdi + 8] ; xmm0 = | p5 | p4 | p3 | p2 |
    jmp .set_value

    .case_mod_even:
    movdqu xmm0, [rdi] ; xmm0 = | p3    | | p2    | | p1    | | p0    |
                       ; xmm0 = |A|R|G|B| |A|R|G|B| |A|R|G|B| |A|R|G|B|

    movdqa xmm1, [rdi - 8] ; xmm1 = | p1 | p0 | p-1 | p-2 |
    movdqa xmm2, [rdi + 8] ; xmm2 = | p5 | p4 | p3  | p2  |

    pmovzxbw xmm3, xmm0 ; xmm3 = | p1 | p0 |
    psrldq xmm0, 8      ; xmm0 = | 0  | 0  | p3 | p2 |
    pmovzxbw xmm4, xmm0 ; xmm4 = | p3 | p2 |

    pmovzxbw xmm5, xmm1 ; xmm5 = | p-1 | p-2 |
    psrldq xmm2, 8      ; xmm2 = | 000 | 000 | p5 | p4 |
    pmovzxbw xmm6, xmm2 ; xmm6 = | p5  | p4  |

    ; Guardo xmm3
    movdqa xmm12, xmm3 ; xmm12 = | p1 | p0 |

    ; Calculos auxiliares
    movdqa xmm7, xmm3   ; xmm7 = | p1  | p0  |
    movdqa xmm8, xmm3   ; xmm8 = | p1  | p0  |
    movdqa xmm9, xmm5   ; xmm9 = | p-1 | p-2 |
    movdqa xmm10, xmm4 ; xmm10 = | p3  | p2  |

    ; p0 = p-2+p-1+p0+p1+p2
    ; p1 = p-1+p0+p1+p2+p3
    paddw xmm3, xmm5 ; xmm3 = | p-1+p1    |  p-2+p0   |
    paddw xmm3, xmm4 ; xmm3 = | p-1+p1+p3 | p-2+p0+p2 |
    pslldq xmm7, 8   ; xmm7 = | p0 | 0   |
    psrldq xmm9, 8   ; xmm9 = | 0  | p-1 |
    por xmm7, xmm9   ; xmm7 = | p0 | p-1 |
    paddw xmm3, xmm7 ; xmm3 = | p-1+p0+p1+p3 | p-2+p-1+p0+p2 |
    psrldq xmm8, 8   ; xmm8 = | 0 | p1  |
    pslldq xmm10, 8 ; xmm10 = | p2 | 0  |
    por xmm8, xmm10  ; xmm8 = | p2 | p1 |
    paddw xmm3, xmm8 ; xmm3 = | p-1+p0+p1+p2+p3 | p-2+p-1+p0+p1+p2 |

    ; Calculos auxiliares
    movdqa xmm9, xmm4   ; xmm9 = | p3 | p2 |
    movdqa xmm10, xmm4 ; xmm10 = | p3 | p2 |

    ; p2 = p0+p1+p2+p3+p4
    ; p3 = p1+p2+p3+p4+p5
    paddw xmm4, xmm6  ; xmm4 = | p3+p5 | p2+p4 |
    paddw xmm4, xmm12 ; xmm4 = | p1+p3+p5 | p0+p2+p4 |
    psrldq xmm12, 8  ; xmm12 = | 0  | p1  |
    pslldq xmm10, 8  ; xmm10 = | p2 | 0   |
    por xmm12, xmm10 ; xmm12 = | p2 | p1  |
    paddw xmm4, xmm12 ; xmm4 = | p1+p2+p3+p5 | p0+p1+p2+p4 |
    psrldq xmm9, 8    ; xmm9 = | 0  | p3  |
    pslldq xmm6, 8    ; xmm6 = | p4 | 0   |
    por xmm9, xmm6    ; xmm9 = | p4 | p3  |
    paddw xmm4, xmm9  ; xmm4 = | p1+p2+p3+p4+p5 | p0+p1+p2+p3+p4 |

    ;;;;;;
    ; En este punto tenemos
    ; xmm3 = | p-1+p0+p1+p2+p3 | p-2+p-1+p0+p1+p2 |
    ; xmm4 = | p1+p2+p3+p4+p5  | p0+p1+p2+p3+p4   |
    ; Falta dividir por 5 y empaquetar

    ; IDEA: Multiplicar por (2^n/5) y luego dividir por 2^n
    ; Usamos n = 8 => multiplicamos por 51 ~~ (2^8/5) = 51.2
    ; Esto va a tener un error de calculo y tenemos que corregirlo
    ;
    ; NOTA: El error de calculo que corregimos es el de los Alpha, el resto
    ; de las componentes difieren como maximo en +-1, suficiente como para que
    ; corran los tests.
    ;;;;;;

    movdqa xmm5, xmm14  ; xmm5 = |51|51|51|51|51|51|51|

    pmullw xmm3, xmm5    ;        |     p1*(2^n/5)      |       p0*(2^n/5)     |
    psrlw xmm3, 8        ; xmm3 = | (p-1+p0+p1+p2+p3)/5 | (p-2+p-1+p0+p1+p2)/5 |

    pmullw xmm4, xmm5    ;        |     p3*(2^n/5)      |       p2*(2^n/5)     |
    psrlw xmm4, 8        ; xmm4 = | (p1+p2+p3+p4+p5)/5  | (p0+p1+p2+p3+p4)/5   |

    packuswb xmm3, xmm4  ; xmm3 = | p3 | p2 | p1 | p0 |
    movdqa xmm6, xmm15   ; xmm6 = |ff|00|ff|00|ff|00|ff|00|
    por xmm3, xmm6       ; xmm3 = |ff|p3|ff|p2|ff|p1|ff|p0|

    movdqa xmm0, xmm3    ; xmm0 = xmm3

    .set_value:
    movdqu [rsi], xmm0   ; res = xmm0

    add rdi, 16
    add rsi, 16
    add r11, 4

    cmp r11, r10
    je .last_col
    jmp .loop_img

    ; Si estamos en el final de una fila tenemos que
    ;   - Sumar devuelta rdi y rsi para caer directo en el primer pixel que nos
    ;     importa
    ;   - Resetear nuestro contador de columna (r11)
    ;   - Aumentar nuestro contador de fila (r12)
    ;   - Aumentar nuestro contador de modulo de fila (r15)
    .last_col:
      add rdi, 16
      add rsi, 16

      mov r11, 4
      inc r12
      inc r15

      cmp r15, 4
      jne .no_reset_mod
      mov r15, 0

      .no_reset_mod:
      cmp r12, rcx
      je .end_loop_img
      jmp .loop_img

  .end_loop_img:

  ; Reset rdi y rsi
  mov rdi, r13
  mov rsi, r14

  ; Pintar bordes
  mov r10, rdx
  shr r10, 1    ; Lo hacemos por el ancho/2
  .loop_border_top:
    movdqa [rsi], xmm13
    add rsi, 16
    dec r10
    cmp r10, 0
    jne .loop_border_top

  xor r11, r11
  mov r10, rdx
  shl r10, 2    ; Calculamos el salto para solo mover en los bordes
  mov r12, rcx
  sub r12, 4    ; Lo hacemos por la altura - 4
  .loop_borders:
    movq [rsi], xmm13
    add rsi, r10
    sub rsi, 8
    movq [rsi], xmm13
    add rsi, 8

    inc r11
    cmp r11, r12
    jne .loop_borders

  mov r10, rdx
  shr r10, 1
  .loop_border_bottom:
    movdqa [rsi], xmm13
    add rsi, 16
    dec r10
    cmp r10, 0
    jne .loop_border_bottom

  pop r15
  pop r14
  pop r13
  pop r12
  pop rbp
  ret
