; De acuerdo a la asignación de la tarjeta del driver de motores realizar un programa, el
; cual permita controlar el funcionamiento y sentido de giro de cada uno de ellos por
; separado, a través del puerto paralelo A, el puerto B deberá mandar las señales al driver,
; como se indica en la tabla.
;	Entrada binaria|	 Motores     | Sentido de giro
;	--------------------------------------------------
;		PuertoA    |Izquierdo|Derecho|   Puerto B
;	--------------------------------------------------
;		000000 	   |  OFF	 |	OFF	 |		Paro
;		000010 	   |  OFF	 |	ON	 |	   Horario
;		000100 	   |  OFF	 |	ON	 |	 Antihorario
;		001000 	   |  ON 	 |	OFF	 |	   Horario
;		010000 	   |  ON 	 |	OFF	 |	 Antihorario
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

ROT_M2_D:
	movlw	H'03'
	movwf	PORTB
	goto	select

ROT_M2_I:
	movlw	H'02'
	movwf	PORTB
	goto	select

ROT_M1_D:
	movlw	H'09'
	movwf	PORTB
	goto	select

ROT_M1_I:
	movlw	H'0C'
	movwf	PORTB
	goto	select

	end
