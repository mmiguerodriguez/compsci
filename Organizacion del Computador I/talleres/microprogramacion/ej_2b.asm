main:	SET R0, 0x0001 ; A
	SET R1, 0x0001 ; B
	SET R2, 0x0005 ; N
	SET R4, 0x0000 ; Zero
loop:	CMP R2, R4
	JZ fin
	MOV R3, R0
	ADD R3, R1
	MOV R0, R1
	MOV R1, R3
	DEC R2
	JMP loop
fin:	
