section .data
sorterPrintStringFormat: DB "%s",0
sorterPrintUFormat: DB "%u", 0
sorterPrintNewline: DB `\n`, 0
fprintNull: DB "NULL",0
listPrintPointerFormat: DB "%p", 0
listPrintCharFormat: DB "%c", 0

section .text
; Includes
extern malloc
extern free
extern fputs
extern fprintf
extern listRemove

; Exports
global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listDelete
global listPrint
global listClone
global sorterNew
global sorterAdd
global sorterRemove
global sorterGetSlot
global sorterGetConcatSlot
global sorterCleanSlot
global sorterDelete
global sorterPrint
global fs_sizeModFive
global fs_firstChar
global fs_bitSplit

; Defines
%define NULL 0

%define OFFSET_ELEM_DATA 0
%define OFFSET_ELEM_NEXT 8
%define OFFSET_ELEM_PREV 16

%define OFFSET_LIST_FIRST 0
%define OFFSET_LIST_LAST 8

%define OFFSET_SORTER_SIZE 0
%define OFFSET_SORTER_SORT_FN 8
%define OFFSET_SORTER_COMPARE_FN 16
%define OFFSET_SORTER_SLOTS 24

;*** String ***

; char* strClone(char* a)
; @params
;		rdi: char* a
;	@return
;		rax: char*
strClone:
	; Armo stack frame
	push rbp
	mov rbp, rsp
	push r12
	push r13

	; Guardo puntero a string a clonar
	mov r13, rdi

	; Calculo largo del string
	call strLen

	; Guardo el largo del string
	xor r12, r12
	mov r12d, eax

	; Reservo el largo de memoria necesario
	mov edi, eax
	inc edi
	call malloc

	xor rcx, rcx
	.loop:
		cmp ecx, r12d
		je .return

		; Muevo lo que habia en a la memoria reservada por malloc (rax)
		mov r9b, [r13 + rcx]
		mov [rax + rcx], r9b

		inc ecx
		jmp .loop

	.return:
		mov BYTE [rax + rcx], NULL
		pop r13
		pop r12
		pop rbp
		ret

; uint32_t strLen(char* a)
; @params
;		rdi: char* a
; @return
;		eax: uint32_t
strLen:
	xor rax, rax

	; Checkeo que el puntero es valido
	cmp rdi, NULL
	je .return

	.loop:
		; Checkeo si llegue al final
		cmp BYTE [rdi + rax], NULL
		je .return

		inc eax
		jmp .loop

	.return:
		ret

; int32_t strCmp(char* a, char* b)
; @params
;		rdi: char* a
;		rsi: char* b
; @return
;		eax: int32_t
strCmp:
	push rbp
	mov rbp, rsp
	push r12
	push r13 ; push para mantener el stack alineado 16 bytes

	mov rbp, rdi ; Guardamos rdi

	; Checkeo que los punteros sean validos
	cmp rsi, NULL
	je .bigger
	cmp rdi, NULL
	je .lower

	; Guardamos en rax el largo mas grande
	call strLen
	mov r12, rax

	mov rdi, rsi ; Movemos el otro string
	call strLen

	mov rdi, rbp ; Volvemos rdi a su valor original

	cmp rax, r12
	jl .modificar ; Si el nuevo valor es menor, modificamos
	jmp .no_modificar
	.modificar:
		mov rax, r12

	.no_modificar:
	xor rcx, rcx
	.loop:
		cmp rax, rcx
		je .equal

		mov dl, [rdi + rcx]
		mov bl, [rsi + rcx]

		; Checkeo para ver si un string ya termino
		cmp dl, NULL
		jne .noNulo
		.unNulo:
			cmp bl, NULL
			je .equal ; Si ambos son NULL estamos en el caso que ambos son iguales
			jmp .lower ; Si a es NULL y b no lo es, entonces a < b
		.noNulo:
			cmp bl, NULL
			je .bigger ; Si a no es NULL y b si lo es entonces a > b

		cmp dl, bl ; En el caso que sigamos igual, comparamos byte a byte
		jl .lower
		jg .bigger

		inc rcx
		jmp .loop

	; Seteamos valores segun las comparaciones
	.equal:
		mov eax, 0
		jmp .return

	.lower:
		mov eax, 1
		jmp .return

	.bigger:
		mov eax, -1

	.return:
		pop r13
		pop r12
		pop rbp
		ret

; char* strConcat(char* a, char* b)
; @params
; 	rdi: char* a
; 	rsi: char* b
; @return
; 	rax: char*
strConcat:
    ;Armo stack frame
    push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8

    mov rbp, rsp

    ;Inicializo los registros que contendran a_size y b_size
    xor r12, r12
    xor r13, r13

    ;Guardo los punteros del string a y el string b en r14 y r15 para luego liberar memoria
    mov r14, rdi
    mov r15, rsi

    call strLen

    ;Guardo a_size en r12d
    mov r12d, eax

    ;Guardo puntero a string a en rbp para usar rdi en el llamado a strlen
    mov rbp, rdi

    ;Guardo b_size en r13d
    mov rdi, rsi
    call strLen
    mov r13d, eax

    ;Sumo la cantidad total de caracteres de res en r12
    add r13d, r12d
    inc r13d

    ;Pido espacio en el heap para el string res
    mov edi, r13d
    call malloc

    ;Guardo la direccion de memoria inicial del string res en rbx
    mov rbx, rax

    xor ecx, ecx

    ;Vuelvo a resetear rdi y rsi, que habían perdido sus valores iniciales al llamar a malloc y strlen
    mov rdi, r14
    mov rsi, r15

    .loop:
        cmp ecx, r13d
        je .fin
        cmp ecx, r12d
        jge .concat_part_b
     .concat_part_a:
        mov r8b, [rdi]
        inc rdi
        mov [rax], r8b
        jmp .fin_concat
     .concat_part_b:
        mov r8b, [rsi]
        inc rsi
        mov [rax], r8b
     .fin_concat:
        inc rax
        inc ecx
        jmp .loop
    .fin:

        ;Libero memoria de los strings a y b
        cmp r14, r15
        je .punteros_iguales
     .punteros_distintos:
        mov rdi, r14
        call strDelete
     .punteros_iguales:
        mov rdi, r15
        call strDelete

        ;Seteo en rax la direccion de memoria inicial del string res
        mov rax, rbx

        ;Desarmo stack frame
        add rsp, 8
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
        pop rbp
        ret

; void strDelete(char* a)
; @params
;		rdi: char* a
strDelete:
	push rbp
	mov rbp, rsp

	; Usamos como parametro el que nos llega desde rdi
	call free

	pop rbp
	ret

; void strPrint(char* a, FILE* pfile)
; @params
; 	rdi: char* a
; 	rsi: FILE* pfile
strPrint:
    push rbp
    mov rbp, rsp

    cmp BYTE [rdi], NULL
    jne .fin
    mov rdi, fprintNull
    .fin:
        call fputs
        pop rbp
        ret

;*** List ***

; list_t* listNew()
; @return
; 	rax: list_t*
listNew:
    push rbp
    mov rbp, rsp

    ; Reservo 16 bytes de memoria, 8 para el primer puntero y 8 mas para el segundo
    mov rdi, 0x0010
    call malloc
    ; Inicializo los punteros first y last en 0.
    mov rbp, NULL
    mov [rax + OFFSET_LIST_FIRST], rbp
    mov [rax + OFFSET_LIST_LAST], rbp

    pop rbp
    ret

; void listAddFirst(list_t* l, void* data)
; @params
; 	rdi: list_t* l
; 	rsi: void* data
listAddFirst:
    push rbp
    mov rbp, rsp
    push r12
    sub rsp, 8

    ; Guardo el puntero al primer nodo de la lista
    mov rbp, rdi
    mov r12, rsi

    ; Reservo memoria para el s_listElem nuevo a agregar, 24bytes -> 0x0018
    mov rdi, 0x0018
    call malloc

    ; Guardo el dato en el nodo
    mov [rax + OFFSET_ELEM_DATA], r12

    ; Me fijo si el primer nodo de la lista es null
    xor rsi, rsi
    cmp [rbp], rsi
    jne .CasoNodoGenerico
    .CasoPrimerNodo:
    ; Si estoy agregando el primer nodo de la lista, siguiente y anterior apuntan ambos a null
    mov [rax+8], rsi
    mov [rax+16], rsi
    ; Seteo primer nodo y el ultimo nodo de la lista al nuevo nodo
    mov [rbp], rax
    mov [rbp+8], rax
    jmp .fin
    .CasoNodoGenerico:
    mov rdx, [rbp]
    ;newNodo->next = l->first
    mov [rax+8], rdx
    mov rdx, [rbp+8]
    ;newNodo->prev = null
    mov QWORD [rax+16], NULL

    .fin:
        ;Guardo en rcx y rdx los punteros al primer y ultimo nodo de la lista
        xor rcx, rcx
        xor rdx, rdx
        mov rcx, [rbp]
        mov rdx, [rbp+8]

        ; El anterior al ex primer nodo apunta al nuevo nodo
        mov [rcx+16], rax

        ; Ahora el primer nodo de la lista es el nuevo nodo
        mov [rbp], rax

        add rsp, 8
        pop r12
        pop rbp
        ret

; void listAddLast (list_t* l, void* data)
; @params
; 	rdi: list_t* l
; 	rsi: void* data
listAddLast:
  push rbp
  mov rbp, rsp
  push r12
  push r13

  ; Guardo el puntero al primer nodo de la lista
  mov rbp, rdi
  mov r13, rsi

  ; Reservo memoria para el s_listElem nuevo a agregar, 24bytes -> 0x0018
  mov rdi, 0x0018
  call malloc

  mov [rax + OFFSET_ELEM_DATA], r13 ; nuevoElem->dato = *dato
  mov QWORD [rax + OFFSET_ELEM_NEXT], NULL; nuevoElem->next = NULL

  cmp QWORD [rbp], NULL
  je .vacia

  mov r12, [rbp + OFFSET_LIST_LAST] ; r12 = l->last
  mov [rax + OFFSET_ELEM_PREV], r12; nuevoElem->prev = antiguaLista->last
  mov [r12 + OFFSET_LIST_LAST], rax ; antiguoLast->next = *nuevoElem
  mov [rbp + OFFSET_LIST_LAST], rax ; list->last = *nuevoElem

  jmp .return

  .vacia:
    mov [rbp + OFFSET_LIST_FIRST], rax ; lista->first = *nuevoElem
    mov QWORD [rax + OFFSET_ELEM_PREV], NULL; nuevoElem->prev = NULL
    mov [rbp + OFFSET_LIST_LAST], rax ; list->last = *nuevoElem

  .return:
    pop r13
    pop r12
    pop rbp
    ret

