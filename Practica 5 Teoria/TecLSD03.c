/*
LCD_Hola.c
22-Julio_2011

Manda un mensaje de "Hola" a la LCD

Nota: La LCD Debe conectarse en modo
de 8 Bits.

Ver pag 212 de la datasheet impresa

Recordar que:

GND (Tierra)         PIN 1  de la LCD
VCC                  PIN 2  de la LCD
Contraste            PIN 3  de la LCD

RS      PORTE,2        PIN 4  de la LCD
RW      PORTE,1        PIN 5  de la LCD
E      PORTE,0        PIN 6  de la LCD

DB0   PORTB,0        PIN 7  de la LCD
DB1   PORTB,1        PIN 8  de la LCD
DB2   PORTB,2        PIN 9  de la LCD
DB3   PORTB,3        PIN 10 de la LCD
DB4   PORTB,4        PIN 11 de la LCD
DB5   PORTB,5        PIN 12 de la LCD
DB6   PORTB,6        PIN 13 de la LCD
DB7   PORTB,7        PIN 14 de la LCD

No Conection (N.C.)  PIN 15 de la LCD
No Conection (N.C.)  PIN 16 de la LCD

clave de equipo 6E  retardo 2s
*/


//Encabezados
#include <16f877.h>

#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {} //for the 8k 16F876/7

//Definiciones

#byte    PORTB =  0x06
#byte    PORTE =  0x09
#byte    PORTD =  0x08
#byte    TRISB =  0x86
#byte    TRISD =  0x88

#define  RS       2
#define  RW       1
#define  E        0

int cont=0;
int DATA11[11], DATA;


//Declaracion de funciones globales
void fncEscribe(char);

