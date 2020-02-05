//#include <Time.h>
#include <TimeLib.h>

/*
 * Macro Definitions
 */

#include <Time.h>
#define SPEC_TRG         A0
#define SPEC_ST          A1
#define SPEC_CLK         A2
#define SPEC_VIDEO       A3
#define WHITE_LED        A4
#define LASER_404        A5
#define SPEC_CHANNELS    288 // New Spec Channel
#define DELAY_TIME       1    // 1 ms delay time between clocks.
int data[SPEC_CHANNELS];
time_t start;
time_t finish;
double cpu_time_used;

using namespace std;

void setup(){
  //Set desired pins to OUTPUT
  pinMode(SPEC_CLK, OUTPUT);
  pinMode(SPEC_ST, OUTPUT);
  pinMode(LASER_404, OUTPUT);
  pinMode(WHITE_LED, OUTPUT);

  //Initialize pin outputs
  digitalWrite(SPEC_CLK, LOW);
  digitalWrite(SPEC_TRG, LOW);
  digitalWrite(SPEC_ST, LOW);
  clock(1);
  Serial.begin(115200); // Baud Rate set to 115200
}

/*
 * This functions reads spectrometer data from SPEC_VIDEO
 * Look at the Timing Chart in the Datasheet for more info
 */
void readSpectrometer(short integrationCycles){
  // Start clock cycle and set start pulse to signal start
  clock(1);
  digitalWrite(SPEC_ST, HIGH);

  //Sample for a period of time
  clock(integrationCycles);
  
  //Set SPEC_ST to low
  digitalWrite(SPEC_ST, LOW);

  //Sample for a period of time
  clock(4);

  
  //Read from SPEC_VIDEO
  for(int i = 0; i < SPEC_CHANNELS; i++){
      data[i] = analogRead(SPEC_VIDEO);
      clock(1); 
  }

  //Set SPEC_ST to high
  digitalWrite(SPEC_ST, HIGH);
  
  //Sample for a small amount of time
  clock(7);
  
}

/*
 * The function below prints out data to the terminal or 
 * processing plot
 */
void printData(){
  
  for (int i = 0; i < SPEC_CHANNELS; i++){
    
    Serial.print(data[i]);
    Serial.print(' ');
    
  }
  
  Serial.print('\n'); 
}

boolean ultra = true;
boolean led = true;


void loop(){
  short integrationCycles = 1;
  readSpectrometer(integrationCycles);
  printData();  
  if(Serial.available()){
    char val = Serial.read();

    //Read the characters coming in through the serial port
    //If I is read, parse the value following it to adjust the integration time. 
    if(val == 'I'){
      integrationCycles = Serial.read();
    }

    //Ultraviolet toggle; send a character U through the serial port to toggle. 
    if(val == 'U'){
      if(ultra) digitalWrite(A5, HIGH);
      else digitalWrite(A5, LOW);
      ultra = !ultra;
    }
    
    //LED toggle; send a character L through the serial port to toggle.
    if(val == 'L'){
      if(led) digitalWrite(A4, HIGH);
      else digitalWrite(A4, LOW);
      led = !led;
    }      
  }
}

void clock(short cycles){
  for(short i = 0; i < cycles; i++){
    digitalWrite(SPEC_CLK, LOW);
    digitalWrite(SPEC_CLK, HIGH);
  }
}
