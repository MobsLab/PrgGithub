// soundControl
//
// by antoine.delhomme@espci.fr
//

#include <SPI.h>

#define VOLUME_MIN 162
#define VOLUME_MAX 192      // (N = 192 --> gain = 0 dB)

// Define pins aliases
const int SSPin = 10;

// Define working variables
int volume = VOLUME_MIN;
int inc = 1;

void setup() {
  // Init the SPI interface
  SPI.begin();
  //SPI.setBitOrder(MSBFIRST);
  //SPI.setDataMode(SPI_MODE1);
  
   // Set the slave select pin as an output
  pinMode(SSPin, OUTPUT);
}

void loop() {
  // Set volume
  setGain(SSPin, volume);
  
  // Update the volume for the next step
  volume = volume + inc;
  
  // Reverser the increment if necessary
  if (volume == VOLUME_MIN || volume == VOLUME_MAX) {
    inc = -inc;
    }
    
  delay(8);
  
}

void setVolume(int canal, int vol) {
  // Set the volume on the selected canal
  //  canal: slave select pin of the targeted PGA2311
  //  vol:   volume in %
  //
  
  // Convert the volume from % to byte
  int N = VOLUME_MIN + (vol*(VOLUME_MAX - VOLUME_MIN))/100;
  
  if (N > 255) {
    N = 255;
  } else if (N < 0) {
    N = 0;
  }
  
  // Set the gain on the PGA2311
  setGain(canal, N);
  }
  
void setGain(int canal, int N) {
  // Set the gain on the selected canal
  //  canal: slave select pin of the targeted PGA2311
  //  N:     gain from 0 to 255
  //
  
  digitalWrite(canal, LOW);
  SPI.transfer(N);
  SPI.transfer(N);
  digitalWrite(canal, HIGH);
  }
