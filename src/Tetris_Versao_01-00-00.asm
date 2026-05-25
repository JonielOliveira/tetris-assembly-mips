#----------------------------------------------------------------------------------------------------------------------------------------------------
# Importar os arquivo de imagem necessarios
.include "peca_I_1.asm"
.include "peca_I_2.asm"
.include "peca_J_1.asm"
.include "peca_J_2.asm"
.include "peca_J_3.asm"
.include "peca_J_4.asm"
.include "peca_L_1.asm"
.include "peca_L_2.asm"
.include "peca_L_3.asm"
.include "peca_L_4.asm"
.include "peca_O_1.asm"
.include "peca_S_1.asm"
.include "peca_S_2.asm"
.include "peca_T_1.asm"
.include "peca_T_2.asm"
.include "peca_T_3.asm"
.include "peca_T_4.asm"
.include "peca_Z_1.asm"
.include "peca_Z_2.asm"
.include "TelaInicial.asm"
.include "Rotacao_AH.asm"
.include "Rotacao_H.asm"
.include "numero_0.asm"
.include "numero_1.asm"
.include "numero_2.asm"
.include "numero_3.asm"
.include "numero_4.asm"
.include "numero_5.asm"
.include "numero_6.asm"
.include "numero_7.asm"
.include "numero_8.asm"
.include "numero_9.asm"
.include "GameOver.asm"

#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
.data
	# Alguns exemplos de cores
	# black:	.word 0x000000
	# white:	.word 0xFFFFFF
	# gray:		.word 0x7F7F7F
	# maroon:	.word 0xAA0000
	# silver:	.word 0xC0C0C0
	# purple:	.word 0xAA00AA
	# navyblue:	.word 0x0000AA
	# darkgreen:	.word 0x00AA00
	# brown:	.word 0xAA5500
	# teal:		.word 0x00AAAA
	
	# E interessante criar este para salvar a posicao base da tela
	enderecoBase: .word 0x1004
	
	matrizNumberCenario: .space 26896
	matrizColorCenario: .space 16384
	matrizNumberPeca3: .space 576
	matrizColorPeca3: .space 576
	matrizNumberPeca2: .space 576
	matrizColorPeca2: .space 576
	matrizNumberPeca: .space 576
	matrizColorPeca: .space 576
	PilhaExtra1:	.space 40
	PilhaExtra2:	.space 40
	PilhaExtra3:	.space 40
	PilhaExtra4:	.space 40
	ListadePecas:	.space 80
	ListadeNumeros: .space 40
	ListadeLinhas:	.space 76
	
	PecaAtual:	.word 0
	PecaBackUp:	.word 0
	PecaPreview:	.word 0
	Pontuacao:	.word -1        
	
	msg0: .asciiz " , "
	msg1:	.asciiz " \n"
	msg2:   .asciiz "Voce Saiu!"
	msg3:   .asciiz "Tecla pressionada: "
	msg4:   .asciiz "Valor atual da coordenada ($S2): "
	msg5:	.asciiz "Resultado da verificacao de colisao: "
	msg6:	.asciiz "Entrou no DeletaPeca!"
	msg7:   .asciiz "Valor atual da coordenada ($S4): "
	msg8:	.asciiz "Peca escolhida: "
	msg9:	.asciiz "Posicao Inicial escolhida: "
	msg10:	.asciiz "\n ENTROU AQUI 1 \n"
	msg11:	.asciiz "\n ENTROU AQUI 2 \n"
	msg12:	.asciiz "\n MSG12: ENTROU AQUI 3 - <> 10 \n"
	msg13:	.asciiz "\n MSG13: ENTROU AQUI 3 - = 10 \n"
	msg14:	.asciiz "\n MSG14: ENTROU AQUI 4 - = 0 \n"
	msg15:	.asciiz "\n MSG15: ENTROU AQUI 4 - <> 0 \n"
	
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------	
.text
	j Main

#----------------------------------------------------------------------------------------------------------------------------------------------------
set_tela: # Inicia todos os valores para a tela
	addi $t0, $zero, 65536 #65536 = (512*512)/4 pixels
	add $t1, $t0, $zero #Adicionar a distribuição de pixels ao endereco
	lui $t1, 0x1004 #Endereco base da tela no heap, pode mudar se quiser
	
	# s1 inicia com o valor da posicao inicial do cenario no DISPLAY
	li $s1, 0X10040000
	# s3 inicia com o valor da posicao inicial da peca no DISPLAY
	move $s3, $s1
	addi $s3, $s3, 1036
	
	# s2 deslocamento total realizado pela peca (64x64)
	move $s2, $zero
	# s4 deslocamento futuro (64x64)
	move $s4, $zero
	
	# s5 deslocamento total realizado pela peca (82x82)
	move $s5, $zero
	# s6 deslocamento futuro (82x82)
	move $s6, $zero
	
	# Armazena o enredeco da peca carregada atualmente no jogo
	move $s7, $zero
	
	jr $ra
#----------------------------------------------------------------------------------------------------------------------------------------------------		

#----------------------------------------------------------------------------------------------------------------------------------------------------
set_cores: #Salvar as cores em registradores
	# lw $s3, black
	# lw $s4, white
	# lw $s5, gray
	# lw $s6, maroon
	# lw $s7, silver 
	jr $ra
#----------------------------------------------------------------------------------------------------------------------------------------------------		


#----------------------------------------------------------------------------------------------------------------------------------------------------
# RotacionarPecaAH 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
RotacionarPecaAH:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -24
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)

	la $t4, PecaAtual
	lw $t0, 0($t4)
	sw $t0, PecaBackUp
	# move $t0, $a0
	mul $t1, $t0, 4
	la $t2, Rotacao_AH
	add $t2, $t2, $t1
	lw $t3, 0($t2)
	add $t0, $t0, $t3
	sw $t0, PecaAtual
	
	move $v0, $t0 
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	sw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 24
	
	jr $ra

endRotacionarPecaAH:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# RotacionarPecaAH 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# RotacionarPecaH 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
RotacionarPecaH:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -24
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)

	la $t4, PecaAtual
	lw $t0, 0($t4)
	sw $t0, PecaBackUp
	# move $t0, $a0
	mul $t1, $t0, 4
	la $t2, Rotacao_H
	add $t2, $t2, $t1
	lw $t3, 0($t2)
	add $t0, $t0, $t3
	sw $t0, PecaAtual
	
	move $v0, $t0 
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	sw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 24
	
	jr $ra

endRotacionarPecaH:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# RotacionarPecaH 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# InicializaMatrizNumberCenario XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
	
InicializaMatrizNumberCenario:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	la $t0, matrizNumberCenario
	
	# inicia o contador i = 0
	addi $t1, $zero, 0
		
	loop_2_03: 
		# inicia o contador j = 0
		addi $t2, $zero, 0
					
		loop_1_03:
			# carrega o valor contido no endereco apontado por t1
			# trasfere para o endereco apontado por t6 
			sw $zero, 0($t0)
			
			addi $t0, $t0, 4
			
			# j = j + 1
			addi $t2, $t2, 1
									
			# Se j = 82, sai do loop
			beq $t2, 82, exit_1_03
			j loop_1_03
		exit_1_03:
		
		# i = i + 1
		addi $t1, $t1, 1
			
		# Se i = 82, sai do loop
		beq $t1, 82, exit_2_03
		j loop_2_03
	exit_2_03:
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 12
																
	jr $ra
	
endInicializaMatrizNumberCenario:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# InicializaMatrizNumberCenario XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadAddressPecas 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
LoadAddressPecas:
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -24
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	
	la $t0, ListadePecas	
	la $t1, peca_I_1
	la $t2, peca_I_2
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	la $t1, peca_J_1
	la $t2, peca_J_2
	la $t3, peca_J_3
	la $t4, peca_J_4		
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	sw $t3, 16($t0)
	sw $t4, 20($t0)
	la $t1, peca_L_1
	la $t2, peca_L_2
	la $t3, peca_L_3
	la $t4, peca_L_4		
	sw $t1, 24($t0)
	sw $t2, 28($t0)
	sw $t3, 32($t0)
	sw $t4, 36($t0)
	la $t1, peca_O_1		
	sw $t1, 40($t0)
	la $t1, peca_S_1
	la $t2, peca_S_2	
	sw $t1, 44($t0)
	sw $t2, 48($t0)
	la $t1, peca_T_1
	la $t2, peca_T_2
	la $t3, peca_T_3
	la $t4, peca_T_4		
	sw $t1, 52($t0)
	sw $t2, 56($t0)
	sw $t3, 60($t0)
	sw $t4, 64($t0)
	la $t1, peca_Z_1
	la $t2, peca_Z_2	
	sw $t1, 68($t0)
	sw $t2, 72($t0)
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 24
	
	jr $ra

endLoadAddressPecas:

