; Empleando el canal de su elección del convertido A/D, realizar un programa en el cuál,
; de acuerdo a una entrada analógica que se ingrese por este canal, se represente el
; resultado de la conversión en un puerto paralelo utilizar el arreglo de leds para ver
; la salida.
	processor 16f877
	include <p16f877.inc>

	org 	0
	goto 	inicio
	org 	5

valor1 	equ h'21'
cte1 	equ h'06'		; PRIMER CONTADOR

valor2 	equ h'34'		; SEGUNDO CONTADOR
cte2 	equ h'ff'

comp	equ H'22'
clave	equ H'23'  		; CLAVE DE EQUIPO "6E"
resu	equ H'24'
Nibble	equ	H'26' 		; AUX PARA SWAP
CON		equ H'25'
		
inicio: 
	clrf 	PORTA
	clrf 	PORTE
	bsf 	STATUS,RP0 		; CAMBIAMOS AL BANCO 1
	bcf 	STATUS,RP1

	movlw 	H'00' 			; PUERTOS "A" Y "B" COMO DIGITALES
	movwf 	ADCON1
	clrf	TRISB
	clrf	TRISD 			; PUERTO "C" COMO SALIDA (CONTROL DE LOS DISPLAYS)
	bcf 	STATUS,RP0 		; REGRESA AL BANCO 0

	clrf	resu
	movlw	B'11000001'		; CONFIGURA EL REGISTRO ADCON0
	movwf	ADCON0	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONVERTIDOR;;;;;;;;;;;;;;;;;;;;;;;;;;;
LOOP2:	
	bsf		ADCON0,2		; INICIA LA CONVERSION COLOCANDO '1' A LA BANDERA GO/DONE
	call	retardo

LOOP:	
	btfss	ADCON0,2
	goto	LOOP
	movf	ADRESH,W		; OBTENEMOS EL RESULTADO

Continua:
	movf	ADRESH,W
	movwf	resu
	goto 	Disp1	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Disp1:
	CLRF	PORTD
	MOVF	resu,W
	MOVWF	PORTB
	CALL	retardo2
	goto	LOOP2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;RETARDO 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo
	movlw cte1
	movwf valor1
tres
	decfsz valor1
	goto tres
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;RETARDO 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo2 
	movlw cte2
	movwf valor2
tres2
	decfsz valor2
	goto tres2
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TABLA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Tabla:
	addwf	PCL,1
			; hgfedcba
	retlw	B'00000000'
	retlw	B'00000001'
	retlw	B'00000011'
	retlw	B'00000111'
	retlw	B'00001111'
	retlw	B'00011111'
	retlw	B'00111111'
	retlw	B'01111111'
	retlw	B'11111111'

	return

end
