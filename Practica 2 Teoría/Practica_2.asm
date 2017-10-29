; Por medio del sistema mínimo construido previamente para esta clase, mostrar en dos displays de 7
; segmentos el voltaje leído de un potenciómetro conectado a algún bit del puerto A del PIC.
; Se va a llegar un punto en el que la lectura de los displays sea igual a la clave del equipo
; proporcionada por el profesor previamente.
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

	movlw	H'6E'			; CLAVE DE EQUIPO
	movwf	clave
;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONVERTIDOR;;;;;;;;;;;;;;;;;;;;;;;;;;;
LOOP2:	
	bsf		ADCON0,2		; INICIA LA CONVERSION COLOCANDO '1' A LA BANDERA GO/DONE
	call	retardo

LOOP:	
	btfss	ADCON0,2
	goto	LOOP
	movf	ADRESH,W		; OBTENEMOS EL RESULTADO
	subwf	clave,W
	btfsc	STATUS,C
	goto	Continua
	goto	Limite

Continua:
	movf	ADRESH,W
	movwf	resu
	goto 	Disp1	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Disp1:
	CLRF	PORTD
	BSF		PORTD,0			; ACTIVA DISPLAY 1
	MOVF	resu,W
	andlw	H'0F'			; ENMASCARADO DE NIBLE BAJO PARA EVITAR DESBORDAMIENTOS
	call	Tabla
	MOVWF	comp
	comf	comp,W
	MOVWF	PORTB
	CALL	retardo2
	BCF		PORTD,0			; DESACTIVA DISPLAY 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Disp2:
	CLRF	PORTD	
	BSF		PORTD,1			; ACTIVA DISPLAY 2
	MOVF	resu,W
	andlw	H'F0'			; ENMASCARADO DE NIBLE ALTO PARA EVITAR DESBORDAMIENTOS
	MOVWF	Nibble
	SWAPF	Nibble
	MOVF	Nibble,W
	call	Tabla
	MOVWF	comp
	comf	comp,W
	MOVWF	PORTB
	CALL 	retardo2
	CLRF	PORTD			; DESACTIVA DISPLAY 2
	GOTO 	LOOP2

Limite:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CLRF	PORTD
	BSF		PORTD,0			; ACTIVA DISPLAY 1
	movlw	B'10000110'		; E
	MOVWF	comp
	comf	comp,W
	MOVWF	PORTB
	call 	retardo2	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CLRF	PORTD
	BSF		PORTD,1			; ACTIVA DISPLAY 1
	movlw	B'10000010'		; 6
	MOVWF	comp
	comf	comp,W
	MOVWF	PORTB
	call 	retardo2
	goto 	LOOP2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;RETARDO 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo
	movlw cte1
	movwf valor1
tres
	decfsz valor1
	goto tres
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;RETARDO 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo2 
	movlw cte2
	movwf valor2
tres2
	decfsz valor2
	goto tres2
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TABLA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Tabla:
	addwf	PCL,1
			; hgfedcba
	retlw	B'11000000'		;H'00'
	retlw	B'11111001'		;H'01'
	retlw	B'10100100'		;H'02'
	retlw	B'10110000'		;H'03'
	retlw	B'10011001'		;H'04'
	retlw	B'10010010'		;H'05'
	retlw	B'10000010'		;H'06'
	retlw	B'11111000'		;H'07'
	retlw	B'10000000'		;H'08'
	retlw	B'10010000'		;H'09'
	retlw	B'10001000'		;H'0A'
	retlw	B'10000011'		;H'0B'
	retlw	B'11000110'		;H'0C'
	retlw	B'10100001'		;H'0D'
	retlw	B'10000110'		;H'0E'
	retlw	B'10001110'		;H'0F'

	return

	end