# 1 "main.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "main.c" 2
# 21 "main.c"
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\xc.h" 1 3
# 18 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\xc.h" 3
extern const char __xc8_OPTIM_SPEED;

extern double __fpnormalize(double);



# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\xc8debug.h" 1 3
# 13 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\xc8debug.h" 3
#pragma intrinsic(__builtin_software_breakpoint)
extern void __builtin_software_breakpoint(void);
# 23 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\xc.h" 2 3




# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 1 3




# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\htc.h" 1 3



# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\xc.h" 1 3
# 4 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\htc.h" 2 3
# 5 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 2 3








# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic_chip_select.h" 1 3
# 2143 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic_chip_select.h" 3
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 1 3
# 44 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\__at.h" 1 3
# 44 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 2 3








extern volatile unsigned char INDF __attribute__((address(0x000)));

__asm("INDF equ 00h");




extern volatile unsigned char TMR0 __attribute__((address(0x001)));

__asm("TMR0 equ 01h");




extern volatile unsigned char PCL __attribute__((address(0x002)));

__asm("PCL equ 02h");




extern volatile unsigned char STATUS __attribute__((address(0x003)));

__asm("STATUS equ 03h");


typedef union {
    struct {
        unsigned C :1;
        unsigned DC :1;
        unsigned Z :1;
        unsigned nPD :1;
        unsigned nTO :1;
        unsigned RP :2;
        unsigned IRP :1;
    };
    struct {
        unsigned :5;
        unsigned RP0 :1;
        unsigned RP1 :1;
    };
    struct {
        unsigned CARRY :1;
        unsigned :1;
        unsigned ZERO :1;
    };
} STATUSbits_t;
extern volatile STATUSbits_t STATUSbits __attribute__((address(0x003)));
# 159 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char FSR __attribute__((address(0x004)));

__asm("FSR equ 04h");




extern volatile unsigned char PORTA __attribute__((address(0x005)));

__asm("PORTA equ 05h");


typedef union {
    struct {
        unsigned RA0 :1;
        unsigned RA1 :1;
        unsigned RA2 :1;
        unsigned RA3 :1;
        unsigned RA4 :1;
        unsigned RA5 :1;
        unsigned RA6 :1;
        unsigned RA7 :1;
    };
} PORTAbits_t;
extern volatile PORTAbits_t PORTAbits __attribute__((address(0x005)));
# 228 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char PORTB __attribute__((address(0x006)));

__asm("PORTB equ 06h");


typedef union {
    struct {
        unsigned RB0 :1;
        unsigned RB1 :1;
        unsigned RB2 :1;
        unsigned RB3 :1;
        unsigned RB4 :1;
        unsigned RB5 :1;
        unsigned RB6 :1;
        unsigned RB7 :1;
    };
} PORTBbits_t;
extern volatile PORTBbits_t PORTBbits __attribute__((address(0x006)));
# 290 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char PCLATH __attribute__((address(0x00A)));

__asm("PCLATH equ 0Ah");


typedef union {
    struct {
        unsigned PCLATH :5;
    };
} PCLATHbits_t;
extern volatile PCLATHbits_t PCLATHbits __attribute__((address(0x00A)));
# 310 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char INTCON __attribute__((address(0x00B)));

__asm("INTCON equ 0Bh");


typedef union {
    struct {
        unsigned RBIF :1;
        unsigned INTF :1;
        unsigned T0IF :1;
        unsigned RBIE :1;
        unsigned INTE :1;
        unsigned T0IE :1;
        unsigned PEIE :1;
        unsigned GIE :1;
    };
    struct {
        unsigned :2;
        unsigned TMR0IF :1;
        unsigned :2;
        unsigned TMR0IE :1;
    };
} INTCONbits_t;
extern volatile INTCONbits_t INTCONbits __attribute__((address(0x00B)));
# 388 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char PIR1 __attribute__((address(0x00C)));

__asm("PIR1 equ 0Ch");


typedef union {
    struct {
        unsigned TMR1IF :1;
        unsigned TMR2IF :1;
        unsigned CCP1IF :1;
        unsigned :1;
        unsigned TXIF :1;
        unsigned RCIF :1;
        unsigned CMIF :1;
        unsigned EEIF :1;
    };
} PIR1bits_t;
extern volatile PIR1bits_t PIR1bits __attribute__((address(0x00C)));
# 445 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned short TMR1 __attribute__((address(0x00E)));

__asm("TMR1 equ 0Eh");




extern volatile unsigned char TMR1L __attribute__((address(0x00E)));

__asm("TMR1L equ 0Eh");




extern volatile unsigned char TMR1H __attribute__((address(0x00F)));

__asm("TMR1H equ 0Fh");




extern volatile unsigned char T1CON __attribute__((address(0x010)));

__asm("T1CON equ 010h");


typedef union {
    struct {
        unsigned TMR1ON :1;
        unsigned TMR1CS :1;
        unsigned nT1SYNC :1;
        unsigned T1OSCEN :1;
        unsigned T1CKPS :2;
    };
    struct {
        unsigned :4;
        unsigned T1CKPS0 :1;
        unsigned T1CKPS1 :1;
    };
} T1CONbits_t;
extern volatile T1CONbits_t T1CONbits __attribute__((address(0x010)));
# 525 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char TMR2 __attribute__((address(0x011)));

__asm("TMR2 equ 011h");




extern volatile unsigned char T2CON __attribute__((address(0x012)));

__asm("T2CON equ 012h");


typedef union {
    struct {
        unsigned T2CKPS :2;
        unsigned TMR2ON :1;
        unsigned TOUTPS :4;
    };
    struct {
        unsigned T2CKPS0 :1;
        unsigned T2CKPS1 :1;
        unsigned :1;
        unsigned TOUTPS0 :1;
        unsigned TOUTPS1 :1;
        unsigned TOUTPS2 :1;
        unsigned TOUTPS3 :1;
    };
} T2CONbits_t;
extern volatile T2CONbits_t T2CONbits __attribute__((address(0x012)));
# 603 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned short CCPR1 __attribute__((address(0x015)));

__asm("CCPR1 equ 015h");




extern volatile unsigned char CCPR1L __attribute__((address(0x015)));

__asm("CCPR1L equ 015h");




extern volatile unsigned char CCPR1H __attribute__((address(0x016)));

__asm("CCPR1H equ 016h");




extern volatile unsigned char CCP1CON __attribute__((address(0x017)));

__asm("CCP1CON equ 017h");


typedef union {
    struct {
        unsigned CCP1M :4;
        unsigned CCP1Y :1;
        unsigned CCP1X :1;
    };
    struct {
        unsigned CCP1M0 :1;
        unsigned CCP1M1 :1;
        unsigned CCP1M2 :1;
        unsigned CCP1M3 :1;
    };
} CCP1CONbits_t;
extern volatile CCP1CONbits_t CCP1CONbits __attribute__((address(0x017)));
# 682 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char RCSTA __attribute__((address(0x018)));

__asm("RCSTA equ 018h");


typedef union {
    struct {
        unsigned RX9D :1;
        unsigned OERR :1;
        unsigned FERR :1;
        unsigned ADEN :1;
        unsigned CREN :1;
        unsigned SREN :1;
        unsigned RX9 :1;
        unsigned SPEN :1;
    };
    struct {
        unsigned :3;
        unsigned ADDEN :1;
    };
} RCSTAbits_t;
extern volatile RCSTAbits_t RCSTAbits __attribute__((address(0x018)));
# 753 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char TXREG __attribute__((address(0x019)));

__asm("TXREG equ 019h");




extern volatile unsigned char RCREG __attribute__((address(0x01A)));

__asm("RCREG equ 01Ah");




extern volatile unsigned char CMCON __attribute__((address(0x01F)));

__asm("CMCON equ 01Fh");


typedef union {
    struct {
        unsigned CM :3;
        unsigned CIS :1;
        unsigned C1INV :1;
        unsigned C2INV :1;
        unsigned C1OUT :1;
        unsigned C2OUT :1;
    };
    struct {
        unsigned CM0 :1;
        unsigned CM1 :1;
        unsigned CM2 :1;
    };
} CMCONbits_t;
extern volatile CMCONbits_t CMCONbits __attribute__((address(0x01F)));
# 837 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char OPTION_REG __attribute__((address(0x081)));

__asm("OPTION_REG equ 081h");


typedef union {
    struct {
        unsigned PS :3;
        unsigned PSA :1;
        unsigned T0SE :1;
        unsigned T0CS :1;
        unsigned INTEDG :1;
        unsigned nRBPU :1;
    };
    struct {
        unsigned PS0 :1;
        unsigned PS1 :1;
        unsigned PS2 :1;
    };
} OPTION_REGbits_t;
extern volatile OPTION_REGbits_t OPTION_REGbits __attribute__((address(0x081)));
# 907 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char TRISA __attribute__((address(0x085)));

__asm("TRISA equ 085h");


typedef union {
    struct {
        unsigned TRISA0 :1;
        unsigned TRISA1 :1;
        unsigned TRISA2 :1;
        unsigned TRISA3 :1;
        unsigned TRISA4 :1;
        unsigned TRISA5 :1;
        unsigned TRISA6 :1;
        unsigned TRISA7 :1;
    };
} TRISAbits_t;
extern volatile TRISAbits_t TRISAbits __attribute__((address(0x085)));
# 969 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char TRISB __attribute__((address(0x086)));

__asm("TRISB equ 086h");


typedef union {
    struct {
        unsigned TRISB0 :1;
        unsigned TRISB1 :1;
        unsigned TRISB2 :1;
        unsigned TRISB3 :1;
        unsigned TRISB4 :1;
        unsigned TRISB5 :1;
        unsigned TRISB6 :1;
        unsigned TRISB7 :1;
    };
} TRISBbits_t;
extern volatile TRISBbits_t TRISBbits __attribute__((address(0x086)));
# 1031 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char PIE1 __attribute__((address(0x08C)));

__asm("PIE1 equ 08Ch");


typedef union {
    struct {
        unsigned TMR1IE :1;
        unsigned TMR2IE :1;
        unsigned CCP1IE :1;
        unsigned :1;
        unsigned TXIE :1;
        unsigned RCIE :1;
        unsigned CMIE :1;
        unsigned EEIE :1;
    };
} PIE1bits_t;
extern volatile PIE1bits_t PIE1bits __attribute__((address(0x08C)));
# 1088 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char PCON __attribute__((address(0x08E)));

__asm("PCON equ 08Eh");


typedef union {
    struct {
        unsigned nBOR :1;
        unsigned nPOR :1;
        unsigned :1;
        unsigned OSCF :1;
    };
    struct {
        unsigned nBO :1;
    };
    struct {
        unsigned nBOD :1;
    };
} PCONbits_t;
extern volatile PCONbits_t PCONbits __attribute__((address(0x08E)));
# 1137 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char PR2 __attribute__((address(0x092)));

__asm("PR2 equ 092h");




extern volatile unsigned char TXSTA __attribute__((address(0x098)));

__asm("TXSTA equ 098h");


typedef union {
    struct {
        unsigned TX9D :1;
        unsigned TRMT :1;
        unsigned BRGH :1;
        unsigned :1;
        unsigned SYNC :1;
        unsigned TXEN :1;
        unsigned TX9 :1;
        unsigned CSRC :1;
    };
} TXSTAbits_t;
extern volatile TXSTAbits_t TXSTAbits __attribute__((address(0x098)));
# 1201 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char SPBRG __attribute__((address(0x099)));

__asm("SPBRG equ 099h");




extern volatile unsigned char EEDATA __attribute__((address(0x09A)));

__asm("EEDATA equ 09Ah");




extern volatile unsigned char EEADR __attribute__((address(0x09B)));

__asm("EEADR equ 09Bh");




extern volatile unsigned char EECON1 __attribute__((address(0x09C)));

__asm("EECON1 equ 09Ch");


typedef union {
    struct {
        unsigned RD :1;
        unsigned WR :1;
        unsigned WREN :1;
        unsigned WRERR :1;
    };
} EECON1bits_t;
extern volatile EECON1bits_t EECON1bits __attribute__((address(0x09C)));
# 1260 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile unsigned char EECON2 __attribute__((address(0x09D)));

__asm("EECON2 equ 09Dh");




extern volatile unsigned char VRCON __attribute__((address(0x09F)));

__asm("VRCON equ 09Fh");


typedef union {
    struct {
        unsigned VR :4;
        unsigned :1;
        unsigned VRR :1;
        unsigned VROE :1;
        unsigned VREN :1;
    };
    struct {
        unsigned VR0 :1;
        unsigned VR1 :1;
        unsigned VR2 :1;
        unsigned VR3 :1;
    };
} VRCONbits_t;
extern volatile VRCONbits_t VRCONbits __attribute__((address(0x09F)));
# 1338 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f628a.h" 3
extern volatile __bit ADDEN __attribute__((address(0xC3)));


extern volatile __bit ADEN __attribute__((address(0xC3)));


extern volatile __bit BRGH __attribute__((address(0x4C2)));


extern volatile __bit C1INV __attribute__((address(0xFC)));


extern volatile __bit C1OUT __attribute__((address(0xFE)));


extern volatile __bit C2INV __attribute__((address(0xFD)));


extern volatile __bit C2OUT __attribute__((address(0xFF)));


extern volatile __bit CARRY __attribute__((address(0x18)));


extern volatile __bit CCP1IE __attribute__((address(0x462)));


extern volatile __bit CCP1IF __attribute__((address(0x62)));


extern volatile __bit CCP1M0 __attribute__((address(0xB8)));


extern volatile __bit CCP1M1 __attribute__((address(0xB9)));


extern volatile __bit CCP1M2 __attribute__((address(0xBA)));


extern volatile __bit CCP1M3 __attribute__((address(0xBB)));


extern volatile __bit CCP1X __attribute__((address(0xBD)));


extern volatile __bit CCP1Y __attribute__((address(0xBC)));


extern volatile __bit CIS __attribute__((address(0xFB)));


extern volatile __bit CM0 __attribute__((address(0xF8)));


extern volatile __bit CM1 __attribute__((address(0xF9)));


extern volatile __bit CM2 __attribute__((address(0xFA)));


extern volatile __bit CMIE __attribute__((address(0x466)));


extern volatile __bit CMIF __attribute__((address(0x66)));


extern volatile __bit CREN __attribute__((address(0xC4)));


extern volatile __bit CSRC __attribute__((address(0x4C7)));


extern volatile __bit DC __attribute__((address(0x19)));


extern volatile __bit EEIE __attribute__((address(0x467)));


extern volatile __bit EEIF __attribute__((address(0x67)));


extern volatile __bit FERR __attribute__((address(0xC2)));


extern volatile __bit GIE __attribute__((address(0x5F)));


extern volatile __bit INTE __attribute__((address(0x5C)));


extern volatile __bit INTEDG __attribute__((address(0x40E)));


extern volatile __bit INTF __attribute__((address(0x59)));


extern volatile __bit IRP __attribute__((address(0x1F)));


extern volatile __bit OERR __attribute__((address(0xC1)));


extern volatile __bit OSCF __attribute__((address(0x473)));


extern volatile __bit PEIE __attribute__((address(0x5E)));


extern volatile __bit PS0 __attribute__((address(0x408)));


extern volatile __bit PS1 __attribute__((address(0x409)));


extern volatile __bit PS2 __attribute__((address(0x40A)));


extern volatile __bit PSA __attribute__((address(0x40B)));


extern volatile __bit RA0 __attribute__((address(0x28)));


extern volatile __bit RA1 __attribute__((address(0x29)));


extern volatile __bit RA2 __attribute__((address(0x2A)));


extern volatile __bit RA3 __attribute__((address(0x2B)));


extern volatile __bit RA4 __attribute__((address(0x2C)));


extern volatile __bit RA5 __attribute__((address(0x2D)));


extern volatile __bit RA6 __attribute__((address(0x2E)));


extern volatile __bit RA7 __attribute__((address(0x2F)));


extern volatile __bit RB0 __attribute__((address(0x30)));


extern volatile __bit RB1 __attribute__((address(0x31)));


extern volatile __bit RB2 __attribute__((address(0x32)));


extern volatile __bit RB3 __attribute__((address(0x33)));


extern volatile __bit RB4 __attribute__((address(0x34)));


extern volatile __bit RB5 __attribute__((address(0x35)));


extern volatile __bit RB6 __attribute__((address(0x36)));


extern volatile __bit RB7 __attribute__((address(0x37)));


extern volatile __bit RBIE __attribute__((address(0x5B)));


extern volatile __bit RBIF __attribute__((address(0x58)));


extern volatile __bit RCIE __attribute__((address(0x465)));


extern volatile __bit RCIF __attribute__((address(0x65)));


extern volatile __bit RD __attribute__((address(0x4E0)));


extern volatile __bit RP0 __attribute__((address(0x1D)));


extern volatile __bit RP1 __attribute__((address(0x1E)));


extern volatile __bit RX9 __attribute__((address(0xC6)));


extern volatile __bit RX9D __attribute__((address(0xC0)));


extern volatile __bit SPEN __attribute__((address(0xC7)));


extern volatile __bit SREN __attribute__((address(0xC5)));


extern volatile __bit SYNC __attribute__((address(0x4C4)));


extern volatile __bit T0CS __attribute__((address(0x40D)));


extern volatile __bit T0IE __attribute__((address(0x5D)));


extern volatile __bit T0IF __attribute__((address(0x5A)));


extern volatile __bit T0SE __attribute__((address(0x40C)));


extern volatile __bit T1CKPS0 __attribute__((address(0x84)));


extern volatile __bit T1CKPS1 __attribute__((address(0x85)));


extern volatile __bit T1OSCEN __attribute__((address(0x83)));


extern volatile __bit T2CKPS0 __attribute__((address(0x90)));


extern volatile __bit T2CKPS1 __attribute__((address(0x91)));


extern volatile __bit TMR0IE __attribute__((address(0x5D)));


extern volatile __bit TMR0IF __attribute__((address(0x5A)));


extern volatile __bit TMR1CS __attribute__((address(0x81)));


extern volatile __bit TMR1IE __attribute__((address(0x460)));


extern volatile __bit TMR1IF __attribute__((address(0x60)));


extern volatile __bit TMR1ON __attribute__((address(0x80)));


extern volatile __bit TMR2IE __attribute__((address(0x461)));


extern volatile __bit TMR2IF __attribute__((address(0x61)));


extern volatile __bit TMR2ON __attribute__((address(0x92)));


extern volatile __bit TOUTPS0 __attribute__((address(0x93)));


extern volatile __bit TOUTPS1 __attribute__((address(0x94)));


extern volatile __bit TOUTPS2 __attribute__((address(0x95)));


extern volatile __bit TOUTPS3 __attribute__((address(0x96)));


extern volatile __bit TRISA0 __attribute__((address(0x428)));


extern volatile __bit TRISA1 __attribute__((address(0x429)));


extern volatile __bit TRISA2 __attribute__((address(0x42A)));


extern volatile __bit TRISA3 __attribute__((address(0x42B)));


extern volatile __bit TRISA4 __attribute__((address(0x42C)));


extern volatile __bit TRISA5 __attribute__((address(0x42D)));


extern volatile __bit TRISA6 __attribute__((address(0x42E)));


extern volatile __bit TRISA7 __attribute__((address(0x42F)));


extern volatile __bit TRISB0 __attribute__((address(0x430)));


extern volatile __bit TRISB1 __attribute__((address(0x431)));


extern volatile __bit TRISB2 __attribute__((address(0x432)));


extern volatile __bit TRISB3 __attribute__((address(0x433)));


extern volatile __bit TRISB4 __attribute__((address(0x434)));


extern volatile __bit TRISB5 __attribute__((address(0x435)));


extern volatile __bit TRISB6 __attribute__((address(0x436)));


extern volatile __bit TRISB7 __attribute__((address(0x437)));


extern volatile __bit TRMT __attribute__((address(0x4C1)));


extern volatile __bit TX9 __attribute__((address(0x4C6)));


extern volatile __bit TX9D __attribute__((address(0x4C0)));


extern volatile __bit TXEN __attribute__((address(0x4C5)));


extern volatile __bit TXIE __attribute__((address(0x464)));


extern volatile __bit TXIF __attribute__((address(0x64)));


extern volatile __bit VR0 __attribute__((address(0x4F8)));


extern volatile __bit VR1 __attribute__((address(0x4F9)));


extern volatile __bit VR2 __attribute__((address(0x4FA)));


extern volatile __bit VR3 __attribute__((address(0x4FB)));


extern volatile __bit VREN __attribute__((address(0x4FF)));


extern volatile __bit VROE __attribute__((address(0x4FE)));


extern volatile __bit VRR __attribute__((address(0x4FD)));


extern volatile __bit WR __attribute__((address(0x4E1)));


extern volatile __bit WREN __attribute__((address(0x4E2)));


extern volatile __bit WRERR __attribute__((address(0x4E3)));


extern volatile __bit ZERO __attribute__((address(0x1A)));


extern volatile __bit nBO __attribute__((address(0x470)));


extern volatile __bit nBOD __attribute__((address(0x470)));


extern volatile __bit nBOR __attribute__((address(0x470)));


extern volatile __bit nPD __attribute__((address(0x1B)));


extern volatile __bit nPOR __attribute__((address(0x471)));


extern volatile __bit nRBPU __attribute__((address(0x40F)));


extern volatile __bit nT1SYNC __attribute__((address(0x82)));


extern volatile __bit nTO __attribute__((address(0x1C)));
# 2143 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic_chip_select.h" 2 3
# 13 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 2 3
# 30 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 3
#pragma intrinsic(__nop)
extern void __nop(void);
# 78 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 3
__attribute__((__unsupported__("The " "FLASH_READ" " macro function is no longer supported. Please use the MPLAB X MCC."))) unsigned char __flash_read(unsigned short addr);

