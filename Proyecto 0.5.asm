.data
Formato: .asciiz "YEAR MO DD"
TimeZone1: .asciiz "AM"
TimeZone2: .asciiz "PM"
Hora1: .byte 1
Hora2: .byte 2
Minuto1: .byte 0
Minuto2: .byte 0
Ano: .word 2024
Mes1: .byte 1
Mes2:.byte 1
Dia1: .byte 5
Dia2: .byte 5
NuevaLinea: .asciiz "\n"
eleccion: .space 1

#a2 tiene si es de mañana o tarde
.text
Main:		j ModoTick

ModoTick:
		jal GuardarPila
		jal ImpresionNormal
		jal EliminarPila
		
		jal LeerTeclado
		beq $v0, 'M', ModoSet
		bne $v0, 'T',ModoTick

ModoSet:	
		
		jal LeerTeclado
		beq $v0, 'M', ModoAlarma
		
		beq $v0, 'S', Set
		beq $v0, 'U', U
		beq $v0, 'D', D
		
		
		
		j ModoSet


U:

D:

ModoAlarma:
		#jal guardarPila
		#jal Impresion
		#jal eliminarPila
		
		jal LeerTeclado
		beq $v0, 'M', ModoTick

LeerTeclado:
		
		li $v0 12
		syscall

		sb $v0,eleccion
		jr $ra
		

		

Set:
	add $s3, $s3, 1
	
	beq $s3, 1 SetCaso1
	beq $s3, 2 SetCaso2
	beq $s3, 3 SetCaso3
	beq $s3, 4 SetCaso4
	beq $s3, 5 SetCaso5
	beq $s3, 6 SetCaso6
	
	beq $s3, 7 SetearS3
	j ModoSet	

SetearS3:
		li $s3 1

Alarma:

Tick:

SetCaso1:
		li $a1 1
		jal PrintLB
		jal PrintTZ	
		jal PrintRB
		
		jal PrintHora
		jal PrintDD
		jal PrintMinuto
		
		li $a1 6
		jal PrintSpace
		
		jal PrintAno	
															
		li $a1 6
		jal PrintSpace
		
		jal PrintMes
		
		li $a1 6
		jal PrintSpace
		
		jal PrintDia
	
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		j ModoSet
SetCaso2:	

		li $a1 1
		jal PrintSpace
		
		jal PrintTZ
		
		li $a1 2
		jal PrintSpace
		
		jal PrintLB
		jal PrintHora
		jal PrintRB 
		jal PrintMinuto
		
		li $a1 6
		jal PrintSpace
		
		jal PrintAno	
															
		li $a1 6
		jal PrintSpace
		
		jal PrintMes
		
		li $a1 6
		jal PrintSpace
		
		jal PrintDia
	
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		j ModoSet

SetCaso3:
		li $a1 1
		jal PrintSpace
		
		jal PrintTZ
		
		li $a1 2
		jal PrintSpace
		
		jal PrintHora
		jal PrintLB
		jal PrintMinuto
		jal PrintRB
		
		li $a1 6
		jal PrintSpace
		
		jal PrintAno	
															
		li $a1 6
		jal PrintSpace
		
		jal PrintMes
		
		li $a1 6
		jal PrintSpace
		
		jal PrintDia
	
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		j ModoSet
SetCaso4:
		li $a1 1
		jal PrintSpace
		
		jal PrintTZ
		
		li $a1 2
		jal PrintSpace
		
		jal PrintHora
		jal PrintDD
		jal PrintMinuto
		
		li $a1 6
		jal PrintSpace
		jal PrintLB
		jal PrintAno
		jal PrintRB
		
		li $a1 6
		jal PrintSpace
		
		jal PrintMes
		
		li $a1 6
		jal PrintSpace
		
		jal PrintDia
	
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		j ModoSet
SetCaso5:	
		#Cabecera
		li $a1 1
		jal PrintSpace
		
		jal PrintTZ
		
		li $a1 2
		jal PrintSpace
		
		jal PrintHora
		jal PrintDD
		jal PrintMinuto
		
		li $a1 6
		jal PrintSpace
		
		jal PrintAno	
															
		li $a1 6
		jal PrintSpace
		jal PrintLB
		jal PrintMes
		jal PrintRB
		
		li $a1 6
		jal PrintSpace
		
		jal PrintDia
	
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		j ModoSet
SetCaso6:
		li $a1 1
		jal PrintSpace
		
		jal PrintTZ
		
		li $a1 2
		jal PrintSpace
		
		jal PrintHora
		jal PrintDD
		jal PrintMinuto
		
		li $a1 6
		jal PrintSpace
		
		jal PrintAno	
															
		li $a1 6
		jal PrintSpace
		
		jal PrintMes
		
		li $a1 6
		jal PrintSpace
		
		jal PrintLB
		jal PrintDia
		jal PrintRB
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		j ModoSet
PrintLB:
	li $a0, '['
	li $v0, 11
	syscall
	
	jr $ra

