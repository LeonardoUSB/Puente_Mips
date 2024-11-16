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
#Cuando comienzan los Meses del 2000
DiaEnero:.byte 7
DiaFebrero:.byte 3
DiaMarzo:.byte 4
DiaAbril:.byte 7
DiaMayo:.byte 2
DiaJunio:.byte 6
DiaJulio:.byte 7
DiaAgosto:.byte 3
DiaSeptiembre:.byte 6
DiaOctubre:.byte 1
DiaNoviembre:.byte 4
DiaDiciembre:.byte 6


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
# 	Impresiï¿½n (Se imprime en consola Cabecera, Medio, Calendario).
#	Teclado (Se recibe por teclado los botones S,M,U,D,T).
#	Acciï¿½n (Se modifican los valores de la fecha u hora, lo cual modificarï¿½ la impresiï¿½n).
#       j main

# Nota: El codigo de todos los Print y de la pila estan hacia el final.


.text
main:				#Dispara el inicio del programa
	# Impresion
	jal Impresion		#Funcion que imprime el calendario completo
        
	# Teclado
	jal Teclado		#Funcion que lee el input
    
	# Accion
	beq $s6 'M' ModoTick    #Va hacia una de las opciones del calendario
	
	j main

ModoSet:
	jal Impresion		#Funcion que imprime el calendario completo
	
	jal Teclado		#Funcion que lee el input
	
	beq $s6 'S' Set  	 # Si la entrada por teclado es S, ir a Set.
	
	# U: Up
	beq $s6 'U' Up  	 # Si la entrada por teclado es U, ir a Up.
		
	# D: Down
	beq $s6 'D' Down  	 # Si la entrada por teclado es D, ir a Down.
	
	beq $s6 'M' ModoTick
	
	
	j ModoSet
	

ModoTick:
	# Borra los corchetes que se establecieron en el modo Set.
	jal BorrarCorchetes

	# Imprime el calendario.
	jal Impresion
	
	# Recibe la entrada por teclado.
	jal Teclado
	
	# Si se introdujo el botón "T", debe ir a Tick para hacer un tick en el reloj interno del calendario.
	beq $s6 'T' Tick
	
	# Si se introdujo el botón "M", debe cambiar al modo Set.
	beq $s6 'M' ModoSet
	
	# Cualquier otra entrada (como S, U y D) es inválida.
	j ModoTick

BorrarCorchetes:
	# Establece dónde están los corchetes para poder borrarlos.
	beq $s7 1 Caso1Borrar
	beq $s7 2 Caso2Borrar
	beq $s7 3 Caso3Borrar
	beq $s7 4 Caso4Borrar
	beq $s7 5 Caso5Borrar
	beq $s7 6 Caso6Borrar
	
	# Si no cayó en ningún caso, es porque es el caso 0. Eso es que, se inició el programa,
	# y nunca se ha ejecutado el botón Set, por lo que no hay ningún corchete en pantalla
	# que eliminar.
	jr $ra
	
Caso1Borrar:
	# Reestablece los caracteres.
	la $t8 espacio1
	li $t9 32
	sb $t9 0($t8)

	la $t8 espacio2
	li $t9 32
	sb $t9 0($t8)
	
	jr $ra	
	
Caso2Borrar:
	# Reestablece los caracteres.
	la $t8 espacio2
	li $t9 32
	sb $t9 0($t8)
	
	la $t8 dd
	li $t9 58
	sb $t9 0($t8)				
	
	jr $ra	
	
Caso3Borrar:
	# Reestablece los caracteres.
	la $t8 dd
	li $t9 58
	sb $t9 0($t8)
	
	la $t8 espacio3
	li $t9 32
	sb $t9 0($t8)				
	
	jr $ra	
	
Caso4Borrar:
	# Reestablece los caracteres.
	la $t8 espacio3
	li $t9 32
	sb $t9 0($t8)

	la $t8 guion1
	li $t9 45
	sb $t9 0($t8)			
	
	jr $ra	
	
Caso5Borrar:
	# Reestablece los caracteres.
	la $t8 guion1
	li $t9 45
	sb $t9 0($t8)
	
	la $t8 guion2
	li $t9 45
	sb $t9 0($t8)				
	
	jr $ra	
	
