/*
 * File:   main.c
 * Author: fomonster
 * e-mail: fomonster@gmail.com
 * ZX Spectrum PS/2 keyboard reader for pic16f84a powered by Z-Controller
 */

/*******************************************************************************
 * Config:       
 *   0x3F2F
 * 
 *   FOSC0 <= 1 
 *   FOSC1 <= 1 
 *   WDTEN <= 0 (disable) - watchdog timer. ???????? ?????? ????? ??????? ? ???, ??? ?? ????????????? ??????????????? ????? ?? ???????? ?? ?????.
 *   /PWRTE <= 1 (disable) - power up timer - ??? ????????? ?? ????? ?????????? ?? ?? ??? ???, ???? ??????? ?? ?????????? ?? ??????? ??????.
 *   
 * 
 * 
 ******************************************************************************/

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

// data mast zero for every sequence
static uint8_t ps2Data = 0; // do not store all data (only one byte)
static int8_t ps2Device = 0; // 0 - keyboard, 1 - mouse
static int8_t ps2WaitCode = 0;
static int8_t ps2Down = false;
static int8_t ps2NeedEncode = 0;

// temp
static uint8_t numLock = false;
static uint8_t shift_ctrl_alt = 0; // when shift , ctrl , alt keys pressed
static uint8_t replaced = 0; // != 0 when key replacement with shift down

static uint8_t delayedKey = 0; // dalayed key code


