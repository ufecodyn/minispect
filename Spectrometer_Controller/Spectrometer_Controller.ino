/*
 * Pin setup:
 * Clock : D2
 * ST    : D3
 * Video : A0
 */

#define SPEC_CHANNELS 288
#define VIDEO A0
#define BAUD 115200

int vals[SPEC_CHANNELS];
int serialByteIn;

void setup() {
 DDRD = DDRD | B11111100;
 PORTD = B00000000;
 Serial.begin(BAUD);
}


/*
 * Port manipulation allows us to change the pin output much faster.
 * Unfortuantely, this comes with a few drawbacks
 *  1. We can't just place a "pin high, delay, pin low, delay" in a loop and call it a day. 
 *     This is because at the end of the loop, the microcontroller must calculate the jump address to jump to the beginning of the loop
 *     We end up with an unstable clock with a high period much shorter than the low period. 
 *  2. The clock itself is somewhat unstable. 
 * 
 */
inline void shortDelay(){
  asm volatile("nop");
}

static inline void sequence(){
  //ST HIGH: 6 CLOCKS
  // --- Clock --- 0
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  //ST HIGH: 6 CLOCKS
  // --- Clock --- 0
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");

  //ST HIGH: 6 CLOCKS
  // --- Clock --- 0
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");
  
  PORTD = B00001100;
  asm volatile("nop");
  PORTD = B00001000;
  asm volatile("nop");


  
  
  //ST LOW: 87 CLOCKS
  // --- Clock --- 0
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 10
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 20
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 30
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 40
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 50
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 60
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 70
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  
  // --- Clock --- 80
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  PORTD = B00000100;
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  
  for(int i = 0; i < SPEC_CHANNELS; i++){
    clock(); 
    vals[i] = analogRead(VIDEO);
  }
}

void printValues(){
  for(int i = 0; i < SPEC_CHANNELS; i++){
    Serial.print(vals[i]);
    Serial.write(" ");
  }
  Serial.write("\n");
}

static inline void clock(){
  PORTD = B00000100; 
  asm volatile("nop");
  PORTD = B00000000;
  asm volatile("nop");
  PORTD = B00000100; 
}

void loop() {
    sequence();
    printValues();
}
