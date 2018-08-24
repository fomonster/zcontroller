/*
 *  Codes replaced when Shift key down
 */
const uint8_t replaceOnShiftKeyDown[36] = 
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
    74, 110
};

const uint8_t replaceTwoBytesCodes[26] = 
{
    0x14, 19, // Ctrl (right)
    0x70, 23, // Insert
    0x6c, 24, // Home
    0x7d, 25, // Page Up
    0x71, 31, // Delete
    0x69, 32, // End 
    0x7a, 39, // Page Down
    0x75, 40, // Up Arrow
    0x6b, 47, // Left Arrow
    0x72, 48, // Down Arrow
    0x74, 55, // Right Arrow
    0x4a, 56, // "/"
    0x5a, 57 // Enter
};

/*
 *  ps2 codes table
 *   This table was autmatically generated by TableGen.xlsm 
 */
const uint8_t codeToMatrix[128] = 
{
0xFF, //  0     
0xFF, //  1     F9
0xFF, //  2     Windows (left)
0xFF, //  3     F5
0xFF, //  4     F3
0xFF, //  5     F1
0xFF, //  6     F2
0xFF, //  7     F12
0xFF, //  8     Alt (right)
0xFF, //  9     F10
0xFF, //  10     F8
0xFF, //  11     F6
0xFF, //  12     F4
0xFF, //  13     Tab
0x9C, //  14 (7+SS) `
0xFF, //  15     Windows (right)
0xFF, //  16     Menus
0xFF, //  17     Alt (left)
0xFF, //  18     Shift (Left)
0xFF, //  19     Ctrl (right)
0xFF, //  20     Ctrl (left)
0x2, //  21 (Q) Q
0x3, //  22 (1) 1
0xFF, //  23     Insert
0xFF, //  24     Home
0xFF, //  25     Page Up
0x8, //  26 (Z) Z
0x9, //  27 (S) S
0x1, //  28 (A) A
0xA, //  29 (W) W
0xB, //  30 (2) 2
0x44, //  31 (0+CS) Delete
0xFF, //  32     End
0x18, //  33 (C) C
0x10, //  34 (X) X
0x11, //  35 (D) D
0x12, //  36 (E) E
0x1B, //  37 (4) 4
0x13, //  38 (3) 3
0xFF, //  39     Page Down
0x5C, //  40 (7+CS) Up Arrow
0x7, //  41 (SP) Spacebar
0x20, //  42 (V) V
0x19, //  43 (F) F
0x22, //  44 (T) T
0x1A, //  45 (R) R
0x23, //  46 (5) 5
0x63, //  47 (5+CS) Left Arrow
0x64, //  48 (6+CS) Down Arrow
0x1F, //  49 (N) N
0x27, //  50 (B) B
0x26, //  51 (H) H
0x21, //  52 (G) G
0x25, //  53 (Y) Y
0x24, //  54 (6) 6
0x54, //  55 (8+CS) Right Arrow
0xA0, //  56 (V+SS) Num Pad /
0x6, //  57 (EN) Num Pad Enter
0x17, //  58 (M) M
0x1E, //  59 (J) J
0x1D, //  60 (U) U
0x1C, //  61 (7) 7
0x14, //  62 (8) 8
0xFF, //  63     F7
0xFF, //  64     Prt Scr
0x9F, //  65 (N+SS) ,
0x16, //  66 (K) K
0x15, //  67 (I) I
0xD, //  68 (O) O
0x4, //  69 (0) 0
0xC, //  70 (9) 9
0xFF, //  71     Pause/Break
0xFF, //  72     ` + Shift = ~
0x97, //  73 (M+SS) .
0xA0, //  74 (V+SS) /
0xE, //  75 (L) L
0x8D, //  76 (O+SS) ;
0x5, //  77 (P) P
0x9E, //  78 (J+SS) -
0x83, //  79 (1+SS) 1 + Shift = !
0x8B, //  80 (2+SS) 2+ Shift = @
0x93, //  81 (3+SS) 3+ Shift = #
0x9C, //  82 (7+SS) '
0x9B, //  83 (4+SS) 4 + Shift = $
0xE5, //  84 (Y+CS+SS) [
0x8E, //  85 (L+SS) =
0xA3, //  86 (5+SS) 5 + Shift = %
0xA6, //  87 (H+SS) 6 + Shift = ^
0x4B, //  88 (2+CS) Caps Lock
0xFF, //  89     Shift (Right)
0x6, //  90 (EN) Enter
0xDD, //  91 (U+CS+SS) ]
0xA4, //  92 (6+SS) 7 + Shift = &
0xFF, //  93     "\"
0xA7, //  94 (B+SS) 8 + Shift = *
0x94, //  95 (8+SS) 9 + Shift = (
0x8C, //  96 (9+SS) 0 + Shift = )
0x84, //  97 (0+SS) - + Shift = _
0x96, //  98 (K+SS) = + Shift = +
0x90, //  99 (X+SS) \ + Shift = |
0xFF, //  100     [ + Shift = {
0xFF, //  101     ] + Shift = }
0x44, //  102 (0+CS) Backspace
0x88, //  103 (Z+SS) ; + Shift = :
0x85, //  104 (P+SS)  + Shift = "
0x3, //  105 (1) Num Pad 1
0x9A, //  106 (R+SS) , + Shift = <
0x1B, //  107 (4) Num Pad 4
0x1C, //  108 (7) Num Pad 7
0xA2, //  109 (T+SS) . + Shift = >
0x98, //  110 (C+SS) / + Shift = ?
0xFF, //  111     
0x4, //  112 (0) Num Pad 0
0x97, //  113 (M+SS) Num Pad .
0xB, //  114 (2) Num Pad 2
0x23, //  115 (5) Num Pad 5
0x24, //  116 (6) Num Pad 6
0x14, //  117 (8) Num Pad 8
0x43, //  118 (1+CS) ESC
0xFF, //  119     Num Lock
0xFF, //  120     F11
0x96, //  121 (K+SS) Num Pad +
0x13, //  122 (3) Num Pad 3
0x9E, //  123 (J+SS) Num Pad -
0xA7, //  124 (B+SS) Num Pad *
0xC, //  125 (9) Num Pad 9
0xFF, //  126     Scroll Lock
0xFF //  127     
};






