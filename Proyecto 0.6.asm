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

# Registros permanentes (No usar para otras cosas)
# $s5 es el contador de Mes.
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
	lb $s5, 0($t1)	# Carga el Mes en el registro permanente $s5 para contar los meses.
		
        li $v0 1          
        move $a0 $s5
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
	
    	li $t5 1            # El número de días. Empieza en el 1.
    	li $t6 31           # La cantidad de días que va a tener el mes.
    	li $t7 0            # Contador de días por semana.
	
printCalendario:	
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

	j printCalendario

salto2:
	li $v0 4            
	la $a0 nueva_linea
	syscall

	li $t7 0           # Reiniciar el contador de días por semana en 0.
	j printCalendario

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
	
	# D: Down
	beq $s6 'D' Down   # Si la entrada por teclado es D, ir a Down.
	
	j main

Set:
	addi $s7 $s7 1   # $s7 es el contador de casos de Set. 
	                 # La primera vez inicia en 0 y al llegar aquí, suma 1 y cae en el caso 1.
	
	beq $s7 7 ReiniciarSet
	
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
		
	ReiniciarSet:
		li $s7 1
		j Caso1		
		
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
	beq $t1 'A' ToPM  # Si el primer caracter es "A" (es decir, AM), entonces cambiará a PM.
	j ToAM	          # Si no es "A", entonces es "P" (es decir, PM) y se cambiará a AM.
	
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
	la $t9 Minuto2
	lb $t8, 0($t9)		# Carga la variable Minuto2 en $t8.
	
	addi $t8 $t8 1		# Aumenta en 1 el minuto.
	
	beq $t8 10 UpDecenas	# Esto es: aumentar, por ejemplo, de 3:19 a 3:20.
	
	sb $t8 0($t9)		# Guardar los cambios en la variable Minuto2.
	j main
	
	UpDecenas:
		li $t8 0	# Cambia la unidad de 9 a 0.
		la $t4 Minuto1
		lb $t3, 0($t4)	# Guarda en $t3 la variable Minuto1.
		
		addi $t3 $t3 1	# Aumenta en 1 a Minuto1 (las decenas).
		
		beq $t3 6 ReiniciarMinutos   # Esto es: aumentar, por ejemplo, de 3:59 a 3:00.
	
		sb $t8 0($t9)	# Guardar los cambios en la variable Minuto2.
		sb $t3 0($t4)	# Guardar los cambios en la variable Minuto1.
		j main	
		
		ReiniciarMinutos:
			li $t3 0	# Cambia el decimal de 5 a 0.
			sb $t8 0($t9)	# Guardar los cambios en la variable Minuto2.
			sb $t3 0($t4)	# Guardar los cambios en la variable Minuto1.
			j main	

Caso4U:
	la $t9 Ano
	lb $t8, 0($t9)		# Carga la variable Ano en $t8.
	
	addi $t8 $t8 1		# Aumentar en 1 el Ano.
	
	sb $t8 0($t9)		# Guardar los cambios en la variable Ano.
	j main

Caso5U:
	la $t9 Mes              # Esto para guardar después en Mes lo que hay en $s5.
	
	addi $s5 $s5 1		# Aumentar en 1 el mes.
	
	beq $s5 13 ReiniciarMes	# Esto es aumentar el mes de 12 a 1.
	
	sb $s5 0($t9)		# Guardar los cambios en la variable Mes.
	j main
	
	ReiniciarMes:
		li $s5 1        # El mes pasa de 12 a 1.
		sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
		j main	

Caso6U:
	la $t9 Dia
	lb $t8, 0($t9)		# Carga la variable Dia en $t8.
	
	addi $t8 $t8 1		# Aumenta en 1 el día.
	
	# Determina si el día tiene 28, 30 o 31 días.
	beq $s5 4 Mes30
	beq $s5 6 Mes30
	beq $s5 9 Mes30
	beq $s5 11 Mes30
	
	beq $s5 2 Febrero
	
	j Mes31			
	
	Mes31:
	
	beq $t8 32 ReiniciarDia	# Si llegó a 31 días, se debe reiniciar a 1.
	
	sb $t8 0($t9)		# Si no, guardar los cambios en la variable Dia.
	j main
	
	Febrero:
	
	beq $t8 29 ReiniciarDia	# Si llegó a 28 días, se debe reiniciar a 1.
	
	sb $t8 0($t9)		# Si no, guardar los cambios en la variable Dia.
	j main
	
	Mes30:
	
	beq $t8 31 ReiniciarDia	# Si llegó a 30 días, se debe reiniciar a 1.
	
	sb $t8 0($t9)		# Si no, guardar los cambios en la variable Dia.
	j main
	
	ReiniciarDia:
		li $t8 1        # El día se reinicia a 1.
		sb $t8 0($t9)	# Guardar los cambios en la variable Dia.
		j main	
	
	