#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadAddressPecas 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadNumeros                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
LoadNumeros:
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -24
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	
	la $t0, ListadeNumeros	
	la $t1, numero_0
	la $t2, numero_1
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	la $t1, numero_2
	la $t2, numero_3
	la $t3, numero_4
	la $t4, numero_5		
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	sw $t3, 16($t0)
	sw $t4, 20($t0)
	la $t1, numero_6
	la $t2, numero_7
	la $t3, numero_8
	la $t4, numero_9		
	sw $t1, 24($t0)
	sw $t2, 28($t0)
	sw $t3, 32($t0)
	sw $t4, 36($t0)
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 24
	
	jr $ra

endLoadNumeros:

#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadNumeros                       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# RandomSelectPeca 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
RandomSelectPeca:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -12
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	
	li $v0, 42
	la $a1, 19
	syscall
	
	move $t0, $a0
	
	la $a0, msg8
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	jal PrintNovaLinha
	
	move $v0, $t0
	
	la $t1, PecaPreview
	sw $t0, 0($t1)
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 12
	
	jr $ra

endRandomSelectPeca:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# RandomSelectPeca 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# RandomPosicaoInicialPeca 	    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
RandomPosicaoInicialPeca:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	
	li $v0, 42
	la $a1, 7
	syscall
	
	move $t0, $a0
	
	la $a0, msg9
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	jal PrintNovaLinha
	
	mul $t0, $t0, 12
	
	add $s2, $s2, $t0
	add $s4, $s4, $t0
	add $s5, $s5, $t0
	add $s6, $s6, $t0
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	
	jr $ra

endRandomPosicaoInicialPeca:

#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# RandomPosicaoInicialPeca 	    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# BuildAddressPeca 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
	
BuildAddressPeca:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -20
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	move $t0, $a0
	addi $t1, $zero, 4
	mult $t0, $t1
	mflo $t0
	
	la $t2, ListadePecas
	add $t2, $t2, $t0
	lw $t3, 0($t2)	
	
	la $a0, msg8
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	jal PrintNovaLinha
	
	# move $s7, $t3 
	move $v0, $t3
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 20
	
	jr $ra

endBuildAddressPeca:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# BuildAddressPeca 	            XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadTelaInicial               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
LoadTelaInicial:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t7, 28($sp)
		
	# carrega no registrador t0 o endereco base da tela no heap
	# carrega no registrador t1 o endereco inicial do rotulo TelaInicial
	# carrega no registrador t2 o endereco inicial do rotulo matrizColorCenario
	# carrega no registrador t3 o endereco inicial do rotulo matrizNumberCenario
	move $t0, $s1
	la $t1, TelaInicial
	la $t2, matrizColorCenario
	la $t3, matrizNumberCenario
	addi $t3, $t3, 2988
						
	# inicia o contador i = 0
	addi $t4, $zero, 0
		
	loop_2_00: 
		# inicia o contador j = 0
		addi $t5, $zero, 0
					
		loop_1_00:
			# carrega o valor contido no endereco apontado por t1
			# trasfere para o endereco apontado por t6 
			lw $t6, 0($t1)	
			
			# switch case
			if_1_00: 
				beq $t6, 1, case_1_00
				beq $t6, 2, case_2_00
				beq $t6, 3, case_3_00
				beq $t6, 4, case_4_00
				beq $t6, 5, case_5_00
				beq $t6, 6, case_6_00
				beq $t6, 7, case_7_00
				beq $t6, 8, case_8_00
				beq $t6, 9, case_9_00
				beq $t6, 10, case_10_00
				else_1_00:
					# carrega em t7 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# pinta o pixel no endereco apontado por t0 com a cor armazenada em t7
					# armazena no endereco apontado por t2 o valor da cor armazanada em t7
					li $t7, 0xFFFFFF
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					# carrega em t7 o imediato que corresponde a uma posicao VAZIA (0) 
					# armazena no endereco apontato por t3 o valor contido em t7
					li $t7, 0
					sw $t7, 0($t3)	
					j endif_1_00
				case_1_00:
					# carrega em t7 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# pinta o pixel no endereco apontado por t0 com a cor armazenada em t7
					# armazena no endereco apontado por t2 o valor da cor armazanada em t7					
					li $t7, 0x000000
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					# carrega em t7 o imediato que corresponde a uma posicao PREENCHIDA (1) 
					# armazena no endereco apontato por t3 o valor contido em t7
					
					if_1B_00:
					bge $t4, 61, case_1B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_1B_00
					case_1B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_1B_00:
					
					j endif_1_00
				case_2_00:
					li $t7, 0xFFFFFF
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					li $t7, 0
					sw $t7, 0($t3)							
					j endif_1_00
				case_3_00:
					li $t7, 0x7F7F7F
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					
					if_3B_00:
					bge $t4, 61, case_3B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_3B_00
					case_3B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_3B_00:
					
					j endif_1_00
				case_4_00:
					li $t7, 0xAA0000
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					
					if_4B_00:
					bge $t4, 61, case_4B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_4B_00
					case_4B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_4B_00:
									
					j endif_1_00
				case_5_00:
					li $t7, 0xC0C0C0
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					if_5B_00:
					bge $t4, 61, case_5B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_5B_00
					case_5B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_5B_00:					
																							
					j endif_1_00
				case_6_00:
					li $t7, 0xAA00AA
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					
					if_6B_00:
					bge $t4, 61, case_6B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_6B_00
					case_6B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_6B_00:
																							
					j endif_1_00
				case_7_00:
					li $t7, 0x0000AA
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					if_7B_00:
					bge $t4, 61, case_7B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_7B_00
					case_7B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_7B_00:
																	
					j endif_1_00
				case_8_00:
					li $t7, 0x00AA00
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					
					if_8B_00:
					bge $t4, 61, case_8B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_8B_00
					case_8B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_8B_00:
																										
					j endif_1_00
				case_9_00:
					li $t7, 0xAA5500
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					if_9B_00:
					bge $t4, 61, case_9B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_9B_00
					case_9B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_9B_00:
																	
					j endif_1_00
				case_10_00:
					li $t7, 0x00AAAA
					sw $t7, 0($t0)
					sw $t7, 0($t2)
					
					if_10B_00:
					bge $t4, 61, case_10B_00  
						li $t7, 1
						sw $t7, 0($t3)
						j endif_10B_00
					case_10B_00:
						li $t7, 2
						sw $t7, 0($t3)
					endif_10B_00:
																							
					j endif_1_00
					
			endif_1_00:
					
			# pula para a proxima coluna no display (proximo elemento no vetor)
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorCenario
			# pula para o proximo elemento na matrizNumberCenario
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			
			# j = j + 1
			addi $t5, $t5, 1
									
			# Se j = 64, sai do loop
			beq $t5, 64, exit_1_00
			j loop_1_00
		exit_1_00:
			
		addi $t3, $t3, 72
			
		# i = i + 1
		addi $t4, $t4, 1
				
		# Se i = 64, sai do loop
		beq $t4, 64, exit_2_00
		j loop_2_00
	exit_2_00:
			
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t7, 28($sp)
	lw $t6, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 32
																
	jr $ra
	
endLoadTelaInicial:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------		
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadTelaInicial               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------	


#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaTela                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
AtualizaTela:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -28
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
		
	# carrega no registrador t0 o endereco base da tela no heap
	# carrega no registrador t1 o endereco inicial do rotulo TelaInicial
	# carrega no registrador t2 o endereco inicial do rotulo matrizColorCenario
	# carrega no registrador t3 o endereco inicial do rotulo matrizNumberCenario
	move $t0, $s1
	la $t1, matrizColorCenario
	
	addi $t0, $t0, 14860
	addi $t1, $t1, 14860
	
	# addi $t0, $t0, 15628
	# addi $t1, $t1, 15628
						
	# inicia o contador k = 0
	addi $t2, $zero, 0
		
	loop_3_38: 
		
		# inicia o contador i = 0
		addi $t3, $zero, 0
					
		loop_2_38:
			
			# inicia o contador j = 0
			addi $t4, $zero, 0
			
			loop_1_38:
				
				lw $t5, 0($t1)
				# li $t5, 0x000000
				sw $t5, 0($t0)
				
				addi $t0, $t0, 4
				addi $t1, $t1, 4
				
				# j = j + 1
				addi $t4, $t4, 1
				
				# Se j = 30, sai do loop
				beq $t4, 30, exit_1_38
				j loop_1_38
			exit_1_38:
			
			addi $t0, $t0, 136
			addi $t1, $t1, 136
			
			# i = i + 1
			addi $t3, $t3, 1
									
			# Se i = 3, sai do loop
			beq $t3, 3, exit_2_38
			j loop_2_38
		exit_2_38:
		
		subi $t0, $t0, 1536
		subi $t1, $t1, 1536

		# k = k + 1
		addi $t2, $t2, 1
				
		# Se k = 19, sai do loop
		beq $t2, 19, exit_3_38
		j loop_3_38
	exit_3_38:
			
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 28
																
	jr $ra
	
endAtualizaTela:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------		
#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaTela                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------	

#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaPontuacao             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
AtualizaPontuacao:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -44
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $t8, 36($sp)
	sw $t9, 40($sp)	
	
	#---------------------------
	la $t0, Pontuacao
	lw $t1, 0($t0)
	add $t1, $t1, $a0
	sw $t1, 0($t0)
	#---------------------------
	
	#---------------------------
	addi $t0, $zero, 100
	div $t1, $t0
	mflo $t2
	mfhi $t1
	#---------------------------
	
	#---------------------------
	addi $t0, $zero, 10
	div $t1, $t0
	mflo $t3
	mfhi $t4
	#---------------------------
	
	#---------------------------
	addi $t0, $zero, 4
	mult $t2, $t0
	mflo $t2
	#---------------------------
	
	#---------------------------
	la $t0, ListadeNumeros
	add $t0, $t0, $t2
	lw $t5, 0($t0)	
	#---------------------------
	
	li $t0, 0X10040000
	addi $t0, $t0, 8104
	
	# inicia o contador i = 0
	addi $t6, $zero, 0
	
	loop_2_40: 
		# inicia o contador j = 0
		addi $t7, $zero, 0
					
		loop_1_40:
			# carrega o valor contido no endereco apontado por t5
			# trasfere para o endereco apontado por t8 
			lw $t8, 0($t5)	
			
			# switch case
			if_1_40: 
				beq $t8, 1, case_1_40
				beq $t8, 2, case_2_40
				else_1_40:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6
					li $t9, 0xFFFFFF
					sw $t9, 0($t0)
					j endif_1_40
				case_1_40:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6					
					li $t9, 0x000000
					sw $t9, 0($t0)
					j endif_1_40
				case_2_40:
					li $t9, 0xFFFFFF
					sw $t9, 0($t0)							
						
			endif_1_40:
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			addi $t0, $t0, 4
			addi $t5, $t5, 4
			
			# j = j + 1
			addi $t7, $t7, 1
									
			# Se j = 3, sai do loop
			beq $t7, 3, exit_1_40
			j loop_1_40
		exit_1_40:
		
		addi $t0, $t0, 244
		
		# i = i + 1
		addi $t6, $t6, 1
			
		# Se i = 5, sai do loop
		beq $t6, 5, exit_2_40
		j loop_2_40
	exit_2_40:
	
	#---------------------------
	addi $t0, $zero, 4
	mult $t3, $t0
	mflo $t3
	#---------------------------
	
	#---------------------------
	la $t0, ListadeNumeros
	add $t0, $t0, $t3
	lw $t5, 0($t0)	
	#---------------------------
	
	li $t0, 0X10040000
	addi $t0, $t0, 8120
	
	# inicia o contador i = 0
	addi $t6, $zero, 0
	
	loop_4_40: 
		# inicia o contador j = 0
		addi $t7, $zero, 0
					
		loop_3_40:
			# carrega o valor contido no endereco apontado por t5
			# trasfere para o endereco apontado por t8 
			lw $t8, 0($t5)	
			
			# switch case
			if_2_40: 
				beq $t8, 1, case_3_40
				beq $t8, 2, case_4_40
				else_2_40:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6
					li $t9, 0xFFFFFF
					sw $t9, 0($t0)
					j endif_2_40
				case_3_40:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6					
					li $t9, 0x000000
					sw $t9, 0($t0)
					j endif_2_40
				case_4_40:
					li $t9, 0xFFFFFF
					sw $t9, 0($t0)							
						
			endif_2_40:
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			addi $t0, $t0, 4
			addi $t5, $t5, 4
			
			# j = j + 1
			addi $t7, $t7, 1
									
			# Se j = 3, sai do loop
			beq $t7, 3, exit_3_40
			j loop_3_40
		exit_3_40:
		
		addi $t0, $t0, 244
		
		# i = i + 1
		addi $t6, $t6, 1
			
		# Se i = 5, sai do loop
		beq $t6, 5, exit_4_40
		j loop_4_40
	exit_4_40:
	
	#---------------------------
	addi $t0, $zero, 4
	mult $t4, $t0
	mflo $t4
	#---------------------------
	
	#---------------------------
	la $t0, ListadeNumeros
	add $t0, $t0, $t4
	lw $t5, 0($t0)	
	#---------------------------
	
	li $t0, 0X10040000
	addi $t0, $t0, 8136
	
	# inicia o contador i = 0
	addi $t6, $zero, 0
	
	loop_6_40: 
		# inicia o contador j = 0
		addi $t7, $zero, 0
					
		loop_5_40:
			# carrega o valor contido no endereco apontado por t5
			# trasfere para o endereco apontado por t8 
			lw $t8, 0($t5)	
			
			# switch case
			if_3_40: 
				beq $t8, 1, case_5_40
				beq $t8, 2, case_6_40
				else_3_40:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6
					li $t9, 0xFFFFFF
					sw $t9, 0($t0)
					j endif_3_40
				case_5_40:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6					
					li $t9, 0x000000
					sw $t9, 0($t0)
					j endif_3_40
				case_6_40:
					li $t9, 0xFFFFFF
					sw $t9, 0($t0)							
						
			endif_3_40:
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			addi $t0, $t0, 4
			addi $t5, $t5, 4
			
			# j = j + 1
			addi $t7, $t7, 1
									
			# Se j = 3, sai do loop
			beq $t7, 3, exit_5_40
			j loop_5_40
		exit_5_40:
		
		addi $t0, $t0, 244
		
		# i = i + 1
		addi $t6, $t6, 1
			
		# Se i = 5, sai do loop
		beq $t6, 5, exit_6_40
		j loop_6_40
	exit_6_40:
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t9, 40($sp)
	lw $t8, 36($sp)
	lw $t7, 32($sp)
	lw $t6, 28($sp)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 44
																
	jr $ra
	
endAtualizaPontuacao:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaPontuacao             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# DrawGameOver                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
DrawGameOver:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -28
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)	
	
	la $t0, GameOver	
	li $t1, 0X10040000
	addi $t1, $t1, 6156
	
	# inicia o contador i = 0
	addi $t2, $zero, 0
	
	loop_2_45: 
		# inicia o contador j = 0
		addi $t3, $zero, 0
					
		loop_1_45:
			# carrega o valor contido no endereco apontado por t5
			# trasfere para o endereco apontado por t8 
			lw $t4, 0($t0)	
			
			# switch case
			if_1_45: 
				beq $t4, 2, case_1_45
				beq $t4, 4, case_2_45
				else_1_45:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6
					li $t5, 0xFFFFFF
					sw $t5, 0($t1)
					j endif_1_45
				case_1_45:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6					
					li $t5, 0xFFFFFF
					sw $t5, 0($t1)
					j endif_1_45
				case_2_45:
					li $t5, 0xAA0000
					sw $t5, 0($t1)							
						
			endif_1_45:
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			
			# j = j + 1
			addi $t3, $t3, 1
									
			# Se j = 30, sai do loop
			beq $t3, 30, exit_1_45
			j loop_1_45
		exit_1_45:
		
		addi $t1, $t1, 136
		
		# i = i + 1
		addi $t2, $t2, 1
			
		# Se i = 17, sai do loop
		beq $t2, 17, exit_2_45
		j loop_2_45
	exit_2_45:
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 28
																
	jr $ra
	
endDrawGameOver:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# DrawGameOver                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadInPreview                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
LoadInPreview:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t7, 28($sp)
		
	# carrega no registrador t0 o endereco inicial da Peca
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	# carrega no registrador t2 o endereco inicial do rotulo matrizNumberPeca
	
	# move $t0, $s7
	move $t0, $a0
	# la $t7, ListadePecas
	# lw $t0, 4($t7)		
	# la $t0, peca_O_1
	la $t1, matrizColorPeca2
	la $t2, matrizNumberPeca2
						
	# inicia o contador i = 0
	addi $t3, $zero, 0
		
	loop_2_01: 
		# inicia o contador j = 0
		addi $t4, $zero, 0
					
		loop_1_01:
			# carrega o valor contido no endereco apontado por t0
			# trasfere para o endereco apontado por t5 
			lw $t5, 0($t0)	
			
			# switch case
			if_1_01: 
				beq $t5, 1, case_1_01
				beq $t5, 2, case_2_01
				beq $t5, 3, case_3_01
				beq $t5, 4, case_4_01
				beq $t5, 5, case_5_01
				beq $t5, 6, case_6_01
				beq $t5, 7, case_7_01
				beq $t5, 8, case_8_01
				beq $t5, 9, case_9_01
				beq $t5, 10, case_10_01
				else_1_01:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6
					li $t6, 0xFFFFFF
					sw $t6, 0($t1)
					# carrega em t6 o imediato que corresponde a uma posicao VAZIA (0) 
					# armazena no endereco apontato por t2 o valor contido em t6
					li $t6, 0
					sw $t6, 0($t2)	
					j endif_1_01
				case_1_01:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6					
					li $t6, 0x000000
					sw $t6, 0($t1)
					# carrega em t6 o imediato que corresponde a uma posicao PREENCHIDA (1) 
					# armazena no endereco apontato por t2 o valor contido em t6
					li $t6, 1
					sw $t6, 0($t2)	
					j endif_1_01
				case_2_01:
					li $t6, 0xFFFFFF
					sw $t6, 0($t1)
					li $t6, 0
					sw $t6, 0($t2)							
					j endif_1_01
				case_3_01:
					li $t6, 0x7F7F7F
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_4_01:
					li $t6, 0xAA0000
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_5_01:
					li $t6, 0xC0C0C0
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_6_01:
					li $t6, 0xAA00AA
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_7_01:
					li $t6, 0x0000AA
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_8_01:
					li $t6, 0x00AA00
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_9_01:
					li $t6, 0xAA5500
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
				case_10_01:
					li $t6, 0x00AAAA
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_01
					
			endif_1_01:
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			# pula para o proximo elemento na matrizNumberPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			
			# j = j + 1
			addi $t4, $t4, 1
									
			# Se j = 12, sai do loop
			beq $t4, 12, exit_1_01
			j loop_1_01
		exit_1_01:
			
		# i = i + 1
		addi $t3, $t3, 1
			
		# Se i = 12, sai do loop
		beq $t3, 12, exit_2_01
		j loop_2_01
	exit_2_01:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t7, 28($sp)
	lw $t6, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 32
																
	jr $ra
	
endLoadInPreview:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadInPreview                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadPecaDireto                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
LoadPecaDireto:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -32
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t7, 28($sp)
		
	# carrega no registrador t0 o endereco inicial da Peca
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	# carrega no registrador t2 o endereco inicial do rotulo matrizNumberPeca
	
	# move $t0, $s7
	move $t0, $a0
	# la $t7, ListadePecas
	# lw $t0, 4($t7)		
	# la $t0, peca_O_1
	la $t1, matrizColorPeca
	la $t2, matrizNumberPeca
						
	# inicia o contador i = 0
	addi $t3, $zero, 0
		
	loop_2_22: 
		# inicia o contador j = 0
		addi $t4, $zero, 0
					
		loop_1_22:
			# carrega o valor contido no endereco apontado por t0
			# trasfere para o endereco apontado por t5 
			lw $t5, 0($t0)	
			
			# switch case
			if_1_22: 
				beq $t5, 1, case_1_22
				beq $t5, 2, case_2_22
				beq $t5, 3, case_3_22
				beq $t5, 4, case_4_22
				beq $t5, 5, case_5_22
				beq $t5, 6, case_6_22
				beq $t5, 7, case_7_22
				beq $t5, 8, case_8_22
				beq $t5, 9, case_9_22
				beq $t5, 10, case_10_22
				else_1_22:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6
					li $t6, 0xFFFFFF
					sw $t6, 0($t1)
					# carrega em t6 o imediato que corresponde a uma posicao VAZIA (0) 
					# armazena no endereco apontato por t2 o valor contido em t6
					li $t6, 0
					sw $t6, 0($t2)	
					j endif_1_22
				case_1_22:
					# carrega em t6 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# armazena no endereco apontado por t1 o valor da cor armazanada em t6					
					li $t6, 0x000000
					sw $t6, 0($t1)
					# carrega em t6 o imediato que corresponde a uma posicao PREENCHIDA (1) 
					# armazena no endereco apontato por t2 o valor contido em t6
					li $t6, 1
					sw $t6, 0($t2)	
					j endif_1_22
				case_2_22:
					li $t6, 0xFFFFFF
					sw $t6, 0($t1)
					li $t6, 0
					sw $t6, 0($t2)							
					j endif_1_22
				case_3_22:
					li $t6, 0x7F7F7F
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_4_22:
					li $t6, 0xAA0000
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_5_22:
					li $t6, 0xC0C0C0
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_6_22:
					li $t6, 0xAA00AA
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_7_22:
					li $t6, 0x0000AA
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_8_22:
					li $t6, 0x00AA00
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_9_22:
					li $t6, 0xAA5500
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
				case_10_22:
					li $t6, 0x00AAAA
					sw $t6, 0($t1)
					li $t6, 1
					sw $t6, 0($t2)							
					j endif_1_22
					
			endif_1_22:
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			# pula para o proximo elemento na matrizNumberPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			
			# j = j + 1
			addi $t4, $t4, 1
									
			# Se j = 12, sai do loop
			beq $t4, 12, exit_1_22
			j loop_1_22
		exit_1_22:
			
		# i = i + 1
		addi $t3, $t3, 1
			
		# Se i = 12, sai do loop
		beq $t3, 12, exit_2_22
		j loop_2_22
	exit_2_22:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t7, 28($sp)
	lw $t6, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 32
																
	jr $ra
	
endLoadPecaDireto:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadPecaDireto                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadPecaIndireto              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
LoadPecaIndireto:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -44
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $t8, 36($sp)
	sw $t9, 40($sp)
		
	# carrega no registrador t0 o endereco inicial da Peca
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	# carrega no registrador t2 o endereco inicial do rotulo matrizNumberPeca
	
	la $t0, matrizColorPeca2
	la $t1, matrizNumberPeca2
	la $t2, matrizColorPeca
	la $t3, matrizNumberPeca
	
	la $t8, PecaPreview
	lw $t9, 0($t8)
	sw $t9, PecaAtual
						
	# inicia o contador i = 0
	addi $t4, $zero, 0
		
	loop_2_05: 
		# inicia o contador j = 0
		addi $t5, $zero, 0
					
		loop_1_05:
			# carrega o valor contido no endereco apontado por t0
			# trasfere para o endereco apontado por t5 
			lw $t6, 0($t0)
			sw $t6, 0($t2)
			
			lw $t7, 0($t1)
			sw $t7, 0($t3)	
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			# pula para o proximo elemento na matrizNumberPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			
			# j = j + 1
			addi $t5, $t5, 1
									
			# Se j = 12, sai do loop
			beq $t5, 12, exit_1_05
			j loop_1_05
		exit_1_05:
			
		# i = i + 1
		addi $t4, $t4, 1
			
		# Se i = 12, sai do loop
		beq $t4, 12, exit_2_05
		j loop_2_05
	exit_2_05:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t9, 40($sp)
	lw $t8, 36($sp)
	lw $t7, 32($sp)
	lw $t6, 28($sp)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 44
																
	jr $ra
	
endLoadPecaIndireto:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadPecaIndireto              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadFromBackUp                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
LoadFromBackUp:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -44
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $t8, 36($sp)
	sw $t9, 40($sp)
		
	# carrega no registrador t0 o endereco inicial da Peca
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	# carrega no registrador t2 o endereco inicial do rotulo matrizNumberPeca
	
	la $t0, matrizColorPeca3
	la $t1, matrizNumberPeca3
	la $t2, matrizColorPeca
	la $t3, matrizNumberPeca
	
	la $t8, PecaBackUp
	lw $t9, 0($t8)
	sw $t9, PecaAtual
						
	# inicia o contador i = 0
	addi $t4, $zero, 0
		
	loop_2_26: 
		# inicia o contador j = 0
		addi $t5, $zero, 0
					
		loop_1_26:
			# carrega o valor contido no endereco apontado por t0
			# trasfere para o endereco apontado por t5 
			lw $t6, 0($t0)
			sw $t6, 0($t2)
			
			lw $t7, 0($t1)
			sw $t7, 0($t3)	
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			# pula para o proximo elemento na matrizNumberPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			
			# j = j + 1
			addi $t5, $t5, 1
									
			# Se j = 12, sai do loop
			beq $t5, 12, exit_1_26
			j loop_1_26
		exit_1_26:
			
		# i = i + 1
		addi $t4, $t4, 1
			
		# Se i = 12, sai do loop
		beq $t4, 12, exit_2_26
		j loop_2_26
	exit_2_26:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t9, 40($sp)
	lw $t8, 36($sp)
	lw $t7, 32($sp)
	lw $t6, 28($sp)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 44
																
	jr $ra
	
endLoadFromBackUp:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadFromBackUp                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadBackUpPeca                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
LoadBackUpPeca:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -44
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $t8, 36($sp)
	sw $t9, 40($sp)
		
	# carrega no registrador t0 o endereco inicial da Peca
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	# carrega no registrador t2 o endereco inicial do rotulo matrizNumberPeca
	
	la $t0, matrizColorPeca
	la $t1, matrizNumberPeca
	la $t2, matrizColorPeca3
	la $t3, matrizNumberPeca3
	
	la $t8, PecaAtual
	lw $t9, 0($t8)
	sw $t9, PecaBackUp										
						
	# inicia o contador i = 0
	addi $t4, $zero, 0
		
	loop_2_21: 
		# inicia o contador j = 0
		addi $t5, $zero, 0
					
		loop_1_21:
			# carrega o valor contido no endereco apontado por t0
			# trasfere para o endereco apontado por t5 
			lw $t6, 0($t0)
			sw $t6, 0($t2)
			
			lw $t7, 0($t1)
			sw $t7, 0($t3)	
				
			# pula para o proximo elemento no vetor de entrada (imagem que esta sendo carregada)
			# pula para a proxima coluna da matrizColorPeca
			# pula para o proximo elemento na matrizNumberPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			addi $t3, $t3, 4
			
			# j = j + 1
			addi $t5, $t5, 1
									
			# Se j = 12, sai do loop
			beq $t5, 12, exit_1_21
			j loop_1_21
		exit_1_21:
			
		# i = i + 1
		addi $t4, $t4, 1
			
		# Se i = 12, sai do loop
		beq $t4, 12, exit_2_21
		j loop_2_21
	exit_2_21:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t9, 40($sp)
	lw $t8, 36($sp)
	lw $t7, 32($sp)
	lw $t6, 28($sp)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 44
																
	jr $ra
	
endLoadBackUpPeca:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LoadBackUpPeca                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# DrawPeca                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
DrawPeca:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
		
	# carrega no registrador t0 o endereco base da tela no heap
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	move $t0, $s3
	add $t0, $t0, $s2
	la $t1, matrizColorPeca
							
	# inicia o contador i = 0
	addi $t2, $zero, 0
	
	loop_2_02: 
		# inicia o contador j = 0
		addi $t3, $zero, 0
					
		loop_1_02:
			# carrega o valor contido no endereco apontado por t1
			# trasfere para o endereco apontado por t4 
			lw $t4, 0($t1)	
			
			# switch case
			if_1_02: 
				beq $t4, 0x000000, case_1_02
				beq $t4, 0xFFFFFF, case_2_02
				beq $t4, 0x7F7F7F, case_3_02
				beq $t4, 0xAA0000, case_4_02
				beq $t4, 0xC0C0C0, case_5_02
				beq $t4, 0xAA00AA, case_6_02
				beq $t4, 0x0000AA, case_7_02
				beq $t4, 0x00AA00, case_8_02
				beq $t4, 0xAA5500, case_9_02
				beq $t4, 0x00AAAA, case_10_02
				else_1_02:
					# carrega em t5 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# pinta o pixel no endereco apontado por t0 com a cor armazenada em t5
					li $t5, 0xFFFFFF
					# sw $t5, 0($t0)
					j endif_1_02
				case_1_02:
					# carrega em t5 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# pinta o pixel no endereco apontado por t0 com a cor armazenada em t5				
					li $t5, 0x000000
					sw $t5, 0($t0)
					j endif_1_02
				case_2_02:
					li $t5, 0xFFFFFF
					# sw $t5, 0($t0)					
					j endif_1_02
				case_3_02:
					li $t5, 0x7F7F7F
					sw $t5, 0($t0)					
					j endif_1_02
				case_4_02:
					li $t5, 0xAA0000
					sw $t5, 0($t0)					
					j endif_1_02
				case_5_02:
					li $t5, 0xC0C0C0
					sw $t5, 0($t0)					
					j endif_1_02
				case_6_02:
					li $t5, 0xAA00AA
					sw $t5, 0($t0)					
					j endif_1_02
				case_7_02:
					li $t5, 0x0000AA
					sw $t5, 0($t0)					
					j endif_1_02
				case_8_02:
					li $t5, 0x00AA00
					sw $t5, 0($t0)					
					j endif_1_02
				case_9_02:
					li $t5, 0xAA5500
					sw $t5, 0($t0)						
					j endif_1_02
				case_10_02:
					li $t5, 0x00AAAA
					sw $t5, 0($t0)					
					j endif_1_02
					
			endif_1_02:
				
			# pula para a proxima coluna no display (proximo elemento no vetor)
			# pula para a proxima coluna da matrizColorPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			
			# j = j + 1
			addi $t3, $t3, 1
									
			# Se j = 12, sai do loop
			beq $t3, 12, exit_1_02
			j loop_1_02
		exit_1_02:
		
		# pula para a proxima linha no display
		addi $t0, $t0, 208
			
		# i = i + 1
		addi $t2, $t2, 1
			
		# Se i = 12, sai do loop
		beq $t2, 12, exit_2_02
		j loop_2_02
	exit_2_02:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 24
																
	jr $ra
	
endDrawPeca:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# DrawPeca                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# DrawInPreview                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------				
	
DrawInPreview:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
		
	# carrega no registrador t0 o endereco base da tela no heap
	# carrega no registrador t1 o endereco inicial do rotulo matrizColorPeca
	move $t0, $s3
	addi $t0, $t0, 924
	la $t1, matrizColorPeca2
							
	# inicia o contador i = 0
	addi $t2, $zero, 0
	
	loop_2_06: 
		# inicia o contador j = 0
		addi $t3, $zero, 0
					
		loop_1_06:
			# carrega o valor contido no endereco apontado por t1
			# trasfere para o endereco apontado por t4 
			lw $t4, 0($t1)	
			
			# switch case
			if_1_06: 
				beq $t4, 0x000000, case_1_06
				beq $t4, 0xFFFFFF, case_2_06
				beq $t4, 0x7F7F7F, case_3_06
				beq $t4, 0xAA0000, case_4_06
				beq $t4, 0xC0C0C0, case_5_06
				beq $t4, 0xAA00AA, case_6_06
				beq $t4, 0x0000AA, case_7_06
				beq $t4, 0x00AA00, case_8_06
				beq $t4, 0xAA5500, case_9_06
				beq $t4, 0x00AAAA, case_10_06
				else_1_06:
					# carrega em t5 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# pinta o pixel no endereco apontado por t0 com a cor armazenada em t5
					li $t5, 0xFFFFFF
					sw $t5, 0($t0)
					j endif_1_06
				case_1_06:
					# carrega em t5 o imediato com o valor correspondente a cor em RGB que deseja aplicar
					# pinta o pixel no endereco apontado por t0 com a cor armazenada em t5				
					li $t5, 0x000000
					sw $t5, 0($t0)
					j endif_1_06
				case_2_06:
					li $t5, 0xFFFFFF
					sw $t5, 0($t0)					
					j endif_1_06
				case_3_06:
					li $t5, 0x7F7F7F
					sw $t5, 0($t0)					
					j endif_1_06
				case_4_06:
					li $t5, 0xAA0000
					sw $t5, 0($t0)					
					j endif_1_06
				case_5_06:
					li $t5, 0xC0C0C0
					sw $t5, 0($t0)					
					j endif_1_06
				case_6_06:
					li $t5, 0xAA00AA
					sw $t5, 0($t0)					
					j endif_1_06
				case_7_06:
					li $t5, 0x0000AA
					sw $t5, 0($t0)					
					j endif_1_06
				case_8_06:
					li $t5, 0x00AA00
					sw $t5, 0($t0)					
					j endif_1_06
				case_9_06:
					li $t5, 0xAA5500
					sw $t5, 0($t0)						
					j endif_1_06
				case_10_06:
					li $t5, 0x00AAAA
					sw $t5, 0($t0)					
					j endif_1_06
					
			endif_1_06:
				
			# pula para a proxima coluna no display (proximo elemento no vetor)
			# pula para a proxima coluna da matrizColorPeca
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			
			# j = j + 1
			addi $t3, $t3, 1
									
			# Se j = 12, sai do loop
			beq $t3, 12, exit_1_06
			j loop_1_06
		exit_1_06:
		
		# pula para a proxima linha no display
		addi $t0, $t0, 208
			
		# i = i + 1
		addi $t2, $t2, 1
			
		# Se i = 12, sai do loop
		beq $t2, 12, exit_2_06
		j loop_2_06
	exit_2_06:
		
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 24
																
	jr $ra
	
endDrawInPreview:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# DrawInPreview                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# DeletaPeca                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
								
DeletaPeca:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	
	la $a0, msg6
	li $v0, 4
	syscall
	
	# jal PrintNovaLinha
				
	move $t0, $s3
	add $t0, $t0, $s2
										
	la $t1, matrizColorCenario
	addi $t1, $t1, 1036
	add $t1, $t1, $s2
	
	# inicia o contador i = 0
	addi $t2, $zero, 0
		
	loop_4: 
		# inicia o contador j = 0
		addi $t3, $zero, 0
				
		loop_3:
			
			lw $t4, 0($t1)					
			sw $t4, 0($t0)
						 
			# pula para a proxima coluna no display (proximo elemento no vetor)
			addi $t0, $t0, 4
			addi $t1, $t1, 4
					
			# j = j + 1
			addi $t3, $t3, 1
			
			# Se j = 12, sai do loop
			beq $t3, 12, exit_3
			j loop_3
		exit_3:
		
		# pula para a proxima linha no display
		addi $t0, $t0, 208
		addi $t1, $t1, 208
		
		# i = i + 1
		addi $t2, $t2, 1
		
		# Se i = 12, sai do loop
		beq $t2, 12, exit_4
		j loop_4
	exit_4:
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 20
															
	jr $ra

endDeletaPeca:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# DeletaPeca                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# MesclarPecaTela               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
								
MesclarPecaTela:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -36
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	
	# la $a0, msg6
	# li $v0, 4
	# syscall
	# jal PrintNovaLinha
	
	# alinha o endereco para a posicao inicial da peca
	la $t0, matrizNumberCenario
	addi $t0, $t0, 2988
	addi $t0, $t0, 288
	addi $t0, $t0, 1036
	add $t0, $t0, $s5
	
	# alinha o endereco para a posicao inicial da peca							
	la $t1, matrizColorCenario
	addi $t1, $t1, 1036
	add $t1, $t1, $s2
	
	la $t2, matrizNumberPeca
	la $t3, matrizColorPeca
		
	# inicia o contador i = 0
	addi $t4, $zero, 0
		
	loop_8: 
		# inicia o contador j = 0
		addi $t5, $zero, 0
				
		loop_7:
			
			# carrega da peca e armazena na tela
			lw $t6, 0($t2)
			if_1_14:
				beqz $t6, endif_1_14
				lw $t7, 0($t3)				
				sw $t6, 0($t0)
				sw $t7, 0($t1)
			endif_1_14:
						 
			# pula para a proxima coluna (...)
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			addi $t2, $t2, 4
			addi $t3, $t3, 4
					
			# j = j + 1
			addi $t5, $t5, 1
			
			# Se j = 12, sai do loop
			beq $t5, 12, exit_7
			j loop_7
		exit_7:
		
		# pula para a proxima linha (...)
		addi $t0, $t0, 280
		addi $t1, $t1, 208
		
		# i = i + 1
		addi $t4, $t4, 1
		
		# Se i = 12, sai do loop
		beq $t4, 12, exit_8
		j loop_8
	exit_8:
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t7, 32($sp)
	lw $t6, 28($sp)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 36
															
	jr $ra

endMesclarPecaTela:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# MesclarPecaTela               XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# VerificaExplosao       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------

VerificaExplosao:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -4
	sw $t9, 0($sp)
	# sw $t0, 0($sp)
	# sw $t1, 4($sp)
	# sw $t2, 8($sp)
	# sw $t3, 12($sp)
	# sw $t4, 16($sp)
	# sw $t5, 20($sp)
	# sw $t6, 24($sp)
	# sw $t7, 28($sp)
	# sw $t8, 32($sp)
	
	# pilha extra (...)
	la $t9, PilhaExtra4
	sw $t0, 0($t9)
	sw $t1, 4($t9)
	sw $t2, 8($t9)
	sw $t3, 12($t9)
	sw $t4, 16($t9)
	sw $t5, 20($t9)
	sw $t6, 24($t9)
	sw $t7, 28($t9) 
	sw $t8, 32($t9)   
	
	la $t0, matrizNumberCenario
	addi $t0, $t0, 22024
	
	la $t1, ListadeLinhas
	
	move $t6, $zero
	move $t7, $zero
	move $t8, $zero
	
	# inicia o contador i = 0
	addi $t2, $zero, 0
			
	loop_2_28: 
		# inicia o contador j = 0
		addi $t3, $zero, 0
					
		loop_1_28:
			
			lw $t4, 0($t0)					
			add $t6, $t6, $t4
			
			# pula para a proxima coluna no display (proximo elemento no vetor)
			addi $t0, $t0, 12
			
			# j = j + 1
			addi $t3, $t3, 1
				
			# Se j = 10, sai do loop
			beq $t3, 10, exit_1_28
			j loop_1_28
		exit_1_28:
		
		if_1_28:
			beq $t6, 10, case_1_28
			else_1_28:
				
				la $a0, msg12
				li $v0, 4
				syscall
				
				move $t8, $zero
				sw $t8, 0($t1)
				j endif_1_28
			case_1_28:
				
				la $a0, msg13
				li $v0, 4
				syscall
				
				addi $t7, $t7, 1
				addi $t8, $zero, 1
				sw $t8, 0($t1) 
		endif_1_28:
		
		move $t6, $zero
	
		# pula para a proxima linha no display
		subi $t0, $t0, 1104
		add $t1, $t1, 4
		
		# i = i + 1
		addi $t2, $t2, 1
		
		# Se i = 19, sai do loop
		beq $t2, 19, exit_2_28
		j loop_2_28
	exit_2_28:
	
	# retorno da funcao:
	move $v0, $t7	
	
	# retorno da funcao:
	# move $v1, $t8
	
	# pilha extra (...)
    	la $t9, PilhaExtra4
	lw $t8, 32($t9)    	
	lw $t7, 28($t9)    	
	lw $t6, 24($t9)
	lw $t5, 20($t9)
	lw $t4, 16($t9)
	lw $t3, 12($t9)
	lw $t2, 8($t9)
	lw $t1, 4($t9)
	lw $t0, 0($t9)  
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	# lw $t8, 32($sp)
	# lw $t7, 28($sp)
	# lw $t6, 24($sp)
	# lw $t5, 20($sp)	
	# lw $t4, 16($sp)
	# lw $t3, 12($sp)
	# lw $t2, 8($sp)
	# lw $t1, 4($sp)
	# lw $t0, 0($sp)
	lw $t9, 0($sp)
	addiu $sp, $sp, 4
															
	jr $ra

endVerificaExplosao:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# VerificaExplosao              XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# Explodir                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
								
Explodir:
	
	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -44
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $t8, 36($sp)
	sw $t9, 40($sp)
	
	# alinha o endereco para a posicao inicial da peca
	la $t0, matrizNumberCenario
	addi $t0, $t0, 22024
	
	# alinha o endereco para a posicao inicial da peca							
	la $t1, matrizColorCenario
	addi $t1, $t1, 14860
	
	move $t2, $t0
	move $t3, $t1
	
	la $t4, ListadeLinhas
		
	# inicia o contador k = 0
	addi $t5, $zero, 0
		
	loop_3_35: 
		
		# carrega da peca e armazena na tela
		lw $t6, 0($t4)
		
		if_1_35:
			beqz $t6, case_1_35
			
			elseif_1_35:
			
				la $a0, msg14
				li $v0, 4
				syscall
				
				subi $t2, $t2, 984
				subi $t3, $t3, 768
				j endif_1_35
			case_1_35:
			
				la $a0, msg15
				li $v0, 4
				syscall
				
				# inicia o contador i = 0
				addi $t7, $zero, 0
				
				loop_2_35:
					
					# inicia o contador j = 0
					addi $t8, $zero, 0
					
					loop_1_35:
						
						lw $t9, 0($t2)
						sw $t9, 0($t0)
						
						lw $t9, 0($t3)
						sw $t9, 0($t1)
						
						# pula para a proxima coluna (...)
						addi $t0, $t0, 4
						addi $t1, $t1, 4
						addi $t2, $t2, 4
						addi $t3, $t3, 4												
						
						# j = j + 1
						addi $t8, $t8, 1
		
						# Se j = 30, sai do loop
						beq $t8, 30, exit_1_35
						j loop_1_35	
											
					exit_1_35:
					
					# pula para a proxima coluna (...)
					addi $t0, $t0, 208
					addi $t1, $t1, 136
					addi $t2, $t2, 208
					addi $t3, $t3, 136
					
					# i = i + 1
					addi $t7, $t7, 1
		
					# Se i = 3, sai do loop
					beq $t7, 3, exit_2_35
					j loop_2_35	
					
				exit_2_35:
				
				subi $t0, $t0, 1968
				subi $t1, $t1, 1536
				subi $t2, $t2, 1968
				subi $t3, $t3, 1536
					
		endif_1_35:
		
		addi $t4, $t4, 4
		
		# k = k + 1
		addi $t5, $t5, 1
		
		# Se k = 19, sai do loop
		beq $t5, 19, exit_3_35
		j loop_3_35	
			
	exit_3_35:
	
	la $t4, ListadeLinhas
	
	# inicia o contador k = 0
	addi $t5, $zero, 0
	
	loop_6_35: 
		
		# carrega da peca e armazena na tela
		lw $t6, 0($t4)
		
		if_2_35:
			bnez $t6, case_2_35
			
			elseif_2_35:
				j endif_2_35
			case_2_35:
				
				# inicia o contador i = 0
				addi $t7, $zero, 0
				
				loop_5_35:
					
					# inicia o contador j = 0
					addi $t8, $zero, 0
					
					loop_4_35:
						
						# lw $t9, 0($t2)
						
						move $t9, $zero  
						sw $t9, 0($t0)
						
						# lw $t9, 0($t3)
						
						li $t9, 0xFFFFFF
						sw $t9, 0($t1)
						
						# pula para a proxima coluna (...)
						addi $t0, $t0, 4
						addi $t1, $t1, 4											
						
						# j = j + 1
						addi $t8, $t8, 1
		
						# Se j = 30, sai do loop
						beq $t8, 30, exit_4_35
						j loop_4_35	
											
					exit_4_35:
					
					# pula para a proxima coluna (...)
					addi $t0, $t0, 208
					addi $t1, $t1, 136
					
					# i = i + 1
					addi $t7, $t7, 1
		
					# Se i = 3, sai do loop
					beq $t7, 3, exit_5_35
					j loop_5_35	
					
				exit_5_35:
				
				subi $t0, $t0, 1968
				subi $t1, $t1, 1536
					
		endif_2_35:
		
		addi $t4, $t4, 4
		
		# k = k + 1
		addi $t5, $t5, 1
		
		# Se k = 19, sai do loop
		beq $t5, 19, exit_6_35
		j loop_6_35	
			
	exit_6_35:	
								
			
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	lw $t9, 40($sp)
	lw $t8, 36($sp)
	lw $t7, 32($sp)
	lw $t6, 28($sp)
	lw $t5, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 44
															
	jr $ra

endExplodir:
	
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Explodir                      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# VerificaMovimentoValido       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------

VerificaMovimentoValido:

	# Armazena na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	addiu $sp, $sp, -4
	sw $t9, 0($sp)
	# sw $t0, 0($sp)
	# sw $t1, 4($sp)
	# sw $t2, 8($sp)
	# sw $t3, 12($sp)
	# sw $t4, 16($sp)
	# sw $t5, 20($sp)
	# sw $t6, 24($sp)
	# sw $t7, 28($sp)
	# sw $t8, 32($sp)
	
	# pilha extra (...)
	la $t9, PilhaExtra2
	sw $t0, 0($t9)
	sw $t1, 4($t9)
	sw $t2, 8($t9)
	sw $t3, 12($t9)
	sw $t4, 16($t9)
	sw $t5, 20($t9)
	sw $t6, 24($t9)
	sw $t7, 28($t9) 
	sw $t8, 32($t9)   
	
	la $t0, matrizNumberCenario
	addi $t0, $t0, 2988
	addi $t0, $t0, 288
	addi $t0, $t0, 1036
	add $t0, $t0, $s6
	
	la $t1, matrizNumberPeca
	
	move $t6, $zero
	move $t7, $zero
	move $t8, $zero
	
	# inicia o contador i = 0
	addi $t2, $zero, 0
			
	loop_6: 
		# inicia o contador j = 0
		addi $t3, $zero, 0
					
		loop_5:
			
			lw $t4, 0($t0)					
			lw $t5, 0($t1)
			
			mul $t6, $t4, $t5  
			add $t7, $t7, $t6
			
			# pula para a proxima coluna no display (proximo elemento no vetor)
			addi $t0, $t0, 4
			addi $t1, $t1, 4	
			
			# j = j + 1
			addi $t3, $t3, 1
				
			# Se j = 12, sai do loop
			beq $t3, 12, exit_5
			j loop_5
		exit_5:
		
		# pula para a proxima linha no display
		addi $t0, $t0, 280
		add $t1, $t1, $zero
		
		# i = i + 1
		addi $t2, $t2, 1
		
		# Se i = 12, sai do loop
		beq $t2, 12, exit_6
		j loop_6
	exit_6:
	
	# retorno da funcao:
	move $v0, $t7	
	
	# retorno da funcao:
	# move $v1, $t8
	
	# pilha extra (...)
    	la $t9, PilhaExtra2
	lw $t8, 32($t9)    	
	lw $t7, 28($t9)    	
	lw $t6, 24($t9)
	lw $t5, 20($t9)
	lw $t4, 16($t9)
	lw $t3, 12($t9)
	lw $t2, 8($t9)
	lw $t1, 4($t9)
	lw $t0, 0($t9)  
	
	# Recupera na pilha os valores dos registradores temporarios
	# (valores antes da chamada da funcao)
	# lw $t8, 32($sp)
	# lw $t7, 28($sp)
	# lw $t6, 24($sp)
	# lw $t5, 20($sp)	
	# lw $t4, 16($sp)
	# lw $t3, 12($sp)
	# lw $t2, 8($sp)
	# lw $t1, 4($sp)
	# lw $t0, 0($sp)
	lw $t9, 0($sp)
	addiu $sp, $sp, 4
															
	jr $ra

endVerificaMovimentoValido:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# VerificaMovimentoValido       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# LerTeclado                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------

LerTeclado:
	
	# pilha (...)
	addiu $sp, $sp, -4
	sw $t0, 0($sp)
			
	# Carrega no registrador $t0 o conteudo contido no endereco 0xffff0000 
	lw $t0, 0xffff0000
	# Chama a pausa
	jal Sleep2
	# Verifica se o Teclado recebeu algo caracter novo
	# Se o teclado receber algum caracter entao o valor armazenado em 0xffff0000 sera diferente de zero.
	# Se o valor armazenado em 0xffff0000 for diferente de zero entao Atualiza Coordenada
	if_1_12:
		bne $t0, $zero, case_1_12
	else_1_12:
		jal AtualizaCoordenada2
		j endif_1_12
	case_1_12:
		jal AtualizaCoordenada1
	endif_1_12:
	
	# pilha (...)
	lw $t0, 0($sp)
	addiu $sp, $sp, 4
	
	# loop
	j LerTeclado

endLerTeclado:

#----------------------------------------------------------------------------------------------------------------------------------------------------	
#----------------------------------------------------------------------------------------------------------------------------------------------------
# LerTeclado                    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# Sleep                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------			
#----------------------------------------------------------------------------------------------------------------------------------------------------	

Sleep:
		    
	# Tempo para pausa (milissegundos)
	# Codigo syscall para pausa (32)
	li $a0, 10
	li $v0, 32
	syscall
	  
	jr $ra

endSleep:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Sleep                         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# Sleep2                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	

Sleep2:
		    
	# Tempo para pausa (milissegundos)
	# Codigo syscall para pausa (32)
	li $a0, 500
	li $v0, 32
	syscall
	  
	jr $ra
	
endSleep2:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Sleep2                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaCoordenada1           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------	
   
AtualizaCoordenada1:
	
	# pilha (...)
	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t9, 4($sp)
	
	# pilha extra (...)
	la $t9, PilhaExtra1
	sw $t0, 0($t9)
	sw $t1, 4($t9)
	sw $t2, 8($t9)
	sw $t3, 12($t9)
	sw $t4, 16($t9)
	sw $t5, 20($t9)
	sw $t6, 24($t9)
	sw $t7, 28($t9)
	sw $t8, 32($t9)  
	
	# armazena em t0 a string que representa a tecla pressionada
	lw $t0, 0xffff0004
	
	move $a0, $t0
	jal PrintTeclaPressionada
																																																																																																																																																																																																																																																																																																																																																																																			    
	li $t1, 'w'
	li $t2, 'a'
	li $t3, 's'
	li $t4, 'd'
	li $t5, 'p'
	    
	if_2:            
    		# beq $t0, 'w', case_1W
    		beq $t0, 'a', case_2A
    		# beq $t0, 's', case_3S
    		beq $t0, 'd', case_4D
    		beq $t0, 'p', case_5P
    		beq $t0, 'q', case_6Q
    		beq $t0, 'e', case_7E
    	case_0X:
    		j endif_2
    	case_1W:
    		subi $s4, $s4, 1536
    		subi $s6, $s6, 1968
    		j endif_2
    	case_2A:
    		subi $s4, $s4, 12
    		subi $s6, $s6, 12
    		j endif_2
    	case_3S:
    		addi $s4, $s4, 1536
    		addi $s6, $s6, 1968
    		j endif_2
    	case_4D:
    		addi $s4, $s4, 12
    		addi $s6, $s6, 12 		
    		j endif_2
    	case_5P:
    		move $s4, $zero
    		move $s6, $zero
    		j End
    	case_6Q:
    		jal LoadBackUpPeca
    		jal RotacionarPecaAH
    		move $a0, $v0
    		
    		# move $a0, $s4
		# li $v0, 1
		# syscall
    		
		jal BuildAddressPeca
		move $a0, $v0
		jal LoadPecaDireto
		j endif_2
	case_7E:
    		jal LoadBackUpPeca
    		jal RotacionarPecaH
    		move $a0, $v0
    		
    		# move $a0, $s4
		# li $v0, 1
		# syscall
    		
		jal BuildAddressPeca
		move $a0, $v0
		jal LoadPecaDireto	    		    	
    	endif_2:
    		
    	addi $s4, $s4, 768
    	addi $s6, $s6, 984 	
  
	jal VerificaMovimentoValido
	
#-----------------------------------------------------------------------------------	
	move $t6, $v0
	# move $t7, $v1
	
	# Print do resultado da verificacao
	la $a0, msg5
	li $v0, 4
	syscall
	
	move $a0, $t6
	li $v0, 1
	syscall
	
	jal PrintNovaLinha 
	
#-----------------------------------------------------------------------------------
   	
   	if_09:	beq $zero, $t6, case_09
		move $s4, $s2
		move $s6, $s5
		
		if_25:
			beq $t0, 'q', case_1_25
    			beq $t0, 'e', case_1_25
    			else_25:
    				j endif_25	
    			case_1_25:
    				jal LoadFromBackUp	
    		endif_25:
    			
		jal AtualizaCoordenada2
		
		j andif_09
	case_09:
		
		#------------------------------------------------------------------
		la $a0, msg4
		li $v0, 4
	    	syscall    	
		move $a0, $s2
		li $v0, 1
		syscall
		jal PrintNovaLinha
		la $a0, msg7
		li $v0, 4
	    	syscall  		
		move $a0, $s4
		li $v0, 1
		syscall
		jal PrintNovaLinha
		#------------------------------------------------------------------
		
		jal DeletaPeca
		move $s2, $s4
		move $s5, $s6
		jal PrintNovaLinha
		# jal drawblock
		jal DrawPeca
		
		#------------------------------------------------------------------
		la $a0, msg4
		li $v0, 4
	    	syscall    	
		move $a0, $s2
		li $v0, 1
		syscall
		jal PrintNovaLinha
		la $a0, msg7
		li $v0, 4
	    	syscall  		
		move $a0, $s4
		li $v0, 1
		syscall
		jal PrintNovaLinha
		#------------------------------------------------------------------

	andif_09:
    	
    	move $a0, $s2
	
    	  
 	# bgt $t6, $zero, End   
    	
    	# pilha extra (...)
    	la $t9, PilhaExtra1
	lw $t8, 24($t9)
	lw $t7, 24($t9)
	lw $t6, 24($t9)
	lw $t5, 20($t9)
	lw $t4, 16($t9)
	lw $t3, 12($t9)
	lw $t2, 8($t9)
	lw $t1, 4($t9)
	lw $t0, 0($t9)  
    	
    	# pilha (...)
	lw $t9, 4($sp)
	lw $ra, 0($sp)						
	addiu $sp, $sp, 8
    					
	jr $ra 
	# j LerTeclado
	
endAtualizaCoordenada1:

#----------------------------------------------------------------------------------------------------------------------------------------------------   
#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaCoordenada1           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaCoordenada2           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------    

AtualizaCoordenada2:
	
	# pilha (...)
	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t7, 4($sp)
	
	# pilha extra (...)
	la $t7, PilhaExtra3
	sw $t0, 0($t7)
	sw $t6, 4($t7)
	sw $t1, 8($t7) 
	sw $t2, 12($t7)  
																																																				
	# armazena em t0 a string que representa que nenhuma tecla foi pressionada
	li $t0, ' '
	
	move $a0, $t0
	jal PrintTeclaPressionada
	    
    	addi $s4, $s4, 768
    	addi $s6, $s6, 984
  
	jal VerificaMovimentoValido

#-----------------------------------------------------------------------------------	
	move $t6, $v0
	# move $t1, $v1
	
	# Print do resultado da verificacao
	la $a0, msg5
	li $v0, 4
	syscall
	
	move $a0, $t6
	li $v0, 1
	syscall
	
	jal PrintNovaLinha 
	
#-----------------------------------------------------------------------------------
   	
   	if_10:	beq $zero, $t6, case_10
		move $s4, $s2
		move $s6, $s5
		
		la $a0, msg10
		li $v0, 4
		syscall
		
		j endif_10
	case_10:
		la $a0, msg4
		li $v0, 4
	    	syscall    	
		move $a0, $s2
		li $v0, 1
		syscall
		jal PrintNovaLinha
		la $a0, msg7
		li $v0, 4
	    	syscall  		
		move $a0, $s4
		li $v0, 1
		syscall
		jal PrintNovaLinha
		
		jal DeletaPeca
		move $s2, $s4
		move $s5, $s6
		jal PrintNovaLinha
		# jal drawblock
		jal DrawPeca
		
		la $a0, msg4
		li $v0, 4
	    	syscall    	
		move $a0, $s2
		li $v0, 1
		syscall
		jal PrintNovaLinha
		la $a0, msg7
		li $v0, 4
	    	syscall  		
		move $a0, $s4
		li $v0, 1
		syscall
		jal PrintNovaLinha

	endif_10:
    	
    	move $a0, $s2  
    	
    	if_1_13:
    		bgt $t6, $zero, case_1_13   
    	else_1_13:
    		j endif_1_13
    	case_1_13:
    		jal MesclarPecaTela
    		jal VerificaExplosao
    		if_2_13:
    			bnez $v0, case_2_13 
    			else_2_13:
    				j endif_2_13
    			case_2_13:
    				move $t2, $v0
    				la $a0, msg11
				li $v0, 4
				syscall
    				jal Explodir
    				jal AtualizaTela
    				move $a0, $t2
    				jal AtualizaPontuacao
    		endif_2_13:
    		j Main_Loop
    	endif_1_13:
    	
    	# pilha extra (...)
    	la $t7, PilhaExtra3
	lw $t2, 12($t7)
	lw $t1, 8($t7)
	lw $t6, 4($t7)
	lw $t0, 0($t7)  
    	
    	# pilha (...)
	lw $t7, 4($sp)
	lw $ra, 0($sp)						
	addiu $sp, $sp, 8
    					
	jr $ra 
	# j LerTeclado
	
endAtualizaCoordenada2:

#----------------------------------------------------------------------------------------------------------------------------------------------------  
#----------------------------------------------------------------------------------------------------------------------------------------------------
# AtualizaCoordenada2           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
# PrintNovaLinha                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------  

# Imprime nova linha no RUN I/O
PrintNovaLinha:      
    
    la $a0, msg1
    li $v0, 4
    syscall

    jr $ra
    
endPrintNovaLinha:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# PrintNovaLinha                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------------------------------------------------------------------
# PrintTeclaPressionada         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------  

# Imprime a tecla pressionada pelo usuario RUN I/O
PrintTeclaPressionada:
        
        # pilha (...)
	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t0, 4($sp)
    	
    	move $t0, $a0
    	
    	la $a0, msg3
	li $v0, 4
	syscall
	    
	move $a0, $t0
	li $v0, 11
	syscall
	
	la $a0, msg1
    	li $v0, 4
    	syscall
	
	# pilha (...)
	lw $t0, 4($sp)
	lw $ra, 0($sp)						
	addiu $sp, $sp, 8
	
	jr $ra
    
endPrintTeclaPressionada:

#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# PrintTeclaPressionada         XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
# Main                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
    
Main: 
		jal set_tela
		jal set_cores
		jal LoadAddressPecas
		jal InicializaMatrizNumberCenario
		jal LoadTelaInicial
		jal LoadNumeros
		# jal DrawGameOver
		li $a0, 1
		jal AtualizaPontuacao
		jal RandomSelectPeca 
		move $a0, $v0
		jal BuildAddressPeca
		move $a0, $v0
		jal LoadInPreview
		jal DrawInPreview
	Main_Loop:	
		jal set_tela
		jal LoadPecaIndireto
		jal RandomSelectPeca 
		move $a0, $v0
		jal BuildAddressPeca
		move $a0, $v0
		jal LoadInPreview
		jal DrawInPreview
		jal RandomPosicaoInicialPeca
		
		jal VerificaMovimentoValido
		#-----------------------------------------------------------------------------------	
		move $t6, $v0
			
		# Print do resultado da verificacao
		la $a0, msg5
		li $v0, 4
		syscall
		
		move $a0, $t6
		li $v0, 1
		syscall
		
		jal PrintNovaLinha 
	
		#-----------------------------------------------------------------------------------
		if_08:	beq $zero, $t6, case_08
			jal DrawGameOver
			j End
		case_08:
			jal DrawPeca
		andif_08:
			
		jal LerTeclado

endMain:
		
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Main                          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------------------------------
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
# Indica que o programa chegou no final da execucao
End:
		
    la $a0, msg2
    li $v0, 4
    syscall
#----------------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------------
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#----------------------------------------------------------------------------------------------------------------------------------------------------
