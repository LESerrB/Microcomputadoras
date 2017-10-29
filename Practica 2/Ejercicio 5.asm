; Realizar un programa que muestre un contador binario por el puerto paralelo B, desde
; su valor mínimo B’00000000’ hasta el máximo B’11111111’ y se repita nuevamente el
; contador; usar retardos de ½ segundo.
; |	00000000
; |	00000001
; |	00000010
; |	00000011
; |	…
; |	…
; v	11111111
	processor 16f877
	include<p16f877.inc>

contador equ h'20'
valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
cte1 equ 02h
cte2 equ 01h
cte3 equ 01h
K equ H'26'

	org 0
	goto inicio
	org 5
inicio
	bsf STATUS,5
	BCF STATUS,6
	MOVLW H'0'
	MOVWF TRISB
	BCF STATUS,5
	clrf PORTB
loop2
	MOVLW H'FF'
	MOVWF PORTB
	call retardo
	MOVLW H'00'
	MOVWF PORTB
	call retardo
	goto loop2
retardo
	movlw cte1
	movwf valor1
tres
	movlw cte2
	movwf valor2
dos
	movlw cte3
	movwf valor3
uno
	decfsz valor3
	goto uno
	decfsz valor2
	goto dos
	decfsz valor1
	goto tres
	return
	END
