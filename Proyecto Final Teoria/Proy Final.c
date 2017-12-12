#include <16f877.h>
#include<string.h>
#fuses HS,NOPROTECT,
#use delay(clock=20000000)
#use rs232(baud=9600, xmit=PIN_C6, rcv=PIN_C7)
#org 0x1F00, 0x1FFF void loader16F877(void) {}

#byte    PORTB =  0x06
#byte    PORTE =  0x09
#byte    PORTD =  0x08
#byte    TRISB =  0x86
#byte    TRISD =  0x88

#define  RS       2
#define  RW       1
#define  E        0

int i=0, cont=0;
int DATA11[11], DATA;
char cadena[]={"                "};
// Declaracion de funciones globales
void fncEscribe(char);
void fncRecibeC(char car);
void fnComparaC(char cadena[]);
void fnLimpCad();
void fncClear();
void fncCadena(char caracter[]);
void RecorDispDer();

void main(){
//******************************* RUTINA DE INICIALIZACION LCD *******************************//
  // Puerto B como salida
  set_tris_b(0x00);
  // Puerto E como salida
  set_tris_e(0x00);
  // int i=8;

  // Bits 0 y 1 del puerto D como entrada
  bit_set(TRISD,0);
  bit_set(TRISD,1);
  // Puerto B como salida
  set_tris_b(0x00);

  // Redardo para que todo se estabilice
  delay_ms(1000);
  // Condicion Inicial
  // Todos los puertos en 0
  output_b(0x00);
  output_e(0x00);

  //------------------------------------//
  // Rutina de Inicializacion de la LCD //
  //------------------------------------//

  //1. Retardo de 16ms para que todos
  //   los voltajes se estabilizen.

  delay_ms(16);        // Retardo de 16ms

  //2.

  // Nota: Siempre que se manda un comando
  // la terminal de control debe ser puesta a 1 (E=1)
  // y luego rehresada a cero (E=0)

  bit_set(PORTE,E);    // E=1
  output_b(0x30);      // PORTB = 30H
  bit_clear(PORTE,E);  // E=0

  //3.
  delay_ms(5);         // Retardo de 5ms

  //4.
  bit_set(PORTE,E);    // E=1
  output_b(0x30);      // PORTB = 30H
  bit_clear(PORTE,E);  // E=0

  //5.
  delay_us(105);       // Retardo de 105us

  //6.
  bit_set(PORTE,E);    // E=1
  output_b(0x30);      // PORTB = 30H
  bit_clear(PORTE,E);  // E=0

  // Ahora debe haber retardos de 2ms entre cada
  // cada instruccion para que puedan ser leidos
  // por la LCD.

  delay_ms(2);         // Retardo de 2ms

  //7. Function Set
  bit_set(PORTE,E);    // E=1
  output_b(0x38);      // PORTB = 38H
  bit_clear(PORTE,E);  // E=0

  delay_ms(2);         // Retardo de 2ms

  //8. Display Off
  bit_set(PORTE,E);    // E=1
  output_b(0x08);      // PORTB = 08H
  bit_clear(PORTE,E);  // E=0

  delay_ms(2);         // Retardo de 2ms

  //9. Display Clear
  bit_set(PORTE,E);    // E=1
  output_b(0x01);      // PORTB = 01H
  bit_clear(PORTE,E);  // E=0

  delay_ms(2);         // Retardo de 2ms

  //10. Entry Mode Set
  bit_set(PORTE,E);    // E=1
  output_b(0x06);      // PORTB = 06H
  bit_clear(PORTE,E);  // E=0

  delay_ms(2);         // Retardo de 2ms

  //------------------------------------//
  // Fin de la Inicializacion de la LCD //
  //------------------------------------//

  //Enciende el display
  bit_set(PORTE,E);    // E=1
  output_b(0x0C);      // PORTB = 0CH
  bit_clear(PORTE,E);  // E=0

  delay_ms(2);         // Retardo de 2ms

  //-----------------------------------//
  //        Escribir Caracteres        //
  //-----------------------------------//

  // LIMPIAR PUERTO B
  output_b(0x00);

  // Pasar a modo dato
  bit_set(PORTE,RS);   // RS=1
  bit_clear(PORTE,RW); // RW=0

  delay_ms(2);         // Retardo de 2ms
//********************************************************************************************//
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MENSAJE DE BIENVENIDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
  fncEscribe('W');
  fncEscribe('E');
  fncEscribe('L');
  fncEscribe('C');
  fncEscribe('O');
  fncEscribe('M');
  fncEscribe('E');

  // Modo comando
  bit_clear(PORTE,RS);
  bit_clear(PORTE,RW);

  // Pocicion cursor
  bit_set(PORTE,E);    // E=1
  output_b(0xC6);      // cursor = pocicion 46 LCD
  bit_clear(PORTE,E);  // E=0
  delay_us(50);

  // Pasar a modo dato
  bit_set(PORTE,RS);   // RS=1
  bit_clear(PORTE,RW); // RW=0

  delay_ms(2);         // Retardo de 2ms
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& CLAVE DE EQUIPO &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//
  fncEscribe('6');
  fncEscribe('E');
  fncEscribe(' ');
  fncEscribe('2');

  // Modo comando
  bit_clear(PORTE,RS);
  bit_clear(PORTE,RW);

  // Retorno a Casa
  bit_set(PORTE,E);    // E=1
  output_b(0x02);      // cursor = pocicion 0 LCD
  bit_clear(PORTE,E);  // E=0
  delay_ms(2);         // Retardo de 2ms

  // Parpadeo del cursor
  bit_set(PORTE,E);    // E=1
  output_b(0x0F);      // PORTB = 1111xb
  bit_clear(PORTE,E);  // E=0

  delay_ms(2);         // Retardo de 2ms
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&//

  while(1){

    while( bit_test( PORTD,0 )==1 );
      DATA11[cont++] = bit_test(PORTD,1);

    while( bit_test( PORTD,0 )==0 );

      if( cont==11 ){

        int i;
        cont=0;

        for( i=1; i<=8; i++ ){

          if(DATA11[i]==1)
            bit_set(DATA,8-i);

          else
            bit_clear(DATA,8-i);

        }

        // Pasar a modo dato
        bit_set(PORTE,RS);   // RS=1
        bit_clear(PORTE,RW); // RW=0
        delay_ms(25);        // Retardo de 2ms

        if(DATA!=0x0F){      // Si es diferente del Codigo de Liberacion de Tecla

          switch(DATA){

            case 0x38:
              fncRecibeC('A');
            break;

            case 0x4C:
              fncRecibeC('B');
            break;

            case 0x84:
              fncRecibeC('C');
            break;

            case 0xC4:
              fncRecibeC('D');
            break;

            case 0x24:
              fncRecibeC('E');
            break;

            case 0xD4:
              fncRecibeC('F');
            break;

            case 0x2C:
              fncRecibeC('G');
            break;

            case 0xCC:
              fncRecibeC('H');
            break;

            case 0xC2:
              fncRecibeC('I');
            break;

            case 0xDC:
              fncRecibeC('J');
            break;

            case 0x42:
              fncRecibeC('K');
            break;

            case 0xD2:
              fncRecibeC('L');
            break;

            case 0x5C:
              fncRecibeC('M');
            break;

            case 0x8C:
              fncRecibeC('N');
            break;

            case 0x22:
              fncRecibeC('O');
            break;

            case 0xB2:
              fncRecibeC('P');
            break;

            case 0xA8:
              fncRecibeC('Q');
            break;

            case 0xB4:
              fncRecibeC('R');
            break;

            case 0xD8:
              fncRecibeC('S');
            break;

            case 0x34:
              fncRecibeC('T');
            break;

            case 0X3C:
              fncRecibeC('U');
            break;

            case 0x54:
              fncRecibeC('V');
            break;

            case 0xB8:
              fncRecibeC('W');
            break;

            case 0x44:
              fncRecibeC('X');
            break;

            case 0xAC:
              fncRecibeC('Y');
            break;

            case 0x58:
              fncRecibeC('Z');
            break;

            case 0x94:
              fncRecibeC(' ');
            break;

            case 0x6E: // ESC
              fnLimpCad();
              fncClear();
            break;

            case 0x5A: // ENTER
              fncRecibeC('\n');
              delay_ms(250);
              fncClear();
              delay_ms(300);
              fnComparaC(cadena);
              delay_ms(400);

              for(i=0;i<40;i++){
                RecorDispDer();
                delay_ms(500);
              }

            break;

          }//switch
        }//if
      }//if
  }//while
}//main

