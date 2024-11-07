.data
TimeZone1:.asciiz "AM"
TimeZone2:.asciiz "PM"
Hora:.byte 0
Minuto:.byte 0
Ano:.word 0
Mes:.byte 0
Dia:.byte 0

#Uso de Registros
# $t0 lleva la cuenta cuantas veces se ha presionado s. Comienza en 0
# $t1 tendra la direccion de unos programas
# $t4 lleva la cuenta de si es mañana o noce. O o 1


.text
main: j Impresion
     li $t0 0x004000ac
     addi $sp, $sp, -4 
#Funciones Basicas
Print_TZ:
	beqz $t4, AM
		la $a0, TimeZone2
		li $v0, 4
		syscall	
		jr $ra
	AM:
		la $a0, TimeZone1
		li $v0, 4
		syscall	
		jr $ra
Print_Hora:
	lb $a0, Hora
	li $v0, 1
	syscall
	jr $ra
Print_Min:
	lb $a0, Minuto
	li $v0, 1
	syscall
	jr $ra
Print_Ano:
	lb $a0, Ano
	li $v0, 1
	syscall
Print_Mes:
	lb $a0, Mes
	li $v0, 1
	syscall
Print_Dia:
	lb $a0, Dia
	li $v0, 1
	syscall
Print_Space:
Print_DP:
Print_LB:
	li $a0, '['
	li $v0, 11
	syscall
	jr $ra
Print_RB:
	li $a0, ']'
	li $v0, 11
	syscall
	jr $ra
	
Guardar:
	move $t1, $ra
	add $t1, $t1, 12
	jr $ra
#Funcion de Impresion General
Impresion:

	jal Guardar
	move $ra, $t1
	beq $t0, 0, Print_LB
	jal Print_TZ
	beq $t0, 0, Print_RB

	beq $t0, 1, Print_LB
	jal Print_Hora
	beq $t0, 1, Print_RB
	

	beq $t0, 2, Print_LB
	jal Print_Min
	beq $t0, 2, Print_RB
	
	j end



end:
