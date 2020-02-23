/*
 * File:   main.c
 * Author: fomonster
 * e-mail: fomonster@gmail.com
 * ZX Spectrum PS/2 keyboard reader for pic16f84a powered by Z-Controller
 * 
 * used info:
 * http://pcbheaven.com/wikipages/The_PS2_protocol/
 * https://youtu.be/vfIiLE0BhE8?t=204
 * http://www.piclist.com/techref/microchip/io/dev/keyboard/ps2-jc.htm
 * https://www.youtube.com/watch?v=A1YSbLnm4_o
 * 
 * keyboard do not need init
 *    read scan keys
 * mouse init after 2 seconds by sending FF (reset) 
 *    wait answer (AA 00) in 1 seconds if no then repeat FF(reset) 2 times
 *    set mouse streaming mode by sending F4
 *    read coords and mouse keys
 */

#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>         /* For uint8_t definition */
#include <stdbool.h>       /* For true/false definition */

#define _XTAL_FREQ 8000000
//#define _XTAL_FREQ 4000000

#include <pic16f628a.h>
#include "ps2tozxtable.h"

// In TL866 just set LVP, FOSC2, BODEN

// Configuration bits. Unkomment if need, my programmer tl866 not work with it. Works manual set. If you have pickit you must use it.

// FOSC_ECIO
//__CONFIG( FOSC_ECIO & WDTE_OFF & PWRTE_OFF & MCLRE_OFF & BOREN_OFF & LVP_OFF & CPD_OFF & CP_OFF);

// CONFIG 
/*#pragma config FOSC = INTOSCIO // Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN) 
//#pragma config FOSC = ECIO //
#pragma config WDTE = OFF  // Watchdog Timer Enable bit (WDT disabled) 
#pragma config PWRTE = OFF  // Power-up Timer Enable bit (PWRT disabled) 
#pragma config MCLRE = OFF  // RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is digital input, MCLR internally tied to VDD) 
#pragma config BOREN = OFF  // Brown-out Detect Enable bit (BOD disabled) 
#pragma config LVP = OFF  // Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming) 
#pragma config CPD = OFF  // Data EE Memory Code Protection bit (Data memory code protection off) 
#pragma config CP = OFF   // Flash Program Memory Code Protection bit (Code protection off) 
*/

/*******************************************************************************
    User Global Variable Declaration                                            
*******************************************************************************/
// trisa 
//    TRISA0 = 1; // RA0 pin 17 input select ps/2 device (0-keyboard, 1-mouse)    
//    TRISA1 = 0; // RA1 pin 18 output RESTRIG to ALTERA  
//    TRISA2 = 0; // RA2 pin 1 output STROBE to ALTERA
//    TRISA3 = 1; // RA3 pin 2 input PS/2 DATA
//    TRISA4 = 1; // RA4 pin 3 input PS/2 CLK and T0CKI
//    TRISA5 = 1;
//    TRISA6 = 1;
//    TRISA7 = 1;
#define TRISA_RECEIVE 0b11111001
#define TRISA_RECEIVE_A 0b11111000
#define TRISA_SEND 0b11110000
#define TRISA_SEND_BEGIN 0b11100000

// ps2 receiver data
#define DEVICE RA0 // PORTAbits.RA0
#define CLOCK RA4 // PORTAbits.RA4
#define DATA RA3 // PORTAbits.RA3

// ps2 receiver states
#define PS2DATA_WAIT 0 // wait something input 
#define PS2DATA_RECEIVING 1 // read in progress
#define PS2DATA_SENDING 2 // data sending in progess
static uint8_t ps2DataState = PS2DATA_WAIT;

#define DEVICE_MODE_UNKNOWN 0
#define DEVICE_MODE_KEYBOARD 1
#define DEVICE_MODE_MOUSE 2
#define DEVICE_MODE_LOGIC 3

// data mast zero for every received byte
static uint8_t ps2Bits = 0;
static uint8_t ps2Parity = 0;
static uint8_t ps2BitsCount = 0;
static uint8_t ps2Device = 0; // 0 - deviceA, 1 - deviceB 
static uint8_t ps2DeviceMain = 3; 

// 
struct PS2DeviceData 
{
    uint8_t deviceMode;
    uint8_t ps2Down;
    uint8_t ps2NeedEncode;

    uint8_t inDataPos; 
    uint8_t readDataPos;  
    uint8_t inData[8];
};

static uint16_t deviceLogicDelay = 0;
static uint8_t deviceLogicIndex = 0;
static uint8_t deviceLogicCommand = 0;
static uint8_t deviceLogicState = 0;
static uint8_t deviceLogicDevice = 0;

static struct PS2DeviceData devices[2];

// ALTERA ports data 
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
static uint16_t kempstonMouseCounterA = 0;
static uint8_t kempstonMouseCounterB = 0;
static uint8_t kempstonMouseCounterC = 0;

// temp
static uint8_t needSave = false;
static uint8_t numLock = false;
static uint8_t shift_ctrl_alt = 0; // when shift , ctrl , alt keys pressed
static uint8_t replaced = 0; // != 0 when key replacement with shift down

static uint8_t delayedKey = 0; // dalayed key code

/*******************************************************************************
 Tools
*******************************************************************************/

/*******************************************************************************
    PS2 device to host receiver and particulary host to device transmitter code
*******************************************************************************/

void __interrupt(high_priority) myIsr(void)
{
    if(T0IE && T0IF){        
        if ( ps2DataState == PS2DATA_SENDING ) {
            
            if ( ps2BitsCount < 8 ) { // 1,2,3,4,5,6,7,8 - data bits
                DATA = ps2Bits & 1;
                ps2Parity ^= ps2Bits & 1;
                ps2Bits >>= 1;
            } else if (ps2BitsCount == 8 ) {                
                DATA = ps2Parity;
            } else {
                TRISA = TRISA_RECEIVE;
                ps2DataState = PS2DATA_WAIT;
            } 
            ps2BitsCount++;

        } else if ( ps2DataState == PS2DATA_RECEIVING ) {
            
            //if ( DEVICE != ps2Device ) {
                
            //} else {
                if ( ps2BitsCount < 8 ) { // 1,2,3,4,5,6,7,8 - data bits
                    ps2Bits >>= 1;
                    if ( DATA ) ps2Bits |= 128;                                  
                    ps2BitsCount++;         
                } else if ( ps2BitsCount == 8 ) { // 9 parity bit
                    ps2BitsCount++;       
                } else if ( ps2BitsCount == 9 ) { // 10 stop bit

                    // save data to arrays
                    struct PS2DeviceData* device = &devices[ps2Device];

                    device->inData[device->inDataPos] = ps2Bits;
                    device->inDataPos = (device->inDataPos+1) & 7;

                    ps2DataState = PS2DATA_WAIT;
                    TRISA = TRISA_RECEIVE;
                }
            //}
        } else if ( ps2DataState == PS2DATA_WAIT ) {
            if ( !CLOCK && !DATA ) { // 0 start bit - PORTAbits.RA4 (clk) is low and PORTAbits.RA3 (data) is low
                ps2BitsCount = 0;
                ps2Bits = 0;
                ps2DataState = PS2DATA_RECEIVING;
                ps2Device = DEVICE;
                TRISA = TRISA_RECEIVE_A;//;
                DEVICE = ps2Device;
            }            
        }        
        T0IF=0;
        TMR0 = 255;
    } else { // other interrupt not used
        
    }
}

/*******************************************************************************
    PS2 host to device transmitter
*******************************************************************************/

