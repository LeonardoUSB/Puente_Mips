.data
TimeZone1:.asciiz "AM"
TimeZone2:.asciiz "PM"
nueva_linea: .asciiz "\n"
Hora:.byte 0
Minuto:.byte 0
Ano:.word 0
Mes:.byte 0
Dia:.byte 0

#Uso de Registros
# $a1 Y $a2 son Auxiliar para funciones
# $t0 lleva la cuenta cuantas veces se ha presionado s. Comienza en 0
# $t1 tendra la direccion de unos programas



.text
main: j Impresion
     
#Funciones Basicas
Print_TZ:
	beqz $a1, AM
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
	jr $ra
Print_Mes:
	lb $a0, Mes
	li $v0, 1
	syscall
	jr $ra
Print_Dia:
	lb $a0, Dia
	li $v0, 1
	syscall
	jr $ra
Print_Space:#Necesita cargar en las iteraciones
	loop:   beqz $a1, endloop
			li $a0, ' ' 
			li $v0, 11
			syscall
			sub $a1, $a1,1
	endloop:		
	jr $ra
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
	
RestartS:
	li $t0 1
	jr $ra
Print_Linea:
    	li $v0 4            
    	la $a0 nueva_linea
    	syscall
    	jr $ra
Print_Calendario:#Recibe a2, numero de dias, a1, donde inicia la semana
	jal Print_Linea
	jal Print_Space
	


#Funcion de Impresion General
Impresion:

	jal Guardar
	move $ra, $t1
	beq $t0, 1, Print_LB
	
	jal Print_TZ
	
	jal Guardar
	move $ra, $t1
	beq $t0, 1, Print_RB
	
	li $a1 2
	jal Print_Space
	
	jal Guardar
	move $ra, $t1
	beq $t0, 2, Print_LB
	
	jal Print_Hora
	
	jal Guardar
	move $ra, $t1
	beq $t0, 2, Print_RB
	
	li $a1 2
	jal Print_Space
	
	jal Guardar
	move $ra, $t1
	beq $t0, 3, Print_LB
	
	jal Print_Min
	
	jal Guardar
	move $ra, $t1
	beq $t0, 3, Print_RB
	
	li $a1 2
	jal Print_Space
	
	jal Guardar
	move $ra, $t1
	beq $t0, 4, Print_LB
	
	jal Print_Ano
	
	jal Guardar
	move $ra, $t1
	beq $t0, 4, Print_RB
	
	li $a1 2
	jal Print_Space
	
	jal Guardar
	move $ra, $t1
	beq $t0, 5, Print_LB
	
	jal Print_Mes
	
	jal Guardar
	move $ra, $t1
	beq $t0, 5, Print_RB
	
	li $a1 2
	jal Print_Space
	
	jal Guardar
	move $ra, $t1
	beq $t0, 6, Print_LB
	
	jal Print_Dia
	
	jal Guardar
	move $ra, $t1
	beq $t0, 6, Print_RB
	
	jal Guardar
	move $ra, $t1
	beq $t0, 7, RestartS
	
	j end



end:
