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
TimeZone1: .asciiz "AM"
TimeZone2: .asciiz "PM"
Hora: .byte 12
Minuto1: .byte 0
Minuto2: .byte 0
Ano: .word 2024
Mes: .byte 11
Dia: .byte 15

#Uso de Registros
#a0 Para SYSCALL

# $t1 se usa temporalmente para ir almacenando en registros algunas variables.
# $t2 es usado para Guardar Pila.
# $t4 para imprimir los 10 espacios en la impresión de Medio.
# $t5-t7 lo usa Calendario.
# $s0-s5 para las variables Hora, Minuto1, Minuto2, Ano, Mes, Dia.
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
	jal guardarPila
	jal Impresion
	jal eliminarPila

	# Imprimir el mensaje (NO SE IMPRIME, EL PROGRAMA NO LLEGA AQUÍ).
	li $v0, 4 
	la $a0, mensaje 
	syscall
        
	# Teclado
	jal Teclado
    
	# Acción
	j Accion
    
	# Repetir
	j end        # Temporalmente no es un bucle y se ejecuta una sola vez.

Impresion:
	jal guardarPila
	jal Cabecera
	nop	
    
	jal guardarPila
	jal Medio
	nop		
    		
	jal guardarPila
	jal Calendario
	nop
	
	# Imprimir el mensaje (NO SE IMPRIME, EL PROGRAMA NO LLEGA AQUÍ).
	li $v0, 4 
	la $a0, mensaje 
	syscall	
	
	jal usarPila
	jr $ra             # Volver a main.
	
Cabecera:
	# Carga del registro $s0 a $s5 los valores de Hora, Minuto1, Minuto2, Ano, Mes y Dia.
	la $t1 Hora
	lb $s0, 0($t1)
	la $t1 Minuto1
	lb $s1, 0($t1)
	la $t1 Minuto2
	lb $s2, 0($t1)
	la $t1 Ano
	lw $s3, 0($t1)
	la $t1 Mes
	lb $s4, 0($t1)
	la $t1 Dia
	lb $s5, 0($t1)
	
	li $t1 0     # Vaciar $t1 por si acaso.
	
	# Imprime lo siguiente: PM 12:00  2024-11-15

	jal printEspacio1

	jal printPM

	jal printEspacio2
	
	jal printHora
	
	jal printDD
	
	jal printMinuto1
	
	jal printMinuto2
	
	jal printEspacio3	
	
	jal printAno														

	jal printGuion1

	jal printMes
	
	jal printGuion2	
	
	jal printDia
	
	jal printEspacio4
	
		# Imprimir el mensaje 
	li $v0, 4 
	la $a0, mensaje 
	syscall
	
	jal usarPila
	jr $ra            # Volver a impresion

Medio:
	# Imprime lo siguiente: (10 espacios) YEAR MO DD

	# Imprime una nueva línea para estar por debajo de Cabecera.
	jal guardarPila
	jal printLinea
	jal eliminarPila
		
	# Bucle que se ejecuta 10 veces para imprimir 10 espacios.		
	li $t4 0
	jal guardarPila
	jal loop
	jal eliminarPila
	
	# Imprimir YEAR MO DD.
	li $v0 4            
	la $a0 formato        
 	syscall
 	
 	# Imprime la nueva línea para el Calendario.
	jal guardarPila
	jal printLinea
	jal eliminarPila
 	
 	jal usarPila
 	jr $ra            # Volver a impresion.
	
loop:
	jal guardarPila
	jal printEspacio
	jal eliminarPila
	addi $t4 $t4 1
		
	blt $t4 10 loop
	
	# Cuando se han impreso 10 espacios se rompe el bucle y sigue aquí.
	jal usarPila
	jr $ra	          # Volver a Medio.


Calendario:
	# Esto no maneja pilas ni jal. Esto es puro código que se ejecuta de arriba a abajo.
	
    	li $t5 1            # El número de días. Empieza en el 1.
    	li $t6 31           # La cantidad de días que va a tener el mes.
    	li $t7 0            # Contador de días por semana.
	
printCalendario:	
	bgt $t5 $t6 end     # Si $t5 = 31, ya imprimió todos los días.

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

	
Teclado:
	# Imprimir el mensaje 
	li $v0, 4 
	la $a0, mensaje 
	syscall
	
	li $v0 8
	la $a0 teclado
	li $a1 2
	syscall
	
	la $t8 teclado
	lb $s6 0($t8)
	
	jr $ra
	
Accion:
	# S: Set
	li $t8 'S'
	beq $s6 $t8 Set  # Si la entrada por teclado es S, ir a Set.
	
	j main

Set:
	addi $s7 $s7 1   # $s7 es el contador de casos de Set. La primera vez inicia en 0 y al llegar aquí, suma 1 y cae en el caso 1.
	
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
	
	# Modificar dd y esoacio3.
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
	
			
# PRINTS
	
printEspacio:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
 	syscall
	
	jr $ra
	
printEspacio1:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio1        
 	syscall
	
	jr $ra
	
printEspacio2:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio2      
 	syscall
	
	jr $ra
	
printEspacio3:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio3        
 	syscall
	
	jr $ra							
	
printEspacio4:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio4        
 	syscall
	
	jr $ra	
	
printLinea:
	# Imprimir una línea.
	li $v0 4            
	la $a0 nueva_linea        
 	syscall
	
	jr $ra	
		
Print_LB:
	# Imprimir un caracter.
	li $a0, '['
	li $v0, 11
	syscall
	
	jr $ra

Print_RB:
	# Imprimir un caracter.
	li $a0, ']'
	li $v0, 11
	syscall
	
	jr $ra
	
printAM:
        li $v0 4            
        la $a0 TimeZone1
        syscall
     
        jr $ra

printPM:
        li $v0 4            
        la $a0 TimeZone2
        syscall
    
        jr $ra

printHora:
        li $v0 1          
        move $a0 $s0
	syscall
    
	jr $ra	
    
printDD:
        li $v0 4            
        la $a0 dd
        syscall
	
	jr $ra

printMinuto1:
        li $v0 1          
        move $a0 $s1
	syscall
    
	jr $ra

printMinuto2:
        li $v0 1          
        move $a0 $s2
	syscall
    
	jr $ra

printAno:
        li $v0 1          
        move $a0 $s3
	syscall
    
	jr $ra

printMes:
        li $v0 1          
        move $a0 $s4
	syscall
    
	jr $ra
	
printDia:
        li $v0 1          
        move $a0 $s5
	syscall
    
	jr $ra

printGuion1:
        li $v0 4            
        la $a0 guion1
        syscall
	
	jr $ra	
	
printGuion2:
        li $v0 4            
        la $a0 guion2
        syscall
	
	jr $ra		
	
	
	
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
