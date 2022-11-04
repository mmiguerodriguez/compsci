section .rodata

align 16
; mask_{c}{i}:
; el c se corresponde a los componentes que va a guardar la mascara
; el i se corresponde al indice del componente que va a guardar
; la mascara
mask_r3: db 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x08, 0x00
         db 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x08, 0x00

mask_g3: db 0x00, 0x08, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
         db 0x00, 0x08, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00

mask_b3: db 0x08, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00
         db 0x08, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00

mask_r2: db 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00
         db 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00

mask_g2: db 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00
         db 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00

mask_b2: db 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
         db 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00

; Estas mascaras son usadas para solucionar problemas al hacer shifts de words
; ya que nos pueden llegar bits de grayscales que estan empaquetados en words
; que no queremos
; mask_r_f: db 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00
;          db 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00
;
; mask_g_f: db 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00
;          db 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00
;
; mask_b_f: db 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00
;          db 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00

; Usada para calcular el xor
mask_xor: db 0x0c, 0x0c, 0x0c, 0x00, 0x0c, 0x0c, 0x0c, 0x00
          db 0x0c, 0x0c, 0x0c, 0x00, 0x0c, 0x0c, 0x0c, 0x00

; Usada para caulcar grayscales
mask_add: db 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
          db 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00

; Usada para limpiar los 2 bits menos significativos que van a ser reemplazados
mask_dst: db 0xfc, 0xfc, 0xfc, 0xff, 0xfc, 0xfc, 0xfc, 0xff
          db 0xfc, 0xfc, 0xfc, 0xff, 0xfc, 0xfc, 0xfc, 0xff

section .data

section .text
global Ocultar_asm

; void Ocultar_asm
; @params
;   rdi: uint8_t *src
;   rsi: uint8_t *src2
;   rdx: uint8_t *dst
;   rcx: int width
;   r8: int height
;   r9: int src_row_size
;   [rbp+16]: int dst_row_size

; REGISTROS
; r10 = Contador de pixeles
; r11 = Contador de filas
; r12 = Guardamos rdx (mul lo modifica)
; r13 = src_mirror*

; REGISTROS SSE
; XMM0  = SRC
; XMM1  = SRC2
; XMM2  = | p1 | p0 | = Grayscales
; XMM3  = | p3 | p2 | = Grayscales
; XMM4  = Temporal para Grayscales
; XMM5  = Temporal para Grayscales (mascara)
; XMM6  = Guardamos
; XMM7  = Temporal para calcular greyscales
; 8-11  = Temporales/Sin usar
; XMM12 = SRC (mirror)
; XMM13 = Mascara para bits que importan
; XMM14 = Mascara para xor
; XMM15 = Mascara para sumar