Caso6Borrar:
	# Reestablece los caracteres.
	la $t8 guion2
	li $t9 45
	sb $t9 0($t8)
	
	la $t8 espacio4
	li $t9 32
	sb $t9 0($t8)																																			

	jr $ra

Impresion:
	j Cabecera
Cabecera:

	# Salto de linea.
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

 	li $t1 0     # Vaciar $t1 y $t8 por seguridad
	li $t8 0    	
 	
 	j Medio

Medio:
	# Imprime lo siguiente: (10 espacios) YEAR MO DD

	# Imprime una nueva linea para estar por debajo de Cabecera.
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
	
	# Cuando se han impreso 10 espacios se rompe el bucle y sigue 
	li $t4 0    # Vaciar $t4 por seguridad
	j Medio2

Medio2:
	# Imprimir YEAR MO DD.
	li $v0 4            
	la $a0 formato        
 	syscall
 	
 	# Imprime la nueva linea para el Calendario.
	li $v0 4            
	la $a0 nueva_linea        
 	syscall
	
	j Calendario

Calendario:
	#  Funcion que Imprime los dias del calendario
	lw $s4 Ano
	li $t5 4
	#Hace el calculo del desfase de días con respecto al año 2000 y el año actual y lo guarda en t2
	sub $s4, $s4, 2000
	abs $s4, $s4
	div $s4, $t5
	mflo $t5	
	add $s4, $t5,$s4	#Agrega el desfase por años bisiestos
	move $t2, $s4	
	
	
    	li $t5 1            # El numero de dias. Empieza en el 1.
    	lb $s4 Mes	    #Para saber cual version del Mes Inprimir
	
printCalendario:			#Todos los casos posibles
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
		lb $t6 Enero		#Carga la informacion del Mes.
		lb $t7 DiaEnero		#Incluyendo numero de dias y que dia de la semana inicia
		sub $t7, $t7, 1 	#Resta para que el desfase encaje correctamente
		add $t7, $t7, $t2	#Se le agrega el desfase de dias con respecto al año 2000
		
		li $t2 7
		div $t7 $t2		#Se realiza modulo 7 para obtener el dia de la semana
		mfhi $t7
		
		li $t2 7
		div $t7 $t2		#Paso para alinear con la impresion
		mfhi $t7
		move $t2, $t7
		
EneDes:		beqz $t2 ComienzoCalendario
		li $v0 4            	# Loop que Inprime la cantidad de espacios necesaria dependeiendo del desfase
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j EneDes
		
CasoFeb:	#Imprimir Desfase			#Lo mismo que en CasoEne pero para el resto de meses
		lb $t6 Febrero
		lb $t7 DiaFebrero
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
FebDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j FebDes
		
CasoMar:	#Imprimir Desfase
		lb $t6 Marzo
		lb $t7 DiaMarzo
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
MarDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j MarDes

CasoAbr:	#Imprimir Desfase
		lb $t6 Abril
		lb $t7 DiaAbril
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
AbrDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j AbrDes
		
CasoMay:	#Imprimir Desfase
		lb $t6 Mayo
		lb $t7 DiaMayo
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
MayDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j MayDes

CasoJun:	#Imprimir Desfase
		lb $t6 Junio
		lb $t7 DiaJunio
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
JunDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j JunDes

CasoJul:	#Imprimir Desfase
		lb $t6 Julio
		lb $t7 DiaJulio
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
JulDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j JulDes

CasoAgo:	#Imprimir Desfase
		lb $t6 Agosto
		lb $t7 DiaAgosto
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
AgoDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j AgoDes

CasoSep:	#Imprimir Desfase
		lb $t6 Septiembre
		lb $t7 DiaSeptiembre
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
SepDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j SepDes

CasoOct:	#Imprimir Desfase
		lb $t6 Octubre
		lb $t7 DiaOctubre
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
OctDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j OctDes

CasoNov:	#Imprimir Desfase
		lb $t6 Noviembre
		lb $t7 DiaNoviembre
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
NovDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		sub $t2, $t2, 1
		j NovDes
CasoDic:	#Imprimir Desfase
		lb $t6 Diciembre
		lb $t7 DiaDiciembre
		add $t7, $t7, $t2
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		
		li $t2 7
		div $t7 $t2
		mfhi $t7
		move $t2, $t7
		