void fnComparaC(char str[]){
//######################################### COMANDOS #########################################//
   char c1[]={'A','P','E','L','L','I','D','O','S','O',' ','\0'}; // APELLIDOS INICIAN CON "O"
   char c2[]={'P','O','S','G','R','A','D','O','D',' ','\0'};     // MAESTRIAS EN FAC DISEÑO
   char c3[]={'A','P','E','L','L','I','D','O','S','Q',' ','\0'}; // APELLIDOS CON "Q"
   char c4[]={'L','E','N','G','U','A','S','S','E','N',' ','\0'}; // LENGUAS HABLADAS EN SENEGAL
   char c5[]={'N','O','M','B','R','E','S','H','J',' ','\0'};     // NOMBRES DE HOMBRE CON "J"
   char c6[]={'L','E','N','G','U','A','S','B','A','N',' ','\0'}; // LENGUAS HABLADAS EN BANGLADESH
   char c7[]={'E','Q','U','I','P','O','S',' ','\0'};             // EQUIPOS LIGA MX
   char c8[]={'E','N','P','C','I','N','C','O',' ','\0'};         // NOMBRE Y DIRECCION ENP5
//############################################################################################//
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ACCIONES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//
//+++++++++++++++++++++++++ Muestra cinco apellidos con la inicial O +++++++++++++++++++++++++//
    if (strcmp (c1,str) == 0){
//1.-
      fncEscribe('O');
      fncEscribe('L');
      fncEscribe('I');
      fncEscribe('V');
      fncEscribe('A');
      fncEscribe(' ');
//2.-
      fncEscribe('O');
      fncEscribe('L');
      fncEscribe('I');
      fncEscribe('V');
      fncEscribe('E');
      fncEscribe('N');
      fncEscribe('C');
      fncEscribe('I');
      fncEscribe('A');
      fncEscribe(' ');
//3.-
      fncEscribe('O');
      fncEscribe('L');
      fncEscribe('I');
      fncEscribe('V');
      fncEscribe('A');
      fncEscribe('R');
      fncEscribe('E');
      fncEscribe('S');
      fncEscribe(' ');
//4.-
      fncEscribe('O');
      fncEscribe('R');
      fncEscribe('T');
      fncEscribe('E');
      fncEscribe('G');
      fncEscribe('A');
      fncEscribe(' ');
//5.-
      fncEscribe('O');
      fncEscribe('R');
      fncEscribe('O');
      fncEscribe('Z');
      fncEscribe('C');
      fncEscribe('O');
    }
//............. Muestra cinco maestrías que se imparten en la carrera de Diseño ..............//
    else if(strcmp(c2,str)== 0){
//1.-
      fncEscribe('A');
      fncEscribe('R');
      fncEscribe('T');
      fncEscribe('E');
      fncEscribe(' ');
//2.-
      fncEscribe('A');
      fncEscribe('M');
      fncEscribe('B');
      fncEscribe('I');
      fncEscribe('E');
      fncEscribe('N');
      fncEscribe('T');
      fncEscribe('A');
      fncEscribe('C');
      fncEscribe('I');
      fncEscribe('O');
      fncEscribe('N');
      fncEscribe(' ');
//3.-
      fncEscribe('F');
      fncEscribe('O');
      fncEscribe('T');
      fncEscribe('O');
      fncEscribe('P');
      fncEscribe('E');
      fncEscribe('R');
      fncEscribe('I');
      fncEscribe('O');
      fncEscribe('D');
      fncEscribe('I');
      fncEscribe('S');
      fncEscribe('M');
      fncEscribe('O');
      fncEscribe(' ');
//4.-
      fncEscribe('P');
      fncEscribe('U');
      fncEscribe('B');
      fncEscribe('L');
      fncEscribe('I');
      fncEscribe('C');
      fncEscribe('I');
      fncEscribe('D');
      fncEscribe('A');
      fncEscribe('D');
      fncEscribe(' ');
//5.-
      fncEscribe('C');
      fncEscribe('O');
      fncEscribe('M');
      fncEscribe('U');
      fncEscribe('N');
      fncEscribe('I');
      fncEscribe('C');
      fncEscribe('A');
      fncEscribe('C');
      fncEscribe('I');
      fncEscribe('O');
      fncEscribe('N');
    }
//========================= Muestra cinco apellidos con la inicial Q =========================//
    else if(strcmp(c3,str)== 0){
//1.-
      fncEscribe('Q');
      fncEscribe('U');
      fncEscribe('I');
      fncEscribe('N');
      fncEscribe('T');
      fncEscribe('A');
      fncEscribe('N');
      fncEscribe('A');
      fncEscribe(' ');
//2.-
      fncEscribe('Q');
      fncEscribe('U');
      fncEscribe('E');
      fncEscribe('S');
      fncEscribe('A');
      fncEscribe('D');
      fncEscribe('A');
      fncEscribe(' ');
//3.-
      fncEscribe('Q');
      fncEscribe('U');
      fncEscribe('I');
      fncEscribe('N');
      fncEscribe('T');
      fncEscribe('E');
      fncEscribe('R');
      fncEscribe('O');
      fncEscribe(' ');
//4.-
      fncEscribe('Q');
      fncEscribe('U');
      fncEscribe('I');
      fncEscribe('R');
      fncEscribe('O');
      fncEscribe('G');
      fncEscribe('A');
      fncEscribe(' ');
//5.-
      fncEscribe('Q');
      fncEscribe('U');
      fncEscribe('I');
      fncEscribe('N');
      fncEscribe('T');
      fncEscribe('A');
      fncEscribe('N');
      fncEscribe('I');
      fncEscribe('L');
      fncEscribe('L');
      fncEscribe('A');
    }
//$$$$$$$$$$$$$$$$$$$$$$$$ Muestra cinco lenguas habladas en Senegal $$$$$$$$$$$$$$$$$$$$$$$$$//
    else if(strcmp(c4,str)== 0){
//1.-
      fncEscribe('F');
      fncEscribe('R');
      fncEscribe('A');
      fncEscribe('N');
      fncEscribe('C');
      fncEscribe('E');
      fncEscribe('S');
      fncEscribe(' ');
//2.-
      fncEscribe('W');
      fncEscribe('O');
      fncEscribe('L');
      fncEscribe('O');
      fncEscribe('F');
      fncEscribe(' ');
//3.-
      fncEscribe('M');
      fncEscribe('A');
      fncEscribe('N');
      fncEscribe('D');
      fncEscribe('E');
      fncEscribe(' ');
//4.-
      fncEscribe('P');
      fncEscribe('E');
      fncEscribe('U');
      fncEscribe('L');
      fncEscribe('H');
      fncEscribe(' ');
//5.-
      fncEscribe('H');
      fncEscribe('A');
      fncEscribe('S');
      fncEscribe('S');
      fncEscribe('A');
      fncEscribe('N');
      fncEscribe('I');
      fncEscribe('A');
    }
//||||||||||||||| Muestra seis nombres de hombres que inicien con la letra “J” |||||||||||||||//
    else if(strcmp(c5,str)== 0){
//1.-
      fncEscribe('J');
      fncEscribe('A');
      fncEscribe('C');
      fncEscribe('I');
      fncEscribe('N');
      fncEscribe('T');
      fncEscribe('O');
      fncEscribe(' ');
//2.-
      fncEscribe('J');
      fncEscribe('A');
      fncEscribe('C');
      fncEscribe('O');
      fncEscribe('B');
      fncEscribe('O');
      fncEscribe(' ');
//3.-
      fncEscribe('J');
      fncEscribe('A');
      fncEscribe('I');
      fncEscribe('R');
      fncEscribe('O');
      fncEscribe(' ');
//4.-
      fncEscribe('J');
      fncEscribe('A');
      fncEscribe('V');
      fncEscribe('I');
      fncEscribe('E');
      fncEscribe('R');
      fncEscribe(' ');
//5.-
      fncEscribe('J');
      fncEscribe('A');
      fncEscribe('I');
      fncEscribe('M');
      fncEscribe('E');
      fncEscribe(' ');
//6.-
      fncEscribe('J');
      fncEscribe('E');
      fncEscribe('S');
      fncEscribe('U');
      fncEscribe('S');
    }
//~~~~~~~~~~~~~~~~~~~~~~~ Muestra cinco lenguas habladas en Bangladés ~~~~~~~~~~~~~~~~~~~~~~~~//
    else if(strcmp(c6,str)== 0){
//1.-
      fncEscribe('H');
      fncEscribe('I');
      fncEscribe('N');
      fncEscribe('D');
      fncEscribe('I');
      fncEscribe(' ');
//2.-
      fncEscribe('B');
      fncEscribe('E');
      fncEscribe('N');
      fncEscribe('G');
      fncEscribe('A');
      fncEscribe('L');
      fncEscribe('I');
      fncEscribe(' ');
//3.-
      fncEscribe('T');
      fncEscribe('E');
      fncEscribe('L');
      fncEscribe('U');
      fncEscribe('G');
      fncEscribe('U');
      fncEscribe(' ');
//4.-
      fncEscribe('M');
      fncEscribe('A');
      fncEscribe('R');
      fncEscribe('A');
      fncEscribe('T');
      fncEscribe('I');
      fncEscribe(' ');
//5.-
      fncEscribe('T');
      fncEscribe('A');
      fncEscribe('M');
      fncEscribe('I');
      fncEscribe('L');
    }
//;;;;;;;;;;;;;;; Muestra los seis mejores equipos de fútbol soccer en México ;;;;;;;;;;;;;;;;//
    else if(strcmp(c7,str)== 0){
//1.-
      fncEscribe('M');
      fncEscribe('O');
      fncEscribe('N');
      fncEscribe('T');
      fncEscribe('E');
      fncEscribe('R');
      fncEscribe('R');
      fncEscribe('E');
      fncEscribe('Y');
      fncEscribe(' ');
//2.-
      fncEscribe('T');
      fncEscribe('I');
      fncEscribe('G');
      fncEscribe('R');
      fncEscribe('E');
      fncEscribe('S');
      fncEscribe(' ');
//3.-
      fncEscribe('A');
      fncEscribe('M');
      fncEscribe('E');
      fncEscribe('R');
      fncEscribe('I');
      fncEscribe('C');
      fncEscribe('A');
      fncEscribe(' ');
//4.-
      fncEscribe('C');
      fncEscribe('H');
      fncEscribe('I');
      fncEscribe('V');
      fncEscribe('A');
      fncEscribe('S');
      fncEscribe(' ');
//5.-
      fncEscribe('T');
      fncEscribe('O');
      fncEscribe('L');
      fncEscribe('U');
      fncEscribe('C');
      fncEscribe('A');
      fncEscribe(' '); 
//6.-
      fncEscribe('C');
      fncEscribe('R');
      fncEscribe('U');
      fncEscribe('Z');
      fncEscribe('A');
      fncEscribe('Z');
      fncEscribe('U');
      fncEscribe('L');
    }
//:::::::::: Muestra el nombre y dirección de la Escuela Nacional Preparatoria No.5 :::::::::://
    else if(strcmp(c8,str)== 0){
      char m8[]={"JOSE VASCONCELOS CALZ DEL HUESO"};
      fncCadena(m8);
    }
//______________________________________ MESAJE DE ERROR _____________________________________//
    else{
      fncEscribe('N');
      fncEscribe('O');
      fncEscribe('T');
      fncEscribe(' ');
      fncEscribe('V');
      fncEscribe('A');
      fncEscribe('L');
      fncEscribe('I');
      fncEscribe('D');
      fncEscribe(' ');
      fncEscribe('O');
      fncEscribe('P');
      fncEscribe('T');
      fncEscribe('I');
      fncEscribe('O');
      fncEscribe('N');
      fncEscribe('!');
    }
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//
}
/////////////////////////////////////////// FUNCIONES //////////////////////////////////////////
void fnLimpCad(){
  int j=0;

  for(j=0;j<16;j++)
    cadena[j]=' ';

  i=0;
}