; void listAdd(list_t* l, void* data, funcCmp_t* fc)
; params
; 	rdi: list_t* l
; 	rsi: void* data
; 	rdx: funcCmp_t* fc
listAdd:
    push rbp
    push r12
    push r13
    push r14
    push r15

    ; Guardo el puntero al primer nodo de la lista
    mov rbp, rdi

    ; Guardo el puntero a la funcion de comparacion
    mov r14, rdx

    ; Guardo el valor de la data a insertar
    mov r15, rsi

    ; Reservo memoria para el s_listElem nuevo a agregar, 24 bytes -> 0x0018
    mov rdi, 0x0018
    call malloc

    ; Guardo el puntero al nuevo nodo a insertar
    mov r13, rax

    mov [r13 + OFFSET_ELEM_DATA], r15

    ; Pongo en r12 el puntero al primer nodo de la lista
    mov r12, [rbp + OFFSET_LIST_FIRST]

    .loop:
        cmp r12, NULL
        je .endLoop
        mov rdi, [r13 + OFFSET_ELEM_DATA]
        mov rsi, [r12 + OFFSET_ELEM_DATA]
        call r14
        cmp rax, 1
        je .endLoop
				; cmp rax, -1
				; je .caso2
        mov r12, [r12 + OFFSET_ELEM_NEXT]
        jmp .loop
    .endLoop:
        ; Me fijo el caso en el que el nodo a insertar es el unico(no habia nodos antes)
        cmp QWORD [rbp + OFFSET_LIST_FIRST], NULL
        jne .caso2
    .caso1:
        mov QWORD [r13 + OFFSET_ELEM_PREV], NULL
        mov QWORD [r13 + OFFSET_ELEM_NEXT], NULL
        mov [rbp + OFFSET_LIST_FIRST], r13
        mov [rbp + OFFSET_LIST_LAST], r13
        jmp .fin
    .caso2:
        ; Me fijo el caso en el que el nodo a insertar va a ser el primero de la lista
        cmp [rbp + OFFSET_LIST_FIRST], r12
        jne .caso3
        mov QWORD [r13 + OFFSET_ELEM_PREV], NULL
        mov [r13 + OFFSET_ELEM_NEXT], r12
        mov [r12 + OFFSET_ELEM_PREV], r13
        mov [rbp + OFFSET_LIST_FIRST], r13
        jmp .fin
    .caso3:
        ; Me fijo en el caso en el que el nodo a insertar va a ser el ultimo de la lista
        cmp r12, NULL
        jne .caso4
        mov rdx, [rbp + OFFSET_LIST_LAST]
        mov [r13 + OFFSET_ELEM_PREV], rdx
        mov QWORD [r13 + OFFSET_ELEM_NEXT], NULL
        mov rdx, [rbp + OFFSET_LIST_LAST]
        mov [rdx + OFFSET_ELEM_NEXT], r13
        mov [rbp + OFFSET_LIST_LAST], r13
        jmp .fin
    .caso4:
        ; Caso generico
        mov rdx, [r12 + OFFSET_ELEM_PREV]
        mov [r13 + OFFSET_ELEM_PREV], rdx
        mov [r13 + OFFSET_ELEM_NEXT], r12
        mov rdx, [r12 + OFFSET_ELEM_PREV]
        mov [rdx + OFFSET_ELEM_NEXT], r13
        mov [r12 + OFFSET_ELEM_PREV], r13
    .fin:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

; list_t* listClone(list_t* l, funcDup_t* fn)
; @params
;  	rdi: list_t* l
;  	rsi: funcDup_t* fn
; @return
;  	rax: list_t* newList
listClone:
  push rbp
  push rbx
  push r12
  push r13
  push r14
  push r15
	sub rsp, 8

  mov rbp, rdi
  mov r14, rsi

  ; Si el puntero a l = NULL => no hago nada
  mov rbp, [rbp + OFFSET_LIST_FIRST]
  cmp rbp, NULL
  je .noList

  ; Caso contrario, hago malloc de 16 bytes para lo que seria una lista
  mov rdi, 16
  call malloc
  ; r13 = clonedList
  mov r13, rax

  mov r15, NULL
  xor rbx, rbx
  .loop:
    ; Itero sobre la lista a partir de list->first hasta que elem->next = NULL
    ; rax = clonedElem
    mov rdi, 24
    call malloc

    cmp rbx, 0
    jne .notFirst
    mov [r13 + OFFSET_LIST_FIRST], rax ; clonedList->first = clonedElem

    .notFirst:
    mov rdi, [rbp + OFFSET_ELEM_DATA]
    mov r12, rax
    call r14 ; funcDup(elem->data) retorna en rax puntero a data
    mov rdi, rax
    mov rax, r12
    mov [rax + OFFSET_ELEM_DATA], rdi ; clonedElem->data = elem->data

    mov [rax + OFFSET_ELEM_PREV], r15 ; clonedElem->prev = prev
    mov QWORD [rax + OFFSET_ELEM_NEXT], NULL ; clonedElem->next = NULL

    cmp r15, NULL
    je .continue
    mov [r15 + OFFSET_ELEM_NEXT], rax ; lastClonedElem->next = clonedElem

    .continue:
    mov r15, rax ; lastClonedElem = clonedElem

    inc rbx

    mov rbp, [rbp + OFFSET_ELEM_NEXT] ; listElem = listElem->next
    cmp rbp, NULL
    jne .loop

  mov [r13 + OFFSET_LIST_LAST], rax ; clonedList->last = clonedElem

  mov rax, r13
  jmp .return

  .noList:
    mov rax, NULL

  .return:
		add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; void listDelete(list_t* l, funcDelete_t* fd)