void send(uint8_t device, uint8_t byte)
{       
    // disable interrupts
    T0IE = 0;
    
    // Enable interrupts and send mode    
    ps2Bits = byte;
    
    ps2Parity = 1;
    ps2BitsCount = 0;
    ps2DataState = PS2DATA_SENDING;
    
    
    
    // init sending
    DATA = 1;
    TRISA = TRISA_SEND_BEGIN; 
    DEVICE = device;
    DATA = 1;
    CLOCK = 0; // Bring the Clock line low for at least 100 microseconds:
    __delay_us(100);
    DATA = 0; // Bring the Data line low:
    //CLOCK = 1;
    TRISA = TRISA_SEND; // CLK is input
    TMR0 = 255;
    T0IF = 0;
    T0IE = 1;

    //  Wait for the keyboard to respond (wait for the device to bring the Clock line low)
    for(uint8_t i = 0; i < 10;i++ ) {
        for(uint8_t j = 0; j < 10;j++ ) {
            __delay_us(10);
            if ( ps2DataState == PS2DATA_WAIT ) break;
        }
        if ( ps2DataState == PS2DATA_WAIT ) break;
    }    
    //    
    __delay_us(10);    
}

/*******************************************************************************
 ALTERA data tools
*******************************************************************************/

// Set port bit
void updatePort(uint8_t bit_id, uint8_t set)
{
    uint8_t a = (1 << ((bit_id >> 3) & 7));
    if ( set ) outPorts[bit_id & 7] |= a;
    else outPorts[bit_id & 7] &= ~a;
}

// Needed for capslock, ctrl, alt and mouse keys
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

