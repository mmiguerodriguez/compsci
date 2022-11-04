	ifndef	??version
?debug	macro
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	S "nibbles.c"
	?debug	C E92D7C5A50096E6962626C65732E63
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_DATA	segment word public 'DATA'
_ivt	label	dword
	db	0
	db	0
	db	0
	db	0
_pantalla	label	dword
	db	0
	db	0
	db	0
	db	184
_gusanito	label	word
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
_longitud_gusanito	label	word
	db	1
	db	0
_direccion_gusanito	label	byte
	db	1
_paso_pendiente	label	word
	db	0
	db	0
_tecla_anterior	label	byte
	db	0
_finalizado	label	word
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void setear_80x25()
   ;	
	assume	cs:_TEXT
_setear_80x25	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;		/* Carga y activa la font 8x16 en 200 scanlines */
   ;		asm mov ax, 0x1114
   ;	
 	mov	 ax, 01114H
   ;	
   ;		asm xor bl, bl
   ;	
 	xor	 bl, bl
   ;	
   ;		asm int 0x10
   ;	
 	int	 010H
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_setear_80x25	endp
   ;	
   ;	void setear_80x50()
   ;	
	assume	cs:_TEXT
_setear_80x50	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;		/* Carga y activa la font 8x8 en 400 scanlines */
   ;		asm mov ax, 0x1112
   ;	
 	mov	 ax, 01112H
   ;	
   ;		asm xor bl, bl
   ;	
 	xor	 bl, bl
   ;	
   ;		asm int 0x10
   ;	
 	int	 010H
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_setear_80x50	endp
   ;	
   ;	void set_isr(unsigned int num, void far *p)
   ;	
	assume	cs:_TEXT
_set_isr	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;		asm cli;
   ;	
 	cli	
   ;	
   ;		ivt[num] = p;
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,1
	shl	ax,1
	les	bx,dword ptr DGROUP:_ivt
	add	bx,ax
	mov	ax,word ptr [bp+8]
	mov	dx,word ptr [bp+6]
	mov	word ptr es:[bx+2],ax
	mov	word ptr es:[bx],dx
   ;	
   ;		asm sti;
   ;	
 	sti	
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_set_isr	endp
   ;	
   ;	void far *get_isr(unsigned int num)
   ;	
	assume	cs:_TEXT
_get_isr	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
   ;	
   ;	{
   ;		void (far *isr)();
   ;		asm cli;
   ;	
 	cli	
   ;	
   ;		isr = ivt[num];
   ;	
	mov	ax,word ptr [bp+4]
	shl	ax,1
	shl	ax,1
	les	bx,dword ptr DGROUP:_ivt
	add	bx,ax
	mov	ax,word ptr es:[bx+2]
	mov	dx,word ptr es:[bx]
	mov	word ptr [bp-2],ax
	mov	word ptr [bp-4],dx
   ;	
   ;		asm sti;
   ;	
 	sti	
   ;	
   ;		return isr;
   ;	
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	jmp	short @4@142
@4@142:
   ;	
   ;	}
   ;	
	mov	sp,bp
	pop	bp
	ret	
_get_isr	endp
   ;	
   ;	unsigned int calc_siguiente(unsigned int actual, unsigned char direccion)
   ;	
	assume	cs:_TEXT
