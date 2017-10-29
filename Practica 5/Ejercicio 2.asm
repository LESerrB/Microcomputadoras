; Realizar un programa, de tal forma que indique cual sensor refleja la luz infla-roja
; mediante el equivalente despliegue al puerto B, representado mediante la siguiente tabla.
; Tomar en cuenta que cuando es detectado el reflejo, el microcontrolador recibe un ‘1’.
; 			 ENTRADAS 		  |		SALIDAS
; ---------------------------------------------------
;  Sensor   | Sensor | Sensor |
; Izquierdo | Central| Derecho|
; ---------------------------------------------------
; 	PA2		|	PA1  |  PA0   |	PB3 | PB2 | PB1 | PB0
; ---------------------------------------------------
; 	 N 		|    N	 |   N 	  |  0  |  0  |  0  |  0
;    N      |    N   |   B    |  0  |  0  |  0  |  1
;    N      |    B   |   N    |  0  |  0  |  1  |  0
; 	 N      |    B   |   B    |  0  |  0  |  1  |  1
; 	 B      |    N   |   N    |  0  |  1  |  0  |  0
;  	 B      |    N   |   B    |  0  |  1  |  0  |  1
;  	 B      |    B   |   N    |  0  |  1  |  1  |  0
;  	 B      |    B   |   B    |  0  |  1  |  1  |  1
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
	btfss	PORTA,2
	goto	select1		;0(0xx)
	goto	select3		;1(1xx)

select1
	btfss	PORTA,1
	goto	select2		;0(xx0)
	goto	select6		;1(xx0)

select2 
	btfss	PORTA,0
	goto	CERO		;0(xx0)
	goto	UNO			;1(xx0)

select3	
	btfss	PORTA,1
	goto	select4		;0(xx0)
	goto	select5		;1(xx0)

select4	
	btfss	PORTA,0
	goto	CUATRO		;0(xx0)
	goto	CINCO		;1(xx0)

select5	
	btfss	PORTA,0
	goto	SEIS		;0(xx0)
	goto	SIETE		;1(xx0)

select6	
	btfss	PORTA,0
	goto	DOS			;0(xx0)
	goto	TRES		;1(xx0)

CERO:
	movlw	H'00'
	movwf	PORTB
	goto	select

UNO:
	movlw	B'00000001'
	movwf	PORTB
	goto	select

DOS:
	movlw	B'00000010'
	movwf	PORTB
	goto	select

TRES:
	movlw	B'00000011'
	movwf	PORTB
	goto	select

CUATRO:
	movlw	B'00000100'
	movwf	PORTB
	goto	select

CINCO:
	movlw	B'00000101'
	movwf	PORTB
	goto	select

SEIS:
	movlw	B'00000110'
	movwf	PORTB
	goto	select

SIETE:
	movlw	B'00000111'
	movwf	PORTB
	goto	select

	end
