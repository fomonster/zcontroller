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
#include <stdint.h>         /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */

#define _XTAL_FREQ 8000000

#include <pic16f84a.h>

//#include <time.h>

//#include "system.h"        /* System funct/params, like osc/peripheral config */
//#include "user.h"          /* User funct/params, such as InitApp */

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/
int8_t ps2Data = 0;
bool ps2DataStarted = false;
int8_t ps2DataBitsCount = 0;

int8_t ps2DataArray[10];
int8_t ps2DataCount = 0;
/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

unsigned short pa=0;

//#pragma vector = 0x04
void __interrupt(high_priority) myIsr(void)
{
    if(T0IE && T0IF){
        
        T0IF=0;
        TMR0 = 255;

        if ( !ps2DataStarted ) {
            if ( !PORTAbits.RA4 ) {
                ps2DataBitsCount = 0;
                ps2Data = 0;
                ps2DataStarted = true;
                return;
            }
        } else if ( ps2DataBitsCount < 8 ) {
            if ( PORTAbits.RA3 ) {
                ps2Data |= ( 1 << ps2DataBitsCount );
            }   
            ps2DataBitsCount++;
            return;
        } else if ( ps2DataBitsCount == 8 ) {
            ps2DataBitsCount++;
            if ( ps2DataCount < 10 ) {
                ps2DataArray[ps2DataCount] = ps2Data;
                ps2DataCount++;
            }            
        } else {
            ps2DataStarted = false;
            ps2DataBitsCount = 0;
        }
        
    }    
}
/*
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

  
    // 
    TRISA0 = 1; // pin 17 input select ps/2 device (0-keyboard, 1-mouse)
    TRISA1 = 0; // pin 18 output RESTRIG to ALTERA
    TRISA2 = 0; // pin 1 output STROBE to ALTERA
    TRISA3 = 1; // pin 1 input PS/2 DATA 
    TRISA4 = 1; // pin 1 input PS/2 CLK and T0CKI
        
    PORTA = 0b00000000; // Setup port A
    
    TRISB = 0b00000000; // Port B all as output
    PORTB = 0b00000010; // Setup port B
        
    //https://www.teachmemicro.com/pic-interrupt-pic16f84a/
    //http://www.bristolwatch.com/k150/f84e.htm
    //OPTION_REG = 0b00111000;
        // 0 PORTB pull-up resistors disabled
        // 0 INTEDG Interrupt on rising edge of INT pin
        // 1 TOCS-TMR0 Clock  uses RA4 pin
        // 1 TOSE-TMR0 Increment on high-to-low transition on the TMR0 pin
        // 1 PSA - Prescaller asigned to WDT not to TMR0
        // 0 0 0 PSC2, PSC1, PSC0 - Prescaler Rate Select bit
        
    //TMR0 = 155;    
    //INTCON=0b10100000; 
        // 1 GIE global enable interrupts
        // 0 EEIE Disables the EE write complete interrupt
        // 1 T0IE Enables the TMR0 interrupt
        // 0 INTE Disables the RB0/INT interrupt
        // 0 RBIE Disables the RB port change interrupt
        // 0 T0IF 0 = TMR0 did not overflow
        // 0 INTF The RB0/INT interrupt did not occur
        // 0 RBIF None of the RB7:RB4 pins have changed state
    
    
    T0CS = 1;
    T0SE = 1;
    GIE = 1;
    T0IE = 1;
    PSA = 1;
    T0IF = 0;
    TMR0 = 255;
    
    
    ps2DataStarted = false;
    ps2DataBitsCount = 0;
    ps2Data = 0;
    
    while(1)
    {
        if ( ps2DataCount > 0 ) {
            int16_t keyCode = ps2DataArray[0];
            for(int8_t i = 0; i < ps2DataCount; i++) {
                ps2DataArray[i] = ps2DataArray[i-1];
            }
            ps2DataCount--;
            
            if ( keyCode == 0x1a ) { // 0x31=N // 0x1a=Z
               if (pa) {
                    pa = 0;
                } else {
                    pa = 1;
                }
            }
        }
                
        
        if ( pa ) {   //&& pa            
            PORTB = 0b00000000; // led on
        } else {
            PORTB = 0b00000010; // led off
        }
        
        // delay
        uint32_t delay = 30000;
        while(delay > 0 ) {          
            delay--;
        }
        
    }
    
}
