.data
nueva_linea: .asciiz "\n"
espacio: .asciiz " "
espacio1: .asciiz " "
espacio2: .asciiz " "
espacio3: .asciiz " "
espacio4: .asciiz " "
dd: .asciiz ":"
guion1: .asciiz "-"
guion2: .asciiz "-"
formato: .asciiz "YEAR MO DD"
mensaje: .asciiz "Ingrese un caracter: "
teclado: .space 1
TimeZone1: .asciiz "PM"
TimeZone2: .asciiz "PM"
Hora: .byte 12
Minuto1: .byte 5
Minuto2: .byte 9
Ano: .word 2024
Mes: .byte 12
Dia: .byte 31
#Dias del 2000
Enero:.byte 31
Febrero:.byte 29
Marzo:.byte 31
Abril:.byte 30
Mayo:.byte 31
Junio:.byte 30
Julio:.byte 31
Agosto:.byte 31
Septiembre:.byte 30
Octubre:.byte 31
Noviembre:.byte 30
Diciembre:.byte 31

#Uso de Registros
#a0 Para SYSCALL

# $t1, $t8 y $t9 se usan temporalmente para ir almacenando en registros algunas variables.
# $t0 y $t2 son para la pila.
# $t5-t7 lo usa Calendario.
# $s1 e para el TimeZone.
# $s6 es para guardar el teclado.
# $s7 es el contador de casos para Set.

# Estructura resumen
# main:
# 	Impresión (Se imprime en consola Cabecera, Medio, Calendario).
#	Teclado (Se recibe por teclado los botones S,M,U,D). NO HECHO.
#	Acción (Se modifican los valores de la fecha u hora, lo cual modificará la impresión). NO HECHO.
#       j main

# Nota: El código de todos los Print y de la pila está hacia el final.


.text
main:	
	# Impresión
	jal Impresion
        
	# Teclado
	jal Teclado
    
	# Acción
	j Accion

Impresion:
	j Cabecera
Cabecera:
	# Imprime lo siguiente: PM 12:00  2024-11-15

	# Salto de línea.
	li $v0 4            
	la $a0 nueva_linea
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio1        
 	syscall

	# PM
        li $v0 4            
        la $a0 TimeZone2
        syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio2        
 	syscall
	
	# Hora
	la $t1 Hora
	lb $t8, 0($t1)	# Carga Hora en $t8.
	
        li $v0 1          
        move $a0 $t8
	syscall
	
	# :
        li $v0 4            
        la $a0 dd
        syscall
	
	# Minuto1
	la $t1 Minuto1
	lb $t8, 0($t1)	# Carga Minuto1 en $t8.
		
        li $v0 1          
        move $a0 $t8
	syscall
	
	# Minuto2
	la $t1 Minuto2
	lb $t8, 0($t1)	# Carga Minuto2 en $t8.
	
        li $v0 1          
        move $a0 $t8
	syscall
	
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio3        
 	syscall	
	
	# Ano
	la $t1 Ano
	lw $t8, 0($t1)	# Carga Ano en $t8.
		
        li $v0 1          
        move $a0 $t8
	syscall														

	# Guion1
        li $v0 4            
        la $a0 guion1
        syscall

	# Mes
	la $t1 Mes
	lb $t8, 0($t1)	# Carga Mes en $t8.
		
        li $v0 1          
        move $a0 $t8
	syscall
	
	# Guion2
        li $v0 4            
        la $a0 guion2
        syscall	
	
	# Dia
	la $t1 Dia
	lb $t8, 0($t1)	# Carga Dia en $t8.
		
        li $v0 1          
        move $a0 $t8
	syscall
	
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio4 
 	syscall

 	li $t1 0     # Vaciar $t1 por si acaso.
	li $t8 0     # Vaciar $t8 por si acaso. 	
 	
 	j Medio

Medio:
	# Imprime lo siguiente: (10 espacios) YEAR MO DD

	# Imprime una nueva línea para estar por debajo de Cabecera.
	li $v0 4            
	la $a0 nueva_linea        
 	syscall
		
	# Bucle que se ejecuta 10 veces para imprimir 10 espacios.		
	li $t4 0
	
	j loop
	
