main:	MOV R0, [inicio]
	MOV R1, [longitud]
	ADD R1, R0
	MOV R2, 0x8000
	MOV R3, 0x7FFF

loop:	CMP [R0], R2
	JGE mayor
mayor:	MOV R2, [R0]

	JLE menor
menor:	MOV R3, [R0]

	ADD R0, 0x0001
	CMP R0, R1
	JNE loop

inicio:	DW 0x0014
longitud:	DW 0x0005

	DW 0x0001
	DW 0x0003
	DW 0x0002
	DW 0xFFFF
	DW 0x0000
