; Realizar un programa, de manera que identifique cuál de tres señales
; analógicas que ingresan al convertidor A/D es mayor que las otras dos
; representar el resultado de acuerdo al contenido de la tabla.
; 		Señal	  | PB2 | PB1 |	PB0 
;-----------------------------------
; Ve1 > Ve2 & Ve3 |	 0 	|  0  |	 1 
; Ve2 > Ve1 & Ve3 |  0 	|  1  |	 1 
; Ve3 > Ve1 & Ve2 |	 1 	|  1  |	 1 

	processor 16f877
	include <p16f877.inc>

	org 	0H 
	goto 	inicio
	org 	05H

valor1	equ h'21'
cte1 	equ 6h					; PRIMER CONTADOR
AN0		EQU	H'22'
AN1		EQU	H'23'
AN2		EQU	H'24'

inicio:
	CLRF 	PORTA
	BSF 	STATUS,RP0
	BCF 	STATUS,RP1
	MOVLW 	00H 				; CONFIGURA PUERTOS "A" Y "E" COMO DIGITALES
	MOVWF 	ADCON1
	MOVLW 	3FH 				; CONFIGURA EL PUERTO "A" COMO ENTRADA
	MOVWF 	TRISA
	movlw	h'00'
	movwf	TRISB
	BCF 	STATUS,RP0
LOOP2
	MOVLW	B'11000001'
	CALL	LEER
	MOVWF	AN1
	MOVLW	B'11001001'
	CALL	LEER
	MOVWF	AN2
	MOVLW	B'11010001'
	CALL	LEER
	MOVWF	AN0
TEST0
	MOVF	AN1,0
	SUBWF	AN0,0			; W = AN0 - AN1
	BTFSS	STATUS,C		; SI HUBO CARRY, 'AN0' ES MAYOR
	GOTO	TEST1			; APAGADO: VAMOS A "TEST1"
	MOVF	AN2,W			; ENCENDIDO:	COMPARAMOS CON 'AN2'
	SUBWF	AN0,0			; W = AN0 - AN2
	BTFSS	STATUS,C		; SI HUBO CARRY, 'AN0' ES MAYOR
	GOTO	LED1
	GOTO	LED2			; NO HUBO CARRY 'AN2' ES MAYOR
TEST1
	MOVF	AN2,0
	SUBWF	AN1,0			; W = AN1 - AN2
	BTFSS	STATUS,C		; SI HUBO CARRY, 'AN1' ES MAYOR
	GOTO	LED1			; APAGADO:
	GOTO	LED0			; ENCENDIDO:

LED0
	MOVLW	B'1'			; BANDERA 'C' ABAJO: ENCENDEMOS 1 LED
	MOVWF	PORTB
	GOTO	LOOP2
	
LED1
	MOVLW	B'11'			; BANDERA 'C' ABAJO: ENCENDEMOS 1 LED
	MOVWF	PORTB
	GOTO	LOOP2

LED2
	MOVLW	B'111'			; BANDERA 'C' ABAJO: ENCENDEMOS 1 LED
	MOVWF	PORTB
	GOTO	LOOP2
;;;;;;;;;;;;;;;;;;;;;;SUBRUTINA PARA LEER LA ENTRADA;;;;;;;;;;;;;;;;;;;;;;
LEER
	MOVWF	ADCON0
	BSF		ADCON0,2			; INICIA LA CONVERSION COLOCANDO '1' A LA BANDERA GO/DONE
	CALL	retardo
LOOP
	BTFSC	ADCON0,2
	GOTO	LOOP
	MOVF	ADRESH,W		; OBTENEMOS EL RESULTADO
	RETURN
;;;;;;;;;;;;;;;;;;;;;;;;;;;SUBRUTINA DE RETARDO;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo
	movlw cte1				; INICIAMOS EL PRIMER CONTADOR
	movwf valor1
tres
	decfsz valor1			; DECREMENTAMOS EL 1ER CONTADOR
	goto tres				; MIENTRAS NO SEA CERO SEGUIMOS DECREMENTANDO
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;TERMINA RUTINA RETARDO;;;;;;;;;;;;;;;;;;;;;;;;;;
	end
