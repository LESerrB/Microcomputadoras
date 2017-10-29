; Modificar el programa anterior, para que ahora los datos que operará se encuentren en
; las localidades reservadas para J y K respectivamente y el resultado almacenarlo en otras
; direcciones, reservadas para C1 y R1 donde C1 representará el valor de la bandera de
; acarreo y R1 el resultado.

	processor 16f877
	include <p16f877.inc>

K equ H'26'
L equ H'27'
M equ H'28'
N equ H'29'

	org 0
	goto inicio
	org 5
inicio: 
	MOVF K,W		;Mueve K a W
	ADDWF L,W		;Suma L a W
	MOVWF M			;Mueve lo de W a M
	BTFSS STATUS, C	;Hace la comparacion del Registro C(Carry)
	GOTO cero		;Si C es 0 va a la subrutina de cero
	GOTO uno		;Si C es 1 va a la subrutina de uno
cero:
	MOVLW H'0'
	MOVWF N
	GOTO inicio
uno 
	MOVLW H'01'
	MOVWF N
	GOTO inicio
	end
