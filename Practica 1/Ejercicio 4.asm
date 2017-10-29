; Desarrollar un programa que presente la cuenta en numeración decimal en la localidad
; de memoria de su elección, como se indica a continuación.
; 00-01-02-03-04-05-06-07-08-09-10-11-12-13-14-15-16-17-18-19-20
	processor 16f877
	include <p16f877.inc>

K equ H'26'

	org 0
	goto inicio
	org 5
inicio:
	CLRF K			;Limpia K para empezar la cuenta
continua			
	INCF K,1		;Hace la cuenta unitaria
	MOVLW H'09'		;Carga el valor de 9 en W
	XORWF K,W		;Realiza un XOR de W con el valor actual de K
	BTFSS STATUS,Z	;Compara con la bandera de ZERO
	GOTO prueba		;Si esta en cero pasa a probar con 19
	GOTO diez		;Si esta en uno pasa a la rutina de diez
prueba	
	MOVLW H'19'		;Carga el valor de 19 en W
	XORWF K,W		;Realiza un XOR de W con el valor actual de K
	BTFSS STATUS,Z	;Compara con la bandera de ZERO
	GOTO continua	;Si esta en cero continua con la cuenta
	GOTO veinte		;Si esta en uno pasa a la rutina de veinte
diez
	MOVLW H'10'		;Si llega a 9 carga un 10 en hex a W
	MOVWF K			
	GOTO continua	;Regresa a la cuenta
veinte
	MOVLW H'20'		;Si llega a 19 carga un 20 en hex a W
	MOVWF K
	GOTO inicio		;Regresa al inicio de la cuenta
	end
