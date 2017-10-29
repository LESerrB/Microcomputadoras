; Elaborar un programa que encuentre el número menor, de un conjunto de datos ubicados
; entre las localidades de memoria 20h a 40h; mostrar el valor en la dirección 41h.
	processor 16f877     ;Procesador a utilizar
	include<p16f877.inc> ;Libreria
  
var equ h'20'

  org 0           ;Vector de RESET
  goto INICIO
  org  5

INICIO
  movlw h'21'
  movwf FSR       ;FSR apunta al siguiente elemento
  movf var,w      ;W contiene el primer elemento
EVALUA
  btfsc FSR,6     ;Cerifica si es la Localidad 40h
  goto FIN        ;SI, finaliza
  subwf INDF,w   ;NO;Realiza INDF-W
  btfss STATUS,DC ;Verifica si el resultado fue positivo
  goto CONSERVA  ;No,entonces el Primero es mayor
  goto CAMBIA     ;Si,entonces el sucesor es mayor
CAMBIA
  movf INDF,w   ;W contiene al Mayor 
  incf FSR,1     ;FSR apunta al siguiente
  movwf h'41'    ;Guarda mayor en h'41'
  movwf var      ;Guarda el maryor
  goto EVALUA    ;Sigue comparando
CONSERVA
  incf FSR,1     ;Apunta al siguiente
  movf var,w     ;Carga el mayor en W
  goto EVALUA    ;Sigue comparando
FIN
  end