; Realizar un programa que de acuerdo a la entrada generada por los sensores, se controle
; la operación de los motores, tal como se muestra en la siguiente tabla.
; 		   ENTRADAS 	   |	ACCION
; ---------------------------------------------
;   Sensor |Sensor | Sensor|  MOTOR  |  MOTOR
; Izquierdo|Central|Derecho|IZQUIERDO| DERECHO
; --------------------------------------------- 
;     B    |   N   |   N   |  ATRÁS  | ADELANTE
;     N    |   B   |   N   | ADELANTE| ADELANTE
;     N    |   N   |   B   | ADELANTE|  ATRÁS
;     N    |   N   |   N   |  PARO   |  PARO
	processor 16f877
	include <p16f877.inc>

	org 0
	goto INICIO
	org 5

INICIO:
	clrf 	PORTA		
	bsf 	STATUS,RP0	; CAMBIAMOS AL BANCO 1
	bcf 	STATUS,RP1
	clrf 	PORTB

	movlw 	06h
	movwf 	ADCON1		; PUERTO A CONFIGURADO COMO ENTRADA
	movlw 	3fh		
	movwf 	TRISA
	bcf 	STATUS,RP0	; CAMBIAMOS AL BANCO 0

select
	btfss	PORTA,0
	goto	select1		;0
	goto	ROT_M2_D	;1	DERECHA

select1	
	btfss	PORTA,1
	goto	select2		;0
	goto	ROT_M2_I	;1	ADELANTE

select2 
	btfss	PORTA,3
	goto	select3		;0
	goto	ROT_M1_D	;1	IZQUIERDA

APAGADO:
	movlw	H'00'
	movwf	PORTB
	goto	select
;ADELANTE
ROT_M2_D:
	movlw	H'0B'
	movwf	PORTB
	goto	select
;IZQUIERDA
ROT_M1_D:
	movlw	H'0F'
	movwf	PORTB
	goto	select
;DERECHA
ROT_M1_I:
	movlw	H'0A'
	movwf	PORTB
	goto	select

	end
