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

#include <pic16f628a.h>
#include "ps2tozxtable.h"

// In TL866 just set LVP, FOSC2, BODEN
// CONFIG = 0x3F2F


/*******************************************************************************
    User Global Variable Declaration                                            
*******************************************************************************/

// ps2 receiver data
#define PS2DATA_WAIT 0 // wait something input 
#define PS2DATA_RECEIVING 1 // read in progress
#define PS2DATA_RECEIVED 2 // data received, now decide what to do
#define PS2DATA_SENDING_WAIT_READY 3 // send seq started, wait device ready to read
#define PS2DATA_SENDING 4 // data sending in progess
#define PS2DATA_SENDED 5 // when data sended and need do something
static int8_t ps2DataState = PS2DATA_WAIT;

// data mast zero for every byte
static uint8_t ps2Bits = 0;
static int8_t ps2BitsCount = 0;



// temp
static uint8_t numLock = false;
static uint8_t shift_ctrl_alt = 0; // when shift , ctrl , alt keys pressed
static uint8_t replaced = 0; // != 0 when key replacement with shift down

static uint8_t delayedKey = 0; // dalayed key code

// Array of input ps2 data
static uint8_t inDataPos = 0; // ????????? ?????? ??? ?????? ??????? 
static uint8_t readDataPos = 0; // ????????? ??????????? ?????? ? ???????, ???? readDataPos == inDataPos, ? ??????? ?????? ???
static uint8_t inData[8] = 
{
    0, 0, 0, 0, 0, 0, 0, 0
};

// Array of ports data sended to Altera
static uint8_t outPorts[11] = 
{
    // keyboard
    0x00, // 0 - #FEFE - CS,Z,X,C,V    "11111110"
    0x00, // 1 - #FDFE - A,S,D,F,G     "11111101"  
    0x00, // 2 - #FBFE - Q,W,E,R,T     "11111011"  
    0x00, // 3 - #F7FE - 1,2,3,4,5     "11110111"  
    0x00, // 4 - #EFFE - 0...6     "11101111"
    0x00, // 5 - #DFFE - P...Y     "11011111"  
    0x00, // 6 - #BFFE - Enter...H "10111111"   
    0x00, // 7 - #7FFE - Space...B "01111111"
    // mouse
    0x07, // #FADF - D0 left btn, D1 reset, D2 nmi
          // D0 left btn, D1 right btn, D2 middle btn, D3 reset, D4-D7 wheel 
    0xF5, // #FBDF - mouse X  245
    0xDA  // #FFDF - mouse Y  218
};

static uint16_t delay = 0; // delay for auto dalayed key press
static uint16_t kempstonMouseEmulatorDelay = 0; // delay for auto dalayed key press
static uint8_t kempstonMouseEmulatorKeys = 0;


/*******************************************************************************
 Tools
*******************************************************************************/

/*
void ps2ReadMode()
{
    TRISA0 = 1; // pin 17 input select ps/2 device (0-keyboard, 1-mouse)
    TRISA3 = 1; // pin 2 input PS/2 DATA 
    TRISA4 = 1; // pin 3 input PS/2 CLK and T0CKI
}

void ps2WriteMode()
{
    TRISA0 = 0; // pin 17 input select ps/2 device (0-keyboard, 1-mouse)
    TRISA3 = 0; // pin 2 input PS/2 DATA 
    TRISA4 = 0; // pin 3 input PS/2 CLK and T0CKI
}
*/
/*******************************************************************************
    PS2 receiver with non one bytes keys encoder and state machine
*******************************************************************************/

// data mast zero for every sequence
static uint8_t ps2DataA = 0; // do not store all data (only one byte)
static uint8_t ps2DataCount = 0; // do not store all data (only one byte)
static uint8_t ps2Device = 0; // 0 - keyboard, 1 - mouse
static uint8_t ps2WaitCode = 0;
static uint8_t ps2DownA = 0;
static uint8_t ps2NeedEncode = 0;