Ocultar_asm:
  push rbp
  mov rbp, rsp
  push r12
  push r13

  xor r10, r10
  xor r11, r11

  movdqa xmm13, [mask_xor] ; xmm7  = | 00 0c 0c 0c | ... | 00 0c 0c 0c |
  movdqa xmm14, [mask_dst] ; xmm14 = | FF FC FC FC | ... | FF FC FC FC |
  movdqa xmm15, [mask_add] ; xmm15 = | 00 00 FF 00 | ... | 00 00 FF 00 |

  mov r12, rdx
  mov r13, rdi

  mov rax, r8              ; rax = width
  mul rcx                  ; rax = width * height
  lea r13, [r13 + rax * 4] ; r13 = rdi + length (final src)
  sub r13, 16              ; r13 = rdi + length - 16 (ultimos 4 pixeles src)

  mov rdx, r12

  .loop_img:
    movdqa xmm0, [rdi]              ; xmm0  = | p3 | p2 | p1 | p0 | = src
    movdqa xmm1, [rsi]              ; xmm1  = | p3 | p2 | p1 | p0 | = src2
    movdqa xmm12, [r13]             ; xmm12 = | p3 | p2 | p1 | p0 | = src mirr
    pshufd xmm12, xmm12, 0b00011011 ; xmm12 = | p0 | p1 | p2 | p3 | = src mirr

    ; NOTA 1: Desde aca se puede optimizar y hacerse en menos operaciones     --

    pmovzxbw xmm2, xmm1 ; xmm2  = | p1 | p0 | = src2
                        ;               p1            p0
                        ; xmm2 = | 0A 0R 0G 0B | 0A 0R 0G 0B |
    movdqa xmm7, xmm15  ; xmm7 = | 00 00 FF 00 | 00 00 FF 00 |
    pand xmm7, xmm2     ; xmm7 = | 00 00 0G 00 | 00 00 0G 00 |
    paddw xmm2, xmm7    ; xmm2 = | 0A 0R 2G 0B | 0A 0R 2G 0B |
    movdqa xmm7, xmm2   ; xmm7 = | 0A 0R 2G 0B | 0A 0R 2G 0B |
    psrldq xmm7, 2      ; xmm7 = | 00 0A 0R 2G | 0B 0A 0R 2G |
    pand xmm7, xmm15    ; xmm7 = | 00 00 0R 00 | 00 00 0R 00 |
    paddw xmm2, xmm7    ; xmm2 = | 0A 0R 2G+R 0B | 0A 0R 2G+R 0B |
    movdqa xmm7, xmm2   ; xmm7 = | 0A 0R 2G+R 0B | 0A 0R 2G+R 0B |
    pslldq xmm7, 2      ; xmm7 = | 0R 2G+R 0B 0A | 0R 2G+R 0B 00 |
    pand xmm7, xmm15    ; xmm7 = | 00 00 0B 00 | 00 00 0B 00 |
    paddw xmm2, xmm7    ; xmm2 = | 0A 0R 2G+R+B 0B  | 0A 0R 2G+R+B 0B  |
    psrlw xmm2, 2       ; xmm2 = | ?? ?? G1 ?? | ?? ?? G0 ?? |

    pshuflw xmm2, xmm2, 0b01010101  ; xmm2 = | ?? ?? G1 ?? | G0 G0 G0 G0 | ; G = greyscale pixel
    pshufhw xmm2, xmm2, 0b01010101  ; xmm2 = | G1 G1 G1 G1 | G0 G0 G0 G0 |

    movdqa xmm7, xmm1   ; xmm7  = xmm1 = src2
    psrldq xmm7, 8      ; xmm7  = | 0  | 0  | p3 | p2 |
    pmovzxbw xmm3, xmm7 ; xmm3  = | p3 | p2 |

                       ;               p3            p2
                       ; xmm3 = | 0A 0R 0G 0B | 0A 0R 0G 0B |
    movdqa xmm7, xmm15 ; xmm7 = | 00 00 FF 00 | 00 00 FF 00 |
    pand xmm7, xmm3    ; xmm7 = | 00 00 0G 00 | 00 00 0G 00 |
    paddw xmm3, xmm7   ; xmm3 = | 0A 0R 2G 0B | 0A 0R 2G 0B |
    movdqa xmm7, xmm3  ; xmm7 = | 0A 0R 2G 0B | 0A 0R 2G 0B |
    psrldq xmm7, 2     ; xmm7 = | 00 0A 0R 2G | 0B 0A 0R 2G |
    pand xmm7, xmm15   ; xmm7 = | 00 00 0R 00 | 00 00 0R 00 |
    paddw xmm3, xmm7   ; xmm3 = | 0A 0R 2G+R 0B | 0A 0R 2G+R 0B |
    movdqa xmm7, xmm3  ; xmm7 = | 0A 0R 2G+R 0B | 0A 0R 2G+R 0B |
    pslldq xmm7, 2     ; xmm7 = | 0R 2G+R 0B 0A | 0R 2G+R 0B 00 |
    pand xmm7, xmm15   ; xmm7 = | 00 00 0B 00 | 00 00 0B 00 |
    paddw xmm3, xmm7   ; xmm3 = | 0A 0R 2G+R+B 0B  | 0A 0R 2G+R+B 0B  |
    psrlw xmm3, 2      ; xmm3 = | ?? ?? G3 ?? | ?? ?? G2 ?? |

    pshuflw xmm3, xmm3, 0b01010101  ; xmm3 = | ?? ?? G3 ?? | G2 G2 G2 G2 | ; G = greyscale pixel
    pshufhw xmm3, xmm3, 0b01010101  ; xmm3 = | G3 G3 G3 G3 | G2 G2 G2 G2 |

    ; FIN NOTA 1: Hasta aca se puede optimizar y hacerse en menos operaciones --

    ; NOTA 2: En esta seccion de codigo tenemos muchas mascaras que se buscan
    ; a memoria que se repiten "mask_r_f, mask_g_f, mask_b_f", podriamos
    ; ponerlas en registros que no usemos para no pedirlas a memoria todo el
    ; tiempo (tener en cuenta que no se va a poder con todas).

    ; NOTA 3: Esta seccion ademas tiene implementado la copia de bits de los
    ; grayscales shifteados correspondientes a los bits[3:2] de cada
    ; componente R,G,B a partir del codigo de C++ ya que no pude entender de
    ; forma correcta el dibujo

    packuswb xmm2, xmm3 ; xmm2 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    pxor xmm6, xmm6     ; xmm6 = 0

    movdqa xmm4, xmm2       ; xmm4 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    psllw xmm4, 1
    movdqa xmm5, [mask_r3]
    pand xmm4, xmm5
    por xmm6, xmm4

    movdqa xmm4, xmm2       ; xmm4 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    psrlw xmm4, 3
    movdqa xmm5, [mask_r2]
    pand xmm4, xmm5
    por xmm6, xmm4

    movdqa xmm4, xmm2       ; xmm4 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    movdqa xmm5, [mask_g3]
    pand xmm4, xmm5
    por xmm6, xmm4

    movdqa xmm4, xmm2       ; xmm4 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    psrlw xmm4, 4
    movdqa xmm5, [mask_g2]
    pand xmm4, xmm5
    por xmm6, xmm4

    movdqa xmm4, xmm2       ; xmm4 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    psrlw xmm4, 1
    movdqa xmm5, [mask_b3]
    pand xmm4, xmm5
    por xmm6, xmm4

    movdqa xmm4, xmm2       ; xmm4 = | g3 g3 g3 g3 | g2 g2 g2 g2 | g1 g1 g1 g1 | g0 g0 g0 g0 |
    psrlw xmm4, 5
    movdqa xmm5, [mask_b2]
    pand xmm4, xmm5
    por xmm6, xmm4

    pand xmm12, xmm13 ; src(mirror) AND (Bits que importan)
    pxor xmm12, xmm6  ; src(mirror) XOR GrayscaleContainer

    pmovzxbw xmm11, xmm12 ; xmm11 = | p1 | p0 |
    psrlw xmm11, 2        ; Shifteamos 2 bits para tener los que nos importan
    psrldq xmm12, 8       ; xmm12 = | 0 | 0 | p3 | p2 |
    pmovzxbw xmm10, xmm12 ; xmm10 = | p3 | p2 |
    psrlw xmm10, 2        ; Shifteamos 2 bits para tener los que nos importan
    packuswb xmm11, xmm10 ; xmm11 = | p3 | p2 | p1 | p0

    pand xmm0, xmm14 ; xmm0 = | a r[7:2] g[7:2] b[7:2] | ... | |
    por xmm0, xmm11  ; xmm0 = | p3 | p2 | p1 | p0 |

    movdqa [rdx], xmm0 ; res = xmm0

    add rdi, 16
    add rsi, 16
    add rdx, 16
    sub r13, 16

    add r10, 4

    cmp r10, rcx
    jne .loop_img

    xor r10, r10
    inc r11

    cmp r11, r8
    je .end_loop_img
    jmp .loop_img

  .end_loop_img:

  pop r13
  pop r12
  pop rbp
  ret
