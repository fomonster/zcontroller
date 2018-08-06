/*
 * File:   main.c
 * Author: fomonster
 * e-mail: fomonster@gmail.com
 * ZX Spectrum PS/2 keyboard reader for pic16f84a powered by Z-Controller
 */

#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>         /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */

#define _XTAL_FREQ 8000000

#include <pic16f84a.h>
#include "ps2tozxtable.h"

/*******************************************************************************
    User Global Variable Declaration                                            
*******************************************************************************/

// ps2 receiver data
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


// Array of ports data sended to Altera
uint8_t outPorts[11] = 
{
    // keyboard
    0xff, // 0 - #FEFE - CS...V    "11111110"
    0xff, // 1 - #FDFE - A...G     "11111101"  
    0xff, // 2 - #FBFE - Q...T     "11111011"  
    0xff, // 3 - #F7FE - 1...5     "11110111"  
    0xff, // 4 - #EFFE - 0...6     "11101111"
    0xff, // 5 - #DFFE - P...Y     "11011111"  
    0xff, // 6 - #BFFE - Enter...H "10111111"   
    0xff, // 7 - #7FFE - Space...B "01111111"
    // mouse
    0xff, // #FADF - D0 left btn, D1 right btn, D2 middle btn, D3 nan, D4-D7 wheel
    0xff, // #FBDF - mouse X 
    0xff  // #FFDF - mouse Y 
};



// temp
int8_t i = 0;
int16_t keyCode = 0;
uint8_t shift = 0;
uint8_t capsLock = 0;
uint8_t numLock = 0;
/*******************************************************************************
  Replace non one byte codes to one byte
*******************************************************************************/
/*
  E0(12)E07C Prt Scr =>
  E114(77)E1F014F077 Pause Break =>
  E070 Ins => 
  E06C Home => 
  E07D Page Up => 
  E071 Del => 
  E069 End => 
  E07A Page Down => 
  E04A NumPad "/" => 
  E05A NumPad Enter => 
  E075 Up => 
  E06B Left => 
  E074 Right => 
  E072 Down => 
  E011 Right Alt => 0x14
  E014 Right Ctrl => 0x11   
 */
uint8_t replaceCode(uint8_t code) 
{
    uint8_t r = 0x00;
    switch(code) {
        case 0x12: 
            r = 0x00;
            break;
        case 0x77: 
            r = 0x00;
            break;
        case 0x70: 
            r = 0x00;
            break;
        case 0x6C: 
            r = 0x00;
            break;
        case 0x7D: 
            r = 0x00;
            break;
        case 0x71: 
            r = 0x00;
            break;
        case 0x69: 
            r = 0x00;
            break;
        case 0x7A: 
            r = 0x00;
            break;
        case 0x5A: 
            r = 0x00;
            break;
        case 0x75: 
            r = 0xF5;
            break;
        case 0x6B: 
            r = 0xFB;
            break;
        case 0x74: 
            r = 0xF4;
            break;
        case 0x72: 
            r = 0xF2;
            break;
        case 0x11: 
            r = 0x00;
            break;
        case 0x14: 
            r = 0x00;
            break;
    }
    return r;
}
/*******************************************************************************
    PS2 receiver
*******************************************************************************/

// ps2 receiver interrupt
void __interrupt(high_priority) myIsr(void)
{
    if(T0IE && T0IF){
        
        T0IF=0;
        TMR0 = 255;
        // https://youtu.be/vfIiLE0BhE8?t=204
        // http://www.piclist.com/techref/microchip/io/dev/keyboard/ps2-jc.htm
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
                if ( ps2Bits == 0xF0 || ps2Bits == 0xE0 ) {
                    ps2DataState = PS2DATA_WAIT_NEXT;
                } else {
                    if ( ps2DataCount == 2 && ps2Data[1] == 0x12 ) { // Prt Scr
                       ps2DataState = PS2DATA_WAIT_NEXT; 
                    } else if ( ps2Data[0] == 0xe1 && ps2DataCount < 8 ) { // Pause Break
                        ps2DataState = PS2DATA_WAIT_NEXT;
                    } else {
                        ps2DataState = PS2DATA_RECEIVED;
                    }
                }
            } 
        } 
    } 
    GIE = 1;
}
/*******************************************************************************
   PortsData
*******************************************************************************/
void setPort(uint8_t bit_id)
{
    outPorts[bit_id & 0x07] |= (1 << (bit_id >> 4));
}

void resetPort(uint8_t bit_id)
{
    outPorts[bit_id & 0x07] &= ~(1 << (bit_id >> 4));
}
/*******************************************************************************
 Key Up and Down functions
*******************************************************************************/
void keyDown(uint8_t key)
{
    uint16_t c = codeToMatrix(key, shift, capsLock, numLock );
    if ( (c & 0xFF) != 0xFF ) setPort(c & 0xFF );
    if ( (( c >> 8 ) & 0xFF) != 0xFF ) setPort( (c >> 8 ) & 0xFF );
}

void keyUp(uint8_t key)
{
    uint16_t c = codeToMatrix(key, shift, capsLock, numLock );
    if ( (c & 0xFF) != 0xFF ) resetPort(c & 0xFF );
    if ( (( c >> 8 ) & 0xFF ) != 0xFF ) setPort( (c >> 8 ) & 0xFF );
}
/*******************************************************************************
 Send data to Altera
*******************************************************************************/
void sendDataToAltera()
{
    
}
/*******************************************************************************
 Send data to ps2 keyboard
*******************************************************************************/
void sendToKeyboardRepeat()
{
    
}

void sendToKeyboardLED(uint8_t id, uint8_t state)
{
    
}
/*******************************************************************************
    Main program
*******************************************************************************/
void main(void)
{
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
    //pa = 0;
    
    while(1)
    {
        if ( ps2DataState == PS2DATA_RECEIVED ) {
            
            // process data
            if ( ps2DataCount == 1) { // one byte code
                keyDown(ps2Data[0]);
            } else if ( ps2DataCount == 2 ) { // two byte code                
                if ( ps2Data[0] == 0xF0 ) {
                    keyUp(ps2Data[1]); // one byte key up
                } else if ( ps2Data[0] == 0xE0 )  { // two bytes key down
                    keyDown(replaceCode(ps2Data[1]));
                }
            } else if ( ps2DataCount == 3 ){
                if ( ps2Data[0] == 0xF0 && ps2Data[1] == 0xE0 ) {
                    keyUp(replaceCode(ps2Data[2]));
                }
            } else if ( ps2DataCount > 3 ){
                if ( ps2Data[0] == 0xF0 ) {
                    if ( ps2Data[1] == 0xE1 && ps2Data[2] == 0x14 ) keyUp(replaceCode(ps2Data[3]));
                    if ( ps2Data[1] == 0xE0 && ps2Data[2] == 0x12 ) keyUp(replaceCode(ps2Data[2]));
                } else {
                    if ( ps2Data[0] == 0xE1 && ps2Data[1] == 0x14 ) keyDown(replaceCode(ps2Data[2]));
                    if ( ps2Data[0] == 0xE0 && ps2Data[1] == 0x12 ) keyDown(replaceCode(ps2Data[1]));
                }
            }
        
            // wait new data
            ps2DataCount = 0;
            ps2DataState = PS2DATA_WAIT;
                 
            // send data
            sendDataToAltera();
        }
                
        // 
        /*if ( pa ) {
            PORTB = 0b00000000; // led on
        } else {
            PORTB = 0b00000010; // led off
        }*/
        
        CLRWDT();       
    }
    
}