DicDes:		beqz $t2 ComienzoCalendario
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
 		li $v0 4            
		la $a0 espacio        
 		syscall
		
		li $v0 4            
		la $a0 espacio        
 		syscall
 		
		sub $t2, $t2, 1
		j DicDes
	
ComienzoCalendario:	
			
	bgt $t5 $t6 endCalendario     # Si $t5 = 31, ya imprimio todos los dïas.

	blt $t5 10 unidades # Si el dï¿½a es de un dï¿½gito (menor que 10), ir a unidades.
    
	bgt $t5 9 decenas   # Si el dï¿½a es de dos dï¿½gitos (mayor que 9), ir a decenas.               


unidades:
	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
 	syscall
    
  	# Imprimir el dia.
	li $v0 1            
	move $a0 $t5       
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio   
	syscall
    
	addi $t5 $t5 1     # Incrementar el contador de dias en 1.
	addi $t7 $t7 1     # Incrementar el contador de dias por semana en 1.
    
	beq $t7 7 salto2    # Si el contador de dï¿½as por semana es igual a 7, ir a "salto" para generar un salto de linea.

	j ComienzoCalendario

decenas:
	# Imprimir el dia.
	li $v0 1            
	move $a0 $t5        
	syscall

	# Imprimir un espacio.
	li $v0 4            
	la $a0 espacio        
	syscall

	addi $t5 $t5 1     # Incrementar el contador de dias en 1.
	addi $t7 $t7 1     # Incrementar el contador de dias por semana en 1.
    
	beq $t7 7 salto2    # Si el contador de dï¿½as por semana es igual a 7, ir a "salto" para generar un salto de lï¿½nea.

	j ComienzoCalendario

salto2:
	li $v0 4            
	la $a0 nueva_linea
	syscall

	li $t7 0           # Reiniciar el contador de dias por semana en 0.
	j ComienzoCalendario

end:
	li $v0, 10         # Finaliza el programa.
	syscall
	
endCalendario:
	jr $ra

	
Teclado:
	# Salto de linea
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
	
	lb $s6 0($t8)   	 # Se guarada en $s6 el boton del teclado.

	bge $s6 97 ToCaps	 # Si la entrada es un caracter ascii mayor que 97, es porque es minuscula.	
	
	jr $ra			 # Volver a main.
	
	ToCaps:
		subi $s6 $s6 32	 # Convierte la entrada en mayuscula.
		
		jr $ra		 # Volver a main.
	
	
Tick:
	lb $t2 Minuto2			#Aumentan en 1 el minuto
	add $t2, $t2,1
	sb $t2 Minuto2
	j Verificadores

Verificadores:				#De pasarse de 60 minutos, aumentar el resto de varaibles
	lb $t2 Minuto2
	beq $t2, 10, SetMin1		#Tambien verifica si las variables no se pasan del limites
	
	lb $t2 Minuto1
	beq $t2, 6, SetHora		#Verifica que minuto no se pase del limite
	
	lb $t2 Hora
	beq $t2, 13, SetTZ		#Verifica que hora no se pase del limite
	
	lb $t2 Dia			#verifica que dia no se pase del limite
	lb $s4 Mes
	j VerificarDia

Siguiente:
	lb $t2 Mes
	beq $t2 13 SetMes		#verifica que mes no se pase del limite
	j ModoTick

SetMes:
	li $t2 1			#Vuelve mes a la normalidad e incrementa ano
	sb $t2 Mes
	lb $t2 Ano
	add $t2 $t2 1
	sb $t2, Ano
	j Siguiente

VerificarDia:				#Vuelve dia a normalidad en incrementa el mes
	beq $s4, 1 SetEne		#Se necesita revisar el limite de dias por mes
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

SetEne:#VerifacionDelMes
	lb $s4 Enero
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente

SetFeb:#VerifacionDelMes
	lb $s4 Febrero
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetMar:#VerifacionDelMes
	lb $s4 Marzo
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetAbr:#VerifacionDelMes
	lb $s4 Abril
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetMay:#VerifacionDelMes
	lb $s4 Mayo
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetJun:#VerifacionDelMes
	lb $s4 Junio
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetJul:#VerifacionDelMes
	lb $s4 Julio
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetAgo:#VerifacionDelMes
	lb $s4 Agosto
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetSep:#VerifacionDelMes
	lb $s4 Septiembre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetOct:#VerifacionDelMes
	lb $s4 Octubre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetNov:#VerifacionDelMes
	lb $s4 Noviembre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
