main:	SET R0, 0x000A
	SET R1, 0x0003
loop:	CMP R0, R1
	JZ fin
	JN menor
	SUB R0, R1
	JMP loop
menor:	SUB R1, R0
	JMP loop
fin:	