_calc_siguiente	proc	near
	push	bp
	mov	bp,sp
	push	si
	mov	si,word ptr [bp+4]
   ;	
   ;	{
   ;		switch (direccion) {
   ;	
	mov	al,byte ptr [bp+6]
	mov	ah,0
	mov	bx,ax
	cmp	bx,3
	ja	short @5@254
	shl	bx,1
	jmp	word ptr cs:@5@C290[bx]
@5@114:
   ;	
   ;			case UP:
   ;				return actual - COLUMNAS;
   ;	
	mov	ax,si
	sub	ax,80
@5@142:
	jmp	short @5@282
@5@170:
   ;	
   ;			case DOWN:
   ;				return actual + COLUMNAS;
   ;	
	mov	ax,si
	add	ax,80
	jmp	short @5@142
@5@198:
   ;	
   ;			case LEFT:
   ;				return actual - 1;
   ;	
	mov	ax,si
	dec	ax
	jmp	short @5@142
@5@226:
   ;	
   ;			case RIGHT:
   ;				return actual + 1;
   ;	
	mov	ax,si
	inc	ax
	jmp	short @5@142
@5@254:
   ;	
   ;		}
   ;		return 0; /* No tiene que llegar */
   ;	
	xor	ax,ax
	jmp	short @5@142
@5@282:
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_calc_siguiente	endp
@5@C290	label	word
	dw	@5@198
	dw	@5@226
	dw	@5@114
	dw	@5@170
   ;	
   ;	void mover_gusanito(unsigned int pos_siguiente)
   ;	
	assume	cs:_TEXT
_mover_gusanito	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
   ;	
   ;	{
   ;		unsigned int i;
   ;		/* Limpiar en pantalla la posicion de mas a la izquierda */
   ;		pantalla[gusanito[0]].ch = NIB_BLANK;
   ;	
	mov	ax,word ptr DGROUP:_gusanito
	shl	ax,1
	les	bx,dword ptr DGROUP:_pantalla
	add	bx,ax
	mov	byte ptr es:[bx],0
   ;	
   ;		/* Shiftear la lista de posiciones a la izquierda */
   ;		for (i = 1; i < longitud_gusanito; i++)
   ;	
	mov	si,1
	jmp	short @6@114
@6@58:
   ;	
   ;			gusanito[i-1] = gusanito[i];
   ;	
	mov	bx,si
	dec	bx
	shl	bx,1
	mov	di,si
	shl	di,1
	mov	ax,word ptr DGROUP:_gusanito[di]
	mov	word ptr DGROUP:_gusanito[bx],ax
	inc	si
@6@114:
	cmp	si,word ptr DGROUP:_longitud_gusanito
	jb	short @6@58
   ;	
   ;		/* Agregar nueva posicion a la derecha */
   ;		gusanito[longitud_gusanito-1] = pos_siguiente;
   ;	
	mov	bx,word ptr DGROUP:_longitud_gusanito
	dec	bx
	shl	bx,1
	mov	ax,word ptr [bp+4]
	mov	word ptr DGROUP:_gusanito[bx],ax
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	pop	bp
	ret	
_mover_gusanito	endp
   ;	
   ;	void crecer_gusanito(unsigned int pos_siguiente)
   ;	
	assume	cs:_TEXT
_crecer_gusanito	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;		longitud_gusanito++;
   ;	
	inc	word ptr DGROUP:_longitud_gusanito
   ;	
   ;		gusanito[longitud_gusanito-1] = pos_siguiente;
   ;	
	mov	bx,word ptr DGROUP:_longitud_gusanito
	dec	bx
	shl	bx,1
	mov	ax,word ptr [bp+4]
	mov	word ptr DGROUP:_gusanito[bx],ax
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_crecer_gusanito	endp
   ;	
   ;	void dibujar_gusanito()
   ;	
	assume	cs:_TEXT
_dibujar_gusanito	proc	near
	push	bp
	mov	bp,sp
	push	si
   ;	
   ;	{
   ;		unsigned int i;
   ;		for (i = 0; i < longitud_gusanito; i++)
   ;	
	xor	si,si
	jmp	short @8@114
@8@58:
   ;	
   ;			pantalla[gusanito[i]].ch = NIB_CHAR;
   ;	
	mov	bx,si
	shl	bx,1
	mov	ax,word ptr DGROUP:_gusanito[bx]
	shl	ax,1
	les	bx,dword ptr DGROUP:_pantalla
	add	bx,ax
	mov	byte ptr es:[bx],219
	inc	si
@8@114:
	cmp	si,word ptr DGROUP:_longitud_gusanito
	jb	short @8@58
   ;	
   ;	}
   ;	
	pop	si
	pop	bp
	ret	
_dibujar_gusanito	endp
   ;	
   ;	void avanzar_gusanito(unsigned char direccion)
   ;	
	assume	cs:_TEXT
_avanzar_gusanito	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
   ;	
   ;	{
   ;		unsigned int pos_siguiente =
   ;			calc_siguiente(gusanito[longitud_gusanito-1], direccion);
   ;	
	mov	al,byte ptr [bp+4]
	push	ax
	mov	bx,word ptr DGROUP:_longitud_gusanito
	dec	bx
	shl	bx,1
	push	word ptr DGROUP:_gusanito[bx]
	call	near ptr _calc_siguiente
	pop	cx
	pop	cx
	mov	si,ax
   ;	
   ;		unsigned char chsig = pantalla[pos_siguiente].ch;
   ;	
	mov	ax,si
	shl	ax,1
	les	bx,dword ptr DGROUP:_pantalla
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr [bp-1],al
   ;	
   ;	
   ;		if (longitud_gusanito == NIB_MAX ||
   ;	
   ;	
   ;				(chsig == NIB_BLANK || chsig == NIB_SPACE || chsig == NIB_CHAR))
   ;	
	cmp	word ptr DGROUP:_longitud_gusanito,16
	je	short @9@142
	cmp	byte ptr [bp-1],0
	je	short @9@142
	cmp	byte ptr [bp-1],32
	je	short @9@142
	cmp	byte ptr [bp-1],219
	jne	short @9@170
@9@142:
   ;	
   ;			mover_gusanito(pos_siguiente);
   ;	
	push	si
	call	near ptr _mover_gusanito
	jmp	short @9@198
@9@170:
   ;	
   ;		else
   ;			crecer_gusanito(pos_siguiente);
   ;	
	push	si
	call	near ptr _crecer_gusanito
@9@198:
	pop	cx
   ;	
   ;	}
   ;	
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_avanzar_gusanito	endp
   ;	
   ;	void far rutina_teclado()
   ;	
	assume	cs:_TEXT
_rutina_teclado	proc	far
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
   ;	
   ;	{
   ;		unsigned char presionada;
   ;		unsigned char rawcode;
   ;		int scancode;
   ;		
   ;		/* Obtener tecla presionada en raw y el scancode correspondiente */
   ;		rawcode = inp(0x60); // leo del puerto de hardware 0x60
   ;	
	mov	ax,96
	push	ax
	call	near ptr _inp
	pop	cx
	mov	byte ptr [bp-2],al
   ;	
   ;		scancode = rawcode & 0x7F; // 7 bits menos significativos
   ;	
	mov	al,byte ptr [bp-2]
	mov	ah,0
	and	ax,127
	mov	si,ax
   ;	
   ;		presionada = !(rawcode & 0x80); // bit mas significativo
   ;	
	mov	al,byte ptr [bp-2]
	mov	ah,0
	and	ax,128
	neg	ax
	sbb	ax,ax
	inc	ax
	mov	byte ptr [bp-1],al
   ;	
   ;	
   ;		// COMPLETAR RUTINA
   ;		if (scancode == TECLA_ESC) {
   ;	
	cmp	si,1
	jne	short @10@86
   ;	
   ;			finalizado = 1;
   ;	
	mov	word ptr DGROUP:_finalizado,1
   ;	
   ;		} else if (scancode == TECLA_UP) {
   ;	
	jmp	short @10@310
@10@86:
	cmp	si,72
	jne	short @10@142
   ;	
   ;			direccion_gusanito = UP;
   ;	
	mov	byte ptr DGROUP:_direccion_gusanito,2
   ;	
   ;		} else if (scancode == TECLA_DOWN) {
   ;	
	jmp	short @10@310
@10@142:
	cmp	si,80
	jne	short @10@198
   ;	
   ;			direccion_gusanito = DOWN;
   ;	
	mov	byte ptr DGROUP:_direccion_gusanito,3
   ;	
   ;		} else if (scancode == TECLA_LEFT) {
   ;	
	jmp	short @10@310
@10@198:
	cmp	si,75
	jne	short @10@254
   ;	
   ;			direccion_gusanito = LEFT;
   ;	
	mov	byte ptr DGROUP:_direccion_gusanito,0
   ;	
   ;		} else if (scancode == TECLA_RIGHT) {
   ;	
	jmp	short @10@310
@10@254:
	cmp	si,77
	jne	short @10@310
   ;	
   ;			direccion_gusanito = RIGHT;
   ;	
	mov	byte ptr DGROUP:_direccion_gusanito,1
@10@310:
   ;	
   ;		}
   ;		
   ;		tecla_anterior = rawcode; // guardo tecla en un buffer
   ;	
	mov	al,byte ptr [bp-2]
	mov	byte ptr DGROUP:_tecla_anterior,al
   ;	
   ;		outp(0x20, 0x20); /* EOI */
   ;	
	mov	ax,32
	push	ax
	mov	ax,32
	push	ax
	call	near ptr _outp
	pop	cx
	pop	cx
   ;	
   ;		//asm IRET; // agregado migueee
   ;	}
   ;	
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_rutina_teclado	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_count	label	word
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	void far rutina_reloj()
   ;	
	assume	cs:_TEXT
_rutina_reloj	proc	far
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;		// COMPLETAR RUTINA
   ;		count++;
   ;	
	inc	word ptr DGROUP:_count
   ;	
   ;		if(count > 4) {
   ;	
	cmp	word ptr DGROUP:_count,4
	jle	short @11@86
   ;	
   ;			paso_pendiente = 1;
   ;	
	mov	word ptr DGROUP:_paso_pendiente,1
   ;	
   ;			count = 0;
   ;	
	mov	word ptr DGROUP:_count,0
@11@86:
   ;	
   ;		}
   ;		outp(0x20, 0x20); /* EOI */
   ;	
	mov	ax,32
	push	ax
	mov	ax,32
	push	ax
	call	near ptr _outp
	pop	cx
	pop	cx
   ;	
   ;		//asm IRET;
   ;	}
   ;	
	pop	bp
	ret	
_rutina_reloj	endp
   ;	
   ;	int main(void)
   ;	
	assume	cs:_TEXT
_main	proc	near
	push	bp
	mov	bp,sp
   ;	
   ;	{
   ;		/* Cambio modo de video para que el gusanito se vea cuadrado */
   ;		setear_80x50();
   ;	
	call	near ptr _setear_80x50
   ;	
   ;	
   ;		// COMPLETAR: setear en la IVT las ISRs del timer y el teclado
   ;		
   ;		paso_pendiente = 1;
   ;	
	mov	word ptr DGROUP:_paso_pendiente,1
   ;	
   ;		
   ;		// punto a
   ;		orig_teclado = get_isr(0x09);
   ;	
	mov	ax,9
	push	ax
	call	near ptr _get_isr
	pop	cx
	mov	word ptr DGROUP:_orig_teclado+2,dx
	mov	word ptr DGROUP:_orig_teclado,ax
   ;	
   ;		orig_timer = get_isr(0x1C);
   ;	
	mov	ax,28
	push	ax
	call	near ptr _get_isr
	pop	cx
	mov	word ptr DGROUP:_orig_timer+2,dx
	mov	word ptr DGROUP:_orig_timer,ax
   ;	
   ;		
   ;		// punto B
   ;		set_isr(TECLADO, rutina_teclado);
   ;	
	mov	ax,seg _rutina_teclado
	push	ax
	mov	ax,offset _rutina_teclado
	push	ax
	mov	ax,9
	push	ax
	call	near ptr _set_isr
	add	sp,6
   ;	
   ;		
   ;		// punto C??
   ;		set_isr(0x1C, rutina_reloj);
   ;	
	mov	ax,seg _rutina_reloj
	push	ax
	mov	ax,offset _rutina_reloj
	push	ax
	mov	ax,28
	push	ax
	call	near ptr _set_isr
	add	sp,6
   ;	
   ;		
   ;		dibujar_gusanito();
   ;	
	call	near ptr _dibujar_gusanito
	jmp	short @12@114
@12@58:
   ;	
   ;		while (!finalizado) {
   ;			if (paso_pendiente) {
   ;	
	cmp	word ptr DGROUP:_paso_pendiente,0
	je	short @12@114
   ;	
   ;				avanzar_gusanito(direccion_gusanito);
   ;	
	mov	al,byte ptr DGROUP:_direccion_gusanito
	push	ax
	call	near ptr _avanzar_gusanito
	pop	cx
   ;	
   ;				dibujar_gusanito();
   ;	
	call	near ptr _dibujar_gusanito
   ;	
   ;				paso_pendiente = 0;
   ;	
	mov	word ptr DGROUP:_paso_pendiente,0
@12@114:
	cmp	word ptr DGROUP:_finalizado,0
	je	short @12@58
   ;	
   ;			}
   ;		}
   ;	
   ;		// COMPLETAR: restaurar estado en la IVT
   ;		set_isr(0x09, orig_teclado);
   ;	
	push	word ptr DGROUP:_orig_teclado+2
	push	word ptr DGROUP:_orig_teclado
	mov	ax,9
	push	ax
	call	near ptr _set_isr
	add	sp,6
   ;	
   ;		set_isr(0x1C, orig_timer);
   ;	
	push	word ptr DGROUP:_orig_timer+2
	push	word ptr DGROUP:_orig_timer
	mov	ax,28
	push	ax
	call	near ptr _set_isr
	add	sp,6
   ;	
   ;	
   ;		/* Restauro modo de video original */
   ;		setear_80x25();
   ;	
	call	near ptr _setear_80x25
   ;	
   ;	
   ;		return 0;
   ;	
	xor	ax,ax
	jmp	short @12@170
@12@170:
   ;	
   ;	}
   ;	
	pop	bp
	ret	
_main	endp
_TEXT	ends
_BSS	segment word public 'BSS'
_orig_teclado	label	dword
	db	4 dup (?)
_orig_timer	label	dword
	db	4 dup (?)
	?debug	C E9
_BSS	ends
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	_main
	public	_rutina_reloj
	public	_count
	extrn	_outp:near
	extrn	_inp:near
	public	_rutina_teclado
	public	_avanzar_gusanito
	public	_dibujar_gusanito
	public	_crecer_gusanito
	public	_mover_gusanito
	public	_calc_siguiente
	public	_get_isr
	public	_set_isr
	public	_setear_80x50
	public	_setear_80x25
	public	_finalizado
	public	_tecla_anterior
	public	_paso_pendiente
	public	_direccion_gusanito
	public	_longitud_gusanito
	public	_gusanito
	public	_orig_teclado
	public	_orig_timer
	public	_pantalla
	public	_ivt
_s@	equ	s@
	end
