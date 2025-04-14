// soundControl
//  Drives up to 12 sound channels.
//  Receive commands from the serial port and execute them.
//  This version offers ore advanced commands. For example, it
//  can manage directly modulation on channels.
//
//  Serial syntax

//   byte #1 ||  byte #2  ||  byte #3
//  -------- || ----/---- || --------
//  canal id    mod / sig || volume
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

// Define modes
//  MODE_NONE:  default, the channel is manually controlled
//  MODE_OSC:   the output of the channel is modulated by a sinus
//  MODE_RAMP:  the output of the channel is modulated by a ramp
#define MODE_NONE 0
#define MODE_OSC 1
#define MODE_RAMP 2

// Define channel flags
//  UP_TO_DATE:     indicate that the real channel gain is up-to-date
//  OUT_OF_DATE:  indicate that the real channel gain has to be updated
#define UP_TO_DATE 0
#define OUT_OF_DATE 1

// Define general variables to handle timers
unsigned long currentMillis = 0;

// Define parameters of MODE_OSC
//  OSC_AMPL:         amplitude of the modulation
//  OSC_FREQ:         frquency of the modulation
//  OSC_INTERVAL:     interval between updates of the modulation (in milliseconds)
//                    It is useless to set it lower than 1/OSC_AMPL*OSC_FREQ.
const float pi = 3.14159;
const byte OSC_AMPL = 20;
const byte OSC_FREQ = 2;
const byte OSC_INTERVAL = 50;
// Define variables to handle the timer
unsigned long OSC_previousMillis = 0;

// Define parameters of MODE_RAMP
//  RAMP_START:       gain t the beginning of the ramp
//  RAMP_INTERVAL:    interval between updates of the modulation (in milliseconds)
//  RAMP_INC:         increment at each update
const byte RAMP_START = 160;
const byte RAMP_INTERVAL = 100;
const byte RAMP_INC = 1;
// Define variables to handle the timer
unsigned long RAMP_previousMillis = 0;

// Define other aliases
//  NB_OF_BOARDS:      number of board driven by the Arduino
//  NB_OF_CHANNELS:    number of speakers driven (NB_OF_CHANNELS = 2*NB_OF_BOARDS)
const byte NB_OF_BOARDS = 6;
const byte NB_OF_CHANNELS = 2*NB_OF_BOARDS;
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

// Array to store flags about each channels
byte flags[NB_OF_CHANNELS];

// Array to store the mode of each channel
byte modes[NB_OF_CHANNELS];

// Buffer for gains of each channel used as reference in modulation
int gains_ref[NB_OF_CHANNELS];

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
    gains_ref[i] = 0;
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
  // STEP #1 ---
  // Read the serial port if a complete command is waiting to be processed
  if (Serial.available() >= 3) {
    //digitalWrite(13, HIGH);
    
    Serial.readBytes(s_channel, 1);
    Serial.readBytes(s_cmd, 1);
    Serial.readBytes(s_gain, 1);
    
    // The command (2nd byte) is processed.
    //    MSB = mode
    //    LSB = subchannel
    byte s_subchannel = s_cmd[0] & B00001111;
    byte s_mode = (s_cmd[0] >> 4) & B00001111;
    
//    Serial.write(s_channel, 1);
//    Serial.write(s_subchannel);
//    Serial.write(s_gain, 1);
    
    // Perform the command
    setGain(int(s_channel[0]), int(s_gain[0]));
    setSource(int(s_channel[0]), s_subchannel);
    setMode(int(s_channel[0]), s_mode);
  }
  
  // Read the current time
  currentMillis = millis();
  
  // STEP #2 ---
  // For channel set in a particular mode, update their modulation. This is only done at a fixed rate.
  // MODE_OSC
  if(currentMillis - OSC_previousMillis >= OSC_INTERVAL) {
    // Update the timer
    OSC_previousMillis = currentMillis;
    
    // Compute the new MODE_OSC module
    int OSC_mod = OSC_AMPL * (1 + sin(2*pi*currentMillis*OSC_FREQ/1000))/2;
    
    // Update the modulation of each channel
    for (i = 0; i < NB_OF_CHANNELS; i += 1) {
      if (modes[i] == MODE_OSC) {
        setGain(i, gains_ref[i] + OSC_mod);
      }
    }
  }
  
  // MODE_RAMP
  if(currentMillis - RAMP_previousMillis >= RAMP_INTERVAL) {
    // Update the timer
    RAMP_previousMillis = currentMillis;
    
    // Update the modulation of each channel
    for (i = 0; i < NB_OF_CHANNELS; i += 1) {
      if (modes[i] == MODE_RAMP) {
        setGain(i, gains[i] + RAMP_INC);
        
        if (gains[i] == gains_ref[i]) {
          // The ramp ends
          setMode(i, MODE_NONE);
        }
      }
    }
  }
  
  // STEP #3 ---
  // Commits changes
  commitGains();
}
  
void setGain(int channel, int N) {
  // Set the gain on the selected canal. Modification are not applied until commitGains() is called.
  //  channel: channel to edit
  //  N:       gain from 0 to 255
  //
  
  // Save the new gain
  gains[channel] = N;
  flags[channel] = OUT_OF_DATE;
  
//  // Update the new gain
//  digitalWrite(channels[channel][SLAVE_SELECT_PIN], LOW);
//  
//  if (channels[channel][SUBCHANNEL_ID] == SUBCHANNEL_RIGHT) {
//    SPI.transfer(N);
//    SPI.transfer(gains[channel + 1]);
//  } else {
//    SPI.transfer(gains[channel - 1]);
//    SPI.transfer(N);
//  }
//  
//  digitalWrite(channels[channel][SLAVE_SELECT_PIN], HIGH);
}

void commitGains() {
  // Commit gains, ie send the right instruction to the board.
  //
  
  // For each channel, updates its gain. It is only done if necessary.
  for (i = 0; i < NB_OF_BOARDS; i += 1) {
    if (flags[2*i] == OUT_OF_DATE || flags[2*i + 1] == OUT_OF_DATE) {
      // Select the right channel
      digitalWrite(channels[2*i][SLAVE_SELECT_PIN], LOW);
      // Send new gains
      SPI.transfer(gains[2*i]);
      SPI.transfer(gains[2*i + 1]);
      // Unselect the channel
      digitalWrite(channels[2*i][SLAVE_SELECT_PIN], HIGH);
      
      flags[2*i] = UP_TO_DATE;
      flags[2*i + 1] = UP_TO_DATE;
    }
  }
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

void setMode(int channel, byte mode) {
  // Set the mode of a channel
  //
  
  // Set the mode
  modes[channel] = mode;
  
  // Do particular actions for some modes
  if (mode == MODE_OSC) {
    // Save the gain of reference (highest amplitude during modulation)
    gains_ref[channel] = gains[channel];
   } else if (mode == MODE_RAMP) {
     // Save the gain of reference (target of the ramp)
     gains_ref[channel] = gains[channel];
     // Set the gain a the start of the ramp
     setGain(channel, RAMP_START);
   }
}
