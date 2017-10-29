; Realizar un programa que muestre la siguiente secuencia en el puerto B con retardos de
; ½ segundo.
; Secuencia:
;	#$80  #$40  #$20  #$10  #$08  #$04  #$02  #$01
	processor 16f877
	include<p16f877.inc>

valor1 	equ h'21'
valor2 	equ h'22'
valor3 	equ h'23'
cte1 	equ 40h
cte2 	equ 50h
cte3 	equ 60h

	org	0
	goto inicio
	org	5
inicio:
	 	bsf		STATUS,5
		bcf		STATUS,6
		movlw	h'0'
		movwf	TRISB
		bcf		STATUS,5
		clrf	PORTB
loop	
		movlw	h'80'		
		movwf 	h'20'
corrimiento	
		movfw h'20'
		movwf PORTB
		rrf h'20',1
		call retardo
		btfss h'20',-1
		goto corrimiento
		goto loop

retardo
		movlw 	cte1
		movwf 	valor1
tres
	 	movlw 	cte2
		movwf 	valor2
dos 	
		movlw 	cte3
		movwf 	valor3
uno 	
		decfsz 	valor3
		goto 	uno
		decfsz 	valor2
		goto 	dos
		decfsz 	valor1
		goto 	tres
		return
		end