SetDic:#VerifacionDelMes
	lb $s4 Diciembre
	add $s4,$s4,1
	beq $t2 $s4, SetDia
	j Siguiente
	
SetDia:				 #Vuele el dia a la normalidad e incrementa el mes
	li $t2 1
	sb $t2 Dia
	lb $t2 Mes
	add $t2 $t2 1
	sb $t2 Mes
	
	j Siguiente
	
	
SetTZ:				#Vuelve Timezone a su normaliad 
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
		add $t2, $t2 1	#Incrementa Dia
		sb $t2 Dia
				
		j Verificadores

	
SetHora:			#Vuelve Minuto a la normalidad e incrementa hora
	li $t2 0
	sb $t2 Minuto1
	lb $t2 Hora
	add $t2, $t2,1
	sb $t2 Hora
	
	j Verificadores
	
SetMin1:			#vuelve la primera parte del minuto a la normalidad e incrementa la segunda parte
	li $t2 0
	sb $t2 Minuto2
	lb $t2 Minuto1
	add $t2, $t2,1
	sb $t2 Minuto1
	
	j Verificadores 
	

Set:
	addi $s7 $s7 1   # $s7 es el contador de casos de Set. 
	                 # La primera vez inicia en 0 y al llegar aquï, suma 1 y cae en el caso 1.
	
	# Si se aumentó a 7, se reinicia a 1, pues hay solo 6 casos.
	beq $s7 7 ReiniciarSet
	
	# Caso TimeZone
	beq $s7 1 Caso1
	
	# Caso Hora
	beq $s7 2 Caso2

	# Caso Minutos
	beq $s7 3 Caso3

	# Caso Ano
	beq $s7 4 Caso4										
	
	# Caso Mes
	beq $s7 5 Caso5
	
	# Caso Dia
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
	
	j ModoSet	
	
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
	
	j ModoSet
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
	
	j ModoSet

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
	
	j ModoSet
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
	
	j ModoSet
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
	
	j ModoSet
	
Up:
	# Caso base: si nunca se presiona Set, $s7 es 0 y por tanto no se puede subir nada.
	# 	     Se devuelve a main.
	beqz $s7 ModoSet
	
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
	beq $t1 'A' ToPM  # Si el primer caracter es "A" (es decir, AM), entonces cambiaria a PM.
	j ToAM	          # Si no es "A", entonces es "P" (es decir, PM) y se cambiaria a AM.
	
	ToPM:
		li $t9 'P'
		sb $t9 0($t8)   # Guarda en el primer caracter la P.
		li $t9 'M'
		sb $t9 1($t8)   # Guarda en el segundo caracter la M.
				
		j ModoSet 
	ToAM:
		li $t9 'A'
		sb $t9 0($t8)   # Guarda en el primer caracter la A.
		li $t9 'M'
		sb $t9 1($t8)	# Guarda en el segundo caracter la M.	
		
		j ModoSet																										
Caso2U:
	la $t9 Hora
	lb $t8, 0($t9)		# Carga la variable Hora en $t8.
	
	addi $t8 $t8 1
	
	beq $t8 13 ReiniciarHora
	
	sb $t8 0($t9)		# Guardar los cambios en la variable Hora.
	j ModoSet
	
	ReiniciarHora:
		li $t8 1        # La hora pasa de 12 a 1.
		sb $t8 0($t9)	# Guardar los cambios en la variable Hora.
		j ModoSet