// ps2 receiver interrupt (high_priority)
// PORTAbits.RA4 - clock
// PORTAbits.RA3 - data
// PORTAbits.RA0 - source (0 - keyboard, 1 - mouse)

void __interrupt(high_priority) myIsr(void)
{
    if(T0IE && T0IF){
        
        T0IF=0;
        TMR0 = 255;
        // https://youtu.be/vfIiLE0BhE8?t=204
        // http://www.piclist.com/techref/microchip/io/dev/keyboard/ps2-jc.htm
        // https://www.youtube.com/watch?v=A1YSbLnm4_o
        if ( ps2DataState == PS2DATA_WAIT ) {
            if ( !PORTAbits.RA4 && !PORTAbits.RA3 ) { // 0 start bit - PORTAbits.RA4 (clk) is low and PORTAbits.RA3 (data) is low
                ps2BitsCount = 0;
                ps2Bits = 0;
                ps2DataState = PS2DATA_RECEIVING;
                ps2Device = PORTAbits.RA0;
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
                    for (int8_t i=0; i < 27; i+=2) {
                        if ( ps2Bits == replaceTwoBytesCodes[i] ) {
                            ps2DataA = replaceTwoBytesCodes[i+1];
                            break;
                        }
                    }                   
                } else {                    
                    ps2DataA = ( ps2Bits == 131 ) ? 63 : ps2Bits; // F7 feature
                }
                if ( ps2Bits == 0xF0 ) {
                    ps2DataState = PS2DATA_WAIT;
                    ps2DownA = 128;
                } else if ( ps2Bits == 0xE0 ) {
                    ps2DataState = PS2DATA_WAIT;
                    ps2NeedEncode = 1;
                /*} else if ( ps2WaitCode == ps2Bits ) { ???? ??? ?????????????. ?????????? ???????? ? ????? ??????.
                    ps2DataState = PS2DATA_RECEIVED;
                } else if ( ps2DataCount >= 2 && ps2Bits == 0x12 ) { // Prt Scr
                   ps2DataState = PS2DATA_WAIT;
                   ps2WaitCode = 0x7C;
                } else if ( ps2DataCount <= 2 && ps2Bits == 0xE1 ) { // Pause Break
                    ps2DataState = PS2DATA_WAIT;
                    ps2WaitCode = 0x77;*/
                } else {            
                    
                    // save data to array
                    inData[inDataPos] = (ps2DataA | ps2DownA);
                    inDataPos = (inDataPos+1) & 7;
                    
                    // wait new data
                    ps2DataA = 0;
                    ps2DataCount = 0;
                    ps2WaitCode = 0;
                    ps2DownA = 0;
                    ps2NeedEncode = 0;
                    ps2DataState = PS2DATA_WAIT;
                }
                
            } 
        } else if ( ps2DataState == PS2DATA_SENDING ) {
           
            ps2DataState = PS2DATA_WAIT;
        }
    } else { // other interrupt
        
    }
}

