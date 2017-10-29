; Considerando la información y los circuitos del ejercicio anterior, realizar un programa
; que de acuerdo a una señal de control ingresada por el puerto A, se genere la acción
; indicada en la tabla.
;	  DATO	  |	 	  ACCION
;------------------------------------
;	Puerto A  |	MOTOR M1 | MOTOR M2
;------------------------------------
;	  $00 	  |	  PARO   |  PARO
;	  $01 	  |	 DERECHA | DERECHA
;	  $02 	  |	IZQUIERDA|IZQUIERDA
;	  $03 	  |	 DERECHA |IZQUIERDA
;	  $04 	  |	IZQUIERDA| DERECHA
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
	btfss	PORTA,1
	goto	select1		;0
	goto	ROT_M2_D	;1

select1	
	btfss	PORTA,2
	goto	select2		;0
	goto	ROT_M2_I	;1

select2 
	btfss	PORTA,3
	goto	select3		;0
	goto	ROT_M1_D	;1

select3	
	btfss	PORTA,4
	goto	select4		;0
	goto	ROT_M1_I	;1

select4	
	btfsc	PORTA,0
	goto	select		;1
	goto	APAGADO		;0

APAGADO:
	movlw	H'00'
	movwf	PORTB
	goto	select
;ADELANTE
ROT_M2_D:
	movlw	H'0B'
	movwf	PORTB
	goto	select
;ATRAS
ROT_M2_I:
	movlw	H'0E'
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
