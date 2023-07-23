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
.eqv	MARIO_LIM_R		160

.include "../sprites/pixels/tiles.s"
.include "../sprites/pixels/tiles2.s"
.include "../sprites/pixels/marios.s"
.include "../sprites/map/map_example.s"
.include "../sprites/map/mapa.asm"

# Só começa a contar que entrou em outra tile após ter passado os 16 pixeis verticais ou horizontais
MAP_POS: .word 0
FRAME:		.byte	1	#frame seguinte

# MARIO #####################################################################################################
MARIO_UPGRADE: .byte 1 # upgrade atual do mario 1 = pqueno 2 = grande
MARIO_STATE: .byte 0 # estado do mario = sprite, cycle
MARIO_POS: .word 160,192 # posicao relativa na tela
MARIO_POS_TILE: .byte 0, 0
MARIO_SPEED_UP: .byte 0


# s11 = flag para renderizar o mapa


.text

MAIN:
	li s11,1
	
GAME_LOOP:	# loop principal do jogo
	jal KEY_HANDLE	# funcao que trata input do teclado
	beq s11,zero,MAP_SKIP1	# verifica se o mapa precisa ser atualizado
	jal MAP_RENDER
MAP_SKIP1:
	jal MARIO_RENDER	# renderiza o mario
	la t0, FRAME
	lb t1,0(t0)
	li t2, FRAME_ADDRS
	sb t1, 0(t2)
	not t1,t1
	andi t1,t1,1
	sb t1,0(t0)	#Atualiza a variavel de frame
	beq s11,zero,MAP_SKIP2
	li s11,0
	jal MAP_RENDER
MAP_SKIP2:
	j GAME_LOOP

	
##########################################################
# MAP RENDER 
##########################################################
MAP_RENDER:
	addi sp,sp,-8				# sp = sp-4
	sw ra,0(sp)
	sw s1,8(sp)

	la a6,MAPA				# carrega o endereco do mapa em a6
	la t0, MAP_POS			
	lw t0,0(t0)
	add a6,a6,t0			#desloca o mapa conforme a variavel de posicao de mapa
	li a1,0					# posicao em x
	li a2,0					# posicao em y
	la t0,FRAME
	lb a3,0(t0)				#frame
	li a4,16				# altura
	li a5,16				# largura
	li a7,0					# contador
	
MAP_LOOP:
	mv s1,a1
	lb a1,0(a6)				# provisorio
	la a0,TILES
	jal TILE_SELECT
	mv a1,s1		
	jal RENDER				# impressao no bitmap
	addi a1,a1,16				# a1 = a1+16
	addi a6,a6,1				# a6 = a6+1
	addi a7,a7,16				# a7 = a7+16
	li t0,320				# t0 = 320
	blt a7,t0,MAP_LOOP			# a7<t0?
	addi a1,a1,-320				# a1 = a1-320
	addi a2,a2,16				# a2 = a2+16
	li t0,240				# t0 = 240
	addi a6,a6,191				# a6 = a6+191
	mv a7,zero				# a7 = 0
	blt a2,t0,MAP_LOOP			# a2<t0? 

	lw ra,0(sp)
	lw s1,8(sp)
	addi sp,sp,8				# sp = sp+4
	ret					# retorna
		
	
	
	
	
	
############################################################################################################################
# RENDER | Args = a0(endereco imagem), a1(x),a2(y),a3(frame),a4(altura),a5(largura),
############################################################################################################################
RENDER:
	li t0 , 0xFF0 				# carrega 0x FF0 em t0
	add t0 , t0 , a3 			# adiciona o frame a FF0
	slli t0 , t0 , 20 			# shift de 20 bits pra esquerda
	add t0 , t0 , a1 			# adiciona x ao t0
	li t1 , 320 				# t1 = 320
	mul t1 , t1 , a2 			# multiplica y por t1
	add t0 , t0 , t1 			# coloca o endereco em t0
	mv t1 , zero 				# zera t1
	mv t2 , zero 				# zera t2
	mv t6 , a0 				# data em t6 para nao mudar a0
	mv t3 , a5 				# carrega a largura em t3
	mv t4 , a4 				# carrega a altura em t4
RENDER_LINE:
	lbu t5 , 0(t6) 				# carrega em t5 um byte da imagem
	sb t5 , 0(t0) 				# imprime no bitmap o byte da imagem
	addi t0 , t0 , 1 			# incrementa endereco do bitmap
	addi t6 , t6 , 1 			# incrementa endereco da imagem
	addi t2 , t2 , 1 			# incrementa contador de coluna
	blt t2 , t3 , RENDER_LINE 		# cont da coluna < largura ?
	addi t0 , t0 , 320 			# t0 += largura do bitmap
	sub t0 , t0 , t3 			# t0 -= largura da imagem
	mv t2 , zero 				# zera t2 ( cont de coluna )
	addi t1 , t1 , 1 			# incrementa contador de linha
	bgt t4 , t1 , RENDER_LINE 		# altura > contador de linha ?
	ret 					# retorna


##########################################################
# TILE SELECT a0(tile sheet address), a1(tile index)
##########################################################
TILE_SELECT:
	li t0,TILE_SIZE	# carrega o tamanho de um tile em t0
	mul t0,t0,a1	#multiplica o indice por esse tamanho
	add a0, a0,t0 	# e soma no endereco da imagem
	ret
	
##########################################################
# RENDER MARIO 
##########################################################
MARIO_RENDER:
	addi sp,sp,-4
	sw ra,0(sp)

	la t0, MARIO_STATE	# carrega o estado atual do mario e pega o endereco da imegem em a0 usando o TILE_SELECT
	la a0, MARIOS
	lb a1,0(t0)
	jal TILE_SELECT

	la t0, MARIO_POS # pega a posicao atual pra por no print
	lw a1,0(t0)
	lw a2,4(t0)

	la t0,MARIO_UPGRADE	#verifica o upgrade mas a principio n usa
	lb t1,0(t0)
	
	la t0,FRAME	# pega o proximo frame que sera o frame que vai ser printado
	lb a3,0(t0)

	li a4,TILE_HEIGHT	#calcula o tamanho do mario
	mul a4,a4,t1
	li a5,TILE_LENGTH

	jal RENDER	# printa o mario
	#TO DO - Limpar sombra

	lw ra,0(sp)
	addi sp,sp,4
	ret

##########################################################
# KEY HANDLING
##########################################################
KEY_HANDLE:
	addi sp,sp,-4
	sw ra,0(sp)

	jal KEY_POLL	# chama keypoll que vai retornar em a0 o status do teclado e em a1 a tecla pressionada caso tenha

	beq a0,zero,KEY_HANDLE_END
	li t0,'a'
	beq a1,t0,KEY_HANDLE_A	# se a tecla for um `a` vai para o tratamento do a
	li t0,'d'
	beq a1,t0,KEY_HANDLE_D	# se a tecla for um `D` vai para o tratamento do d
	li t0,'w'
	beq a1,t0,KEY_HANDLE_W	# se a tecla for um `W` vai para o tratamento do w
	li t0,27
	beq a1,t0,KEY_HANDLE_ESC	# se a tecla for um `ESC` vai para o tratamento do ESC
	j KEY_HANDLE_END

KEY_HANDLE_A:
	la t0, MARIO_POS	# carrega o endereco da posicao do mario
	lw t1,0(t0)			# pega a posicao no eixo x
	li t2, MARIO_LIM_L	
	ble t1,t2,HANDLE_A_END	# verifica se chegou no limite do movimento
	addi t1,t1,-4	
	sw t1,0(t0)	#atualiza posicao movendo o mario para a esquerda se possivel
	HANDLE_A_END:
		j KEY_HANDLE_END

KEY_HANDLE_D:
	la t0, MARIO_POS	# carrega o endereco da posicao do mario
	lw t1,0(t0)			# pega a posicao no eixo x
	li t2, MARIO_LIM_R
	bgeu t1,t2,HANDLE_D_MAP	# verifica se chegou no limite do movimento
	addi t1,t1,4	# se nao chegou soma 4 na posicao do mario
	sw t1,0(t0)
	j HANDLE_D_END

	HANDLE_D_MAP:	# se esta no limite mexe a posicao atual do mapa
		la t0, MAP_POS	#Carrega a posicao do mapa # TO DO - possivelmente ver jeito de mudar isso para n pular um tile inteiro
		lw t1,0(t0)		
		addi t1,t1,1	#soma 1 na posicao atual do mapa
		sw t1,0(t0)	# salva nova posicao do mapa
		li s11,1
	HANDLE_D_END:
		j KEY_HANDLE_END

KEY_HANDLE_W:
	HANDLE_W_END:
		j KEY_HANDLE_END

KEY_HANDLE_ESC:
	li a7, 10	# termina o programa se esc for apertado
	ecall


KEY_HANDLE_END:
	lw ra,0(sp)
	addi sp,sp, 4
	ret
	
##########################################################
# KEY POLLING
##########################################################
KEY_POLL:
	li t1,0xFF200000	# endereco do teclado
	lw t0,0(t1)			
	andi a0,t0,1		#status teclado
	beq a0,zero,KEY_POLL_END
	lw a1,4(t1)			# se tiver tecla guarda ela em a1
KEY_POLL_END:
	ret
