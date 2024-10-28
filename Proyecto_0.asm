.data
Tiempo1:.asciiz "AM "
Tiempo2:.asciiz "PM "
Numeros1: .byte 23,11
Numeros2: .word 2234,34,56


.text

la $t0, Numeros1
li $t1, 2
li $t2, 1

la $a0 Tiempo1
li $v0, 4
syscall

Imprimir_reloj: beqz  $t1, end1
		lb $a0, 0($t0)
		li $v0, 1
		syscall
		
		beq $t1,$t2, parte1
		li $a0, ':'
		li $v0, 11
		syscall

parte1:		add $t0, $t0, 1
		add $t1, $t1, -1

		j Imprimir_reloj
		
end1: la $t0, Numeros2	
	li $t1, 3
	li $t2, 1
	
	li $a0, ' '
	li $v0, 11
	syscall

Imprimir_Año: 	beqz  $t1, end2
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		
		beq $t1,$t2, parte2
		li $a0, '-'
		li $v0, 11
		syscall
		
parte2:		add $t0, $t0, 4
		add $t1, $t1, -1
		j Imprimir_Año
		
		
end2:	li $v0, 10 
	syscall