// Update key by key code
void updateKey(uint8_t key, uint8_t down) // true when down
{   
    uint8_t code = 0xFF;
    uint8_t localShift = (((shift_ctrl_alt & IK_SHIFT) > 0) && replaced == 0); // All replaced keys is when shift pressed  
    uint8_t localCtrl = (shift_ctrl_alt & IK_CTRL) > 0;
    if ( key < 128 ) code = codeToMatrix[key];
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

// temp
void myDelay()
{ 
}

// Send data to Altera
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

void processKeyCode(uint8_t keyCode, uint8_t keyDown)
{
    if ( keyCode > 127 ) return;
    //****************************************************
    // bits registers mouse and shifts

    calculateBitsFromTable(&keyCode, &keyDown, &shift_ctrl_alt, importantKeys, 6, false);

    calculateBitsFromTable(&keyCode, &keyDown, &kempstonMouseEmulatorKeys, kempstonMouseKeys, 6, numLock);

    //****************************************************
    // stuff

    // kempston mouse emulation (num pad arrows)
    if ( keyCode == 119 && keyDown ) {
        numLock = !numLock; 
    }

    // ctrl + alt + delete => RES
    if ( (shift_ctrl_alt & IK_CTRL) > 0 && (shift_ctrl_alt & IK_ALT) > 0 && keyCode == 31 && keyDown  ) {                
        outPorts[8] &= 251;
    } else {
        outPorts[8] |= 4;
    }

    // ctrl + scroll lock => NMI
    if ( (shift_ctrl_alt & IK_CTRL) > 0 && keyCode == 126 && keyDown ) {  
        outPorts[8] &= 247;                    
    } else {
        outPorts[8] |= 8;  
    }

    //****************************************************
    //  Main logic

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

    // Delayed keys ( Del, [, ], {, }, ~ )
    // Those symbols intered by sequence : CS and SS both on ... delay ... key code on ... delay ... CS or SS off.
    for(int8_t i = 0; i < 8; i++) {
        if ( keyCode == replaceOnDelayKeyDown[i] ) {
            if ( keyDown ) {
                if ( delay == 0 ) {
                    delayedKey = keyCode;
                    delay = 400; //2600;
                    keyCode = 111; // CS + SS key
                } else {
                    keyCode = 0;
                }                    
                break;
            } else {
                //updateKey(keyCode, false );
            }
        }
    }

    //****************************************************

    updateKey(keyCode, keyDown ); 

}
/*******************************************************************************
    PS2DeviceData code
*******************************************************************************/

void deviceDataInit(struct PS2DeviceData* device)
{   
    device->ps2Down = true;
    device->ps2NeedEncode = 0;
    device->readDataPos = 0;
    device->inDataPos = 0;
    device->deviceMode = DEVICE_MODE_UNKNOWN;    
}


void deviceDataUpdateKeyboard(struct PS2DeviceData* device)
{
    if ( device->readDataPos == device->inDataPos  ) return;
    uint8_t code = device->inData[device->readDataPos];
    device->readDataPos = (device->readDataPos + 1) & 7;

    if ( device->ps2NeedEncode ) {
        for (int8_t i=0; i < 27; i+=2) {
            if ( code == replaceTwoBytesCodes[i] ) {
                code = replaceTwoBytesCodes[i+1];
                break;
            }
        }                   
    } else {                    
        code = ( code == 131 ) ? 63 : code; // F7 feature
    }
    if ( code == 0xF0 ) {
        device->ps2Down = false;
    } else if ( code == 0xE0 ) {
        device->ps2NeedEncode = 1;
    } else {
        processKeyCode(code, device->ps2Down);
        needSave = true;
        device->ps2Down = true;
        device->ps2NeedEncode = 0;
    }

}

void deviceDataUpdateMouse(struct PS2DeviceData* device)
{    
    if ( device->inDataPos == kempstonMouseCounterB ) {        
        kempstonMouseCounterA++;
        return;
    }
    kempstonMouseCounterB = device->inDataPos;
    
    if ( kempstonMouseCounterA > 10 ) {
        device->readDataPos = ( device->inDataPos - 1 ) & 7;
        kempstonMouseCounterC = 0;
    }
    kempstonMouseCounterA = 0;
    
    kempstonMouseCounterC++;
    if ( kempstonMouseCounterC < 3 ) return;
    
    uint8_t code = device->inData[device->readDataPos];
    device->readDataPos = (device->readDataPos + 1) & 7;
        
    if ( (code & 1) > 0 ) {
        outPorts[8] &= 254;
    } else {
        outPorts[8] |= 1;
    }
    
    if ( (code & 2) > 0 ) {
        outPorts[8] &= 253;
    } else {
        outPorts[8] |= 2;
    }

    outPorts[9] += device->inData[device->readDataPos];
    device->readDataPos = (device->readDataPos + 1) & 7;
    
    outPorts[10] += device->inData[device->readDataPos];
    device->readDataPos = (device->readDataPos + 1) & 7;
 
    kempstonMouseCounterC -= 3;
    for(uint8_t j = 0; j < 8; j++) outPorts[j] = 0;
    needSave = true;
}

/*******************************************************************************
    Main program
*******************************************************************************/
void main(void)
{    
    // receiver init
    deviceDataInit(&devices[0]);
    deviceDataInit(&devices[1]);
    
    // 
    for(int8_t i=0;i<8;i++) {
        outPorts[i] = 0;
    }
    outPorts[8] = 0xFF; //
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
    nRBPU = 1; // pull-up resistors disabled
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
    TRISA = TRISA_RECEIVE;
    PORTA = 0; // Setup port A
    
    // PORT
    TRISB = 0; // Port B all as output
    PORTB = 0xFF; // Setup port B

    //
    delay = 0;
    delayedKey = 0;
    shift_ctrl_alt = 0;
    replaced = 0;

    deviceLogicDelay = 0;
    deviceLogicIndex = 0;
    deviceLogicState = 0;    
    deviceLogicDevice = 3;
    
    kempstonMouseCounterA = 0;
    kempstonMouseCounterB = 0;
    kempstonMouseCounterC = 0;
    
    uint8_t code;
    
    sendDataToAltera();
    
    while(1)
    {        
        needSave = false;
        
        for(uint8_t i = 0; i < 2; i++) {
            struct PS2DeviceData* device = &devices[i];
            
            if ( device->readDataPos != device->inDataPos && device->inData[device->readDataPos] == 0xaa ) {
                device->deviceMode = DEVICE_MODE_LOGIC;
            }
            
            if ( device->deviceMode == DEVICE_MODE_KEYBOARD ) {
                deviceDataUpdateKeyboard(device);
            } else if ( device->deviceMode == DEVICE_MODE_MOUSE ) {
                deviceDataUpdateMouse(device);
            } else if ( device->deviceMode == DEVICE_MODE_LOGIC && (deviceLogicDevice == 3 || deviceLogicDevice == i) ) {
                
                deviceLogicDelay++;
                if ( deviceLogicDelay > 333 ) {

                    // read code from device
                    if ( device->readDataPos != device->inDataPos ) {
                        code = device->inData[device->readDataPos];
                        device->readDataPos = (device->readDataPos + 1) & 7;
                    } else code = 0xff;
                    
                    
                    if ( deviceLogicState == 0 ) { // assign device to logic

                        if ( deviceLogicDevice == 3 ) {
                            deviceLogicDevice = i;
                            deviceLogicIndex = 0;
                            deviceLogicState = 1; 
                        }

                    } else if ( deviceLogicState == 1 ) { // send and wait command
                            
                        deviceLogicCommand = deviceLogic[deviceLogicIndex];
                        if (deviceLogicCommand == 0xaa ) { // stop
                            if ( deviceLogicIndex == deviceLogicMax - 1 ) {
                                device->deviceMode = DEVICE_MODE_MOUSE;
                                kempstonMouseCounterA = 255;
                            } else {
                                ps2DeviceMain = i;
                                device->deviceMode = DEVICE_MODE_KEYBOARD;
                                for(uint8_t j = 0; j < 8; j++) outPorts[j] = 0;
                            }
                            deviceLogicState = 0;
                            deviceLogicDevice = 3;
                            break;
                        }
                        send(deviceLogicDevice, deviceLogicCommand);
                        deviceLogicState = 2;
                                
                    } else if ( deviceLogicState == 2 ) { // read answer
 
                        if ( code == 0xfe || code == 0xfc ) { // If error resend
                            deviceLogicState = 1; // resend message
                        } else /*if ( code == 0xfa )*/ { // all ok go to next
                            deviceLogicState = 3;
                        }
                        
                    } else if ( deviceLogicState == 3 ) { //

                        
                        // 
                        if ( deviceLogicCommand == 0xf2 ) { // 
                            if ( code == 0x83 ) {
                                // keyboard
                            } else if ( code == 0x00 || code == 0x03 ) {
                                // mouse
                                deviceLogicIndex = deviceLogicMouseIndex - 1; // hardcode!!!
                            }
                        } else if ( deviceLogicCommand == 0xff ) { // 
                            if ( code != 0xaa ) {
                                break;
                            }
                        }
                        
                        deviceLogicIndex++;
                        deviceLogicState = 1;
                    }
                    
                    deviceLogicDelay = 0;
                }
                
                break;                
            } else {
                device->readDataPos = device->inDataPos;
            }
        }

        if ( delay != 0 ) {
            
            delay--;
            if ( delay == 0 ) {

                updatePort(0x00, false); // caps shift reset
                //updatePort(0x0F, false); // or symbol shift 
                needSave = true;
            } else if ( delay == 200 /*1500*/ ) {
                    
                updateKey(delayedKey, true );
                delayedKey = 0;    
                needSave = true;
                
            }
            
        }
        
        kempstonMouseEmulatorDelay++;
        if ( kempstonMouseEmulatorDelay > 333 && numLock ) {

            if ( (kempstonMouseEmulatorKeys & IK_LEFT) > 0 ) outPorts[9]-=1;
            if ( (kempstonMouseEmulatorKeys & IK_RIGHT) > 0 ) outPorts[9]+=1;
            if ( (kempstonMouseEmulatorKeys & IK_UP) > 0 ) outPorts[10]+=1;
            if ( (kempstonMouseEmulatorKeys & IK_DOWN) > 0 ) outPorts[10]-=1;
            if ( (kempstonMouseEmulatorKeys & IK_FIRE) > 0 ) outPorts[8] &= 254;
            else outPorts[8] |= 1;  
                
            kempstonMouseEmulatorDelay = 0;                
            needSave = true;
        }
        
        if ( needSave) {
            sendDataToAltera();
        }
        
        CLRWDT();       
    }
    
}