__attribute__((__unsupported__("The " "FLASH_WRITE" " macro function is no longer supported. Please use the MPLAB X MCC."))) void __flash_write(unsigned short addr, unsigned short data);

__attribute__((__unsupported__("The " "FLASH_ERASE" " macro function is no longer supported. Please use the MPLAB X MCC."))) void __flash_erase(unsigned short addr);



# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\eeprom_routines.h" 1 3
# 114 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\eeprom_routines.h" 3
extern void eeprom_write(unsigned char addr, unsigned char value);
extern unsigned char eeprom_read(unsigned char addr);
# 85 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 2 3






#pragma intrinsic(_delay)
extern __attribute__((nonreentrant)) void _delay(unsigned long);
#pragma intrinsic(_delaywdt)
extern __attribute__((nonreentrant)) void _delaywdt(unsigned long);
# 137 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic.h" 3
extern __bank0 unsigned char __resetbits;
extern __bank0 __bit __powerdown;
extern __bank0 __bit __timeout;
# 27 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\xc.h" 2 3
# 21 "main.c" 2

# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 1 3



# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\__size_t.h" 1 3



typedef unsigned size_t;
# 4 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 2 3

# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\__null.h" 1 3
# 5 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 2 3






# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdarg.h" 1 3






typedef void * va_list[1];

#pragma intrinsic(__va_start)
extern void * __va_start(void);

#pragma intrinsic(__va_arg)
extern void * __va_arg(void *, ...);
# 11 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 2 3
# 43 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 3
struct __prbuf
{
 char * ptr;
 void (* func)(char);
};
# 85 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 3
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\conio.h" 1 3







# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\errno.h" 1 3
# 29 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\errno.h" 3
extern int errno;
# 8 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\conio.h" 2 3




extern void init_uart(void);

extern char getch(void);
extern char getche(void);
extern void putch(char);
extern void ungetch(char);

extern __bit kbhit(void);



extern char * cgets(char *);
extern void cputs(const char *);
# 85 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 2 3



extern int cprintf(char *, ...);
#pragma printf_check(cprintf)



extern int _doprnt(struct __prbuf *, const register char *, register va_list);
# 180 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdio.h" 3
#pragma printf_check(vprintf) const
#pragma printf_check(vsprintf) const

extern char * gets(char *);
extern int puts(const char *);
extern int scanf(const char *, ...) __attribute__((unsupported("scanf() is not supported by this compiler")));
extern int sscanf(const char *, const char *, ...) __attribute__((unsupported("sscanf() is not supported by this compiler")));
extern int vprintf(const char *, va_list) __attribute__((unsupported("vprintf() is not supported by this compiler")));
extern int vsprintf(char *, const char *, va_list) __attribute__((unsupported("vsprintf() is not supported by this compiler")));
extern int vscanf(const char *, va_list ap) __attribute__((unsupported("vscanf() is not supported by this compiler")));
extern int vsscanf(const char *, const char *, va_list) __attribute__((unsupported("vsscanf() is not supported by this compiler")));

#pragma printf_check(printf) const
#pragma printf_check(sprintf) const
extern int sprintf(char *, const char *, ...);
extern int printf(const char *, ...);
# 22 "main.c" 2

# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdlib.h" 1 3






typedef unsigned short wchar_t;







typedef struct {
 int rem;
 int quot;
} div_t;
typedef struct {
 unsigned rem;
 unsigned quot;
} udiv_t;
typedef struct {
 long quot;
 long rem;
} ldiv_t;
typedef struct {
 unsigned long quot;
 unsigned long rem;
} uldiv_t;
# 65 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdlib.h" 3
extern double atof(const char *);
extern double strtod(const char *, const char **);
extern int atoi(const char *);
extern unsigned xtoi(const char *);
extern long atol(const char *);



extern long strtol(const char *, char **, int);

extern int rand(void);
extern void srand(unsigned int);
extern void * calloc(size_t, size_t);
extern div_t div(int numer, int denom);
extern udiv_t udiv(unsigned numer, unsigned denom);
extern ldiv_t ldiv(long numer, long denom);
extern uldiv_t uldiv(unsigned long numer,unsigned long denom);



extern unsigned long _lrotl(unsigned long value, unsigned int shift);
extern unsigned long _lrotr(unsigned long value, unsigned int shift);
extern unsigned int _rotl(unsigned int value, unsigned int shift);
extern unsigned int _rotr(unsigned int value, unsigned int shift);




extern void * malloc(size_t);
extern void free(void *);
extern void * realloc(void *, size_t);
# 104 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdlib.h" 3
extern int atexit(void (*)(void));
extern char * getenv(const char *);
extern char ** environ;
extern int system(char *);
extern void qsort(void *, size_t, size_t, int (*)(const void *, const void *));
extern void * bsearch(const void *, void *, size_t, size_t, int(*)(const void *, const void *));
extern int abs(int);
extern long labs(long);

extern char * itoa(char * buf, int val, int base);
extern char * utoa(char * buf, unsigned val, int base);




extern char * ltoa(char * buf, long val, int base);
extern char * ultoa(char * buf, unsigned long val, int base);

extern char * ftoa(float f, int * status);
# 23 "main.c" 2

# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 1 3
# 13 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed char int8_t;






typedef signed int int16_t;
# 36 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed long int int32_t;
# 52 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef unsigned char uint8_t;





