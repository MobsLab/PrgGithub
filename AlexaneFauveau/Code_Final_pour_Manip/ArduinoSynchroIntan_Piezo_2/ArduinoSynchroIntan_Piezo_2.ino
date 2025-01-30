int val = 0;
int ordre = 0;
int valold = 0;
int intan_piezo_port = 51;
int IntanOnOff = 36;
int piezo_port = 53;
int StimPin = 50;
int IntanStimPin = 38;
int StimRelay1 = 46; //stimulator
int StimRelay2 = 47; //stimulator
int StimRelay3 = 48; // ground
int StimRelay4 = 49; // ground
int stimdur = 200; // 200 ms of eyeshock
int start_chrono_piezo = millis();      
int intervalPiezoSynchro = 3600*1000; // delay between two synchronizations --> change to 1hr
int debut = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(IntanOnOff, OUTPUT);
  digitalWrite(IntanOnOff, LOW);
  pinMode(piezo_port, OUTPUT);
  digitalWrite(piezo_port, LOW);
  pinMode(intan_piezo_port, OUTPUT);
  digitalWrite(intan_piezo_port, LOW);
  pinMode(IntanStimPin, OUTPUT);
  digitalWrite(IntanStimPin, LOW);
  pinMode(StimPin, OUTPUT);
  digitalWrite(StimPin, LOW);

  pinMode(StimRelay1, OUTPUT);
  digitalWrite(StimRelay1, LOW);
  pinMode(StimRelay2, OUTPUT);
  digitalWrite(StimRelay2, LOW);
  pinMode(StimRelay3, OUTPUT);
  digitalWrite(StimRelay3, HIGH);
  pinMode(StimRelay4, OUTPUT);
  digitalWrite(StimRelay4, HIGH);

}

void loop() {

  // synchro piezo intan
   if(millis() - start_chrono_piezo >= intervalPiezoSynchro){ 
    start_chrono_piezo = millis();   
    // send synchro signal to intan
    digitalWrite(intan_piezo_port, HIGH);
    for (int t=0; t<5; t++)
    {
    digitalWrite(piezo_port, HIGH);
    delay(100);
    digitalWrite(piezo_port, LOW);
    delay(100);
    }
    digitalWrite(intan_piezo_port, LOW);
   }

  if (Serial.available() > 0) {
    debut = Serial.read();
  }
  //commencer à compter
  //et attendre l'ordre d'envoi
  if (debut == 1) {
    // dit à alphalab de démarrer
    digitalWrite(IntanOnOff, HIGH);
    Serial.flush();
    digitalWrite(intan_piezo_port, HIGH);
    for (int t=0; t<5; t++)
    {
    digitalWrite(piezo_port, HIGH);
    delay(100);
    digitalWrite(piezo_port, LOW);
    delay(100);
    }
   digitalWrite(intan_piezo_port, LOW);
  }

while (debut ==1) {
  if (Serial.available() > 0) {
    ordre = Serial.read();
    Serial.flush();
    // OFF Signal
    if (ordre == 3) {
      digitalWrite(IntanOnOff, LOW);
      Serial.flush();
      debut = 0;
    }
  }
  if(millis() - start_chrono_piezo >= intervalPiezoSynchro){ 
  start_chrono_piezo = millis();   
  // send synchro signal to intan
  digitalWrite(intan_piezo_port, HIGH);
  for (int t=0; t<5; t++)
  {
    digitalWrite(piezo_port, HIGH);
    delay(100);
    digitalWrite(piezo_port, LOW);
    delay(100);
  }
  digitalWrite(intan_piezo_port, LOW);
  }

  if (ordre == 9) {
    digitalWrite(StimRelay3, LOW);
    digitalWrite(StimRelay4, LOW);
    digitalWrite(StimRelay1, HIGH);
    digitalWrite(StimRelay2, HIGH);
    digitalWrite(StimPin, HIGH);
    digitalWrite(IntanStimPin, HIGH);

    delay(10);
    digitalWrite(StimPin, LOW);

    delay(stimdur-10);
    digitalWrite(IntanStimPin, LOW);
    digitalWrite(StimRelay3, HIGH);
    digitalWrite(StimRelay4, HIGH);  
    digitalWrite(StimRelay1, LOW);
    digitalWrite(StimRelay2, LOW);
    Serial.flush();

  }
}
}