PrintRB:
	li $a0, ']'
	li $v0, 11
	syscall
	
	jr $ra

ImpresionNormal:
		#Cabecera
		li $a1 1
		jal PrintSpace
		
		jal PrintTZ
		
		li $a1 2
		jal PrintSpace
		
		jal PrintHora
		jal PrintDD
		jal PrintMinuto
		
		li $a1 6
		jal PrintSpace
		
		jal PrintAno	
															
		li $a1 6
		jal PrintSpace
		
		jal PrintMes
		
		li $a1 6
		jal PrintSpace
		
		jal PrintDia
	
		#Medio
		jal PrintLinea
		li $a1 10
		jal PrintSpace
		
		li $v0 4            
		la $a0 Formato        
 		syscall
 		
 		jal PrintLinea
 		
 		#Calendario
 		li $s0 1            # El número de días. Empieza en el 1.
    		li $s1 31
    		li $s2 0
    		
    		jal GuardarPila
 		jal PrintCalendario
 		jal EliminarPila
 		
 		jal UsarPila
 		
PrintCalendario:
		bgt $s0 $s1 end
		
		blt $s0 10 Unidades
		
		bgt $s0 9 Decenas 


Unidades:
		li $a1 1
		jal PrintSpace
		
		li $v0 1            
		move $a0 $s0      
		syscall
		
		li $a1 1
		jal PrintSpace
		
		addi $s0 $s0 1     # Incrementar el contador de días en 1.
		addi $s2 $s2 1
		
		beq $s2 7 SaltoAuxiliar
		
		j PrintCalendario
		
SaltoAuxiliar:
		jal PrintLinea
		li $s2 0
		j PrintCalendario
Decenas:
		li $v0 1            
		move $a0 $s0      
		syscall	
		
		li $a1 1
		jal PrintSpace
		
		addi $s0 $s0 1     # Incrementar el contador de días en 1.
		addi $s2 $s2 1
		
		beq $s2 7 SaltoAuxiliar
		j PrintCalendario
		
		
end: 		
		jal PrintLinea
		jal UsarPila
PrintSpace:
		beqz $a1, EndPrintSpace
		li $a0, ' ' 
		li $v0, 11
		syscall
		sub $a1, $a1,1
		j PrintSpace

EndPrintSpace:
		jr $ra

PrintLinea:	
		li $v0 4            
    		la $a0 NuevaLinea
    		syscall	
    		
    		jr $ra
PrintTZ:
		beqz $a2, AM
		la $a0, TimeZone2
		li $v0, 4
		syscall	
			
		jr $ra
	AM:
		la $a0, TimeZone1
		li $v0, 4
		syscall	
		
		jr $ra

PrintHora:	
		lb $a0, Hora1
		beqz $a0, UnidadHora
		
		lb $a0, Hora1
		li $v0, 1
		syscall
		
		lb $a0, Hora2
		li $v0, 1
		syscall
		
		jr $ra

UnidadHora:	
		li $a0, ' ' 
		li $v0, 11
		syscall
			
		lb $a0, Hora2
		li $v0, 1
		syscall
		
		jr $ra
		
PrintDD:		
		li $a0, ':'
		li $v0, 11
		syscall
		
		jr $ra
		
PrintMinuto:
		lb $a0, Minuto1
		li $v0, 1
		syscall
		
		lb $a0, Minuto2
		li $v0, 1
		syscall
		
		jr $ra

PrintAno:	
		lw $a0, Ano
		li $v0, 1
		syscall
		
		jr $ra

PrintMes:	
		lb $a0, Mes1
		li $v0, 1
		syscall
		
		lb $a0, Mes2
		li $v0, 1
		syscall
		
		jr $ra
		

PrintDia:

		lb $a0, Dia1
		li $v0, 1
		syscall
		
		lb $a0, Dia2
		li $v0, 1
		syscall
		
		jr $ra



GuardarPila:
	move $t2,$ra
	add $t2, $t2, 4 
	sw $t2 0($sp)
	add $sp, $sp, 4
	add $t0, $t0, 1
	li $t2, 0
	jr $ra
	

UsarPila:
	sub $sp, $sp, 4
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
EliminarPila:
	beqz $t0, salto
	sub $t0, $t0, 1
	sub $sp, $sp, 4
	jr $ra
	salto:
		jr $ra	
		