/*******************************************************************************
   PortsData
*******************************************************************************/
void updatePort(uint8_t bit_id, uint8_t set)
{
    uint8_t a = (1 << ((bit_id >> 3) & 7));
    if ( set ) outPorts[bit_id & 7] |= a;
    else outPorts[bit_id & 7] &= ~a;
}
/*******************************************************************************
 Key Up and Down functions
*******************************************************************************/
void updateKey(uint8_t key, uint8_t down) // true when down
{   
    uint8_t code = 0xFF;
    uint8_t localShift = (((shift_ctrl_alt & IK_SHIFT) > 0) && replaced == 0); // All replaced keys is when shift pressed  
    uint8_t localCtrl = (shift_ctrl_alt & IK_CTRL) > 0;
    code = codeToMatrix[key];
    if ( code != 0xFF ) {
        updatePort(code, down);
        localShift |= ((code & 64) > 0);
        localCtrl |= ((code & 128) > 0);
    }   
    if ( down ) {
        updatePort(0x00, localShift ); // caps shift  
        updatePort(0x0F, localCtrl ); // symbol shift
    }
}
/*******************************************************************************
 Send data to Altera
*******************************************************************************/
void myDelay()
{
   // for(uint8_t j = 0; j < 1; j++) { };
}


 
//---------------------------------------------
//	PS2: Write Byte
//
//	Input
//	W: byte to write
//
//	Output
//	PS_FLAGS[PS_BIT_ERROR]: Set if error, 
//		cleared otherwise. If this is set, then
//		result is set to a non-zero value
//	PS_RESULT: result code. 
//
//	To write to a device, first bring the clock
//	low for at least 100 usec, then bring the data
//	low, and then release the clock line.
//	The device will now drive the clock line and
//	put out 11 pulses.
//	For the first 8 pulses, the host will write
//	the data bits, starting with the LSB.
//	For the 9th pulse, the host will write the
//	parity bit (ODD)
//	The 10th pulse is a stop bit. The host must
//	release the data line.
//	The 11th pulse is an ACK from the device.
//---------------------------------------------
void sendDataToAltera()
{    
    RA2 = 1; // STROBE
    RA1 = 0; // RESTRIG
    myDelay();
    RA1 = 1; // RESTRIG
    myDelay();
    RA1 = 0; // RESTRIG    
    myDelay();
    for(int8_t i=0;i<11;i++) {
        RA2 = 1; //STROBE   
        PORTB = i < 8 ? ~outPorts[i] : outPorts[i];
        myDelay();
        RA2 = 0; //STROBE 
        myDelay();
        RA2 = 1; //STROBE --  
        myDelay();
    }
    PORTB = 0xFF; 
}
/*
void sendToPs2Device()
{   
    TMR0 = 0; // disable interrupt
    // http://pcbheaven.com/wikipages/The_PS2_protocol/    
    
    
    TRISA0 = 0; // pin 17 output select ps/2 device (0-keyboard, 1-mouse)    
    PORTAbits.RA0 = 1; // pull 1 - mouse
    
    TRISA4 = 0; // Set-up PS2 pin 3 output CLK and T0CKI
    TRISA3 = 0; // Set-up PS2 pin 2 output DATA
    
    // REQUEST WRITE 
    // Bring the Clock line low for at least 100 microseconds.
    PORTAbits.RA4 = 0; // Set clock line low    
    for(uint8_t j = 0; j < 100; j++) { }; // 100 microseconds delay    
    PORTAbits.RA3 = 0; // Bring the Data line low.
    PORTAbits.RA4 = 1; // Release the Clock line
    TRISA4 = 1; // Set-up PS2 pin 3 input CLK and T0CKI
    TRISA0 = 1; // pin 17 input select ps/2 device (0-keyboard, 1-mouse)
    TMR0 = 255; 
    
    
    //myDelay();
    //PORTAbits.RA3 = 1; // pull data high
    
    //TRISA4 = 1; // pin 3 input PS/2 CLK and T0CKI 
    //TRISA0 = 1;
    
   // myDelay();         
   // myDelay(); 
    
    
    
    //PORTAbits.RA4 = 1; // pull clk high 
    
    
    //TRISA3 = 1; // pin 2 input PS/2 DATA
    
    //T0IF=0;
    //TMR0 = 255; // enable interrupt
    
    ps2BitsCount = 0;
    ps2DataState = PS2DATA_SENDING; //_WAIT_READY

}*/
/*******************************************************************************
 Send data to ps2 keyboard
*******************************************************************************/

