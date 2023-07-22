.data

.eqv 	TILE_HEIGHT		16
.eqv  	TILE_LENGTH		16
.eqv 	TILE_SIZE		256
.eqv 	MAP_HEIGHT  	15
.eqv	MAP_LENGTH		211
.eqv 	SCREEN_HEIGHT 	15
.eqv 	SCREEN_LENGTH 	20
.eqv 	FRAME_ADDRS 	0xFF200604
.eqv	GRAVITY			-10
.eqv 	MARIO_LIM_L		0
.eqv	MARIO_LIM_R		120

.include "../sprites/pixels/tiles.s"
.include "../sprites/pixels/tiles2.s"
.include "../sprites/pixels/marios.s"
.include "../sprites/map/map_example.s"
.include "../sprites/map/map_v0.s"

# Só começa a contar que entrou em outra tile após ter passado os 16 pixeis verticais ou horizontais
CHAR_POS:	.word	5, 461	# X, Y em relação ao mapa
CHAR_POS_TILE:	.byte	0, 0	# X, Y em relação à tile
FRAME:		.byte	1

# MARIO #####################################################################################################
MARIO_UPGRADE: .byte 0
MARIO_STATE: .byte 0 # estado do mario = sprite, cycle
MARIO_REL_POS: .byte 132 # posicao relativa na tela
MARIO_SPEED_UP: .byte 0


.text

MAIN:

	
GAME_LOOP:

	
	
	#jal MAP_RENDER
	jal KEY_HANDLE
	jal MARIO_RENDER
	la t0, FRAME
	lb t1,0(t0)
	not t1,t1
	andi t1,t1,1
	sb t1,0(t0)
	li t0, FRAME_ADDRS
	sb t1, 0(t0)
	j GAME_LOOP

	
##########################################################
# MAP RENDER POSITION
##########################################################
MAP_RENDER:
	addi sp,sp,-12
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	
	
	
	la a2, MAP_EXAMPLE	# pega matriz do mapa
	lui a1, 0xFF000
	li a3, MAP_HEIGHT
	li a5, SCREEN_LENGTH
	li t2,0
	li t4,0
	
	MAP_RENDER_LOOP:
		mv t3, a1
		la a0, TILES		# pega lista de tiles
		lb a1, 0(a2)		# pega valor na matriz do mapa
		jal TILE_SELECT
		mv a1,t3
		
		li a4, TILE_LENGTH
		li a6, TILE_HEIGHT
		jal RENDER
		
		addi a2, a2, 1
		addi t4,t4,1
		addi a1, a1, TILE_LENGTH
		
		bne t4,a5, MAP_RENDER_LOOP_POINT
		addi t2,t2,1
		li t4,0
		lui t5,1
		addi t5,t5,704
		add a1,a1,t5
		
	MAP_RENDER_LOOP_POINT:
		blt t2,a3, MAP_RENDER_LOOP 
		lw ra, 0(sp)
		lw s0, 4(sp)
		lw s1, 8(sp)
		addi sp,sp,12
		ret
		
	
	
	
	
	
