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

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

#define PS2DATA_WAIT 0
#define PS2DATA_WAIT_NEXT 1
#define PS2DATA_RECEIVING 2
#define PS2DATA_RECEIVED 3
int8_t ps2DataState = PS2DATA_WAIT;

uint8_t ps2Bits = 0;
int8_t ps2BitsCount = 0;

#define PS2DATA_MAX 8
uint8_t ps2Data[PS2DATA_MAX];
int8_t ps2DataCount = 0;

int8_t i = 0;
int16_t keyCode = 0;
uint32_t delay = 0;

/******************************************************************************/
/* User Global Variable Declaration                                           */
/******************************************************************************/

//__CONFIG(0x3FF9);  

unsigned short pa=0;

// ????????? ????????? ??????????. 
void __interrupt(high_priority) myIsr(void)
{
    if(T0IE && T0IF){
        
        T0IF=0;
        TMR0 = 255;
        // https://youtu.be/vfIiLE0BhE8?t=204
        if ( ps2DataState == PS2DATA_WAIT || ps2DataState == PS2DATA_WAIT_NEXT ) {
            if ( !PORTAbits.RA4 && !PORTAbits.RA3 ) { // 0 start bit
                ps2BitsCount = 0;
                ps2Bits = 0;
                ps2DataState = PS2DATA_RECEIVING;             
            }
        } else if ( ps2DataState == PS2DATA_RECEIVING ) {
            if ( ps2BitsCount < 8 ) { // 1,2,3,4,5,6,7,8 - data bits
                if ( PORTAbits.RA3 ) {
                    ps2Bits |= ( 1 << ps2BitsCount );
                }   
                ps2BitsCount++;          
            } else if ( ps2BitsCount == 8 ) { // 9 parity bit
                ps2BitsCount++;       
            } else if ( ps2BitsCount == 9 ) { // 10 stop bit
                if ( ps2DataCount < PS2DATA_MAX ) {
                    ps2Data[ps2DataCount] = ps2Bits;
                    ps2DataCount++;
                }
                if ( ps2Bits == 0xF0 ) {
                    ps2DataState = PS2DATA_WAIT_NEXT;
                } else {
                    ps2DataState = PS2DATA_RECEIVED;
                }
            } 
        } 
    } 
    GIE = 1;
}

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
        

    //OPTION_REG = 0b00111111;
        // 0 PORTB pull-up resistors disabled
        // 0 INTEDG Interrupt on rising edge of INT pin
        // 1 TOCS-TMR0 Clock  uses RA4 pin
        // 1 TOSE-TMR0 Increment on high-to-low transition on the TMR0 pin
        // 1 PSA - Prescaller asigned to WDT not to TMR0
        // 0 0 0 PSC2, PSC1, PSC0 - Prescaler Rate Select bit
               
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
    
    
    ps2DataState = PS2DATA_WAIT;
    ps2BitsCount = 0;
    ps2Bits = 0;
    pa = 0;
    
    while(1)
    {
        if ( ps2DataState == PS2DATA_RECEIVED ) {
            
            
            if ( ps2DataCount > 1 ) {
            
                if ( ps2Data[0] == 0xF0 && ps2Data[1] == 0x1a ) { // 0x31=N // 0x1a=Z
                   pa = 0;
                } else {
                   //pa = 0;
                }
                    
            } else {
                            
                if ( ps2Data[0] == 0x1a ) { // 0x31=N // 0x1a=Z
                    pa = 1;
                } else {
                    pa = 0;
                }
                
            }
            ps2DataCount = 0;
            ps2DataState = PS2DATA_WAIT;
        }
                
        
        if ( pa ) {
            PORTB = 0b00000000; // led on
        } else {
            PORTB = 0b00000010; // led off
        }
        CLRWDT();
        // delay
        //delay = 1000;
        //while(delay > 0 ) {
         //   delay--;
        //}
        
    }
    
}
