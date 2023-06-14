.data

.include "../sprites/map/base_map.data"

.text

MAIN:

	la a0, base_map
	li a1,0
	li a2,0
	li a3,1
	jal PRINT_SCREEN
	

	li a7, 10
	ecall

##########################################################
# PRINT
##########################################################


#   a0 = endereco da imagem
#   a1 = x
#   a2 = y
#   a3 = frame
#   a4 = WindowX	
#
#   t0 = endereco do bitmap display
#   t1 = endereco da imagem
#   t2 = contador de linhas
#   t3 = contador de colunas
#   t4 = largura
#   t5 = altura

PRINT_SCREEN:  
        li t0,0xFF0
        add t0,t0,a3
        slli t0,t0,20

        addi t1,a0,8

        mv t2,zero
        mv t3,zero

        li t4, 320
        li t5, 240
        lw s1, 0(a0)

PRINT_LINHA_SCREEN:
        lw t6,0(t1)
        sw t6,0(t0)

        addi t0,t0,4
        addi t1,t1,4

        addi t3,t3,4
        blt t3,t4,PRINT_LINHA_SCREEN
        
        add t1,t1,s1
        sub t1,t1,t4

        mv t3,zero
        addi t2,t2,1
        blt t2,t5 PRINT_LINHA_SCREEN

        ret