; params
; 	rdi: list_t* l
; 	rsi: funcDelete_t* fd
listDelete:
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rbp, rsp

    ; Guardo el puntero a la lista en r15
    mov r15, rdi

    cmp rdi, NULL
    je .vacia

    ; Guardo el puntero actual en r13, y el anterior al actual en r12
    mov r13, [rdi + OFFSET_LIST_FIRST]
    mov r12, r13
    ; Me fijo si la lista tiene al menos un elemento
    cmp r13, NULL
    je .finListaSinElementos
    ; Si la lista tiene al menos un elemento, avanzo el puntero actual, quedando como resultado el anterior en r12
    mov r13, [r13 + OFFSET_ELEM_NEXT]

    ; Guardo el puntero a la func_Delete en r14
    mov r14, rsi

    .loop:
        cmp r13, NULL
        je .fin
        cmp QWORD [r12 + OFFSET_ELEM_DATA], NULL
        je .NoDeleteData
    .DeleteData:
        cmp rsi, NULL
        je .NoDeleteData
        mov rdi, [r12 + OFFSET_ELEM_DATA]
        call r14
    .NoDeleteData:
        mov rdi, r12
        call free
        mov r12, r13
        mov r13, [r13 + OFFSET_ELEM_NEXT]
        jmp .loop
    .fin:
        cmp QWORD [r12 + OFFSET_ELEM_DATA], NULL
        je .finNoDeleteData
    .finDeleteData:
        cmp rsi, NULL
        je .finNoDeleteData
        mov rdi, [r12 + OFFSET_ELEM_DATA]
        call r14
    .finNoDeleteData:
        mov rdi, r12
        call free
    .finListaSinElementos:
        mov rdi, r15
        call free
    .vacia:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

; void listPrint(list_t* l, FILE *pFile, funcPrint_t* fp)
; params
; 	rdi: list_t* l
; 	rsi: FILE *pFile
; 	rdx: funcPrint_t* fp
listPrint:
    push rbp
    push r12
    push r13
    push r14
    push r15
    mov rbp, rsp

    ; Guardo el puntero a la lista en r12, el puntero al FILE en r13, y el puntero a la funcion en r14
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    ; Me fijo si la lista que llega es vacia
    cmp r12, NULL
    je .vacia

    ; Me fijo si la lista no tiene elementos
    cmp QWORD [r12 + OFFSET_LIST_FIRST], NULL
    je .vacia

    ; En r15, voy a tener el puntero al nodo actual
    mov r15, [r12 + OFFSET_LIST_FIRST]

    ; Imprimo el character squareBracketsIni --> '['
    mov rdi, r13
    mov rsi, listPrintCharFormat
    xor rdx, rdx
    ; 0x5b --> '['
    mov dl, 0x5b
    call fprintf

    .loop:
        cmp r15, NULL
        je .fin
        cmp r14, NULL
        je .noFuncPointer
    .siFuncPointer:
        mov rdi, [r15 + OFFSET_ELEM_DATA]
        mov rsi, r13
        call r14
        jmp .avanzarPrintf
    .noFuncPointer:
        mov rdi, r13
        mov rsi, listPrintPointerFormat
        lea rdx, [r15 + OFFSET_ELEM_DATA]
        call fprintf
    .avanzarPrintf:
        ; Me fijo si el siguiente es nulo
        cmp QWORD [r15 + OFFSET_ELEM_NEXT], NULL
        je  .avanzarActual
        mov rdi, r13
        mov rsi, listPrintCharFormat
        xor rdx, rdx
        ; 0x2c --> ','
        mov dl, 0x2c
        call fprintf
    .avanzarActual:
        mov r15, [r15 + OFFSET_ELEM_NEXT]
        jmp .loop
    .fin:
        jmp .novacia
    .vacia:
        ; Imprimo el character squareBracketsStart --> '['
        mov rdi, r13
        mov rsi, listPrintCharFormat
        xor rdx,rdx
        mov dl, 0x5b
        call fprintf

    .novacia:
        ; Imprimo el character squareBracketsEnd --> ']'
        mov rdi, r13
        mov rsi, listPrintCharFormat
        xor rdx,rdx
        ; 0x5d --> ']'
        mov dl, 0x5d
        call fprintf

        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