Caso3U:
	la $t9 Minuto2
	lb $t8, 0($t9)		# Carga la variable Minuto2 en $t8.
	
	addi $t8 $t8 1		# Aumenta en 1 el minuto.
	
	beq $t8 10 UpDecenas	# Esto es: aumentar, por ejemplo, de 3:19 a 3:20.
	
	sb $t8 0($t9)		# Guardar los cambios en la variable Minuto2.
	j ModoSet
	
	UpDecenas:
		li $t8 0	# Cambia la unidad de 9 a 0.
		la $t4 Minuto1
		lb $t3, 0($t4)	# Guarda en $t3 la variable Minuto1.
		
		addi $t3 $t3 1	# Aumenta en 1 a Minuto1 (las decenas).
		
		beq $t3 6 ReiniciarMinutos   # Esto es: aumentar, por ejemplo, de 3:59 a 3:00.
	
		sb $t8 0($t9)	# Guardar los cambios en la variable Minuto2.
		sb $t3 0($t4)	# Guardar los cambios en la variable Minuto1.
		j ModoSet	
		
		ReiniciarMinutos:
			li $t3 0	# Cambia el decimal de 5 a 0.
			sb $t8 0($t9)	# Guardar los cambios en la variable Minuto2.
			sb $t3 0($t4)	# Guardar los cambios en la variable Minuto1.
			j ModoSet	

Caso4U:
	la $t9 Ano
	lw $t8, 0($t9)		# Carga la variable Ano en $t8.
	
	addi $t8 $t8 1		# Aumentar en 1 el Ano.
	
	sw $t8 0($t9)		# Guardar los cambios en la variable Ano.
	j ModoSet

Caso5U:
	la $t9 Mes              # Esto para guardar despues en Mes lo que hay en $s5.
	li $s0 1
	
	addi $s5 $s5 1		# Aumentar en 1 el mes.
	
	beq $s5 13 ReiniciarMes	# Esto es aumentar el mes de 12 a 1.
	j LastDia
	
	ReiniciarMes:
		li $s5 1        # El mes pasa de 12 a 1.
		
		j LastDia
	
LastDia:
	beq $s5 1 LastEnero
	beq $s5 2 LastFebrero	# Cambiar el ultimo dia de febrero.
	beq $s5 3 LastMarzo
	beq $s5 4 Last30
	beq $s5 6 Last30
	beq $s5 9 Last30
	beq $s5 11 Last30
	j Last31
		
	LastEnero:
		la $t4 Dia
		lb $t3, 0($t4)			# Carga la variable Dia en $t3.
	
		beq $s0 1 UpEnero
	
		beq $t3 28 CM
		beq $t3 29 CM
		
		sb $s5 0($t9)			# Guardar los cambios en la variable Mes.
		sb $t3 0($t4)			# Guardar los cambios en la variable Dia.
		j ModoSet	
	
	UpEnero:
		beq $t3 31 CM
		
	LastFebrero:
		la $t4 Dia
		lb $t3, 0($t4)		# Carga la variable Dia en $t3.
	
		bge $t3 30 CF
	
		sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
		sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
		j ModoSet	
				
		CF:
			li $t3 28
			sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
			sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
			j ModoSet				

	LastMarzo:
	la $t4 Dia
	lb $t3, 0($t4)		# Carga la variable Dia en $t3.
	
	beq $t3 30 CM
	beq $t3 28 CM
	beq $t3 29 CM
	
	sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
	sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
	j ModoSet	
			
		CM:
			li $t3 31
			sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
			sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
			j ModoSet						
	Last30:
	la $t4 Dia
	lb $t3, 0($t4)		# Carga la variable Dia en $t3.
	
	beq $t3 31 C30
	sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
	sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
	j ModoSet			
		
		C30:
			li $t3 30
			sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
			sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
			j ModoSet	
	
	Last31:
	la $t4 Dia
	lb $t3, 0($t4)		# Carga la variable Dia en $t3.
	
	beq $t3 30 C31
	
	sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
	sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
	j ModoSet				
	
		C31:
			li $t3 31
			sb $s5 0($t9)	# Guardar los cambios en la variable Mes.
			sb $t3 0($t4)	# Guardar los cambios en la variable Dia.
			j ModoSet			
					