typedef unsigned int uint16_t;
# 72 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef unsigned long int uint32_t;
# 88 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed char int_least8_t;







typedef signed int int_least16_t;
# 105 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed long int int_least24_t;
# 118 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed long int int_least32_t;
# 136 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef unsigned char uint_least8_t;






typedef unsigned int uint_least16_t;







typedef unsigned long int uint_least24_t;
# 162 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef unsigned long int uint_least32_t;
# 181 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed char int_fast8_t;






typedef signed int int_fast16_t;







typedef signed long int int_fast24_t;
# 208 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef signed long int int_fast32_t;
# 224 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef unsigned char uint_fast8_t;





typedef unsigned int uint_fast16_t;






typedef unsigned long int uint_fast24_t;
# 247 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef unsigned long int uint_fast32_t;
# 268 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef int32_t intmax_t;
# 282 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdint.h" 3
typedef uint32_t uintmax_t;






typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 24 "main.c" 2

# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdbool.h" 1 3
# 25 "main.c" 2






# 1 "./ps2tozxtable.h" 1
# 14 "./ps2tozxtable.h"
const uint8_t deviceLogicMouseIndex = 3;
const uint8_t deviceLogicMax = 9;
const uint8_t deviceLogic[9] =
{
    0xf2,

    0xff,
    0xaa,

    0xf4,
    0xe8,
    0xf3,
    60,
    0x00,
    0xaa,
};




const uint8_t kempstonMouseKeys[6] =
{

    107,
    116,
    117,
    114,
    115,
    4
};




const uint8_t importantKeys[6] =
{

    18, 89,
    20, 19,
    17, 8
};




const uint8_t replaceOnDelayKeyDown[8] =
{
    31, 84, 91, 99, 100, 101, 72, 93
};




const uint8_t replaceOnShiftKeyDown[42] =
{
    22, 79,
    30, 80,
    38, 81,
    37, 83,
    46, 86,
    54, 87,
    61, 92,
    62, 94,
    70, 95,
    69, 96,
    78, 97,
    85, 98,
    93, 99,
    76, 103,
    82, 104,
    65, 106,
    73, 109,
    74, 110,
    14, 72,
    84, 100,
    91, 101
 };




const uint8_t replaceTwoBytesCodes[28] =
{
    0x11, 8,
    0x14, 19,
    0x70, 23,
    0x6c, 24,
    0x7d, 25,
    0x71, 31,
    0x69, 32,
    0x7a, 39,
    0x75, 40,
    0x6b, 47,
    0x72, 48,
    0x74, 55,
    0x4a, 56,
    0x5a, 57
};





const uint8_t codeToMatrix[128] =
{
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0x9C,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0xFF,
0x2,
0x3,
0xFF,
0xFF,
0xFF,
0x8,
0x9,
0x1,
0xA,
0xB,
0xD6,
0xFF,
0x18,
0x10,
0x11,
0x12,
0x1B,
0x13,
0xFF,
0x5C,
0x7,
0x20,
0x19,
0x22,
0x1A,
0x23,
0x63,
0x64,
0x1F,
0x27,
0x26,
0x21,
0x25,
0x24,
0x54,
0xA0,
0x6,
0x17,
0x1E,
0x1D,
0x1C,
0x14,
0xFF,
0xFF,
0x9F,
0x16,
0x15,
0xD,
0x4,
0xC,
0xFF,
0xC1,
0x97,
0xA0,
0xE,
0x8D,
0x5,
0x9E,
0x83,
0x8B,
0x93,
0x9C,
0x9B,
0xE5,
0x8E,
0xA3,
0xA6,
0x4B,
0xFF,
0x6,
0xDD,
0xA4,
0xD1,
0xA7,
0x94,
0x8C,
0x84,
0x96,
0xC9,
0xD9,
0xE1,
0x44,
0x88,
0x85,
0x3,
0x9A,
0x1B,
0x1C,
0xA2,
0x98,
0xC0,
0x4,
0x97,
0xB,
0x23,
0x24,
0x14,
0x43,
0xFF,
0xFF,
0x96,
0x13,
0x9E,
0xA7,
0xC,
0xFF,
0xFF,
};
# 31 "main.c" 2
# 78 "main.c"
static uint8_t ps2DataState = 0;







static uint8_t ps2Bits = 0;
static uint8_t ps2Parity = 0;
static uint8_t ps2BitsCount = 0;
static uint8_t ps2Device = 0;
static uint8_t ps2DeviceMain = 3;


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


static uint8_t outPorts[11] =
{

    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,

    0x07,

    0xF5,
    0xDA
};

static uint16_t delay = 0;
static uint16_t kempstonMouseEmulatorDelay = 0;
static uint8_t kempstonMouseEmulatorKeys = 0;
static uint16_t kempstonMouseCounterA = 0;
static uint8_t kempstonMouseCounterB = 0;
static uint8_t kempstonMouseCounterC = 0;


static uint8_t needSave = 0;
static uint8_t numLock = 0;
static uint8_t shift_ctrl_alt = 0;
static uint8_t replaced = 0;

