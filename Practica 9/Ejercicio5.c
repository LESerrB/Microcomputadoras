/* Utilizando la interrupción por cambio de nivel del puerto paralelo, realizar un programa
   que reconozca un flanco positivo en los pines PB4, PB5, PB6 o PB7 del puerto B, y
   cuando se presente, envíe a la terminal el siguiente texto; de acuerdo a la entrada en la que
   ha ocurrido el evento.
    Interrupción PB4 Activada
    Interrupción PB5 Activada
    Interrupción PB6 Activada
    Interrupción PB7 Activada
   Cuando se detecte la transición de alto a bajo, se debe mostrar:
    Pulso de bajada */
#include <16f877.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
//Configuración Puerto SERIAL
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF

void loader16F877(void) {}

int var;
int var2;
int16 contador = 0;

#int_rb

port_rb(){

    var2 = input_b();

    if(var2==0x80)
    printf("Interrupcion PB7\n\r");
    if(var2==0x40)
    printf("Interrupcion PB6\n\r");
    if(var2==0x20)
    printf("Interrupcion PB5\n\r");
    if(var2==0x10)
    printf("Interrupcion PB4\n\r");
    if(var2==0x00)
    printf("Pulso de bajada\n\r");
 }

#int_rtcc                                             // Timer0

clock_isr(){                                          // Rutina de atención a la interrupción por Timer0
     contador++;
     if(contador==770){
     contador=0;
   }
}

void main(){

    Enable_interrupts(INT_RB);                        // Habilita interrupción por cambio
                                                      // de nivel en los cuatro bits más significativos del puerto B

    set_timer0(0);                                    // Inicia el timer0 en 00H
    setup_counters(RTCC_INTERNAL,RTCC_DIV_256);       // Fuente de reloj y pre-divisor
    enable_interrupts(INT_RTCC);                      // Habilita interrupción TIMER0
    enable_interrupts(GLOBAL);                        // Habilita demás interrupciones

    while(1){
    
    }
}
