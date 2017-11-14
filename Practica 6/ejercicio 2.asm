; Utilizando el circuito anterior, realizar un programa que indique si el valor del voltaje a
; la entrada del convertidor A/D, se encuentra entre los siguientes rangos de voltaje.
; 	    ENTRADAS   	  |		SALIDAS
; ---------------------------------------
; 			   		  |	PX2 | PX1 | PX0
; ---------------------------------------
; Ve < 1/3 Vcc 		  |  0  |  0  |  1
; 1/3Vcc < Ve <2/3Vcc |  0  |  1  |  1
; 2/3 < Ve < Vcc 	  |  1  |  1  |  1
	processor 16f877
	include <p16f877.inc>

	org 	0H
	goto 	inicio
	org 	05H

valor1 equ h'21'			; PRIMER CONTADOR
cte1 equ 6h		

inicio:
	CLRF 	PORTA
	CLRF 	PORTE
	BSF 	STATUS,RP0
	BCF 	STATUS,RP1
	MOVLW 	00H 			; CONFIGURA PUERTOS "A" Y "E" COMO DIGITALES
	MOVWF 	ADCON1
	MOVLW 	3FH 			; CONFIGURA EL PUERTO "A" COMO ENTRADA
	MOVWF 	TRISA
	movlw	h'00'
	movwf	TRISB
	BCF 	STATUS,RP0 
	MOVLW	B'11000001'
	MOVWF	ADCON0
LOOP2
	BSF		ADCON0,2		; INICIA LA CONVERSION COLOCANDO '1' A LA BANDERA GO/DONE
	CALL	retardo
LOOP
	BTFSC	ADCON0,2
	GOTO	LOOP
	MOVF	ADRESH,W		; OBTENEMOS EL RESULTADO

		
	SUBLW	H'07'
	BTFSC	STATUS,C
	GOTO	UNOX
	MOVF	ADRESH,W
	SUBLW	H'7F'
	BTFSC	STATUS,C
	GOTO	DOSX
	GOTO	TRESX


UNOX
	MOVLW	H'01'
	MOVWF	PORTB
	GOTO	LOOP2

DOSX
	MOVLW	H'03'
	MOVWF	PORTB
	GOTO	LOOP2

TRESX
	MOVLW	H'07'
	MOVWF	PORTB
	GOTO	LOOP2
	GOTO 	LOOP2				

;;;;;;;;;;;;;;;;;;;;;;;;;;;SUBRUTINA DE RETARDO;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo 		movlw cte1
		movwf valor1
tres	
	decfsz valor1
	goto tres
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;TERMINA RUTINA RETARDO;;;;;;;;;;;;;;;;;;;;;;;;;;

	end
