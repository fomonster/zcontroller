 // 0 - #FEFE - CS...V    "11111110"
 // 1 - #FDFE - A...G     "11111101"  
 // 2 - #FBFE - Q...T     "11111011"  
 // 3 - #F7FE - 1...5     "11110111"  
 // 4 - #EFFE - 0...6     "11101111"
 // 5 - #DFFE - P...Y     "11011111"  
 // 6 - #BFFE - Enter...H "10111111"   
 // 7 - #7FFE - Space...B "01111111"
         
/*
 *    ps2 codes table
 * 
 *   k - input ps2 key code
 *   s - shift 
 *   c - capslock
 *   n - numlock
 *   result - 2 bytes of 2 matrix offset.
 *   1 byte - cs or shift matrix offset 
 *   2 byte - a (0..4) row key bit, b (0..7) port number 
 *   0x17 is "symbol shift" key
 *   0x07 is "space" key
 *   0x06 is "enter" key
 *   0x00 is "caps shift" key 
 *   0xFF nothing
 *   ..
 */
uint16_t codeToMatrix(uint8_t k, uint8_t s, uint8_t c, uint8_t n)
{
    uint16_t r;
    // c - input
    switch (c) {        
        case 0x5A: //"enter"
            r = 0xFF06;
            break;
        case 0xFB: //"left"
            r = 0x0043;
            break;
        case 0xF4: //"right"
            r = 0x0024;
            break;
        case 0xF5: //"up"
            r = 0x0034;
            break;            
        case 0xF2: //"down"
            r = 0x0044;
            break;            
        case 0x16: //"1"
            r = (s) ? 0x1703 : 0xFF03;
            break;            
        case 0x1E: //"2"
            r = (s) ? 0x1713 : 0xFF13;
            break;            
        case 0x26: //"3"
            r = (s) ? 0x1723 : 0xFF23;
            break;            
        case 0x25: //"4"
            r = (s) ? 0x1733 : 0xFF33;
            break;            
        case 0x2E: //"5"
            r = (s) ? 0x1743 : 0xFF43;
            break;            
        case 0x36: //"6"
            r = (s) ? 0x1746 : 0xFF44;
            break;            
        case 0x3D: //"7" 
            r = (s) ? 0x1744 : 0xFF34;
            break;            
        case 0x3E: //"8"
            r = (s) ? 0x1747 : 0xFF24;
            break;            
        case 0x46: //"9"
            r = (s) ? 0x1724 : 0xFF14;
            break;            
        case 0x45: //"0"
            r = (s) ? 0x1714 : 0xFF04;
            break;            
        default:
            r = 0xFFFF;
    }
    return r;
}