loop:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
 	syscall
 	
	addi $t4 $t4 1
		
	blt $t4 10 loop
	
	# Cuando se han impreso 10 espacios se rompe el bucle y sigue aquí.
	li $t4 0    # Vaciar $t4 por si acaso.
	j Medio2

Medio2:
	# Imprimir YEAR MO DD.
	li $v0 4            
	la $a0 formato        
 	syscall
 	
 	# Imprime la nueva línea para el Calendario.
	li $v0 4            
	la $a0 nueva_linea        
 	syscall
	
	j Calendario

Calendario:
	# Esto no maneja pilas ni jal. Esto es puro código que se ejecuta de arriba a abajo.
	lb $s4 Mes
    	li $t5 1            # El número de días. Empieza en el 1.
    			    
    	li $t7 0            # Contador de días por semana.
	
printCalendario:
		beq $s4, 1 CasoEne
		beq $s4, 2 CasoFeb
		beq $s4, 3 CasoMar
		beq $s4, 4 CasoAbr
		beq $s4, 5 CasoMay
		beq $s4, 6 CasoJun
		beq $s4, 7 CasoJul
		beq $s4, 8 CasoAgo
		beq $s4, 9 CasoSep
		beq $s4, 10 CasoOct
		beq $s4, 11 CasoNov
		beq $s4, 12 CasoDic
		
		j ComienzoCalendario
		
CasoEne: 
		lb $t6 Enero
		j ComienzoCalendario
CasoFeb:
		lb $t6 Febrero
		j ComienzoCalendario
		
CasoMar:
		lb $t6 Marzo
		j ComienzoCalendario
CasoAbr:
		lb $t6 Abril
		j ComienzoCalendario
CasoMay:
		lb $t6 Mayo
		j ComienzoCalendario
CasoJun:
		lb $t6 Junio
		j ComienzoCalendario
CasoJul:
		lb $t6 Julio
		j ComienzoCalendario
CasoAgo:
		lb $t6 Agosto
		j ComienzoCalendario
CasoSep:
		lb $t6 Septiembre
		j ComienzoCalendario
CasoOct:
		lb $t6 Octubre
		j ComienzoCalendario
CasoNov:
		lb $t6 Noviembre
		j ComienzoCalendario
CasoDic:
		lb $t6 Diciembre
		j ComienzoCalendario
	
ComienzoCalendario:
			
	bgt $t5 $t6 endCalendario     # Si $t5 = 31, ya imprimió todos los días.

	blt $t5 10 unidades # Si el día es de un dígito (menor que 10), ir a unidades.
    
	bgt $t5 9 decenas   # Si el día es de dos dígitos (mayor que 9), ir a decenas.               


unidades:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
 	syscall
    
  	# Imprimir el día.
	li $v0 1            
	move $a0 $t5       
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio   
	syscall
    
	addi $t5 $t5 1     # Incrementar el contador de días en 1.
	addi $t7 $t7 1     # Incrementar el contador de días por semana en 1.
    
	beq $t7 7 salto2    # Si el contador de días por semana es igual a 7, ir a "salto" para generar un salto de línea.

	j printCalendario

decenas:
	# Imprimir el día.
	li $v0 1            
	move $a0 $t5        
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
	syscall

	addi $t5 $t5 1     # Incrementar el contador de días en 1.
	addi $t7 $t7 1     # Incrementar el contador de días por semana en 1.
    
	beq $t7 7 salto2    # Si el contador de días por semana es igual a 7, ir a "salto" para generar un salto de línea.

	j ComienzoCalendario

salto2:
	li $v0 4            
	la $a0 nueva_linea
	syscall

	li $t7 0           # Reiniciar el contador de días por semana en 0.
	j ComienzoCalendario

end:
	li $v0, 10         # Finaliza el programa.
	syscall
	
endCalendario:
	jr $ra

	
Teclado:
	# Salto de línea
	li $v0 4            
	la $a0 nueva_linea
	syscall
	
	# Imprimir el mensaje 
	li $v0, 4 
	la $a0, mensaje 
	syscall
	
	li $v0 8
	la $a0 teclado
	li $a1 2
	syscall
	
	la $t8 teclado
	lb $s6 0($t8)   # Se guarada en $s6 el botón del teclado.
	
	jr $ra
	
