; Empleando dos puertos paralelos del microcontrolador PIC, uno de ellos configurado
; como entrada y el otro como salida; realizar un programa que de acuerdo al valor del bit
; menos significativo del puerto A, se genere la acción indicada en el puerto B.
;	Valor PA0  | Acción puerto B
; -------------------------------
;		0 	   |	00000000
;		1 	   |	11111111
	processor 16f877
	include <p16f877.inc>

	org 0
	goto INICIO
	org 5

INICIO:
	clrf PORTA		
	bsf STATUS,RP0	; CAMBIAMOS AL BANCO 1
	bcf STATUS,RP1
	clrf PORTB

	movlw 06h
	movwf ADCON1	; PUERTO A CONFIGURADOPCOMO ENTRADA
	movlw 3fh		
	movwf TRISA
	bcf STATUS,RP0
CICLO:
	btfsc PORTA,0
	goto ENC
	movlw h'00'
	movwf PORTB
	goto CICLO
ENC:
	movlw h'ff'
	movwf PORTB
	goto CICLO
	end
