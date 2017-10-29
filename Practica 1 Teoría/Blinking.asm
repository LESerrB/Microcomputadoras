 ; Este programa prende y apaga todos los leds del puerto B

 		LIST 	P=16F877A
		INCLUDE	P16F877A.INC
		__CONFIG  _HS_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_ON & _CPD_OFF & _CP_OFF & _LVP_ON & _WRT_OFF 


;Declaracion de variables

valor1 		equ h'21'
valor2 		equ h'22'
valor3 		equ h'23'

cte1 		equ 20h
cte2 		equ 50h
cte3 		equ 60h

			;Definir origen
  			org 0
  			goto inicio
  			org 5

inicio 		

			;Configurar Puertos
			bsf STATUS,5
     		bcf STATUS,6 ; Me paso al banco 1 para configurar puertos
     		
			MOVLW H'00'
    		MOVWF PORTB
   			
			BCF STATUS,5  ; Me paso al banco 0 para usar puertos
   		
			;Codigo	

loop2  		
      		movlw H'FF'
       		movwf PORTB
       		
       		call retardo
       		
      		movlw H'00'
       		movwf PORTB

      	
       		call retardo

       		goto loop2
   
retardo 	
			movlw cte1
  			movwf valor1
tres 		movlw cte2
 			movwf valor2
dos 		movlw cte3
 			movwf valor3
uno 		decfsz valor3,1
  			goto uno
 			decfsz valor2,1
 			goto dos
 			decfsz valor1,1
 			goto tres
			return

 			end