// Array of ports data sended to Altera
static uint8_t outPorts[11] = 
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
                //ps2DataCount++;
                if ( ps2NeedEncode ) {
                    for (int8_t i=0; i < 27; i+=2) {
                        if ( ps2Bits == replaceTwoBytesCodes[i] ) {
                            ps2Data = replaceTwoBytesCodes[i+1];
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
                /*} else if ( ps2WaitCode == ps2Bits ) {
                    ps2DataState = PS2DATA_RECEIVED;
                } else if ( ps2DataCount >= 2 && ps2Bits == 0x12 ) { // Prt Scr
                   ps2DataState = PS2DATA_WAIT;
                   ps2WaitCode = 0x7C;
                } else if ( ps2DataCount <= 2 && ps2Bits == 0xE1 ) { // Pause Break
                    ps2DataState = PS2DATA_WAIT;
                    ps2WaitCode = 0x77;*/
                } else {                        
                    ps2DataState = PS2DATA_RECEIVED;
                }
                
            } 
        } else if ( ps2DataState == PS2DATA_SENDING ) {
           
            ps2DataState = PS2DATA_WAIT;
        }
    } else { // other interrupt
        
    }
    GIE = 1;
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
void updateKey(uint8_t key, uint8_t set) // true when down
{   
    uint8_t code = 0xFF;
    uint8_t localShift = (((shift_ctrl_alt & IK_SHIFT) > 0) && replaced == 0); // All replaced keys is when shift pressed  
    uint8_t localCtrl = (shift_ctrl_alt & IK_CTRL) > 0;
    if ( key < 128 ) code = codeToMatrix[key];
    if ( code != 0xFF ) {
        updatePort(code, set);
        localShift |= ((code & 64) > 0);
        localCtrl |= ((code & 128) > 0);
    }   
    if ( set ) {
        updatePort(0x00, localShift ); // caps shift  
        updatePort(0x0F, localCtrl ); // symbol shift
    }
}
/*******************************************************************************
 Send data to Altera
*******************************************************************************/
void myDelay()
{
    for(uint8_t j = 0; j < 5; j++) { };
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
//  R 01000000
//  S 11110111
//  D XXXSXXXS 
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

void calculateBitsFromTable(uint8_t* bits, uint8_t table[], uint8_t count, uint8_t clearIfFound)
{
    for(uint8_t i = 0; i < count;i++) {
        if ( ps2Data == table[i] ) {
            if ( ps2Down ) {
                (*bits) |= (1 << i);
            } else {
                (*bits) &= ~(1 << i);
            }
            if ( clearIfFound ) {
                ps2Data = 0;
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
    /*for(int8_t i=0;i<8;i++) {
        outPorts[i] = 0;
    };
    outPorts[8] = 7;
    outPorts[9] = 0xF5; 
    outPorts[10] = 0xDA;*/

    TRISA1 = 0; // pin 18 output RESTRIG to ALTERA
    TRISA2 = 0; // pin 1 output STROBE to ALTERA
    TRISA0 = 1; // pin 17 input select ps/2 device (0-keyboard, 1-mouse)
    TRISA4 = 1; // pin 3 input PS/2 CLK and T0CKI
    TRISA3 = 1; // pin 2 input PS/2 DATA
    
    PORTA = 0; // Setup port A
    
    TRISB = 0; // Port B all as output
    PORTB = 0; // Setup port B

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
    
    ps2Data = 0;
    //ps2DataCount = 0;
    ps2WaitCode = 0;
    ps2Down = true;
    ps2NeedEncode = 0;
    ps2DataState = PS2DATA_WAIT;

    delay = 0;
    delayedKey = 0;
    shift_ctrl_alt = 0;
    replaced = 0;
    
    
    T0CS = 1;
    T0SE = 1;
    GIE = 1;
    T0IE = 1;
    PSA = 1;   
    T0IF = 0;
    TMR0 = 255;
    
    sendDataToAltera();
    
    while(1)
    {
        // Key code is received and changed with replaceTwoBytesCodes table.
        if ( ps2DataState == PS2DATA_RECEIVED ) {
                    
            //if ( ps2Device == 0 ) { // keyboard
                
                /****************************************************
                 * 
                 ****************************************************/
                
                calculateBitsFromTable(&shift_ctrl_alt, importantKeys, 6, false);
                
                calculateBitsFromTable(&kempstonMouseEmulatorKeys, kempstonMouseKeys, 6, numLock);

                /****************************************************
                 *  Stuff
                 ****************************************************/
                // kempston mouse emulation (num pad arrows)
                if ( ps2Data == 119 && ps2Down ) {
                    numLock = !numLock; 
                }
                
                // ctrl + alt + delete => RES
                if ( (shift_ctrl_alt & IK_CTRL) > 0 && (shift_ctrl_alt & IK_ALT) > 0 && ps2Data == 31 && ps2Down  ) {                
                    outPorts[8] &= 253;
                } else {
                    outPorts[8] |= 2;
                }
                
                // ctrl + scroll lock => NMI
                if ( (shift_ctrl_alt & IK_CTRL) > 0 && ps2Data == 126 && ps2Down ) {  
                    outPorts[8] &= 251;                    
                } else {
                    outPorts[8] |= 4;  
                }
                
                /****************************************************
                 *  Main logic
                 ****************************************************/
                
                // replace data if shift down for some keys in replaceOnShiftKeyDown table            
                for(int8_t i = 0; i < 41 ;i+=2) {
                    if ( ps2Data == replaceOnShiftKeyDown[i] ) {
                        if ( (((shift_ctrl_alt & IK_SHIFT) > 0) && replaced == 0) || replaced == ps2Data) {
                            if ( ps2Down ) replaced = ps2Data;
                            else replaced = 0;
                            ps2Data = replaceOnShiftKeyDown[i+1];
                        } else {
                            if ( replaced != 0 ) ps2Data = 0; // Ignore this key
                        }
                        break;
                    }
                }

                // Dalayed keys ( Del, [, ], {, }, ~ )
                // Those symbols intered by sequence : CS and SS both on ... delay ... key code on ... delay ... CS or SS off.
                for(int8_t i = 0; i < 8; i++) {
                    if ( ps2Data == replaceOnDelayKeyDown[i] && ps2Down ) { 
                        if ( delay == 0 ) {
                            delayedKey = ps2Data;
                            delay = 2600;
                            ps2Data = 111; // CS + SS key
                        } else {
                            ps2Data = 0;
                        }                    
                        break;
                    }
                }
 
                /****************************************************
                 * 
                 ****************************************************/
                
                updateKey(ps2Data, ps2Down ); // ps2Down when key is down, else is up

                // send data to altera registers
                sendDataToAltera();
                
            //} else if ( ps2Device == 1 ) { // mouse
                
                
                
            //}
            
            // wait new data
            ps2Data = 0;
            //ps2DataCount = 0;
            ps2WaitCode = 0;
            ps2Down = true;
            ps2NeedEncode = 0;
            ps2DataState = PS2DATA_WAIT;
            
            
                
        } else if ( delay != 0 ) {
            
            delay--;
            if ( delay == 0 ) {

                updatePort(0x00, false); // caps shift reset
                //updatePort(0x0F, false); // or symbol shift 
                sendDataToAltera();
                
            } else if ( delay == 1300 ) {
                    
                updateKey(delayedKey, true );
                delayedKey = 0;    
                sendDataToAltera();
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
                
                sendDataToAltera();

                kempstonMouseEmulatorDelay = 0;
            }
            
        }
        
        CLRWDT();       
    }
    
}
