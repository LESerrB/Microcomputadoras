; Realizar un programa, el cuál realice las siguientes acciones de control, para lo cuál
; requiere trabajar un puerto de entrada y otro puerto de salida, usar los sugeridos en el
; ejercicio anterior; generar retardos de ½ seg., en las secuencias que lo requieran.
;	DATO  |		      ACCION 			  | Ejecución
;-----------------------------------------------------
;	$00   |	Todos los leds apagados 	  |	 00000000
;-----------------------------------------------------
;	$01   |	Todos los leds encendidos 	  |	 11111111
;-----------------------------------------------------
;	$02   |	Corrimiento del bit más  	  |	 10000000
;		  |	significativo hacia la derecha|	 01000000
;		  |								  |	 00100000
;		  |								  |	   ………..
;		  |								  |	 00000001
;-----------------------------------------------------
;	$03   | Corrimiento del bit menos	  |  00000001
;		  |	significativo hacia la  	  |  00000010
;		  |	izquierda					  |  00000100
;		  |								  |	   ………..
;		  |							  	  |	 10000000
;-----------------------------------------------------
;	$04   | Corrimiento del bit más		  |	 10000000
;		  | significativo hacia la derecha|  01000000
;		  | y a la izquierda			  |    ………..
;		  |								  |	 00000001
;		  |								  |  00000010
;		  |								  |    ………..
;		  |								  |	 10000000
;-----------------------------------------------------
;	$05   | Apagar y encender todos los	  |  00000000
;		  |	bits.						  |  11111111
	processor 16f877
	include <p16f877.inc>

valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 20h	;PRIMER CONTADOR
cte2 equ 50h	;SEGUNDO CONTADOR
cte3 equ 60h	;TERCER CONTADOR

	org 0
	goto INICIO
	org 5

INICIO:
	clrf 	PORTA		
	bsf 	STATUS,RP0	; CAMBIAMOS AL BANCO 1
	bcf 	STATUS,RP1
	clrf 	PORTB

	movlw 	H'06'
	movwf 	ADCON1	; PUERTO A CONFIGURADO COMO ENTRADA
	movlw 	H'3F'		
	movwf 	TRISA
	bcf 	STATUS,RP0	; CAMBIAMOS AL BANCO 0

select
	btfsc	PORTA,1
	goto	select1
	goto	select2

select1	
	btfsc	PORTA,0
	goto	CORR_I
	goto	CORR_D

select2 
	btfsc	PORTA,2
	goto	select3
	goto	select4

select3	
	btfsc	PORTA,0
	goto	FLASH
	goto	CORR_A

select4	
	btfsc	PORTA,0
	goto	ENC
	goto	CICLO

CICLO:
	movlw 	h'00'
	movwf 	PORTB
	goto 	select

ENC:
	movlw 	h'ff'
	movwf 	PORTB
	goto 	select

CORR_D:
	movlw 	h'80'
	movwf 	PORTB
LOOP0:
	rrf 	PORTB,1
	call 	retardo
	btfss	PORTB,-1
	goto	LOOP0
	goto 	select

CORR_I:
	movlw 	h'01'
	movwf 	PORTB
LOOP1:
	rlf 	PORTB,1
	call 	retardo
	btfss	PORTB,8
	goto 	LOOP1
	goto 	select

CORR_A:
	movlw 	h'80'
	movwf 	PORTB
LOOP2:
	rrf 	PORTB,1
	call 	retardo
	btfss	PORTB,-1
	goto	LOOP2
	goto	LOOP3
LOOP3:
	rlf 	PORTB,1
	call 	retardo
	btfss	PORTB,8
	goto 	LOOP3
	goto 	select	

FLASH:	
	movlw	h'ff'
	movwf	PORTB
	call 	retardo
	movlw	h'00'
	movwf	PORTB
	call 	retardo
	goto	select

retardo 
	movlw cte1		;INICIAMOS EL PRIMER CONTADOR
	movwf valor1
tres
 	movlw cte2		;INICIAMOS EK SEGUNDO CONTADOR
	movwf valor2
dos
 	movlw cte3		;INICIAMOS TERCER CONTADOR
	movwf valor3
uno
 	decfsz valor3	;DECREMENTAMOS EL 3ER CONTADOR
	goto uno		;MIENTRAS NO SEA CERO SEGUIMOS DECREMENTANDO
	decfsz valor2	;DECREMENTAMOS EL 2DO CONTADOR
	goto dos		;MIENTRAS NO SEA CERO SEGUIMOS DECREMENTANDO
	decfsz valor1	;DECREMENTAMOS EL 1ER CONTADOR
	goto tres		;MIENTRAS NO SEA CERO SEGUIMOS DECREMENTANDO
	return
	end