void calculateBitsFromTable(uint8_t* keyCode, uint8_t* keyDown, uint8_t* bits, uint8_t table[], uint8_t count, uint8_t clearIfFound)
{
    for(uint8_t i = 0; i < count;i++) {
        if ( (*keyCode) == table[i] ) {
            if ( (*keyDown) ) {
                (*bits) |= (1 << i);
            } else {
                (*bits) &= ~(1 << i);
            }
            if ( clearIfFound ) {
                (*keyCode) = 0;
            }
            break;
        }
    }
}
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
    // receiver init
    ps2DataA = 0;
    ps2DataCount = 0;
    ps2WaitCode = 0;
    ps2DownA = 0;
    ps2NeedEncode = 0;
    ps2DataState = PS2DATA_WAIT;
    
    // 
    for(int8_t i=0;i<8;i++) {
        outPorts[i] = 0;
    }
    outPorts[8] = 0x07; //
    outPorts[9] = 0xF5; // #FBDF - mouse X  245
    outPorts[10] = 0xDA;  // #FFDF - mouse Y  218
    sendDataToAltera();
    
    // Configure PIC16F28x

    //INTCON
    GIE = 1; //global enable interrupts
    PEIE = 0; // Disables the EE write complete interrupt
    T0IE = 1; // enable timer 0 interrupt
    INTE = 0; // Disables the RB0/INT interrupt
    RBIE = 0; //
    T0IF = 0; // TMR0 overflow did not occur
    INTF = 0; // The RB0/INT interrupt did not occur
    RBIF = 0; // None of the RB7:RB4 pins have changed state
    
    //PIR1
    EEIF = 0;
    CMIF = 0;
    RCIF = 0;
    TXIF = 0;
    CCP1IF = 0;
    TMR2IF = 0;
    TMR1IF = 0;
    
    //PIE1
    EEIE = 0; 
    CMIE = 0; // interrupts from comparators off    
    RCIE = 0; // interrupts async receiver off
    TXIE = 0;
    CCP1IE = 0;
    TMR2IE = 0;
    TMR1IE = 0;

    //OPTION 
    nRBPU = 0; // pull-up resistors disabled
    INTEDG = 0; // rb0/int falling_edge interrupt mode
    T0CS = 1; // TMR0 signal not internal, and from RA4/T0CKI
    T0SE = 1; // falling_edge on RA4/T0CKI
    PSA = 1; // Devider is for WDT not for TMR0
    PS2 = 0;
    PS1 = 0;
    PS0 = 0;
    
    //
    TMR0 = 255;
    TMR1L = 0;
    TMR1H = 0;
    TMR2 = 0;
    T1CON = 6;
    CCPR1L = 0;
    CCPR1H = 0;
    CCP1CON = 0;
    CMCON = 7; // all comparators off     
    VRCON = 0; // opornoe napryazhenie Vref
    RCSTA = 0;
    TXSTA = 128;
    SPEN = 0;
    
    // Configure PIC16F28x pins
    
    // PORTA
    PORTA = 0; // Setup port A
    //TRISA = 255;
    TRISA0 = 1; // RA0 pin 17 input select ps/2 device (0-keyboard, 1-mouse)    
    TRISA1 = 0; // RA1 pin 18 output RESTRIG to ALTERA  
    TRISA2 = 0; // RA2 pin 1 output STROBE to ALTERA
    TRISA3 = 1; // RA3 pin 2 input PS/2 DATA
    TRISA4 = 1; // RA4 pin 3 input PS/2 CLK and T0CKI
    TRISA5 = 1;
    TRISA6 = 1;
    TRISA7 = 1;
            
    // PORT
    TRISB = 0; // Port B all as output
    PORTB = 0xFF; // Setup port B

    //
    delay = 0;
    delayedKey = 0;
    shift_ctrl_alt = 0;
    replaced = 0;
    
    // 
    /*inData[0] = 18;
    inData[1] = 22;
    inData[2] = 22 | 128;
    inData[3] = 18 | 128;
    readDataPos = 0;
    inDataPos = 4;*/
    
    while(1)
    {        
        uint8_t needSave = false;
        
        // Key code is received and changed with replaceTwoBytesCodes table.
        if ( readDataPos != inDataPos ) {
            
            uint8_t keyCode = (inData[readDataPos] & 127);
            uint8_t keyDown = (inData[readDataPos] & 128) == 0;
            readDataPos = (readDataPos + 1) & 7;
            
            //if ( ps2Device == 0 ) { // keyboard
                
                /****************************************************
                 * 
                 ****************************************************/
                
                calculateBitsFromTable(&keyCode, &keyDown, &shift_ctrl_alt, importantKeys, 6, false);
                
                calculateBitsFromTable(&keyCode, &keyDown, &kempstonMouseEmulatorKeys, kempstonMouseKeys, 6, numLock);
                
                /****************************************************
                 *  Stuff
                 ****************************************************/
                
                // kempston mouse emulation (num pad arrows)
                if ( keyCode == 119 && keyDown ) {
                    numLock = !numLock; 
                }
                
                // ctrl + alt + delete => RES
                if ( (shift_ctrl_alt & IK_CTRL) > 0 && (shift_ctrl_alt & IK_ALT) > 0 && keyCode == 31 && keyDown  ) {                
                    outPorts[8] &= 253;
                } else {
                    outPorts[8] |= 2;
                }
                
                // ctrl + scroll lock => NMI
                if ( (shift_ctrl_alt & IK_CTRL) > 0 && keyCode == 126 && keyDown ) {  
                    outPorts[8] &= 251;                    
                } else {
                    outPorts[8] |= 4;  
                }
                
                /****************************************************
                 *  Main logic
                 ****************************************************/
                
                // replace data if shift down for some keys in replaceOnShiftKeyDown table            
                for(int8_t i = 0; i < 41 ;i+=2) {
                    if ( keyCode == replaceOnShiftKeyDown[i] ) {
                        if ( (((shift_ctrl_alt & IK_SHIFT) > 0) && replaced == 0) || replaced == keyCode) {
                            if ( keyDown ) replaced = keyCode;
                            else replaced = 0;
                            keyCode = replaceOnShiftKeyDown[i+1];
                        } else {
                            if ( replaced != 0 ) keyCode = 0; // Ignore this key
                        }
                        break;
                    }
                }

                // Dalayed keys ( Del, [, ], {, }, ~ )
                // Those symbols intered by sequence : CS and SS both on ... delay ... key code on ... delay ... CS or SS off.
                for(int8_t i = 0; i < 8; i++) {
                    if ( keyCode == replaceOnDelayKeyDown[i] && keyDown ) { 
                        if ( delay == 0 ) {
                            delayedKey = keyCode;
                            delay = 2600;
                            keyCode = 111; // CS + SS key
                        } else {
                            keyCode = 0;
                        }                    
                        break;
                    }
                }
 
                /****************************************************
                 * 
                 ****************************************************/
                
                updateKey(keyCode, keyDown ); 

                // send data to altera registers
                needSave = true;
                
            //} else if ( ps2Device == 1 ) { // mouse
                
                
                
            //}
            
            
 
        } else if ( delay != 0   ) {
            
            delay--;
            if ( delay == 0 ) {

                updatePort(0x00, false); // caps shift reset
                //updatePort(0x0F, false); // or symbol shift 
                needSave = true;
                
            } else if ( delay == 1300 ) {
                    
                updateKey(delayedKey, true );
                delayedKey = 0;    
                needSave = true;
            }
            
        } else {
            
            // random mouse movement        
            kempstonMouseEmulatorDelay++;
            if ( kempstonMouseEmulatorDelay > 2000  ) { 

                if ( numLock ) {
                    if ( (kempstonMouseEmulatorKeys & IK_LEFT) > 0 ) outPorts[9]-=2;
                    if ( (kempstonMouseEmulatorKeys & IK_RIGHT) > 0 ) outPorts[9]+=2;
                    if ( (kempstonMouseEmulatorKeys & IK_UP) > 0 ) outPorts[10]+=2;
                    if ( (kempstonMouseEmulatorKeys & IK_DOWN) > 0 ) outPorts[10]-=2;
                    if ( (kempstonMouseEmulatorKeys & IK_FIRE) > 0 ) outPorts[8] &= 254;
                    else outPorts[8] |= 1;  
                }
                kempstonMouseEmulatorDelay = 0;                
                needSave = true;
            }
            
        }
        
        if ( needSave) {
            sendDataToAltera();
        }
        
        CLRWDT();       
    }
    
}