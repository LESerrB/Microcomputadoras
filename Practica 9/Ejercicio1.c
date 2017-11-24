/* Programa el cual obtenga una señal analógica a través del canal de su elección, se
   realice la conversión a decimal, binario, hexadecimal y su valor de voltaje y el
   resultado de esta, la muestre en un puerto paralelo y a su vez lo trasmita al puerto
   serie.*/
#include <16f877.h>
#fuses HS,NOPROTECT,
#device ADC=10                          // Convertidor A/D indica resolución de 8 bits
#use delay(clock=20000000)             // Frec. de Osc. 20Mhz
//Configuracion del Puerto SERIAL
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7) 
#org 0x1F00, 0x1FFF void loader16F877(void) {}  

long var;

void main(){	
    //Configuración del Puerto A como analógico 
    setup_port_a(ALL_ANALOG);   
       setup_adc(ADC_CLOCK_INTERNAL); // Relog interno de Conv. A/D
    set_adc_channel(0);               // Selecion del canal 0 

    while(1){
        delay_us(20);                 // Retardo de 20us (microsegundos) 
        var=read_adc();               // Se asigna a var la lectura del Canal 0  
        delay_us(20);                 // Retardo de 20us (microsegundos)
        output_b(var);                // Se muestra  var en el puerto B 
                          
        printf(" voltaje =%lu [dec], %LX [hex], %2f[v]\n\r ",var,var,(var*0.0196)); 
    }
} 
