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
#a0 Para SYSCALL
# $a1,$a2, $a3 son para entrada de funciones

# $t0 LLeva la cuenta de la profundidad de la la funcion
# $t1 lleva la cuenta cuantas veces se ha presionado s. Comienza en 0
# $t2 es usado para Guardar Pila
# $t3 es usado para Loop en Print_Space
# $t4-t6 Lo usa Calendario



.text
main:	li $t1, 1
	 j Impresion
     
#Funciones Basicas
Print_TZ:
	beqz $a1, AM
		la $a0, TimeZone2
		li $v0, 4
		syscall	
		
		bne $t0, $zero, UsarPila	
		jr $ra
	AM:
		la $a0, TimeZone1
		li $v0, 4
		syscall	
		bne $t0, $zero, UsarPila
		jr $ra
Print_Hora:
	lb $a0, Hora
	li $v0, 1
	syscall
	bne $t0, $zero, UsarPila
	jr $ra
Print_Min:
	lb $a0, Minuto
	li $v0, 1
	syscall
	bne $t0, $zero, UsarPila
	jr $ra
Print_Ano:
	lb $a0, Ano
	li $v0, 1
	syscall
	bne $t0, $zero, UsarPila
	jr $ra
Print_Mes:
	lb $a0, Mes
	li $v0, 1
	syscall
	bne $t0, $zero, UsarPila
	jr $ra
Print_Dia:
	lb $a0, Dia
	li $v0, 1
	syscall
	bne $t0, $zero, UsarPila
	jr $ra
Print_Space:#Necesita cargar en las iteraciones
	move $t3, $a1
	loop:   beqz $t3, endloop
			li $a0, ' ' 
			li $v0, 11
			syscall
			sub $t3, $t3,1
			j loop
	endloop:
	bne $t0, $zero, UsarPila	
	jr $ra
	
Print_DP:
Print_LB:
	li $a0, '['
	li $v0, 11
	syscall
	
	bne $t0, $zero, UsarPila
	jr $ra

Print_RB:
	li $a0, ']'
	li $v0, 11
	syscall
	
	bne $t0, $zero, UsarPila
	jr $ra
	
GuardarPila:
	move $t2,$ra
	add $t2, $t2, 12 
	sw $t2 0($sp)
	add $sp, $sp, 4
	add $t0, $t0, 1
	li $t2, 0
	jr $ra
UsarPila:
	sub $t0, $t0, 1
	sub $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra
EliminarPila:
	beqz $t0, salto
	sub $t0, $t0, 1
	sub $sp, $sp, 4
	jr $ra
	salto:
		jr $ra
	
Print_Linea:
    	li $v0 4            
    	la $a0 nueva_linea
    	syscall
    	
    	bne $t0, $zero, UsarPila
    	jr $ra
Print_Calendario:#Recibe a1 donde inicia la semana
	jal GuardarPila
	jal Print_Linea
	nop
	nop
	#a1,a2,a3
	mul $a3, $a1, 3
	jal GuardarPila
	jal Print_Space
	nop
	nop 
	jal GuardarPila
	jal Print_Space
	nop
	nop
	li $t4, 0
	li $t5, 0
	add $t4, $t4, $a1
	move $t8, $a1
	li $a1, 1
	loopDia: beq $t5, 9, endUnidades
		 add $t5, $t5, 1
		 add $t4, $t4, 1
		 
		 jal GuardarPila
		 beq $t4, 7, Print_Linea
		 jal EliminarPila		 
		 nop
		 nop
		 jal GuardarPila
		 beq $t4, 7,SeteoEspacio
		 jal EliminarPila
		 nop
		 nop
		 jal GuardarPila
		 beq $t4, 7,ReinicioSem
		 jal EliminarPila
		 nop
		 li $a1, 1
		 jal GuardarPila
		 jal Print_Space
		 nop
		 nop
		 jal GuardarPila
		 jal Print_Space
		 nop
		 nop		 
		 move $a0 $t5
		 li $v0 1
		 syscall		 
		 
	j loopDia
	
endUnidades:
		li $a1 1
		move $t6 $t4
		move $t4 $a2
		li $t5 10
		
		loopMes:beq $t5, $t4 endCalendario
			add $t5, $t5, 1
			add $t6, $t6, 1
			
		 	jal GuardarPila
		 	beq $t6, 7, Print_Linea
			jal EliminarPila
			nop
			nop		 
		 	jal GuardarPila
			beq $t6, 7,SeteoEspacio
		 	jal EliminarPila
		 	nop
		 	nop
		 	jal GuardarPila
		 	beq $t6, 7,ReinicioSem
		 	jal EliminarPila
		 	nop
		 	nop
		 	li $a1, 1
		 	jal GuardarPila
		 	jal Print_Space
		 	nop
		 	nop
		 	move $a0 $t5
		 	li $v0 1
		 	syscall
		j loopMes
		
ReinicioSem:	
		beq $t4,7 endt4
		beq $t6,7 endt6
		endt4:
			li $t4,0
			bne $t0, $zero, UsarPila
			jr $ra	
		endt6:
			li $t6,0
			bne $t0, $zero, UsarPila
			jr $ra	

endCalendario:
		
		jal UsarPila

SeteoEspacio:
		move $a1, $t8
		j Print_Space
#Funcion de Impresion General
Impresion:

	jal GuardarPila
	beq $t1, 1, Print_LB
	jal EliminarPila
	
	jal Print_TZ
	
	jal GuardarPila
	beq $t1, 1, Print_RB
	jal EliminarPila
	
	li $a1 2
	jal Print_Space
	
	jal GuardarPila
	beq $t1, 2, Print_LB
	jal EliminarPila
	
	jal Print_Hora
	
	jal GuardarPila
	beq $t1, 2, Print_RB
	jal EliminarPila
	
	li $a1 2
	jal Print_Space
	
	jal GuardarPila
	beq $t1, 3, Print_LB
	jal EliminarPila
	
	jal Print_Min
	
	jal GuardarPila
	beq $t1, 3, Print_RB
	jal EliminarPila
	
	li $a1 2
	jal Print_Space
	
	jal GuardarPila
	beq $t1, 4, Print_LB
	jal EliminarPila
	
	jal Print_Ano
	
	jal GuardarPila
	beq $t1, 4, Print_RB
	jal EliminarPila
	
	li $a1 2
	jal Print_Space
	
	jal GuardarPila
	beq $t1, 5, Print_LB
	jal EliminarPila
	
	jal Print_Mes
	
	jal GuardarPila
	beq $t1, 5, Print_RB
	jal EliminarPila
	
	li $a1 2
	jal Print_Space
	
	jal GuardarPila
	beq $t1, 6, Print_LB
	jal EliminarPila
	
	jal Print_Dia
	
	jal GuardarPila
	beq $t1, 6, Print_RB
	jal EliminarPila
	
	jal GuardarPila
	li $a1 0
	li $a2 31
	jal Print_Calendario
	
	j end



end:
