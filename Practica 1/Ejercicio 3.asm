; Realice un programa que ejecute la siguiente secuencia, misma que deber� ver en la
; direcci�n de memoria de su elecci�n.
; Secuencia:
;	#$01  #$02  #$04  #$08  #$10  #$20  #$40  #$80
	processor 16f877
	include <p16f877.inc>

K equ H'26'

	org 0
	goto inicio
	org 5
inicio:
	MOVLW H'1'		;Carga el primer valor de la secuencia
	MOVWF K
recorre:
	RLF	K,1
	BTFSC K,7		;Checa si se ha llegado al valor m�ximo
	GOTO inicio		;Vuelve al valor inicial
	GOTO recorre	;Ccontinua con la secuencia
	end