void fncEscribe(char car){
  bit_set(PORTE,E);    // E=1
  output_b(car);       // PORTB = car
  bit_clear(PORTE,E);  // E=0
  delay_us(50);
}

void fncRecibeC(char car){

  if(car != '\n'){
    cadena[i]=car;
    i++;
    fncEscribe(car);
  }

  else{
    i++;
    cadena[i]='\0';
    i=0;
  }
}

void fncClear(){
  //Modo comando
  bit_clear(PORTE,RS);
  bit_clear(PORTE,RW);
  bit_set(PORTE,E);    // E=1
  output_b(0x01);      // PORTB = car
  bit_clear(PORTE,E);  // E=0

  //Pasar a modo dato
  bit_set(PORTE,RS);   // RS=1
  bit_clear(PORTE,RW); // RW=0
}

void fncCadena(char caracter[])
{
  int x=0;
    
  for(x=0;x<=50;x++){
     if (caracter[x] != '\0')
        fncEscribe(caracter[x]);

     else
        x=50;  
  }   
}

void RecorDispDer(){
  //Modo comando
  bit_clear(PORTE,RS);
  bit_clear(PORTE,RW);

  bit_set(PORTE,E);    // E=1
  output_b(0x18);      // cambia direccion de cursor <--
  bit_clear(PORTE,E);  // E=0
  delay_us(50);

  bit_set(PORTE,RS);   // RS=1
  bit_clear(PORTE,RW); // RW=0
}
