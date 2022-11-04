section .rodata

align 16
and_lsb: db 0x03, 0x03, 0x03, 0x00, 0x03, 0x03, 0x03, 0x00
         db 0x03, 0x03, 0x03, 0x00, 0x03, 0x03, 0x03, 0x00

mask_r: db 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00
        db 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00

mask_g: db 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00
        db 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00

mask_b: db 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
        db 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00

mask_res: db 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff
          db 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff

shuf_r: db 0x02, 0x02, 0x02, 0x80, 0x06, 0x06, 0x06, 0x80
        db 0x0A, 0x0A, 0x0A, 0x80, 0x0E, 0x0E, 0x0E, 0x80

shuf_g: db 0x01, 0x01, 0x01, 0x80, 0x05, 0x05, 0x05, 0x80
        db 0x09, 0x09, 0x09, 0x80, 0x0D, 0x0D, 0x0D, 0x80

shuf_b: db 0x00, 0x00, 0x00, 0x80, 0x04, 0x04, 0x04, 0x80
        db 0x08, 0x08, 0x08, 0x80, 0x0C, 0x0C, 0x0C, 0x80

section .data

section .text
global Descubrir_asm

; void Descubrir_asm
; @params
;   rdi: uint8_t *src
;   rsi: uint8_t *dst
;   rdx: int width
;   rcx: int height
;   r8: int src_row_size
;   r9: int dst_row_size

Descubrir_asm:
  push rbp
  mov rbp, rsp
  push r12
  push r13

  xor r10, r10
  xor r11, r11

  mov r12, rdx

  mov rax, rdx             ; rax = width
  mul rcx                  ; rax = width * height
  lea r13, [rdi + rax * 4] ; r13 = rdi + length (final src)
  sub r13, 16              ; r13 = rdi + length - 16 (ultimos 4 pixeles src)

  mov rdx, r12

  movdqa xmm8,  [mask_res] ; Mascara para resultado
  movdqa xmm9,  [mask_r]   ; Mascaras para bits
  movdqa xmm10, [mask_g]   ; Mascaras para bits
  movdqa xmm11, [mask_b]   ; Mascaras para bits
  movdqa xmm12, [shuf_r]   ; Registro para shuffle
  movdqa xmm13, [shuf_g]   ; Registro para shuffle
  movdqa xmm14, [shuf_b]   ; Registro para shuffle
  movdqa xmm15, [and_lsb]  ; Mascara para xor bit a bit

  .loop_img:
    movdqa xmm0, [rdi]            ; xmm0 =  | p3 | p2 | p1 | p0 | = src
    movdqa xmm1, [r13]            ; xmm1  = | p3 | p2 | p1 | p0 | = src mirr
    pshufd xmm1, xmm1, 0b00011011 ; xmm1  = | p0 | p1 | p2 | p3 | = src mirr

    movdqa xmm2, xmm1

    pmovzxbw xmm3, xmm2 ; xmm3 = | p2 | p3 |
    psrldq xmm2, 8      ; xmm2 = | 0  | 0  | p2 | p3 |
    pmovzxbw xmm4, xmm2 ; xmm4 = | p0 | p1 |

    psrlw xmm3, 2       ; xmm3 = | p2 | p3 | >> 2
    psrlw xmm4, 2       ; xmm4 = | p0 | p1 | >> 2
    packuswb xmm3, xmm4 ; xmm3 = | p0 | p1 | p2 | p3 |

    pxor xmm3, xmm0     ; xor RGB
    pand xmm3, xmm15    ; xmm3 = | 0 R[1:0] G[1:0] B[1:0] | ... |   |

    pxor xmm6, xmm6     ; xmm6 = 0

    ; Vamos a notar Cr, Cg y Cb como el valor Color que va a ser resultado para
    ; las componentes de cada pixel. Los shuffle hacen un broadcast del
    ; resultado parcial de cada pixel sobre las componentes de ese mismo pixel.

    movdqa xmm5, xmm3
    psrlw xmm5, 1       ; bit2 = (r >> 1) & 0x1;
    pand xmm5, xmm9
    psllw xmm5, 2       ; bit2 = bit2 << 2
    por xmm6, xmm5      ; Cr += bit2
    movdqa xmm5, xmm3
    pand xmm5, xmm9     ; bit5 = r & 0x1
    psllw xmm5, 5       ; bit5 = bit5 << 5
    por xmm6, xmm5      ; Cr += bit5
    pshufb xmm6, xmm12  ; xmm6 = | 0 | Cr[3] | Cr[3] | Cr[3] | ... | 0 | Cr[0] | Cr[0] | Cr[0] |

    movdqa xmm5, xmm3
    psrlw xmm5, 1       ; bit3 = (g >> 1) & 0x1
    pand xmm5, xmm10
    psllw xmm5, 3       ; bit3 = bit3 << 3
    por xmm6, xmm5      ; Cg += bit3
    movdqa xmm5, xmm3
    pand xmm5, xmm10    ; bit6 = g & 0x1;
    psllw xmm5, 6       ; bit6 = bit6 << 6
    por xmm6, xmm5      ; Cg += bit6
    pshufb xmm6, xmm13  ; xmm6 = | 0 | Cr[3] + Cg[3] | Cr[3] + Cg[3] | Cr[3] + Cg[3] | ... | 0 | Cr[0] + Cg[0] | Cr[0] + Cg[0] | Cr[0] + Cg[0] |

    movdqa xmm5, xmm3
    psrlw xmm5, 1       ; bit4 = (b >> 1) & 0x1
    pand xmm5, xmm11
    psllw xmm5, 4       ; bit4 = bit4 << 4
    por xmm6, xmm5      ; Cb += bit4
    movdqa xmm5, xmm3
    pand xmm5, xmm11    ; bit7 = b & 0x1;
    psllw xmm5, 7       ; bit7 = bit7 << 7
    por xmm6, xmm5      ; Cb += bit7
    pshufb xmm6, xmm14  ; xmm6 = | 0 | Cr[3] + Cg[3] + Cb[3] | Cr[3] + Cg[3] + Cb[3] | Cr[3] + Cg[3] + Cb[3] | ... | 0 | Cr[0] + Cg[0] + Cb[0] | Cr[0] + Cg[0] + Cb[0] | Cr[0] + Cg[0] + Cb[0] |

    movdqa xmm0, xmm8  ; xmm0 = | FF 00 00 00 | ... | FF 00 00 00 |
    por xmm0, xmm6     ; xmm0 = | FF  C[3]  C[3]  C[3] | ... | FF  C[0]  C[0]  C[0] |
    movdqa [rsi], xmm0 ; res = xmm0

    add rdi, 16
    add rsi, 16
    sub r13, 16

    add r10, 4
    cmp r10, rdx
    jne .loop_img

    xor r10, r10
    inc r11
    cmp r11, rcx
    je .end_loop_img
    jmp .loop_img

  .end_loop_img:

  pop r13
  pop r12
  pop rbp
  ret
