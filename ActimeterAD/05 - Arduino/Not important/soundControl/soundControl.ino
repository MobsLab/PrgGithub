// soundControl
//  Drives up to 12 sound channels.
//  Receive commands from the serial port and execute them.
//
//  Serial syntax

//   byte #1 ||  byte #2  ||  byte #3
//  -------- || ----/---- || --------
//  canal id    cmd / sig || volume
//
// by antoine.delhomme@espci.fr
//

#include <SPI.h>

// Define some aliases
#define SLAVE_SELECT_PIN 0
#define SOURCE_SELECT_PIN 1
#define SUBCHANNEL_ID 2

// Define some constants
//  LEFT: id of the left sub-channel on a PGA2311
//  RIGHT: id of the right sub-channel on a PGA2311
#define SUBCHANNEL_LEFT 0
#define SUBCHANNEL_RIGHT 1

#define VOLUME_MIN 162
#define VOLUME_MAX 192

// Define other aliases
const byte NB_OF_CHANNELS = 12;
const byte SOUND_NOISE = HIGH;
const byte SOUND_TUNE = LOW;

// Define how to reach each channel
//  [0] slave select pin
//  [1] source select pin
//  [2] sub-channel (left or right) on a PGA2311
const byte channels[NB_OF_CHANNELS][3] = {
  {30, 31, SUBCHANNEL_RIGHT},
  {30, 33, SUBCHANNEL_LEFT},
  {34, 35, SUBCHANNEL_RIGHT},
  {34, 37, SUBCHANNEL_LEFT},
  {38, 39, SUBCHANNEL_RIGHT},
  {38, 41, SUBCHANNEL_LEFT},
  {42, 43, SUBCHANNEL_RIGHT},
  {42, 45, SUBCHANNEL_LEFT},
  {46, 47, SUBCHANNEL_RIGHT},
  {46, 49, SUBCHANNEL_LEFT},
  {50, 51, SUBCHANNEL_RIGHT},
  {50, 53, SUBCHANNEL_LEFT},
};

// Buffer for gains on each channels
int gains[NB_OF_CHANNELS];

// Byte buffers
byte s_channel[] = {0};
byte s_cmd[] = {0};
byte s_gain[] = {0};

// Define working variables
int i;

void setup() {
  // Init the SPI interface
  SPI.begin();
  
  // Init the serial interface
  Serial.begin(9600);
  
  // Init the gains array
  for (i = 0; i < NB_OF_CHANNELS; i += 1) {
    gains[i] = 0;
  }
  
  // Set ...
  //  ... slave select pins as outputs
  //  ... slave select pins in a HIGH level
  //  ... source select pins as outputs
  //  ... source select pins in a LOW level
  //  ... gains to zero
  for (i = 0; i < NB_OF_CHANNELS; i += 1) {
    pinMode(channels[i][SLAVE_SELECT_PIN], OUTPUT);
    digitalWrite(channels[i][SLAVE_SELECT_PIN], HIGH);
    
    pinMode(channels[i][SOURCE_SELECT_PIN], OUTPUT);
    digitalWrite(channels[i][SOURCE_SELECT_PIN], LOW);
    
    setGain(i, 0);
  }
  
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}

void loop() {
  // Read the serial port if a complete command is waiting to be processed
  
  if (Serial.available() >= 3) {
    digitalWrite(13, HIGH);
    
    Serial.readBytes(s_channel, 1);
    Serial.readBytes(s_cmd, 1);
    Serial.readBytes(s_gain, 1);
    
    // The command (2nd byte) is processed.
    //    MSB = undefined
    //    LSB = subchannel
    byte s_subchannel = s_cmd[0] & B00001111;
    
//    Serial.write(s_channel, 1);
//    Serial.write(s_subchannel);
//    Serial.write(s_gain, 1);
    
    // Perform the command
    setGain(int(s_channel[0]), int(s_gain[0]));
    setSource(int(s_channel[0]), s_subchannel);
  }
  
}

void setVolume(int channel, int vol) {
  // Set the volume on the selected canal
  //  channel: slave select pin of the targeted PGA2311
  //  vol:     volume in %
  //
  
  // Convert the volume from % to byte
  int N = VOLUME_MIN + (vol*(VOLUME_MAX - VOLUME_MIN))/100;
  
  if (N > 255) {
    N = 255;
  } else if (N < 0) {
    N = 0;
  }
  
  // Set the gain on the PGA2311
  setGain(channel, N);
}
  
void setGain(int channel, int N) {
  // Set the gain on the selected canal
  //  channel: channel to edit
  //  N:       gain from 0 to 255
  //
  
  // Save the new gain
  gains[channel] = N;
  
  // Update the new gain
  digitalWrite(channels[channel][SLAVE_SELECT_PIN], LOW);
  
  if (channels[channel][SUBCHANNEL_ID] == SUBCHANNEL_RIGHT) {
    SPI.transfer(N);
    SPI.transfer(gains[channel + 1]);
  } else {
    SPI.transfer(gains[channel - 1]);
    SPI.transfer(N);
  }
  
  digitalWrite(channels[channel][SLAVE_SELECT_PIN], HIGH);
}

void setSource(int channel, int source) {
  // Set the source of a channel
  //
  
  if (source == SOUND_NOISE) {
    digitalWrite(channels[channel][SOURCE_SELECT_PIN], LOW);
  } else {
    digitalWrite(channels[channel][SOURCE_SELECT_PIN], HIGH);
  }
}
