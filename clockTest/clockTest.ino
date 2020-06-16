#define PORTD _SFR_IO8(0x0B)
#define __SFR_OFFSET 0x20
#define _SFR_IO_ADDR(sfr) ((sfr) - __SFR_OFFSET)


void setup() {
  DDRD = DDRD | B11111100;
  PORTD = B00000000;
}

static inline void asmTest(int cycles){
  asm volatile( "clr r16 \n" //set r16 0
        "ldi r17, %0 \n" : : "reg" (cycles)
  );
  PORTD = B00000100;
  asm volatile(     
        "loop:"
  );  
  PORTD = B00000100;
  asm volatile("\t inc r16");  // increment by one
  PORTD = B00000000;
  asm volatile("\t nop \n ");
  PORTD = B00000100;
  asm volatile("\t cp r16, r17 \n");
  PORTD = B00000000;
  asm volatile("\t brlt loop \n"
               "\t nop"); 
}

void loop() {
  // put your main code here, to run repeatedly:
  /*asm (
    "sbi 0x0B, 2 \n"
    "cbi 0x0B, 2 \n"
    "sbi 0x0B, 2 \n"
    "cbi 0x0B, 2 \n"
  );*/

  asmTest(5);

 
  PORTD = B00000100;
  PORTD = B00000000;
  PORTD = B00000100;
  PORTD = B00000000;

  PORTD = B00000100;
  PORTD = B00000000;
  PORTD = B00000100;
  PORTD = B00000000;
  
  

}
