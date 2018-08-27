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
#define PS2DATA_RECEIVING 1
#define PS2DATA_RECEIVED 2
#define PS2DATA_DALAYED_CALL 3
static int_fast8_t ps2DataState = PS2DATA_WAIT;

// data mast zero for every byte
uint_fast8_t ps2Bits = 0;
static int_fast8_t ps2BitsCount = 0;

// data mast zero for every sequence
static uint_fast8_t ps2Data = 0; // do not store all data (only one byte)
static int_fast8_t ps2DataCount = 0;
static int_fast8_t ps2WaitCode = 0;
static int_fast8_t ps2Down = 0;
static int_fast8_t ps2NeedEncode = 0;

// Array of ports data sended to Altera
uint_fast8_t outPorts[11] = 
{
    // keyboard
    0x00, // 0 - #FEFE - CS...V    "11111110"
    0x00, // 1 - #FDFE - A...G     "11111101"  
    0x00, // 2 - #FBFE - Q...T     "11111011"  
    0x00, // 3 - #F7FE - 1...5     "11110111"  
    0x00, // 4 - #EFFE - 0...6     "11101111"
    0x00, // 5 - #DFFE - P...Y     "11011111"  
    0x00, // 6 - #BFFE - Enter...H "10111111"   
    0x00, // 7 - #7FFE - Space...B "01111111"
    // mouse
    0x07, // #FADF - D0 left btn, D1 right btn, D2 middle btn, D3 nan, D4-D7 wheel 
    0xF5, // #FBDF - mouse X  245
    0xDA  // #FFDF - mouse Y  218
};

// temp
uint_fast8_t i = 0;
uint_fast8_t shift = false;
//int_fast8_t localCtrl = 0;
//int_fast8_t localShift = 0;
uint_fast8_t ctrl = false;
uint_fast8_t replaced = 0;

/* mouse test */
uint_fast8_t mouseX = 220;
uint_fast8_t mouseY = 110;
uint_fast16_t delay = 0;

/*******************************************************************************
    PS2 receiver with non one bytes keys encoder and state machine
*******************************************************************************/

// ps2 receiver interrupt
void __interrupt(high_priority) myIsr(void)
{
    if(T0IE && T0IF){
        
        T0IF=0;
        TMR0 = 255;
        // https://youtu.be/vfIiLE0BhE8?t=204
        // http://www.piclist.com/techref/microchip/io/dev/keyboard/ps2-jc.htm
        // https://www.youtube.com/watch?v=A1YSbLnm4_o
        if ( ps2DataState == PS2DATA_WAIT ) {
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
                ps2DataCount++;
                if ( ps2NeedEncode ) {
                    for (int ii=0; ii < 25; ii+=2) {
                        if ( ps2Bits == replaceTwoBytesCodes[ii] ) {
                            ps2Data = replaceTwoBytesCodes[ii+1];
                            break;
                        }
                    }                   
                } else {                    
                    ps2Data = ( ps2Bits == 131 ) ? 63 : ps2Bits; // F7
                }
                if ( ps2Bits == 0xF0 ) {
                    ps2DataState = PS2DATA_WAIT;
                    ps2Down = false;
                } else if ( ps2Bits == 0xE0 ) {
                    ps2DataState = PS2DATA_WAIT;
                    ps2NeedEncode = 1;
                } /*else if ( ps2WaitCode == ps2Bits ) {
                    ps2DataState = PS2DATA_RECEIVED;
                } else if ( ps2DataCount >= 2 && ps2Bits == 0x12 ) { // Prt Scr
                   ps2DataState = PS2DATA_WAIT;
                   ps2WaitCode = 0x7C;
                } else if ( ps2DataCount <= 2 && ps2Bits == 0xE1 ) { // Pause Break
                    ps2DataState = PS2DATA_WAIT;
                    ps2WaitCode = 0x77;
                }*/ else {                        
                    ps2DataState = PS2DATA_RECEIVED;
                }
                
            } 
        } 
    } 
    GIE = 1;
}
/*******************************************************************************
   PortsData
*******************************************************************************/
void updatePort(uint_fast8_t bit_id, uint_fast8_t set)
{
    uint_fast8_t b = outPorts[bit_id & 7];
    uint_fast8_t a = (1 << ((bit_id >> 3) & 7));
    if ( set ) b |= a;
    else b &= ~a;
    outPorts[bit_id & 7] = b;
}
/*******************************************************************************
 Key Up and Down functions
*******************************************************************************/
void updateKey(uint_fast8_t key, uint_fast8_t set) // true when down
{   
    i = 0xFF;
    uint_fast8_t localShift = (shift && replaced == 0); // All replaced keys is when shift pressed  
    uint_fast8_t localCtrl = 0;
    if ( key < 128 ) i = codeToMatrix[key];
    if ( i != 0xFF ) {
        updatePort(i, set);
        localShift |= (i & 0b01000000) > 0;
        localCtrl |= (i & 0b10000000) > 0;
    }   
    if ( set ) {
        updatePort(0x00, localShift > 0 || ( shift && replaced == 0)); // caps shift  
        updatePort(0x0F, localCtrl > 0); // symbol shift
    }
}
/*******************************************************************************
 Send data to Altera
*******************************************************************************/
void sendDataToAltera()
{
    RA2 = 1; //STROBE
    RA1 = 1; //RESTRIG
    RA2 = 0; //STROBE
    RA2 = 1; //STROBE
    RA1 = 0; //RESTRIG
    for(i=0;i<11;i++) {
        RA2 = 1; //STROBE
        PORTB = outPorts[i];
        RA2 = 0; //STROBE
    }
    RA2 = 1; //STROBE
    PORTB = 0;
}
/*******************************************************************************
 Send data to ps2 keyboard
*******************************************************************************/