;*** Sorter ***
; sorter_t* sorterNew(uint16_t slots, funcSorter_t* fs, funcCmp_t* fc)
; @params
; 	rdi: uint16_t slots
;   rsi: funcSorter_t* fs
;   rdx: funcCmp_t* fc
; @return
; 	rax: sorter_t* newSorter
sorterNew:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8

	xor r12, r12 ; ??? necesario para setear en 0 todo?
	mov r12w, di
	mov r13, rsi
	mov r14, rdx

	mov rdi, 32 ; size = 2 bytes, pero el resto de parametros = 8 bytes
	call malloc
	mov rbp, rax
	mov WORD [rbp + OFFSET_SORTER_SIZE], r12w ; sorter->size = size
	mov QWORD [rbp + OFFSET_SORTER_SORT_FN], r13 ; sorter->sorterFn = *sorterFn
	mov QWORD [rbp + OFFSET_SORTER_COMPARE_FN], r14 ; sorter->compareFn = *compareFn

	lea rdi, [r12 * 8] ; size * 8 bytes c/u
	call malloc
	mov QWORD [rbp + OFFSET_SORTER_SLOTS], rax
	mov r15, rax ; r15 = *sorter->slots

	xor rbx, rbx
	.loop:
	 	cmp rbx, r12
		je .endloop

		call listNew
		mov [r15 + rbx * 8], rax ; sorter->slots[rbx] = *listNew

		inc rbx
		jmp .loop

	.endloop:
		mov rax, rbp ; return *newSorter

		add rsp, 8
		pop rbx
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

; void sorterAdd(sorter_t* sorter, void* data)
; @params
; 	rdi: sorter_t* sorter
;   rsi: void* data
sorterAdd:
	push rbp
	push r12
	sub rsp, 8

	mov rbp, rdi
	mov r12, rsi

	mov rdi, rsi ; parametro para la sortFn
	call [rbp + OFFSET_SORTER_SORT_FN]
	; ax = slot donde tengo que insertar el dato
	mov rdi, [rbp + OFFSET_SORTER_SLOTS] ; calculo slots
	mov rdi, [rdi + rax * 8] ; calculo slots[slot]
	mov rsi, r12 ; dato a guardar
	mov rdx, [rbp + OFFSET_SORTER_COMPARE_FN]	; usamos la compareFn del
																						; sorter para agregar el dato
	call listAdd

	add rsp, 8
	pop r12
	pop rbp
	ret

; void sorterRemove(sorter_t* sorter, void* data, funcDelete_t* fd)
; @params
; 	rdi: sorter_t* sorter
;   rsi: void* data
;		rdx: funcDelete_t* fd
sorterRemove:
	push rbp
	push r12
	push r13

	mov rbp, rdi
	mov r12, rsi
	mov r13, rdx

	mov rdi, rsi
	call [rbp + OFFSET_SORTER_SORT_FN]

	mov rdi, [rbp + OFFSET_SORTER_SLOTS] ; calculo slots
	mov rdi, [rdi + rax * 8] ; calculo slots[slot]
	mov rsi, r12
	mov rdx, [rbp + OFFSET_SORTER_COMPARE_FN]
	mov rcx, r13
	call listRemove

	pop r13
	pop r12
	pop rbp
	ret


; list_t* sorterGetSlot(sorter_t* sorter, uint16_t slot, funcDup_t* fn)
; @params
;  	rdi: sorter_t* sorter
; 	si: uint16_t slot
; 	rdx: funcDup_t* fn
; @return
; 	rax: list_t*
sorterGetSlot:
    push rbp
    mov rbp, rsp

    ; Guardo en rcx el puntero a los slots
    mov rcx, [rdi + OFFSET_SORTER_SLOTS]

    ; Calculo en rbp el desplazamiento al slot ingresado por parametro
    and rsi, 0xFFFF
    lea rbp, [rsi * 8]
    ; Pongo en rcx el puntero a la lista correspondiente al slot ingresado por parametro
    mov rcx, [rcx + rbp]

    ; LLamo a listClone para clonar la lista usando la funcion de duplicacion ingresada por parametro
    mov rdi, rcx
    mov rsi, rdx
    call listClone

    pop rbp
    ret