static uint8_t delayedKey = 0;
# 154 "main.c"
void __attribute__((picinterrupt("high_priority"))) myIsr(void)
{
    if(T0IE && T0IF){
        if ( ps2DataState == 2 ) {

            if ( ps2BitsCount < 8 ) {
                RA3 = ps2Bits & 1;
                ps2Parity ^= ps2Bits & 1;
                ps2Bits >>= 1;
            } else if (ps2BitsCount == 8 ) {
                RA3 = ps2Parity;
            } else {
                TRISA = 0b11111001;
                ps2DataState = 0;
            }
            ps2BitsCount++;

        } else if ( ps2DataState == 1 ) {




                if ( ps2BitsCount < 8 ) {
                    ps2Bits >>= 1;
                    if ( RA3 ) ps2Bits |= 128;
                    ps2BitsCount++;
                } else if ( ps2BitsCount == 8 ) {
                    ps2BitsCount++;
                } else if ( ps2BitsCount == 9 ) {


                    struct PS2DeviceData* device = &devices[ps2Device];

                    device->inData[device->inDataPos] = ps2Bits;
                    device->inDataPos = (device->inDataPos+1) & 7;

                    ps2DataState = 0;
                    TRISA = 0b11111001;
                }

        } else if ( ps2DataState == 0 ) {
            if ( !RA4 && !RA3 ) {
                ps2BitsCount = 0;
                ps2Bits = 0;
                ps2DataState = 1;
                ps2Device = RA0;
                TRISA = 0b11111000;
                RA0 = ps2Device;
            }
        }
        T0IF=0;
        TMR0 = 255;
    } else {

    }
}





void send(uint8_t device, uint8_t byte)
{

    T0IE = 0;


    ps2Bits = byte;

    ps2Parity = 1;
    ps2BitsCount = 0;
    ps2DataState = 2;




    RA3 = 1;
    TRISA = 0b11100000;
    RA0 = device;
    RA3 = 1;
    RA4 = 0;
    _delay((unsigned long)((100)*(8000000/4000000.0)));
    RA3 = 0;

    TRISA = 0b11110000;
    TMR0 = 255;
    T0IF = 0;
    T0IE = 1;


    for(uint8_t i = 0; i < 10;i++ ) {
        for(uint8_t j = 0; j < 10;j++ ) {
            _delay((unsigned long)((10)*(8000000/4000000.0)));
            if ( ps2DataState == 0 ) break;
        }
        if ( ps2DataState == 0 ) break;
    }

    _delay((unsigned long)((10)*(8000000/4000000.0)));
}






void updatePort(uint8_t bit_id, uint8_t set)
{
    uint8_t a = (1 << ((bit_id >> 3) & 7));
    if ( set ) outPorts[bit_id & 7] |= a;
    else outPorts[bit_id & 7] &= ~a;
}


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


void updateKey(uint8_t key, uint8_t down)
{
    uint8_t code = 0xFF;
    uint8_t localShift = (((shift_ctrl_alt & 3) > 0) && replaced == 0);
    uint8_t localCtrl = (shift_ctrl_alt & 12) > 0;
    if ( key < 128 ) code = codeToMatrix[key];
    if ( code != 0xFF ) {
        updatePort(code, down);
        localShift |= ((code & 64) > 0);
        localCtrl |= ((code & 128) > 0);
    }
    if ( down ) {
        updatePort(0x00, localShift );
        updatePort(0x0F, localCtrl );
    }
}


void myDelay()
{
}


void sendDataToAltera()
{
    RA2 = 1;
    RA1 = 0;
    myDelay();
    RA1 = 1;
    myDelay();
    RA1 = 0;
    myDelay();
    for(int8_t i=0;i<11;i++) {
        RA2 = 1;
        PORTB = i < 8 ? ~outPorts[i] : outPorts[i];
        myDelay();
        RA2 = 0;
        myDelay();
        RA2 = 1;
        myDelay();
    }
    PORTB = 0xFF;
}

void processKeyCode(uint8_t keyCode, uint8_t keyDown)
{
    if ( keyCode > 127 ) return;



    calculateBitsFromTable(&keyCode, &keyDown, &shift_ctrl_alt, importantKeys, 6, 0);

    calculateBitsFromTable(&keyCode, &keyDown, &kempstonMouseEmulatorKeys, kempstonMouseKeys, 6, numLock);





    if ( keyCode == 119 && keyDown ) {
        numLock = !numLock;
    }


    if ( (shift_ctrl_alt & 12) > 0 && (shift_ctrl_alt & 48) > 0 && keyCode == 31 && keyDown ) {
        outPorts[8] &= 251;
    } else {
        outPorts[8] |= 4;
    }


    if ( (shift_ctrl_alt & 12) > 0 && keyCode == 126 && keyDown ) {
        outPorts[8] &= 247;
    } else {
        outPorts[8] |= 8;
    }





    for(int8_t i = 0; i < 41 ;i+=2) {
        if ( keyCode == replaceOnShiftKeyDown[i] ) {
            if ( (((shift_ctrl_alt & 3) > 0) && replaced == 0) || replaced == keyCode) {
                if ( keyDown ) replaced = keyCode;
                else replaced = 0;
                keyCode = replaceOnShiftKeyDown[i+1];
            } else {
                if ( replaced != 0 ) keyCode = 0;
            }
            break;
        }
    }



    for(int8_t i = 0; i < 8; i++) {
        if ( keyCode == replaceOnDelayKeyDown[i] ) {
            if ( keyDown ) {
                if ( delay == 0 ) {
                    delayedKey = keyCode;
                    delay = 400;
                    keyCode = 111;
                } else {
                    keyCode = 0;
                }
                break;
            } else {

            }
        }
    }



    updateKey(keyCode, keyDown );

}




void deviceDataInit(struct PS2DeviceData* device)
{
    device->ps2Down = 1;
    device->ps2NeedEncode = 0;
    device->readDataPos = 0;
    device->inDataPos = 0;
    device->deviceMode = 0;
}