/*
void sendToKeyboard(uint8_t d)
{
    TRISA4 = 0; // pin 3 output PS/2 CLK and T0CKI
    TRISA3 = 0; // pin 2 output PS/2 DATA     
    RA3 = 0;
    RA4 = 0;    
    myDelay();
    RA3 = 1;
    for(i=0;i<11;i++) {
        myDelay();
        RA4 = (d & 1);
        RA3 = 0;
        myDelay();
        d = d << 1;
        RA3 = 1;
    }
    TRISA4 = 1; // pin 3 input PS/2 CLK and T0CKI
    TRISA3 = 1; // pin 2 input PS/2 DATA 
}


void sendToKeyboardLED(uint8_t id, uint8_t state)
{
    sendToKeyboard(0xED);
    ps2DataState = PS2DATA_WAIT;
    while ( ps2DataState != PS2DATA_RECEIVED ) {
    }
    sendToKeyboard(0b00000111);
}*/

/*******************************************************************************
    Main program
*******************************************************************************/
void main(void)
{
    TRISA0 = 1; // pin 17 input select ps/2 device (0-keyboard, 1-mouse)
    TRISA1 = 0; // pin 18 output RESTRIG to ALTERA
    TRISA2 = 0; // pin 1 output STROBE to ALTERA
    TRISA3 = 1; // pin 2 input PS/2 DATA 
    TRISA4 = 1; // pin 3 input PS/2 CLK and T0CKI
        
    PORTA = 0b00000000; // Setup port A
    
    TRISB = 0b00000000; // Port B all as output
    PORTB = 0b00000000; // Setup port B

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
    
    ps2Data = 0;
    ps2DataCount = 0;
    ps2WaitCode = 0;
    ps2Down = true;
    ps2NeedEncode = 0;
    ps2DataState = PS2DATA_WAIT;
    
    //for(int i=0;i < 11; i++ ) outPorts[i] = 0;
    
    //localCtrl = 0;
    //localShift = 0;
    shift = false;
    ctrl = false;
    replaced = 0;
    
    while(1)
    {
        if ( ps2DataState == PS2DATA_RECEIVED ) {
            
            // replace data if shift down for some keys in replaceOnShiftKeyDown table            
            for(i = 0; i < 35 ;i+=2) {
                if ( ps2Data == replaceOnShiftKeyDown[i] ) {
                    if ( (shift && replaced == 0) || replaced == ps2Data) {
                        if ( ps2Down ) replaced = ps2Data;
                        else replaced = 0;
                        ps2Data = replaceOnShiftKeyDown[i+1];
                    } else {
                        if ( replaced != 0 ) ps2Data = 0; // Ignore this key
                    }
                    break;                    
                }
            }
            
            // process data            
            if ( ps2Data == 18 || ps2Data == 89) shift = ps2Down;
            if ( ps2Data == 20 || ps2Data == 19) ctrl = ps2Down;          
            updateKey(ps2Data, ps2Down ); // ps2Down when key is down, else is up
        
            // wait new data
            ps2Data = 0;
            ps2DataCount = 0;
            ps2WaitCode = 0;
            ps2Down = true;
            ps2NeedEncode = 0;
            ps2DataState = PS2DATA_WAIT;

            // send data
            sendDataToAltera();
        }
                
        //if ( ps2DataState == PS2DATA_DALAYED_CALL ) {
        //    for(int delay=0; delay < 3000; delay++ ) {                
        //    }
        //    
        //}        
        // random mouse movement
        
        delay++;
        if ( delay > 2000 ) {
            
            if ( outPorts[9] > mouseX ) outPorts[9]--;
            else if ( outPorts[9] < mouseX ) outPorts[9]++;
            if ( outPorts[10] > mouseY ) outPorts[10]--;
            else if ( outPorts[10] < mouseY ) outPorts[10]++;
                
            if (  outPorts[9] ==  mouseX && outPorts[10] ==  mouseY ) {
                mouseX -= 128;
                mouseY += 200;
            }
            sendDataToAltera();
             
            delay = 0;
        }
        
        
        CLRWDT();       
    }
    
}