Accion:
	# S: Set
	beq $s6 'S' Set  # Si la entrada por teclado es S, ir a Set.
	
	# U: Up
	beq $s6 'U' Up   # Si la entrada por teclado es U, ir a Up.
	
	beq $s6 'T' Tick
	
	j main

Tick:
	lb $t2 Minuto2
	add $t2, $t2,1
	sb $t2 Minuto2
	j Verificadores

Verificadores:
	lb $t2 Minuto2
	beq $t2, 10, SetMin1
	
	lb $t2 Minuto1
	beq $t2, 6, SetHora
	
	lb $t2 Hora
	beq $t2, 13, SetTZ
	
	lb $t2 Dia
	lb $s4 Mes
	j VerificarDia

Siguiente:
	lb $t2 Mes
	beq $t2 13 SetMes
	j main

SetMes:
	li $t2 1
	sb $t2 Mes
	lb $t2 Ano
	add $t2 $t2 1
	sb $t2, Ano
	j Siguiente

VerificarDia:
	beq $s4, 1 SetEne
	beq $s4, 2 SetFeb
	beq $s4, 3 SetMar
	beq $s4, 4 SetAbr
	beq $s4, 5 SetMay
	beq $s4, 6 SetJun
	beq $s4, 7 SetJul
	beq $s4, 8 SetAgo
	beq $s4, 9 SetSep
	beq $s4, 10 SetOct
	beq $s4, 11 SetNov
	beq $s4, 12 SetDic

SetEne:
	lb $s4 Enero
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente

SetFeb:
	lb $s4 Febrero
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetMar:
	lb $s4 Marzo
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetAbr:
	lb $s4 Abril
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetMay:
	lb $s4 Mayo
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetJun:
	lb $s4 Junio
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetJul:
	lb $s4 Julio
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetAgo:
	lb $s4 Agosto
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetSep:
	lb $s4 Septiembre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetOct:
	lb $s4 Octubre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetNov:
	lb $s4 Noviembre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetDic:
	lb $s4 Diciembre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetDia:
	li $t2 1
	sb $t2 Dia
	lb $t2 Mes
	add $t2 $t2 1
	sb $t2 Mes
	
	j Siguiente
	
	
SetTZ:
	li $t2 1
	sb $t2 Hora
	
	la $t8 TimeZone2
	lb $t1 0($t8)
	beq $t1 'A' HaciaPM
	j HaciaAM 
	
	HaciaPM:
		li $t9 'P'
		sb $t9 0($t8)   # Guarda en el primer caracter la P.
		li $t9 'M'
		sb $t9 1($t8)   # Guarda en el segundo caracter la M.
		
		
		j Verificadores
	HaciaAM:
		li $t9 'A'
		sb $t9 0($t8)   # Guarda en el primer caracter la A.
		li $t9 'M'
		sb $t9 1($t8)	# Guarda en el segundo caracter la M.	
		
		lb $t2 Dia
		add $t2, $t2 1
		sb $t2 Dia
				
		j Verificadores

	
SetHora:
	li $t2 0
	sb $t2 Minuto1
	lb $t2 Hora
	add $t2, $t2,1
	sb $t2 Hora
	
	j Verificadores
	
SetMin1:
	li $t2 0
	sb $t2 Minuto2
	lb $t2 Minuto1
	add $t2, $t2,1
	sb $t2 Minuto1
	
	j Verificadores 
	
Set:
	addi $s7 $s7 1   # $s7 es el contador de casos de Set. 
	                 # La primera vez inicia en 0 y al llegar aquí, suma 1 y cae en el caso 1.
	
	# Caso 1
	beq $s7 1 Caso1
	
	# Caso 2
	beq $s7 2 Caso2

	# Caso 3
	beq $s7 3 Caso3

	# Caso 4
	beq $s7 4 Caso4										
	
	# Caso 5
	beq $s7 5 Caso5
	
	# Caso 6
	beq $s7 6 Caso6			
		
Caso1:
	# Devolver a la normalidad el Caso6.
	la $t8 guion2
	li $t9 45
	sb $t9 0($t8)
	
	la $t8 espacio4
	li $t9 32
	sb $t9 0($t8)	
	
	# Modificar espacio1 y espacio2
	la $t8 espacio1
	li $t9 91
	sb $t9 0($t8)
	
	la $t8 espacio2
	li $t9 93
	sb $t9 0($t8)	
	
	j main	
	