; char* sorterGetConcatSlot(sorter_t* sorter, uint16_t slot)
; @params
; 	rdi: sorter_t* sorter
;   rsi: uint16_t slot
; @return
;   rax: char* concatString
sorterGetConcatSlot:
	push rbp
	push r12 ; puntero a la lista
	push r13 ; cantidad de caracteres
	push r14 ; contador de posicion sobre nueva memoria
	push r15 ; puntero a nueva memoria

	mov rbp, rdi
	mov rbp, [rbp + OFFSET_SORTER_SLOTS]
	mov rbp, [rbp + rsi * 8]
	mov rbp, [rbp + OFFSET_LIST_FIRST] ; calculamos la lista
	mov r12, rbp

	xor r13, r13
	xor r14, r14

	.getTotalLength:
		cmp rbp, NULL
		je .noMoreData

		mov QWORD rdi, [rbp + OFFSET_ELEM_DATA]
		call strLen

		add r13, rax
		mov rbp, [rbp + OFFSET_ELEM_NEXT]
		jmp .getTotalLength

	.noMoreData:
		inc r13 ; Para agregar el caracter nulo al final
		mov rdi, r13
		call malloc
		mov r15, rax
		mov rbp, r12

	.joinStrings:
		cmp rbp, NULL ; Lista no se termina
		je .return

		xor rcx, rcx ; Contador para cada string
		mov QWORD rdi, [rbp + OFFSET_ELEM_DATA]
		call strLen

		.loopString:
			cmp rcx, rax
			je .endLoopString

			mov r8, [rbp + OFFSET_ELEM_DATA]
			mov r8b, [r8 + rcx] ; Agarro cada byte del string
			mov [r15 + r14], r8b ; Lo guardo en la nueva memoria

			inc rcx
			inc r14
			jmp .loopString

		.endLoopString:
		mov rbp, [rbp + OFFSET_ELEM_NEXT]
		jmp .joinStrings

	.return:
		mov BYTE [r15 + r14], NULL ; Agrego el null al final
		mov rax, r15 ; Muevo al registro de retorno

		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

; void sorterCleanSlot(sorter_t* sorter, uint16_t slot, funcDelete_t* fd)
; @params
; 	rdi: sorter_t* sorter
; 	si: uint16_t slot
; 	rdx: funcDelete_t* fd
sorterCleanSlot:
    push rbp
    push r12
    push r13
    push r14
    push r15

    ; Guardo los datos ingresados como paramentro en registros rdi -> r12, si -> r13w, rdx -> r14
    mov r12, rdi
    and rsi, 0xFFFF
    mov r13, rsi
    mov r14, rdx

    ; Guardo en r15 el puntero a los slots
    mov r15, [r12 + OFFSET_SORTER_SLOTS]

    ; Pongo en rbp el puntero a la lista
    mov rbp, [r15 + r13 * 8]

    ; Pongo en r15, el puntero al nodo que tengo de la lista
    mov r15, [rbp + OFFSET_LIST_FIRST]

    .loop:
        cmp r15, NULL
        je .fin
        ; Pongo en r13 el puntero al siguiente de la lista
        mov r13, [r15 + OFFSET_ELEM_NEXT]

        mov rdi, [r15 + OFFSET_ELEM_DATA]
        call r14

        mov rdi, r15
        call free

        mov r15, r13
        jmp .loop

    .fin:
        mov QWORD [rbp + OFFSET_LIST_FIRST], NULL
        mov QWORD [rbp + OFFSET_LIST_LAST], NULL

        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

; void sorterDelete(sorter_t* sorter, funcDelete_t* fd)
; @params
; 	rdi: sorter_t* sorter
;   rsi: funcDelete_t* fd
sorterDelete:
	push rbp ; apunta al sorter
	push r12 ; guardo funcDelete
	push r13 ; contador para saber en que slot estamos
	push r14 ; apunta a cada lista
	push r15 ; apunta a los slots

	mov rbp, rdi
	mov r12, rsi

	mov r15, [rbp + OFFSET_SORTER_SLOTS]

	xor r13, r13
	.loopslots:
		cmp WORD r13w, [rbp + OFFSET_SORTER_SIZE]
		je .endloop

		mov r14, [r15 + r13 * 8]

		mov rdi, r14
		mov rsi, r12
		call listDelete ; Limpio las listas

		inc r13
		jmp .loopslots

	.endloop:
		mov rdi, r15 ; Limpio el espacio de los slots
		call free

		mov rdi, rbp ; Limpio el espacio del sorter
		call free

		pop r15
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

