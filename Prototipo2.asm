.data
nueva_linea: .asciiz "\n"
espacio: .asciiz " "

.text
main:
    li $t0 1            # El n�mero de d�as. Empieza en el 1.
    li $t1 31           # La cantidad de d�as que va a tener el mes.
    li $t2 0            # Contador de d�as por semana.

loop:
    bgt $t0 $t1 end     # Si $t0 = 31, ya imprimi� todos los d�as.

    blt $t0 10 unidades # Si el d�a es de un d�gito (menor que 10), ir a unidades.
    
    bgt $t0 9 decenas   # Si el d�a es de dos d�gitos (mayor que 9), ir a decenas.               


unidades:
    # Imprimir un espacio.
    li $v0 4            
    la $a0 espacio        
    syscall
    
    # Imprimir el d�a.
    li $v0 1            
    move $a0 $t0       
    syscall

    # Imprimir un espacio.
    li $v0 4            
    la $a0 espacio   
    syscall
    
    addi $t0 $t0 1     # Incrementar el contador de d�as en 1.
    addi $t2 $t2 1     # Incrementar el contador de d�as por semana en 1.
    
    beq $t2 7 salto    # Si el contador de d�as por semana es igual a 7, ir a "salto" para generar un salto de l�nea.

    j loop

decenas:
    # Imprimir el n�mero.
    li $v0 1            
    move $a0 $t0        
    syscall

    # Imprimir un espacio.
    li $v0 4            
    la $a0 espacio        
    syscall

    addi $t0 $t0 1     # Incrementar el contador de d�as en 1.
    addi $t2 $t2 1     # Incrementar el contador de d�as por semana en 1.
    
    beq $t2 7 salto    # Si el contador de d�as por semana es igual a 7, ir a "salto" para generar un salto de l�nea.

    j loop

salto:
    li $v0 4            
    la $a0 nueva_linea
    syscall

    li $t2 0           # Reiniciar el contador de d�as por semana en 0.
    j loop

end:
    li $v0, 10         # Finaliza el programa.
    syscall
