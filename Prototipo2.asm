.data
nueva_linea: .asciiz "\n"
espacio: .asciiz " "

.text
main:
    li $t0 1            # El número de días. Empieza en el 1.
    li $t1 31           # La cantidad de días que va a tener el mes.
    li $t2 0            # Contador de días por semana.

loop:
    bgt $t0 $t1 end     # Si $t0 = 31, ya imprimió todos los días.

    blt $t0 10 unidades # Si el día es de un dígito (menor que 10), ir a unidades.
    
    bgt $t0 9 decenas   # Si el día es de dos dígitos (mayor que 9), ir a decenas.               


unidades:
    # Imprimir un espacio.
    li $v0 4            
    la $a0 espacio        
    syscall
    
    # Imprimir el día.
    li $v0 1            
    move $a0 $t0       
    syscall

    # Imprimir un espacio.
    li $v0 4            
    la $a0 espacio   
    syscall
    
    addi $t0 $t0 1     # Incrementar el contador de días en 1.
    addi $t2 $t2 1     # Incrementar el contador de días por semana en 1.
    
    beq $t2 7 salto    # Si el contador de días por semana es igual a 7, ir a "salto" para generar un salto de línea.

    j loop

decenas:
    # Imprimir el número.
    li $v0 1            
    move $a0 $t0        
    syscall

    # Imprimir un espacio.
    li $v0 4            
    la $a0 espacio        
    syscall

    addi $t0 $t0 1     # Incrementar el contador de días en 1.
    addi $t2 $t2 1     # Incrementar el contador de días por semana en 1.
    
    beq $t2 7 salto    # Si el contador de días por semana es igual a 7, ir a "salto" para generar un salto de línea.

    j loop

salto:
    li $v0 4            
    la $a0 nueva_linea
    syscall

    li $t2 0           # Reiniciar el contador de días por semana en 0.
    j loop

end:
    li $v0, 10         # Finaliza el programa.
    syscall