Down:
	# Caso base: si nunca se presionó Set, $s7 es 0 y por tanto no se puede subir nada.
	# 	     Se devuelve a main.
	beqz $s7 main
	
	# AM - PM:
	beq $s7 1 CasoTZ
	
	# Hora:
	beq $s7 2 Caso2D
	
	# Minuto:
	beq $s7 3 Caso3D
	
	# Ano:
	beq $s7 4 Caso4D
	
	# Mes:
	beq $s7 5 Caso5D
	
	# Dia:
	beq $s7 6 Caso6D	
	
Caso2D:
	la $t9 Hora
	lb $t8, 0($t9)			# Carga la variable Hora en $t8.
	
	subi $t8 $t8 1			# Disminuye la Hora en 1.
	
	beqz $t8 MaxHora		# Si la Hora llega a 0, es porque cambia de 1 a 12.
	
	sb $t8 0($t9)			# Guardar los cambios en la variable Hora.
	j main
	
	MaxHora:
		li $t8 12       	# La hora pasa de 12 a 1.
		sb $t8 0($t9)		# Guardar los cambios en la variable Hora.
		j main
		
Caso3D:
	la $t9 Minuto2
	lb $t8, 0($t9)			# Carga la variable Minuto2 en $t8.
	
	subi $t8 $t8 1
	
	beq $t8 -1 DownDecenas		# Esto es: disminuir, por ejemplo, de 3:20 a 3:19.
	
	sb $t8 0($t9)			# Guardar los cambios en la variable Minuto1.
	j main
	
	DownDecenas:
		li $t8 9		# Se cambia a 9 las unidades.
		la $t4 Minuto1
		lb $t3, 0($t4)		# Se carga la variable Minuto1 en $t4.	
		
		subi $t3 $t3 1		# Se resta 1 a las decenas.
		
		beq $t3 -1 MaxMinutos	# Esto es: disminuir, por ejemplo, de 3:00 a 3:59.
	
		sb $t8 0($t9)		# Guardar los cambios en la variable Minuto2.
		sb $t3 0($t4)		# Guardar los cambios en la variable Minuto1.
		j main	
		
		MaxMinutos:
			li $t3 5	# Esto es: disminuir, por ejemplo, de 3:00 a 3:59.
			sb $t8 0($t9)	# Guardar los cambios en la variable Minuto2.
			sb $t3 0($t4)	# Guardar los cambios en la variable Minuto1.
			j main	

Caso4D:
	la $t9 Ano
	lb $t8, 0($t9)		# Carga la variable Ano en $t8.
	
	subi $t8 $t8 1		# Disminuir en 1 el Ano.
	
	sb $t8 0($t9)		# Guardar los cambios en la variable Ano.
	j main

Caso5D:
	la $t9 Mes              # Esto para guardar después en Mes lo que hay en $s5.
	
	subi $s5 $s5 1		# Disminuir en 1 el contador de mes.
	
	beqz $s5 MaxMes		# Si el mes llega a 0, es porque se está cambiando de 1 a 12.
	
	sb $s5 0($t9)		# Guardar los cambios en la variable Mes.
	j main
	
	MaxMes:
		li $s5 12       # El mes pasa de 1 a 12.
		sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
		j main	

Caso6D:
	la $t9 Dia
	lb $t8, 0($t9)		# Carga la variable Dia en $t8.
	
	subi $t8 $t8 1		# Disminuye en 1 el día.
	beqz $t8 MinDia		# Si el día es 0, es porque pasa del día 1 al último día del mes.
		
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j main
	
	MinDia:
		# Verifica si el mes en cuestión es de 28, 30 o 31 días.
		beq $s5 4 DMes30
		beq $s5 6 DMes30
		beq $s5 9 DMes30
		beq $s5 11 DMes30
	
		beq $s5 2 DFebrero
	
		j DMes31			
	
	DMes31:
	
	li $t8 31		# El día pasa a ser 31.
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j main
	
	DFebrero:
	
	li $t8 28		# El día pasa a ser 28.
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j main
	
	DMes30:
	
	li $t8 30		# El día pasa a ser 30.
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j main
	
	
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
