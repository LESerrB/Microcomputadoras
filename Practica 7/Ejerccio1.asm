; Utilizando el programa de Control de acciones, realizar las modificaciones necesarias
; para que ahora se controle por medio del teclado de PC, el cuál transmitirá el comando
; de la acción a ejecutar.
;     TECLA  |          ACCION
;            |         Puerto B
;-------------------------------------------
;       0    |  Todos los bits
;            |  del puerto apagados
;-------------------------------------------
;       1    |  Todos los bits del
;            |  puerto encendidos
;-------------------------------------------
;       2    |  Corrimiento del bit
;            |  más significativo hacia
;            |  la derecha
;-------------------------------------------
;       3    |  Corrimiento del bit menos
;            |  significativo hacia la
;            |  izquierda
;-------------------------------------------
;       4    |  Corrimiento del bit más
;            |  significativo hacia la
;            |  derecha y a la izquierda
;-------------------------------------------
;       5    |  Apagar y encender todos
;            |  los bits.

      processor 16f877
      include<p16f877.inc>

valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'

v0 equ h'24'
v1 equ h'25'
v2 equ h'26'
v3 equ h'27'
v4 equ h'29'
v5 equ h'30'

      org 0h
      goto INICIO
      org 05h

INICIO:                 ; CONFIGURACION DEL REGISTRO TRANSMISOR
      clrf PORTB
      bsf STATUS,RP0    
      bcf STATUS,RP1
      clrf TRISB

      bsf TXSTA, BRGH   ; BIT DE SELECCION DE BAUDIOS BRGH=1 ALTA VELOCIDAD
      movlw d'129'      ; VELOCIDAD 9600 BAUDS
      movwf SPBRG       ; CONFIG VELOCIDAD DE COMUNICACION
      bcf TXSTA, SYNC   ; COMUNICACION ASINCRONA SYNC=0   
      bsf TXSTA, TXEN   ; ACTIVA TRANSMISION
      bcf STATUS, RP0
   ; CONFIGURACON DEL REGISTRO RECEPTOR
      bsf RCSTA, SPEN   ; HABILITA PUERTO SERIE
      bsf RCSTA, CREN   ; CONFIGURA RECEPCION EN MODO ASINCRONO
RECIBE:
      btfss PIR1, RCIF  ; VERIFICA SI SE COMPLETO LA RECEPCION
      goto RECIBE
      movf RCREG,w
CICLO:   
      clrf PORTB

      movlw '0'
      movwf v0
      movfw RCREG
      xorwf v0,w
      btfsc STATUS,Z
      goto APG

      movlw '1'
      movwf v1
      movfw RCREG
      xorwf v1,w
      btfsc STATUS,Z
      goto UNOS

      movlw '2'
      movwf v2
      movfw RCREG
      xorwf v2,w
      btfsc STATUS,Z
      goto DER

      movlw '3'
      movwf v3
      movfw RCREG
      xorwf v3,w
      btfsc STATUS,Z
      goto  IZQ

      movlw '4'
      movwf v4
      movfw RCREG
      xorwf v4,w
      btfsc STATUS,Z
      goto DERIZQ

      movlw '5'
      movwf v5
      movfw RCREG
      xorwf v5,w
      btfsc STATUS,Z
      goto ENCAPG
      goto CICLO

APG:                    ; APAGA TODOS LOS BITS
      movlw h'00'
      movwf PORTB
      goto CICLO
 
UNOS:                   ; ENCIENDE TODOS LOS BITS
      movlw h'FF'
      movwf PORTB
      goto CICLO

DER:                    ; CORRIMIENTO A LA DERECHA
      movlw h'80'
      movwf PORTB
      call retardo

DER1:
      rrf PORTB,1
      call retardo
      btfss PORTB,0
      goto DER1
      goto CICLO
       
IZQ:                    ; CORRIMIENTO A LA IZQUIERDA
      movlw h'01'
      movwf PORTB
      call retardo
IZQ1:
      rlf PORTB,1
      call retardo
      btfss PORTB,7
      goto IZQ1
      goto CICLO
       
DERIZQ:                 ; CORRIMIENTO AMBOS LADOS
      movlw h'80'
      movwf PORTB
      call retardo
DER2:
      rrf PORTB,1
      call retardo
      btfss PORTB,0
      goto DER2

      movlw h'01'
      movwf PORTB
      call retardo
IZQ2:
      rlf PORTB,1
      call retardo
      btfss PORTB,7
      goto IZQ2
      goto CICLO 
ENCAPG: 
      movlw h'00'
      movwf PORTB
      call retardo
      movlw h'FF'
      movwf PORTB
      call retardo
      goto CICLO 
;;;;;;;;;;;;;;;;;;;;;;;;;;;SUBRUTINA DE RETARDO;;;;;;;;;;;;;;;;;;;;;;;;;;;
retardo: 
     movlw 15h       
	movwf valor1
tres
      movlw 60h
	movwf valor2
dos
      movlw 50h
	movwf valor3
uno
      decfsz valor3 
	goto uno 
	decfsz valor2
	goto dos
	decfsz valor1   
	goto tres
	return     
      
      end  