void deviceDataUpdateKeyboard(struct PS2DeviceData* device)
{
    if ( device->readDataPos == device->inDataPos ) return;
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
        code = ( code == 131 ) ? 63 : code;
    }
    if ( code == 0xF0 ) {
        device->ps2Down = 0;
    } else if ( code == 0xE0 ) {
        device->ps2NeedEncode = 1;
    } else {
        processKeyCode(code, device->ps2Down);
        needSave = 1;
        device->ps2Down = 1;
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
    needSave = 1;
}




void main(void)
{

    deviceDataInit(&devices[0]);
    deviceDataInit(&devices[1]);


    for(int8_t i=0;i<8;i++) {
        outPorts[i] = 0;
    }
    outPorts[8] = 0xFF;
    outPorts[9] = 0xF5;
    outPorts[10] = 0xDA;
    sendDataToAltera();




    GIE = 1;
    PEIE = 0;
    T0IE = 1;
    INTE = 0;
    RBIE = 0;
    T0IF = 0;
    INTF = 0;
    RBIF = 0;


    EEIF = 0;
    CMIF = 0;
    RCIF = 0;
    TXIF = 0;
    CCP1IF = 0;
    TMR2IF = 0;
    TMR1IF = 0;


    EEIE = 0;
    CMIE = 0;
    RCIE = 0;
    TXIE = 0;
    CCP1IE = 0;
    TMR2IE = 0;
    TMR1IE = 0;


    nRBPU = 1;
    INTEDG = 0;
    T0CS = 1;
    T0SE = 1;
    PSA = 1;
    PS2 = 0;
    PS1 = 0;
    PS0 = 0;


    TMR0 = 255;
    TMR1L = 0;
    TMR1H = 0;
    TMR2 = 0;
    T1CON = 6;
    CCPR1L = 0;
    CCPR1H = 0;
    CCP1CON = 0;
    CMCON = 7;
    VRCON = 0;
    RCSTA = 0;
    TXSTA = 128;
    SPEN = 0;




    TRISA = 0b11111001;
    PORTA = 0;


    TRISB = 0;
    PORTB = 0xFF;


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
        needSave = 0;

        for(uint8_t i = 0; i < 2; i++) {
            struct PS2DeviceData* device = &devices[i];

            if ( device->readDataPos != device->inDataPos && device->inData[device->readDataPos] == 0xaa ) {
                device->deviceMode = 3;
            }

            if ( device->deviceMode == 1 ) {
                deviceDataUpdateKeyboard(device);
            } else if ( device->deviceMode == 2 ) {
                deviceDataUpdateMouse(device);
            } else if ( device->deviceMode == 3 && (deviceLogicDevice == 3 || deviceLogicDevice == i) ) {

                deviceLogicDelay++;
                if ( deviceLogicDelay > 333 ) {


                    if ( device->readDataPos != device->inDataPos ) {
                        code = device->inData[device->readDataPos];
                        device->readDataPos = (device->readDataPos + 1) & 7;
                    } else code = 0xff;


                    if ( deviceLogicState == 0 ) {

                        if ( deviceLogicDevice == 3 ) {
                            deviceLogicDevice = i;
                            deviceLogicIndex = 0;
                            deviceLogicState = 1;
                        }

                    } else if ( deviceLogicState == 1 ) {

                        deviceLogicCommand = deviceLogic[deviceLogicIndex];
                        if (deviceLogicCommand == 0xaa ) {
                            if ( deviceLogicIndex == deviceLogicMax - 1 ) {
                                device->deviceMode = 2;
                                kempstonMouseCounterA = 255;
                            } else {
                                ps2DeviceMain = i;
                                device->deviceMode = 1;
                                for(uint8_t j = 0; j < 8; j++) outPorts[j] = 0;
                            }
                            deviceLogicState = 0;
                            deviceLogicDevice = 3;
                            break;
                        }
                        send(deviceLogicDevice, deviceLogicCommand);
                        deviceLogicState = 2;

                    } else if ( deviceLogicState == 2 ) {

                        if ( code == 0xfe || code == 0xfc ) {
                            deviceLogicState = 1;
                        } else {
                            deviceLogicState = 3;
                        }

                    } else if ( deviceLogicState == 3 ) {



                        if ( deviceLogicCommand == 0xf2 ) {
                            if ( code == 0x83 ) {

                            } else if ( code == 0x00 || code == 0x03 ) {

                                deviceLogicIndex = deviceLogicMouseIndex - 1;
                            }
                        } else if ( deviceLogicCommand == 0xff ) {
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

                updatePort(0x00, 0);

                needSave = 1;
            } else if ( delay == 200 ) {

                updateKey(delayedKey, 1 );
                delayedKey = 0;
                needSave = 1;

            }

        }

        kempstonMouseEmulatorDelay++;
        if ( kempstonMouseEmulatorDelay > 333 && numLock ) {

            if ( (kempstonMouseEmulatorKeys & 1) > 0 ) outPorts[9]-=1;
            if ( (kempstonMouseEmulatorKeys & 2) > 0 ) outPorts[9]+=1;
            if ( (kempstonMouseEmulatorKeys & 4) > 0 ) outPorts[10]+=1;
            if ( (kempstonMouseEmulatorKeys & 8) > 0 ) outPorts[10]-=1;
            if ( (kempstonMouseEmulatorKeys & 16) > 0 ) outPorts[8] &= 254;
            else outPorts[8] |= 1;

            kempstonMouseEmulatorDelay = 0;
            needSave = 1;
        }

        if ( needSave) {
            sendDataToAltera();
        }

        __asm("clrwdt");
    }

}
