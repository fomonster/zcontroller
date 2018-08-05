/*
 * File:   main.c
 * Author: fomonster
 *
 * PS/2 Keyboard reader
 * 
 */
#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>        /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */

#define _XTAL_FREQ 8000000

#include <pic16f84a.h>

//#include <time.h>

//#include "system.h"        /* System funct/params, like osc/peripheral config */
//#include "user.h"          /* User funct/params, such as InitApp */

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/
//int8_t PS2Data;

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

unsigned short pa=0;
// ??????? ????????? ??????????
/*void interrupt(void)
{
    if(T0IF){
        // ???? ??????????? ????????? ?? ??????? T0CKI
        T0IF = 0;
        //  PS2Data
    }
}

void WaitLowHighPS2Clock()
{
    while(RA1 == 0) { } // Wait for the LOW clock pulse to finish 
    while(RA2 == 1) { } // After low edge wait for the HIGH clock pulse to finish 
}

*/
/******************************************************************************/
/* Main Program                                                               */
/******************************************************************************/
void main(void)
{

  
    // ???????????????? ???????????
    TRISA0 = 1; // pin 17 input ??????????? ?? ?????? ps/2 ????? ?????? (0-??????????, 1-?????)
    TRISA1 = 0; // pin 18 output RESTRIG ? ????
    TRISA2 = 0; // pin 1 output STROBE ? ????
    TRISA3 = 1; // pin 1 input PS/2 DATA 
    TRISA4 = 1; // pin 1 input PS/2 CLK and T0CKI
        
    PORTA = 0b00000000; // ??????? ???? ?
    
    TRISB = 0b00000000; // Port B all as output
    PORTB = 0b00000010; // ??????? ???? ?
   // CLKIN 
    //INTOSC = 0;
    //https://www.teachmemicro.com/pic-interrupt-pic16f84a/
    //http://www.bristolwatch.com/k150/f84e.htm
    /*GIE = 1;
    OPTION_REG = 0b00111000;
    INTCON=0b10100100;
    //T0CS = 0;
    TMR0 = 0b01101000; // 
    T0IF = 0;
    T0IE = 1;       // Enable Timer Interrupt
    //RBPU = 1;  // ????????????? R (0-???, 1-????)
    */
    //T0CON = 0x68;
    //TMR0L = 0;
    
    /* Configure the oscillator for the device */
    //ConfigureOscillator();

    /* Initialize I/O and Peripherals for application */
    //InitApp();

    //PS2Data = 0;
    //FOSC0 = 0;
    
    while(1)
    {
        /* TODO <INSERT USER APPLICATION CODE HERE> */        
        if (pa) {
            PORTB = 0b00000010; // ??????? ???? ?
           pa = 0;
        } else {
            PORTB = 0b00000000; // ??????? ???? ?
           pa = 1;
        }
        __delay_ms(1000); //delay of 1second
        
    }
    
}
