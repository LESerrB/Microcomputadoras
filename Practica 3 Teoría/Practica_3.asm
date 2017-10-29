; Por medio del sistema mínimo construido previamente para esta clase, conectar 5 botones al puerto A del
; PIC. Al oprimir cada botón, se mostrará una secuencia particular en dos displays de 7 segmentos.
; Botón 1 para "Swap": Si se oprime este botón los dígitos mostrados se intercambian de lugar.
; Botón 2 para "Poner a cero": Si se oprime este botón los displays muestran el valor "00".
; Botón 3 para "Parpadeo": Si se oprime este botón comienzan a parpadear los displays con el
; retardo que le fue asignado al equipo por el profesor. Si se vuelve a oprimir este botón, los displays
; dejan de parpadear.
; Botón 4 para "Incremento en 1": Si se oprime este botón se incrementa en uno la información
; que este desplegada en ese momento en los displays. Al oprimir el botón de Reset del sistema, se vuelve
; a mostrar la clave del equipo en los displays.
; Botón 5 para "Decremento en 1": ": Si se oprime este botón se decrementa en uno la
; información que este desplegada en ese momento en los displays. Al oprimir el botón de Reset del sistema,
; se vuelve a mostrar la clave del equipo en los displays.
	processor 16f877
	include <p16f877.inc>

	org 0
	goto INICIO
	org 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA REGISTROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
valor1 		equ h'21'
cte1 		equ h'FF'		; PRIMER CONTADOR

valor2 		equ h'34'		; SEGUNDO CONTADOR
cte2 		equ h'FF'

valor3 		equ h'35'
cte3 		equ h'08'		; PRIMER CONTADOR

comp		equ H'22'
clave		equ H'23'  		; CLAVE DE EQUIPO "6E"
resu		equ H'24'
Nibble		equ	H'26' 		; AUX PARA SWAP
NUM			equ H'25'
check		equ H'27'		; CHECA CUANTAS VECES SE HA PRESIONADO LOS BOTONES 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONFIGURA PUERTOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INICIO:
	clrf 	PORTA
	bsf 	STATUS,RP0 		; CAMBIAMOS AL BANCO 1
	bcf 	STATUS,RP1

	movlw 	H'06' 			; PUERTOS "A" Y "E" COMO DIGITALES
	movwf 	ADCON1
	
	movlw	H'3F'			; PUERTO "A" COMO ENTRADA
	movwf	TRISA

	clrf	TRISB
	clrf	TRISD 			; PUERTO "D" COMO SALIDA (CONTROL DE LOS DISPLAYS)

	bcf 	STATUS,RP0 		; REGRESA AL BANCO 0

	clrf	resu			; LIMPIA LOS REGISTROS A USAR
	clrf	check

	movlw	H'6E'			; CLAVE DE EQUIPO
	movwf	clave

	movf	clave,w
	movwf	NUM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INICIA PROGRAMA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LOOP:
	movf	NUM,w
	movwf	resu
	call	Disp1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SELCTOR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SELECT
	btfsc	PORTA,0
	goto	SELECT1		; 1
	goto	SWAP_NUMS	; 0

SELECT1	
	btfsc	PORTA,1
	goto	SELECT2		; 1
	goto	RESET_0		; 0

SELECT2 
	btfsc	PORTA,2
	goto	SELECT3		; 1
	goto	CHECK		; 0

SELECT3	
	btfsc	PORTA,3
	goto	SELECT4		; 1
	goto	INCRASE		; 0

SELECT4	
	btfsc	PORTA,4
	goto	LOOP		; 1
	goto	DECREMENT	; 0

CHECK
	btfss	check,0
	call	BLINKING	; 0
	goto	LOOP		; 1
	
PRESS2
	btfss	check,0
	goto	LOOP
	goto	BLINKING
	goto	LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCIONES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SWAP_NUMS
	call	retardo
	swapf	NUM
	goto 	LOOP
RESET_0
	movlw	H'00'
	movwf	NUM
	goto 	LOOP
BLINKING
	clrf	PORTB
	call	retardo
	call	retardo
	call	retardo
	call	retardo
	movf	NUM,w
	movwf	resu
	call	Disp1	
	call	retardo
	call	retardo
	call	retardo
	call	retardo
	btfsc	PORTA,2		; MANTENER PRESIONADO
	goto	BLINKING	; 1
	bsf		check,0		; 0
	goto	CHECK
INCRASE
	call 	retardo
	incf	NUM
	goto 	LOOP
DECREMENT
	call 	retardo
	decf	NUM
	goto 	LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Disp1:
	CLRF	PORTD
	BSF		PORTD,0			; ACTIVA DISPLAY 1
	MOVF	resu,W
	andlw	H'0F'			; ENMASCARADO DE NIBLE BAJO PARA EVITAR DESBORDAMIENTOS
	call	Tabla
	MOVWF	comp
	comf	comp,W
	MOVWF	PORTB
	CALL	retardo2
	BCF		PORTD,0			; DESACTIVA DISPLAY 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Disp2:
	CLRF	PORTD	
	BSF		PORTD,1			; ACTIVA DISPLAY 2
	MOVF	resu,W
	andlw	H'F0'			; ENMASCARADO DE NIBLE ALTO PARA EVITAR DESBORDAMIENTOS
	MOVWF	Nibble
	SWAPF	Nibble
	MOVF	Nibble,W
	call	Tabla
	MOVWF	comp
	comf	comp,W
	MOVWF	PORTB
	CALL 	retardo2
	CLRF	PORTD			; DESACTIVA DISPLAY 2
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;RETARDO 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo
	movlw 	cte1
	movwf 	valor1
tres
	movlw 	cte2
	movwf 	valor2
dos
	movlw 	cte3
	movwf 	valor3
uno 
	decfsz 	valor3
	goto 	uno
	decfsz 	valor2
	goto 	dos
	decfsz 	valor1
	goto 	tres
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;RETARDO 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo2 
	movlw 	cte2
	movwf 	valor2
tres2
	decfsz 	valor2
	goto 	tres2
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TABLA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Tabla:
	addwf	PCL,1
			; hgfedcba
	retlw	B'11000000'		; '00'
	retlw	B'11111001'		; '01'
	retlw	B'10100100'		; '02'
	retlw	B'10110000'		; '03'
	retlw	B'10011001'		; '04'
	retlw	B'10010010'		; '05'
	retlw	B'10000010'		; '06'
	retlw	B'11111000'		; '07'
	retlw	B'10000000'		; '08'
	retlw	B'10010000'		; '09'
	retlw	B'10001000'		; '0A'
	retlw	B'10000011'		; '0B'
	retlw	B'11000110'		; '0C'
	retlw	B'10100001'		; '0D'
	retlw	B'10000110'		; '0E'
	retlw	B'10001110'		; '0F'

	return
	end