Caso6U:
	la $t9 Dia
	lb $t8, 0($t9)		# Carga la variable Dia en $t8.
	
	addi $t8 $t8 1		# Aumenta en 1 el dia.
	
	# Determina si el dia tiene 28, 30 o 31 dias.
	beq $s5 4 Mes30
	beq $s5 6 Mes30
	beq $s5 9 Mes30
	beq $s5 11 Mes30
	
	beq $s5 2 Febrero_
	
	j Mes31			
	
	Mes31:
	
	beq $t8 32 ReiniciarDia	# Si llegï¿½ a 31 dias, se debe reiniciar a 1.
	
	sb $t8 0($t9)		# Si no, guardar los cambios en la variable Dia.
	j ModoSet
	
	Febrero_:

	beq $t8 29 ReiniciarDia	# Si llego a 28 dias, se debe reiniciar a 1.
	
	sb $t8 0($t9)		# Si no, guardar los cambios en la variable Dia.
	j ModoSet
	
	Mes30:

	beq $t8 31 ReiniciarDia	# Si llega a 30 dïas, se debe reiniciar a 1.
	
	sb $t8 0($t9)		# Si no, guardar los cambios en la variable Dia.
	j ModoSet
	
	ReiniciarDia:
		li $t8 1        # El dia se reinicia a 1.
		
		sb $t8 0($t9)	# Guardar los cambios en la variable Dia.
		j ModoSet			
	
Down:
	# Caso base: si nunca se presiono Set, $s7 es 0 y por tanto no se puede subir nada.
	# 	     Se devuelve a main.
	beqz $s7 ModoSet
	
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
	j ModoSet
	
	MaxHora:
		li $t8 12       	# La hora pasa de 12 a 1.
		sb $t8 0($t9)		# Guardar los cambios en la variable Hora.
		j ModoSet
		
Caso3D:
	la $t9 Minuto2
	lb $t8, 0($t9)			# Carga la variable Minuto2 en $t8.
	
	subi $t8 $t8 1
	
	beq $t8 -1 DownDecenas		# Esto es: disminuir, por ejemplo, de 3:20 a 3:19.
	
	sb $t8 0($t9)			# Guardar los cambios en la variable Minuto1.
	j ModoSet
	
	DownDecenas:
		li $t8 9		# Se cambia a 9 las unidades.
		la $t4 Minuto1
		lb $t3, 0($t4)		# Se carga la variable Minuto1 en $t4.	
		
		subi $t3 $t3 1		# Se resta 1 a las decenas.
		
		beq $t3 -1 MaxMinutos	# Esto es: disminuir, por ejemplo, de 3:00 a 3:59.
	
		sb $t8 0($t9)		# Guardar los cambios en la variable Minuto2.
		sb $t3 0($t4)		# Guardar los cambios en la variable Minuto1.
		j ModoSet	
		
		MaxMinutos:
			li $t3 5	# Esto es: disminuir, por ejemplo, de 3:00 a 3:59.
			sb $t8 0($t9)	# Guardar los cambios en la variable Minuto2.
			sb $t3 0($t4)	# Guardar los cambios en la variable Minuto1.
			j ModoSet	

Caso4D:
	la $t9 Ano
	lw $t8, 0($t9)		# Carga la variable Ano en $t8.
	
	subi $t8 $t8 1		# Disminuir en 1 el Ano.
	
	sw $t8 0($t9)		# Guardar los cambios en la variable Ano.
	j ModoSet

Caso5D:
	la $t9 Mes              # Esto para guardar despues en Mes lo que hay en $s5.
	li $s0 0
	
	subi $s5 $s5 1		# Disminuir en 1 el contador de mes.
	
	beqz $s5 MaxMes		# Si el mes llega a 0, es porque se esta cambiando de 1 a 12.
	j LastDia
	
	MaxMes:
		li $s5 12       # El mes pasa de 1 a 12.
		j LastDia	

Caso6D:
	la $t9 Dia
	lb $t8, 0($t9)		# Carga la variable Dia en $t8.
	
	subi $t8 $t8 1		# Disminuye en 1 el dia.
	beqz $t8 MinDia		# Si el dï¿½a es 0, es porque pasa del dïa 1 al ultimo dia del mes.
		
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j ModoSet
	
	MinDia:
		# Verifica si el mes en cuestion es de 28, 30 o 31 dias.
		beq $s5 4 DMes30
		beq $s5 6 DMes30
		beq $s5 9 DMes30
		beq $s5 11 DMes30
	
		beq $s5 2 DFebrero
	
		j DMes31			
	
	DMes31:
	
	li $t8 31		# El dia pasa a ser 31.
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j ModoSet
	
	DFebrero:
	
	li $t8 28		# El dia pasa a ser 28.
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j ModoSet
	
	DMes30:
	
	li $t8 30		# El dia pasa a ser 30.
	sb $t8 0($t9)		# Guarda los cambios en la variable Dia.
	j ModoSet
	
	
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
