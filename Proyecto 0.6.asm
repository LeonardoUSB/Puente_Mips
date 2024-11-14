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
Minuto1: .byte 3
Minuto2: .byte 0
Ano: .word 2024
Mes: .byte 11
Dia: .byte 15

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
# 	Impresi�n (Se imprime en consola Cabecera, Medio, Calendario).
#	Teclado (Se recibe por teclado los botones S,M,U,D). NO HECHO.
#	Acci�n (Se modifican los valores de la fecha u hora, lo cual modificar� la impresi�n). NO HECHO.
#       j main

# Nota: El c�digo de todos los Print y de la pila est� hacia el final.


.text
main:	
	# Impresi�n
	jal Impresion
        
	# Teclado
	jal Teclado
    
	# Acci�n
	j Accion

Impresion:
	j Cabecera
Cabecera:
	# Imprime lo siguiente: PM 12:00  2024-11-15

	# Salto de l�nea.
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

	# Imprime una nueva l�nea para estar por debajo de Cabecera.
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
	
	# Cuando se han impreso 10 espacios se rompe el bucle y sigue aqu�.
	li $t4 0    # Vaciar $t4 por si acaso.
	j Medio2

Medio2:
	# Imprimir YEAR MO DD.
	li $v0 4            
	la $a0 formato        
 	syscall
 	
 	# Imprime la nueva l�nea para el Calendario.
	li $v0 4            
	la $a0 nueva_linea        
 	syscall
	
	j Calendario

Calendario:
	# Esto no maneja pilas ni jal. Esto es puro c�digo que se ejecuta de arriba a abajo.
	
    	li $t5 1            # El n�mero de d�as. Empieza en el 1.
    	li $t6 31           # La cantidad de d�as que va a tener el mes.
    	li $t7 0            # Contador de d�as por semana.
	
printCalendario:	
	bgt $t5 $t6 endCalendario     # Si $t5 = 31, ya imprimi� todos los d�as.

	blt $t5 10 unidades # Si el d�a es de un d�gito (menor que 10), ir a unidades.
    
	bgt $t5 9 decenas   # Si el d�a es de dos d�gitos (mayor que 9), ir a decenas.               


unidades:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
 	syscall
    
  	# Imprimir el d�a.
	li $v0 1            
	move $a0 $t5       
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio   
	syscall
    
	addi $t5 $t5 1     # Incrementar el contador de d�as en 1.
	addi $t7 $t7 1     # Incrementar el contador de d�as por semana en 1.
    
	beq $t7 7 salto2    # Si el contador de d�as por semana es igual a 7, ir a "salto" para generar un salto de l�nea.

	j printCalendario

decenas:
	# Imprimir el d�a.
	li $v0 1            
	move $a0 $t5        
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
	syscall

	addi $t5 $t5 1     # Incrementar el contador de d�as en 1.
	addi $t7 $t7 1     # Incrementar el contador de d�as por semana en 1.
    
	beq $t7 7 salto2    # Si el contador de d�as por semana es igual a 7, ir a "salto" para generar un salto de l�nea.

	j printCalendario

salto2:
	li $v0 4            
	la $a0 nueva_linea
	syscall

	li $t7 0           # Reiniciar el contador de d�as por semana en 0.
	j printCalendario

end:
	li $v0, 10         # Finaliza el programa.
	syscall
	
endCalendario:
	jr $ra

	
Teclado:
	# Salto de l�nea
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
	lb $s6 0($t8)   # Se guarada en $s6 el bot�n del teclado.
	
	jr $ra
	
Accion:
	# S: Set
	beq $s6 'S' Set  # Si la entrada por teclado es S, ir a Set.
	
	# U: Up
	beq $s6 'U' Up   # Si la entrada por teclado es U, ir a Up.
	
	j main

Set:
	addi $s7 $s7 1   # $s7 es el contador de casos de Set. 
	                 # La primera vez inicia en 0 y al llegar aqu�, suma 1 y cae en el caso 1.
	
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
	# Caso base: si nunca se presion� Set, $s7 es 0 y por tanto no se puede subir nada.
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
	beq $t1 'A' ToPM  # Si el primer caracter es "A" (es decir, AM), entonces cambiar� a PM.
	j ToAM	          # Si no es "A", entonces es "P" (es decir, PM) y se cambiar� a AM.
	
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
