# 1 "main.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "main.c" 2







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
# 2523 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic_chip_select.h" 3
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 1 3
# 44 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\__at.h" 1 3
# 44 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 2 3








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
# 159 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
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
    };
} PORTAbits_t;
extern volatile PORTAbits_t PORTAbits __attribute__((address(0x005)));
# 210 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
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
# 272 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
extern volatile unsigned char EEDATA __attribute__((address(0x008)));

__asm("EEDATA equ 08h");




extern volatile unsigned char EEADR __attribute__((address(0x009)));

__asm("EEADR equ 09h");




extern volatile unsigned char PCLATH __attribute__((address(0x00A)));

__asm("PCLATH equ 0Ah");


typedef union {
    struct {
        unsigned PCLATH :5;
    };
} PCLATHbits_t;
extern volatile PCLATHbits_t PCLATHbits __attribute__((address(0x00A)));
# 306 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
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
        unsigned EEIE :1;
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
# 384 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
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
# 454 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
extern volatile unsigned char TRISA __attribute__((address(0x085)));

__asm("TRISA equ 085h");


typedef union {
    struct {
        unsigned TRISA0 :1;
        unsigned TRISA1 :1;
        unsigned TRISA2 :1;
        unsigned TRISA3 :1;
        unsigned TRISA4 :1;
    };
} TRISAbits_t;
extern volatile TRISAbits_t TRISAbits __attribute__((address(0x085)));
# 498 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
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
# 560 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
extern volatile unsigned char EECON1 __attribute__((address(0x088)));

__asm("EECON1 equ 088h");


typedef union {
    struct {
        unsigned RD :1;
        unsigned WR :1;
        unsigned WREN :1;
        unsigned WRERR :1;
        unsigned EEIF :1;
    };
} EECON1bits_t;
extern volatile EECON1bits_t EECON1bits __attribute__((address(0x088)));
# 604 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
extern volatile unsigned char EECON2 __attribute__((address(0x089)));

__asm("EECON2 equ 089h");
# 617 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic16f84a.h" 3
extern volatile __bit CARRY __attribute__((address(0x18)));


extern volatile __bit DC __attribute__((address(0x19)));


extern volatile __bit EEIE __attribute__((address(0x5E)));


extern volatile __bit EEIF __attribute__((address(0x444)));


extern volatile __bit GIE __attribute__((address(0x5F)));


extern volatile __bit INTE __attribute__((address(0x5C)));


extern volatile __bit INTEDG __attribute__((address(0x40E)));


extern volatile __bit INTF __attribute__((address(0x59)));


extern volatile __bit IRP __attribute__((address(0x1F)));


extern volatile __bit PS0 __attribute__((address(0x408)));


extern volatile __bit PS1 __attribute__((address(0x409)));


extern volatile __bit PS2 __attribute__((address(0x40A)));


extern volatile __bit PSA __attribute__((address(0x40B)));


extern volatile __bit RA0 __attribute__((address(0x28)));


extern volatile __bit RA1 __attribute__((address(0x29)));


extern volatile __bit RA2 __attribute__((address(0x2A)));


extern volatile __bit RA3 __attribute__((address(0x2B)));


extern volatile __bit RA4 __attribute__((address(0x2C)));


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


extern volatile __bit RD __attribute__((address(0x440)));


extern volatile __bit RP0 __attribute__((address(0x1D)));


extern volatile __bit RP1 __attribute__((address(0x1E)));


extern volatile __bit T0CS __attribute__((address(0x40D)));


extern volatile __bit T0IE __attribute__((address(0x5D)));


extern volatile __bit T0IF __attribute__((address(0x5A)));


extern volatile __bit T0SE __attribute__((address(0x40C)));


extern volatile __bit TMR0IE __attribute__((address(0x5D)));


extern volatile __bit TMR0IF __attribute__((address(0x5A)));


extern volatile __bit TRISA0 __attribute__((address(0x428)));


extern volatile __bit TRISA1 __attribute__((address(0x429)));


extern volatile __bit TRISA2 __attribute__((address(0x42A)));


extern volatile __bit TRISA3 __attribute__((address(0x42B)));


extern volatile __bit TRISA4 __attribute__((address(0x42C)));


extern volatile __bit TRISB0 __attribute__((address(0x430)));


extern volatile __bit TRISB1 __attribute__((address(0x431)));


extern volatile __bit TRISB2 __attribute__((address(0x432)));


extern volatile __bit TRISB3 __attribute__((address(0x433)));


extern volatile __bit TRISB4 __attribute__((address(0x434)));


extern volatile __bit TRISB5 __attribute__((address(0x435)));


extern volatile __bit TRISB6 __attribute__((address(0x436)));


extern volatile __bit TRISB7 __attribute__((address(0x437)));


extern volatile __bit WR __attribute__((address(0x441)));


extern volatile __bit WREN __attribute__((address(0x442)));


extern volatile __bit WRERR __attribute__((address(0x443)));


extern volatile __bit ZERO __attribute__((address(0x1A)));


extern volatile __bit nPD __attribute__((address(0x1B)));


extern volatile __bit nRBPU __attribute__((address(0x40F)));


extern volatile __bit nTO __attribute__((address(0x1C)));
# 2523 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\pic_chip_select.h" 2 3
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
# 8 "main.c" 2

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
# 9 "main.c" 2

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
# 10 "main.c" 2

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
# 11 "main.c" 2

# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.00\\pic\\include\\c90\\stdbool.h" 1 3
# 12 "main.c" 2





# 1 "./ps2tozxtable.h" 1
# 27 "./ps2tozxtable.h"
uint16_t codeToMatrix(uint8_t k, uint8_t s, uint8_t c, uint8_t n)
{
    uint16_t r;

    switch (c) {
        case 0x5A:
            r = 0xFF06;
            break;
        case 0xFB:
            r = 0x0043;
            break;
        case 0xF4:
            r = 0x0024;
            break;
        case 0xF5:
            r = 0x0034;
            break;
        case 0xF2:
            r = 0x0044;
            break;
        case 0x16:
            r = (s) ? 0x1703 : 0xFF03;
            break;
        case 0x1E:
            r = (s) ? 0x1713 : 0xFF13;
            break;
        case 0x26:
            r = (s) ? 0x1723 : 0xFF23;
            break;
        case 0x25:
            r = (s) ? 0x1733 : 0xFF33;
            break;
        case 0x2E:
            r = (s) ? 0x1743 : 0xFF43;
            break;
        case 0x36:
            r = (s) ? 0x1746 : 0xFF44;
            break;
        case 0x3D:
            r = (s) ? 0x1744 : 0xFF34;
            break;
        case 0x3E:
            r = (s) ? 0x1747 : 0xFF24;
            break;
        case 0x46:
            r = (s) ? 0x1724 : 0xFF14;
            break;
        case 0x45:
            r = (s) ? 0x1714 : 0xFF04;
            break;
        default:
            r = 0xFFFF;
    }
    return r;
}
# 17 "main.c" 2
# 28 "main.c"
int8_t ps2DataState = 0;

uint8_t ps2Bits = 0;
int8_t ps2BitsCount = 0;


uint8_t ps2Data[8];
int8_t ps2DataCount = 0;



uint8_t outPorts[11] =
{

    0xff,
    0xff,
    0xff,
    0xff,
    0xff,
    0xff,
    0xff,
    0xff,

    0xff,
    0xff,
    0xff
};




int8_t i = 0;
int16_t keyCode = 0;
uint8_t shift = 0;
uint8_t capsLock = 0;
uint8_t numLock = 0;
# 85 "main.c"
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





void __attribute__((picinterrupt("high_priority"))) myIsr(void)
{
    if(T0IE && T0IF){

        T0IF=0;
        TMR0 = 255;


        if ( ps2DataState == 0 || ps2DataState == 1 ) {
            if ( !PORTAbits.RA4 && !PORTAbits.RA3 ) {
                ps2BitsCount = 0;
                ps2Bits = 0;
                ps2DataState = 2;
            }
        } else if ( ps2DataState == 2 ) {
            if ( ps2BitsCount < 8 ) {
                if ( PORTAbits.RA3 ) {
                    ps2Bits |= ( 1 << ps2BitsCount );
                }
                ps2BitsCount++;
            } else if ( ps2BitsCount == 8 ) {
                ps2BitsCount++;
            } else if ( ps2BitsCount == 9 ) {
                if ( ps2DataCount < 8 ) {
                    ps2Data[ps2DataCount] = ps2Bits;
                    ps2DataCount++;
                }
                if ( ps2Bits == 0xF0 || ps2Bits == 0xE0 ) {
                    ps2DataState = 1;
                } else {
                    if ( ps2DataCount == 2 && ps2Data[1] == 0x12 ) {
                       ps2DataState = 1;
                    } else if ( ps2Data[0] == 0xe1 && ps2DataCount < 8 ) {
                        ps2DataState = 1;
                    } else {
                        ps2DataState = 3;
                    }
                }
            }
        }
    }
    GIE = 1;
}



void setPort(uint8_t bit_id)
{
    outPorts[bit_id & 0x07] |= (1 << (bit_id >> 4));
}

void resetPort(uint8_t bit_id)
{
    outPorts[bit_id & 0x07] &= ~(1 << (bit_id >> 4));
}



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



void sendDataToAltera()
{

}



void sendToKeyboardRepeat()
{

}

void sendToKeyboardLED(uint8_t id, uint8_t state)
{

}



void main(void)
{
    TRISA0 = 1;
    TRISA1 = 0;
    TRISA2 = 0;
    TRISA3 = 1;
    TRISA4 = 1;

    PORTA = 0b00000000;

    TRISB = 0b00000000;
    PORTB = 0b00000010;
# 266 "main.c"
    T0CS = 1;
    T0SE = 1;
    GIE = 1;
    T0IE = 1;
    PSA = 1;
    T0IF = 0;
    TMR0 = 255;

    ps2DataState = 0;
    ps2BitsCount = 0;
    ps2Bits = 0;


    while(1)
    {
        if ( ps2DataState == 3 ) {


            if ( ps2DataCount == 1) {
                keyDown(ps2Data[0]);
            } else if ( ps2DataCount == 2 ) {
                if ( ps2Data[0] == 0xF0 ) {
                    keyUp(ps2Data[1]);
                } else if ( ps2Data[0] == 0xE0 ) {
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


            ps2DataCount = 0;
            ps2DataState = 0;


            sendDataToAltera();
        }
# 321 "main.c"
        __asm("clrwdt");
    }

}