void main()
{
   //Puerto B como salida
   set_tris_b(0x00);
   //Puerto E como salida
   set_tris_e(0x00);
   //int i = 8;

   //Bits 0 y 1 del puerto D como entrada
   bit_set(TRISD,0);
   bit_set(TRISD,1);
   //Puerto B como salida
   set_tris_b(0x00);

   //Redardo para que todo se estabilice
   delay_ms(1000);
   //Condicion Inicial
   //Todos los puertos en 0
   output_b(0x00);
   output_e(0x00);

   //-----------------------------------//
   //Rutina de Inicializacion de la LCD
   //-----------------------------------//

   //1.  Retardo de 16ms para que todos
   //    los voltajes se estabilizen.

   delay_ms(16);        //Retardo de 16ms

   //2.-

   //Nota: Siempre que se manda un comando
   //la terminal de control debe ser puesta a 1 (E=1)
   //y luego rehresada a cero (E=0)

   bit_set(PORTE,E);    //E=1
   output_b(0x30);      //PORTB = 30H
   bit_clear(PORTE,E);  //E=0

   //3.
   delay_ms(5);         //Retardo de 5ms

   //4.
   bit_set(PORTE,E);    //E=1
   output_b(0x30);      //PORTB = 30H
   bit_clear(PORTE,E);  //E=0

   //5.
   delay_us(105);       //Retardo de 105us

   //6.
   bit_set(PORTE,E);    //E=1
   output_b(0x30);      //PORTB = 30H
   bit_clear(PORTE,E);  //E=0

   //x.

   //Ahora debe haber retardos de 2ms entre cada
   //cada instruccion para que puedan ser leidos
   //por la LCD.

   delay_ms(2);         //Retardo de 2ms

   //7.Function Set
   bit_set(PORTE,E);    //E=1
   output_b(0x38);      //PORTB = 38H
   bit_clear(PORTE,E);  //E=0

   delay_ms(2);         //Retardo de 2ms

   //8.Display Off
   bit_set(PORTE,E);    //E=1
   output_b(0x08);      //PORTB = 08H
   bit_clear(PORTE,E);  //E=0

   delay_ms(2);         //Retardo de 2ms

   //9.Display Clear
   bit_set(PORTE,E);    //E=1
   output_b(0x01);      //PORTB = 01H
   bit_clear(PORTE,E);  //E=0

   delay_ms(2);         //Retardo de 2ms

   //10. Entry Mode Set
   bit_set(PORTE,E);    //E=1
   output_b(0x06);      //PORTB = 06H
   bit_clear(PORTE,E);  //E=0

   delay_ms(2);         //Retardo de 2ms

   //-----------------------------------//
   //Fin de la Inicializacion de la LCD
   //-----------------------------------//

   //Enciende el display
   bit_set(PORTE,E);    //E=1
   output_b(0x0C);      //PORTB = 0CH
   bit_clear(PORTE,E);  //E=0

   delay_ms(2);         //Retardo de 2ms

   //-----------------------------------//
   //Escribir Caracteres
   //-----------------------------------//

  //Pociciona el cursor

  //lIMPIAR PUERTO B
  output_b(0x00);

  //Modo comando
  bit_clear(PORTE,RS);
  bit_clear(PORTE,RW);

 // Pociciona cursor
  bit_set(PORTE,E);    //E=1
  output_b(0xC6);       //cursor = pocicion 46 LCD
  bit_clear(PORTE,E);  //E=0
  delay_us(50);

  //Pasar a modo dato
   bit_set(PORTE,RS);      //RS=1
   bit_clear(PORTE,RW);    //RW=0

   delay_ms(2);         //Retardo de 2ms

   // CLAVE Y RETARDO
   fncEscribe('6');
   fncEscribe('E');
   fncEscribe(' ');
   fncEscribe('2');


 //Modo comando
  bit_clear(PORTE,RS);
  bit_clear(PORTE,RW);

  //Retorno a Casa

  bit_set(PORTE,E);    //E=1
  output_b(0x02);       //cursor = pocicion 0 LCD
  bit_clear(PORTE,E);  //E=0
  delay_ms(2);         //Retardo de 2ms

//Parpadeo del cursor
   bit_set(PORTE,E);    //E=1
   output_b(0x0F);      //PORTB = 1111xb
   bit_clear(PORTE,E);  //E=0

   delay_ms(2);         //Retardo de 2ms

   while(1)
   {
   while(bit_test(PORTD,0)==1);
      DATA11[cont++] = bit_test(PORTD,1);
      while(bit_test(PORTD,0)==0);


      if(cont==11)
      {
         int i;
         cont=0;

         for(i=1;i<=8;i++)
         {
            if(DATA11[i]==1)
               bit_set(DATA,8-i);
            else
               bit_clear(DATA,8-i);
         }
    //Pasar a modo dato
   bit_set(PORTE,RS);      //RS=1
   bit_clear(PORTE,RW);    //RW=0
         delay_ms(25);         //Retardo de 2ms
         if(DATA!=0x0F)  {    //Si es diferente del Codigo de Liberacion de Tecla
           // output_b(DATA);  //que SI muestre. pasae el dato a funcion que determina la letra
             switch(DATA){
               case 0x38:
                  fncEscribe('A');
               break;

               case 0x4C:
                  fncEscribe('B');
               break;

               case 0x84:
                  fncEscribe('C');
               break;

               case 0xC4:
                  fncEscribe('D');
               break;

               case 0x24:
                  fncEscribe('E');
               break;

               case 0xD4:
                  fncEscribe('F');
               break;

               case 0x2C:
                  fncEscribe('G');
               break;

               case 0xCC:
                  fncEscribe('H');
               break;

               case 0xC2:
                  fncEscribe('I');
               break;

               case 0xDC:
                  fncEscribe('J');
               break;

               case 0x42:
                  fncEscribe('K');
               break;

               case 0xD2:
                  fncEscribe('L');
               break;

               case 0x5C:
                  fncEscribe('M');
               break;

               case 0x8C:
                  fncEscribe('N');
               break;

               case 0x22:
                  fncEscribe('O');
               break;

               case 0xB2:
                  fncEscribe('P');
               break;

               case 0xA8:
                  fncEscribe('Q');
               break;

               case 0xB4:
                  fncEscribe('R');
               break;

               case 0xD8:
                  fncEscribe('S');
               break;

               case 0x34:
                  fncEscribe('T');
               break;

               case 0X3C:
                  fncEscribe('U');
               break;

               case 0x54:
                  fncEscribe('V');
               break;

               case 0xB8:
                  fncEscribe('W');
               break;

               case 0x44:
                  fncEscribe('X');
               break;

               case 0xAC:
                  fncEscribe('Y');
               break;

               case 0x58:
                  fncEscribe('Z');
               break;

               case 0x94:
                  fncEscribe(' ');
               break;

               case 0x0E:
               {
                  bit_clear(PORTE,RS);
                  bit_clear(PORTE,RW);
               
                  bit_set(PORTE,E);    //E=1
                  output_b(0x02);      //cursor = pocicion 0 LCD
                  bit_clear(PORTE,E);  //E=0
                  delay_ms(2);         //Retardo de 2ms
            
                  bit_set(PORTE,E);    //E=1
                  output_b(0x0F);      //PORTB = 1111xb
                  bit_clear(PORTE,E);  //E=0
               
                  delay_ms(2);         //Retardo de 2ms

               }
               break;
                  
                default:
                  fncEscribe('?');
                break;

             }
         }
      }
   }//while
}//main

//Funcion que escribe un caracter en la LCD
void fncEscribe(char car)
{
      bit_set(PORTE,E);    //E=1
      output_b(car);       //PORTB = car
      bit_clear(PORTE,E);  //E=0
      delay_us(50);
}