Caso2:	
	# Devolver a la normalidad el Caso1.
	la $t8 espacio1
	li $t9 32
	sb $t9 0($t8)
	
	# Modificar espacio2 y dd.
	la $t8 espacio2
	li $t9 91
	sb $t9 0($t8)
	
	la $t8 dd
	li $t9 93
	sb $t9 0($t8)	
	
	j main
Caso3:
	# Devolver a la normalidad el Caso2.
	la $t8 espacio2
	li $t9 32
	sb $t9 0($t8)
	
	# Modificar dd y espacio3.
	la $t8 dd
	li $t9 91
	sb $t9 0($t8)
	
	la $t8 espacio3
	li $t9 93
	sb $t9 0($t8)	
	
	j main

Caso4:
	# Devolver a la normalidad el Caso3.
	la $t8 dd
	li $t9 58
	sb $t9 0($t8)
	
	# Modificar espacio3 y guion1.
	la $t8 espacio3
	li $t9 91
	sb $t9 0($t8)
	
	la $t8 guion1
	li $t9 93
	sb $t9 0($t8)	
	
	j main
Caso5:
	# Devolver a la normalidad el Caso4.
	la $t8 espacio3
	li $t9 32
	sb $t9 0($t8)
	
	# Modificar guion1 y guion2.
	la $t8 guion1
	li $t9 91
	sb $t9 0($t8)
	
	la $t8 guion2
	li $t9 93
	sb $t9 0($t8)	
	
	j main
Caso6:
	# Devolver a la normalidad el Caso5.
	la $t8 guion1
	li $t9 45
	sb $t9 0($t8)
	
	# Modificar guion1 y guion2.
	la $t8 guion2
	li $t9 91
	sb $t9 0($t8)
	
	la $t8 espacio4
	li $t9 93
	sb $t9 0($t8)	
	
	li $s7 0
	j main
	
Up:
	# Caso base: si nunca se presionó Set, $s7 es 0 y por tanto no se puede subir nada.
	# 	     Se devuelve a main.
	beqz $s7 main
	
	# AM - PM:
	beq $s7 1 CasoTZ
	
	# Hora:
	beq $s7 2 Caso2U
	
	# Minuto:
	beq $s7 3 Caso3U
	
	# Ano:
	beq $s7 4 Caso4U
	
	# Mes:
	beq $s7 5 Caso5U
	
	# Dia:
	beq $s7 6 Caso6U
	
CasoTZ:
	la $t8 TimeZone2
	lb $t1 0($t8)
	beq $t1 'A' ToPM
	j ToAM# Si no es "A", entonces es "P" (es decir, PM) y se cambiará a AM.
	
	ToPM:
		li $t9 'P'
		sb $t9 0($t8)   # Guarda en el primer caracter la P.
		li $t9 'M'
		sb $t9 1($t8)   # Guarda en el segundo caracter la M.
				
		j main 
	ToAM:
		li $t9 'A'
		sb $t9 0($t8)   # Guarda en el primer caracter la A.
		li $t9 'M'
		sb $t9 1($t8)	# Guarda en el segundo caracter la M.	
		
		j main																										
Caso2U:
	la $t9 Hora
	lb $t8, 0($t9)		# Carga la variable Hora en $t8.
	
	addi $t8 $t8 1
	
	beq $t8 13 ReiniciarHora
	
	sb $t8 0($t9)		# Guardar los cambios en la variable Hora.
	j main
	
	ReiniciarHora:
		li $t8 1        # La hora pasa de 12 a 1.
		sb $t8 0($t9)	# Guardar los cambios en la variable Hora.
		j main
Caso3U:
Caso4U:
Caso5U:
Caso6U:
																																																																																																																																																																																																							
	
	
# PILA
	
guardarPila:
	move $t2,$ra
	add $t2, $t2, 8 
	sw $t2 0($sp)
	add $sp, $sp, 4
	add $t0, $t0, 1
	li $t2, 0
	jr $ra
usarPila:
	sub $t0, $t0, 1
	sub $sp, $sp, 4
	lw $ra, 0($sp)
	jr $ra
eliminarPila:
	beqz $t0, salto
	sub $t0, $t0, 1
	sub $sp, $sp, 4
	jr $ra
	salto:
		jr $ra	