############################################################################################################################
# RENDER | Args = a0 (endereço da imagem), a1 (endereço inicio de impressão), a4 (largura da imagem), a6 (altura da imagem) 
############################################################################################################################
RENDER:
	addi sp, sp, -28
	sw ra, (sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a5, 20(sp)
	sw t4, 24(sp)

	la t0, FRAME
	lb t0, 0(t0)
	xori t0, t0, 1		# verifica qual é a frame atual e printa na contrária
	slli t0, t0, 20
	add a1, a1, t0

	add a5, a1, zero        # Guarda valor do endereço inicial em a5

	li t5,1                  # Inicializa contador
	li t6,320                # 320 p/ usar em contas

	# Conta p/ conseguir o endereço final
	addi a2,a6,-1
	mul a2,a2,t6
	add a2,a2,a4
	add a2,a2,a1

	RENDER_LOOP1:
		add t4,a5,zero           # Guarda valor do endereço inicial em t4
		mul t0,t6,t5             # Faz 320 * contador
		add t4,t4,t0             # Define qual será o próximo endereço

		add a3,a1,zero           # Guarda valor do endereço inicial em a3
		add a3,a3,a4             # Soma o endereço inicial à largura

	RENDER_LOOP2:
		beq a1,a3, RENDER_EXIT # Sai quando tiver printado valor correspondente à largura
		lw t1,0(a0)              # Lê 4 pixels
		sw t1,0(a1)              # Escreve a word na memória
		addi a1,a1,4             # Soma 4 ao inicial
		addi a0,a0,4             # Soma 4 ao endereço da imagem
		j RENDER_LOOP2

	RENDER_EXIT:

		addi t5,t5,1              # Adiciona 1 ao contador
		add a1,t4,zero            # Coloca o próximo endereço
		bltu a1,a2,RENDER_LOOP1   # Faz branch enquanto não alcança o endereço final

		lw ra, (sp)
		lw a0, 4(sp)
		lw a1, 8(sp)
		lw a2, 12(sp)
		lw a3, 16(sp)
		lw a5, 20(sp)
		lw t4, 24(sp)
		addi sp, sp, 28
		ret

##########################################################
# RENDER MAP
##########################################################


##########################################################
# TILE SELECT a0(tile sheet address), a1(tile index)
##########################################################
TILE_SELECT:

	li t0,256
	mul t0,t0,a1
	add a0, a0,t0
	ret
	
##########################################################
# RENDER MARIO 
##########################################################
MARIO_RENDER:
	addi sp,sp,-4
	sw ra,0(sp)

	la t0, MARIO_STATE
	la a0, MARIOS
	lb a1, 0(t0)
	jal TILE_SELECT

	li a1, 0xFF000000
	li t2,220
	li t3, TILE_SIZE
	mul t2,t2,t3
	add a1,a1,t2
	la t0,MARIO_REL_POS
	lb t1,0(t0)
	add a1,a1,t1
	
	li a4, TILE_HEIGHT
	li a6, TILE_LENGTH
	jal RENDER

	lw ra,0(sp)
	addi sp,sp,4
	ret

##########################################################
# KEY HANDLING
##########################################################
KEY_HANDLE:
	addi sp,sp,-4
	sw ra,0(sp)

	jal KEY_POLL

	beq a0,zero,KEY_HANDLE_END
	li t0,'a'
	beq a1,t0,KEY_HANDLE_A
	li t0,'d'
	beq a1,t0,KEY_HANDLE_D
	li t0,'w'
	beq a1,t0,KEY_HANDLE_W
	li t0,27
	beq a1,t0,KEY_HANDLE_ESC
	j KEY_HANDLE_END

KEY_HANDLE_A:
	la t0, MARIO_REL_POS
	lb t1,0(t0)
	li t2, MARIO_LIM_L
	ble t1,t2,HANDLE_A_END
	addi t1,t1,-4
	sb t1,0(t0)
	HANDLE_A_END:
		j KEY_HANDLE_END
KEY_HANDLE_D:
	la t0, MARIO_REL_POS
	lb t1,0(t0)
	li t2, MARIO_LIM_R
	bgeu t1,t2,HANDLE_D_END
	addi t1,t1,4
	sb t1,0(t0)
	HANDLE_D_END:
		j KEY_HANDLE_END
KEY_HANDLE_W:
	HANDLE_W_END:
		j KEY_HANDLE_END
KEY_HANDLE_ESC:
	li a7, 10
	ecall


KEY_HANDLE_END:
	lw ra,0(sp)
	addi sp,sp, 4
	ret
	


##########################################################
# KEY POLLING
##########################################################
KEY_POLL:
	li t1,0xFF200000
	lw t0,0(t1)
	andi a0,t0,1
	beq a0,zero,KEY_POLL_END
	lw a1,4(t1)
KEY_POLL_END:
	ret