; void sorterPrint(sorter_t* sorter, FILE *pFile, funcPrint_t* fp)
; @params
; 	rdi: sorter_t* sorter
; 	rsi: FILE *pFile
; 	rdx: funcPrint_t* fp
sorterPrint:
    push rbp
    push r12
    push r13
    push r14
    push r15

    ; Guardo rdi --> r12, rsi --> r13, rdx --> r14
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx

    ; En rbp voy a tener la cantidad de listas que hay en el sorter
    mov bp, [r12 + OFFSET_SORTER_SIZE]
    and rbp, 0xffff

    ; En r12 voy a poner ahora el puntero a los slots
    mov r12, [r12 + OFFSET_SORTER_SLOTS]

    ; En r15 voy a tener mi variable contadora
    xor r15w, r15w

    .loop:
        cmp r15w, bp
        je .fin

        ; Imprimo el valor de mi variable contadora, y luego el de la lista correspondiente
        mov rdi, r13
        mov rsi, sorterPrintUFormat
        mov dx, r15w
        and rdx, 0xffff
        call fprintf

        and r15, 0xffff

        ; Imprimo el valor de " = ", el character ' ' es 0x00203d20
        mov rdi, r13
        mov rsi, listPrintCharFormat
        mov rdx, 0x0020
        call fprintf

        ; Imprimo el valor de " = ", el character ' ' es 0x00203d20
        mov rdi, r13
        mov rsi, listPrintCharFormat
        mov rdx, 0x003d
        call fprintf

        ; Imprimo el valor de " = ", el character ' ' es 0x00203d20
        mov rdi, r13
        mov rsi, listPrintCharFormat
        mov rdx, 0x0020
        call fprintf

        ; Imprimo el contenido de la lista
        mov rdi, [r12 + 8 * r15]
        mov rsi, r13
        mov rdx, r14
        call listPrint

        ; Imprimo el salto de linea SorterPrintNewline
        mov rdi, r13
        mov rsi, sorterPrintStringFormat
        mov rdx, sorterPrintNewline
        call fprintf

        inc r15
        jmp .loop

    .fin:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

;*** aux Functions ***
; uint16_t fs_sizeModFive(char* s)
; @params
; 	rdi: char* s
; @return
; 	ax: uint16_t sizeModFive
fs_sizeModFive:
	push rbp

	mov rbp, rdi
	xor rcx, rcx
	.loop:
		cmp BYTE [rbp + rcx], NULL
		je .endloop
		inc rcx
		jmp .loop

	.endloop:
		xor edx, edx
		mov eax, ecx ; dividendo
		mov ecx, 5 ; divisor
		div ecx ; resultado en dx
		mov ax, dx

		pop rbp
		ret

; uint16_t fs_firstChar(char* s)
; @params
; 	rdi: char* s
; @return
; 	ax: uint16_t firstChar
fs_firstChar:
	xor rax, rax
	mov al, [rdi]
	ret

; uint16_t fs_bitSplit(char* s)
; @params
; 	rdi: char* s
; @return
; 	ax: uint16_t splittedWord
fs_bitSplit:
	push rbp

	mov rbp, rdi
	xor rax, rax

	cmp BYTE [rbp], 0
	jne .case_even
	mov ax, 8
	jmp .return

	.case_even:
		mov BYTE al, [rbp]
		dec al
		and BYTE al, [rbp]
		; al = rbp & (rbp - 1) = 0 => potencia de 2
		cmp al, 0
		jne .case_other

		mov BYTE al, [rbp]
		xor cx, cx
		shr al, 1
		.loop:
			cmp al, 0
			je .endloop
			shr al, 1
			inc cx
			jmp .loop

		.endloop:
			mov ax, cx
			jmp .return

	.case_other:
		mov ax, 9

	.return:
		pop rbp
		ret
