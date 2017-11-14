; Realizar un programa que muestre las vocales (mayúsculas y minúsculas en un
; display de 7 segmentos, las cuales serán enviadas vía serie a través del
; teclado de la PC.

	processor 16f877
	include <p16f877.inc>

	org 	0H
	goto 	inicio
	org 	05H

valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 20h					; PRIMER CONTADOR
cte2 equ 50h					; SEGUNDO CONTADOR
cte3 equ 60h					; TERCER CONTADOR

inicio
	bsf		STATUS,RP0
	BCF		STATUS,RP1

	MOVLW 	00H 				; Configura puertos A y E como digitales
	MOVWF 	ADCON1	
	MOVLW 	3FH 				; Configura el puerto A como entrada
	MOVWF 	TRISA
	movlw	h'00'
	movwf	TRISB		

	BSF		TXSTA,BRGH
	MOVLW	D'129'				; 9600 BOUDS
	MOVWF	SPBRG
	BCF		TXSTA,SYNC
	BSF		TXSTA,TXEN
	BCF		STATUS,RP0
	BSF		RCSTA,SPEN
	BSF		RCSTA,CREN
RECIBE
	BTFSS	PIR1,RCIF
	GOTO	RECIBE
	MOVF	RCREG,W
	MOVWF	TXREG
	BSF		STATUS,RP0
TRANSMITE
	BTFSS	TXSTA,TRMT
	GOTO	TRANSMITE
	BCF		STATUS,RP0
	MOVF	TXREG,W
;;;;;;;;;;;;;;;;;;SELECCION;;;;;;;;;;;;;;;;;;
LETRAA							; CODIGO ASCII
	SUBLW	H'41'				; 65
	BTFSS	STATUS,Z
	GOTO	LETRAE	
	MOVLW	H'00'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAE
	SUBLW	H'45'				; 69
	BTFSS	STATUS,Z
	GOTO	LETRAI	
	MOVLW	H'01'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAI
	SUBLW	H'49'				; 73
	BTFSS	STATUS,Z
	GOTO	LETRAO	
	MOVLW	H'02'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAO
	SUBLW	H'4F'				; 79
	BTFSS	STATUS,Z
	GOTO	LETRAU	
	MOVLW	H'03'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAU
	SUBLW	H'55'				; 85
	BTFSS	STATUS,Z
	GOTO	LETRAa	
	MOVLW	H'04'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAa
	SUBLW	H'61'				; 97
	BTFSS	STATUS,Z
	GOTO	LETRAe	
	MOVLW	H'05'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAe
	SUBLW	H'65'				; 101
	BTFSS	STATUS,Z
	GOTO	LETRAi	
	MOVLW	H'06'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAi
	SUBLW	H'69'				; 105
	BTFSS	STATUS,Z
	GOTO	LETRAo	
	MOVLW	H'07'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAo
	SUBLW	H'6F'				; 111
	BTFSS	STATUS,Z
	GOTO	LETRAu	
	MOVLW	H'08'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE

LETRAu
	SUBLW	H'75'				; 117
	BTFSS	STATUS,Z
	GOTO	RECIBE	
	MOVLW	H'09'
	CALL	TABLA
	MOVWF	PORTB
	GOTO	RECIBE
TABLA
	ADDWF	PCL,1
			;'hgfedcba
	retlw	B'01110111'	;H'0A'
	retlw	B'01111001'	;H'0E'
	retlw	B'00000110'	;H'01'
	retlw	B'00111111'	;H'0O'
	retlw	B'00111110'	;H'0U'

	retlw	B'11011100'	;H'0a'
	retlw	B'01111011' ;H'0e'
	retlw	B'00000100'	;H'01'
	retlw	B'01011100' ;H'0o'
	retlw	B'00011100' ;H'0u'

	end
