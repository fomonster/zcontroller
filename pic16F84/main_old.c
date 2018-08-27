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
static int8_t ps2DataState = PS2DATA_WAIT;

// data mast zero for every byte
uint8_t ps2Bits = 0;
static int8_t ps2BitsCount = 0;

// data mast zero for every sequence
static uint8_t ps2Data = 0; // do not store all data (only one byte)
static int8_t ps2DataCount = 0;
static int8_t ps2WaitCode = 0;
static int8_t ps2Up = 0;
static int8_t ps2NeedEncode = 0;

// Array of ports data sended to Altera
uint8_t outPorts[11] = 
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
uint8_t i = 0;
uint8_t shift = 0;
uint8_t ctrl = 0;
uint8_t replaced = 0;

/* mouse test */
uint8_t mouseX = 220;
uint8_t mouseY = 110;
uint16_t mouseDelay = 0;

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
                    ps2Up = 1;
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
void setPort(uint8_t bit_id)
{
    outPorts[bit_id & 7] |= (1 << ((bit_id >> 3) & 7));
}

void resetPort(uint8_t bit_id)
{
    outPorts[bit_id & 7] &= ~(1 << ((bit_id >> 3) & 7));
}
/*******************************************************************************
 Key Up and Down functions
*******************************************************************************/
void keyDown(uint8_t key)
{    
    if ( key >= 128 ) return;
    i = codeToMatrix[key];
    if ( i != 0xFF ) {
        setPort(i);
        // caps shift
        if ( (shift &&!replaced) || (i & 0b01000000) ) { 
            setPort(0x00); 
        } else {
            resetPort(0x00);
        }
        // symbol shift
        if ( ctrl || (i & 0b10000000) ) {
            setPort(0x0F);
        } else {
            resetPort(0x0F);
        }
    }
}

void keyUp(uint8_t key)
{
    if ( key >= 128 ) return;
    i = codeToMatrix[key];
    if ( i != 0xFF ) resetPort(i);
}

void myDelay()
{
    //for(uint8_t j = 0; j < 1; j++) { };
}

/*******************************************************************************
 Send data to Altera
*******************************************************************************/
void sendDataToAltera()
{
    RA2 = 1; //STROBE
    RA1 = 1; // RESTRIG
    myDelay();
    RA2 = 0; //STROBE
    myDelay();
    RA2 = 1; //STROBE
    myDelay();
    RA1 = 0; // RESTRIG
    myDelay();
    for(i=0;i<11;i++) {
        myDelay();
        RA2 = 1; //STROBE
        myDelay();
        PORTB = outPorts[i];
        myDelay();
        RA2 = 0; //STROBE
        myDelay();
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
    ps2Up = 0;
    ps2NeedEncode = 0;
    ps2DataState = PS2DATA_WAIT;
    
    while(1)
    {
        if ( ps2DataState == PS2DATA_RECEIVED ) {
            // replace data if shift pressed
            replaced = 0;
            if ( shift && !ctrl ) {
               
                for(i = 0; i < 35 ;i+=2) {
                    if ( ps2Data == replaceOnShiftKeyDown[i] ) {
                        replaced = 1;
                        ps2Data = replaceOnShiftKeyDown[i+1];
                        break;
                    }
                }
            }
            // process data
            if ( ps2Up == 0) { // one byte code
                keyDown(ps2Data);
                if ( ps2Data == 18 || ps2Data == 89) shift = 1;
                if ( ps2Data == 20 || ps2Data == 19) ctrl = 1;
                //if ( ps2Data == 0x77 ) numLock = !numLock;
            } else {
                if ( ps2Data == 18 || ps2Data == 89) shift = 0;
                if ( ps2Data == 20 || ps2Data == 19) ctrl = 0;
                keyUp(ps2Data); // one byte key up                
            }
        
            // wait new data
            ps2Data = 0;
            ps2DataCount = 0;
            ps2WaitCode = 0;
            ps2Up = 0;
            ps2NeedEncode = 0;
            ps2DataState = PS2DATA_WAIT;

            // send data
            sendDataToAltera();
        }
                
        
        // random mouse movement
        
        mouseDelay++;
        if ( mouseDelay > 20000 ) {
            
            if ( outPorts[9] > mouseX ) outPorts[9]--;
            else if ( outPorts[9] < mouseX ) outPorts[9]++;
            if ( outPorts[10] > mouseY ) outPorts[10]--;
            else if ( outPorts[10] < mouseY ) outPorts[10]++;
                
            if (  outPorts[9] ==  mouseX && outPorts[10] ==  mouseY ) {
                mouseX -= 128;
                mouseY += 200;
            }
            sendDataToAltera();
             
            mouseDelay = 0;
        }
        
        
        CLRWDT();       
    }
    
}