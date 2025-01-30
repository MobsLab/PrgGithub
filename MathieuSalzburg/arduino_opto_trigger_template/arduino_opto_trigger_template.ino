//// Parameters of protocol
unsigned long InterStimTime1 = 5000;       // time between stims
unsigned long TimeBeforeStim = 10000;       // time in one state before stim (consolided REM etc...)

//Stim characteristics
unsigned long DurationOfStim = 20000;       // Time of the stimulation
unsigned long FrequencyStim = 10;            // Frequence of the stim

// Select the Sleep Stage where you want to stilmulate : 1 is stimulation 0 is no stimulation
int StimWAKE = 0;
int StimREM = 1;
int StimNREM = 0;
int StimWAKETHETA = 0;


//// Define the pins
int IntanSync_StartStopRecording = 13;  // sends ttl to intan to synchronize recording --> dig 0
int IntanSync_SyncFrames = 10;          // sends ttl to intan to synchronize every 1000 frames --> dig 3

int IntanNREM=31;   //High if Mouse in NREM sleep
int IntanREM=33;    //High if Mouse in REM sleep
int IntanWAKE=35;   //High if Mouse in Wake state
int IntanWAKETHETA = 37; //High if Mouse in Wake Theta state


// Mouse 1
int StimPin_Mouse1 = 8;           // controls the voltage generator
int IntanSync_Stim_Mouse1 = 12;   // controls the voltage generator


/////////////////////////////DO NOT MODIFY BELOW ///////////////////////////////


////Intern parameters
int input = 0;            // tracks what matlab has sent
unsigned long Time_Mouse1 = 0;          // tracks time in a same state for the mouse
unsigned long Time_LastStim = 0;        // tracks time of last stim
int SleepState = 0;        // express the sleep State of previous iteration 3 means WAKE, 2 means REM, 1 means NREM

// Stim parameters --> to calculate with the Duration and Frequency of the Stim
int CycleRepeats = DurationOfStim * FrequencyStim/1000 ; // number of cycles to make
unsigned long StimRepeatsTps = 1000/(2*FrequencyStim); // duration in ms of one half cycle 2,3,3.5,4,4.5,5,6,7





void setup() {
  Serial.begin(9600);

  randomSeed(analogRead(0));

  //// Start the pins
  pinMode(IntanSync_StartStopRecording, OUTPUT);
  digitalWrite(IntanSync_StartStopRecording, LOW);

  pinMode(IntanSync_SyncFrames, OUTPUT);
  digitalWrite(IntanSync_SyncFrames, LOW);

  pinMode(StimPin_Mouse1, OUTPUT);
  digitalWrite(StimPin_Mouse1, LOW);

  pinMode(IntanSync_Stim_Mouse1, OUTPUT);
  digitalWrite(IntanSync_Stim_Mouse1, LOW);

 
  pinMode(IntanREM,INPUT);
  pinMode(IntanNREM,INPUT);
  pinMode(IntanWAKE,INPUT);
  pinMode(IntanWAKETHETA,INPUT);
    
  pinMode(LED_BUILTIN,OUTPUT);
  digitalWrite(LED_BUILTIN,LOW);
}

void loop() {

  // get input from matlab if necessary

  if (Serial.available()) {
    input = Serial.read();
    Serial.flush();
  }


  //Start recording
  if (input == 1) {
    digitalWrite(IntanSync_StartStopRecording, HIGH);
  }
  
  //Stop recording
  else if (input == 3) {
    digitalWrite(IntanSync_StartStopRecording, LOW);
  }
  
  // Every Thousand frames synchronize with intan
  else if (input == 2) {
    digitalWrite(IntanSync_SyncFrames, HIGH);
    delay(5);
    Time_Mouse1 = Time_Mouse1 +5;
    Time_LastStim = Time_LastStim +5;
    digitalWrite(IntanSync_SyncFrames, LOW);
  }



  delay(1);
  Time_LastStim = Time_LastStim +1;

  //Get the SleepStage to induce the stim
  if (digitalRead(IntanWAKE)==HIGH)
  {
    if (SleepState == 3)
    {
      Time_Mouse1 = Time_Mouse1 +1;
    }
    else  
    {
      SleepState = 3;
      Time_Mouse1 = 0;
    }

  }
    else if (digitalRead(IntanNREM)==HIGH)
  {
    if (SleepState == 1)
    {
      Time_Mouse1 = Time_Mouse1 +1;
    }
    else  
    {
      SleepState = 1;
      Time_Mouse1 = 0;
    }
  }
  
  else if (digitalRead(IntanREM)==HIGH)
  {
    if (SleepState == 2)
    {
      Time_Mouse1 = Time_Mouse1 +1;
    }
    else  
    {
      SleepState = 2;
      Time_Mouse1 = 0;
    }
  }
  else if (digitalRead(IntanWAKETHETA) == HIGH)
  {
    if (SleepState == 4)
    {
      Time_Mouse1 = Time_Mouse1 +1;
    }
    else  
    {
      SleepState = 4;
      Time_Mouse1 = 0;
    }
  }
  else{
    SleepState = 0;
    Time_Mouse1 = 0;
  }


// Now determine if we stimulate or if we don't

//First check if the Stimulation doesn't occur too early in the Sleep State and if the interval between stim is conserved :
 if ((Time_Mouse1 > TimeBeforeStim) && (Time_LastStim > InterStimTime1)) {

    //Now we check if the Sleep state match with a trigger state
    if ((StimWAKE ==1 && SleepState ==3) || (StimREM ==1 && SleepState ==2) || (StimNREM ==1 && SleepState ==1) || (StimWAKETHETA ==1 && SleepState ==4))
    {
      Time_LastStim = 0;
      digitalWrite(LED_BUILTIN,HIGH);
      // do stimulation
      for (int s = 0; s < CycleRepeats ; s++) {
        digitalWrite(StimPin_Mouse1, HIGH);
        digitalWrite(IntanSync_Stim_Mouse1, HIGH);
        delay(StimRepeatsTps);
        digitalWrite(StimPin_Mouse1, LOW);
        digitalWrite(IntanSync_Stim_Mouse1, LOW);
        delay(StimRepeatsTps);
      }
      digitalWrite(LED_BUILTIN,LOW);
    }
  }
}




