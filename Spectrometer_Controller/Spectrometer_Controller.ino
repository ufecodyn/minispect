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

// Clock sequence-- FOR loop that clocks cycles * 2 times. Each "cycle" takes 9 clock cycles. Since Arduino Nano has a 16 MHz clock rate, this gives us 2.8e-7 s per clock (0.28125 us)
// This method is used in the sequence() function to adjust the integration time
inline void integrate(int cycles){
  int cyc = 5;
  asm volatile( "clr r16 \n ldi r17, %0" : : "num" (cyc));
  PORTD = B00001100;
  asm volatile(     
        "loop:"
  );    
  
  PORTD = B00001100;
  asm volatile("\t inc r16");  // increment by one
  PORTD = B00001000;
  asm volatile("\t nop \n ");
  PORTD = B00001100;
  asm volatile("\t cp r16, r17 \n");
  PORTD = B00001000;
  asm volatile("\t brlt loop \n"
               "\t nop"); 
  
}

/*
 * Port manipulation allows us to change the pin output much faster.
 * Unfortuantely, this comes with a few drawbacks
 *  1. We can't just place a "pin high, delay, pin low, delay" in a loop and call it a day. 
 *     This is because at the end of the loop, the microcontroller must calculate the jump address to jump to the beginning of the loop
 *     We end up with an unstable clock with a high period much shorter than the low period. 
 *  2. The clock itself is somewhat unstable. 
 * 
 * The parameter cycles is an integer representing the number of times the FOR loop in integrate() should execute; this means that the function will clock cycles*2 times, using 4.5 system clock cycles per driven clock. 
 * Setting the cycles value to 0 achieves the minimum integration time as per the C12880MA documentation.
 * 
 */

static inline void sequence(int cycles){
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
  
  //INTEGRATE for x cycles in addition to the first 6 required.
  // This is used to modify the integration time. Read method documentation for more information.
  //integrate(cycles);
  delay(cycles);
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
  if(Serial){
    serialByteIn = Serial.read();
    if(serialByteIn == 'r'){
        int cycles = Serial.parseInt();
        sequence(cycles);
        /*Serial.print("Cycles: ");
        Serial.print(cycles);
        Serial.print("\n");*/
        printValues();
        serialByteIn = 'a';
    }
  }
}
