// thermoReader
//  Read the temperature from a Humidity and Temperature Sensor Pro (Grove) and
//  send it to the serial port.
//
//  Work on:
//    Arduino DUE
//
//  Libraries:
//    DHTlib 1.13
//  
//  by antoine.delhomme@espci.fr
//

#include <dht.h>

dht DHT;

#define THERMO_PIN 5

void setup() {
  // Init the serial communication
  Serial.begin(9600);

}

void loop() {
  // Read data
  int chk = DHT.read22(THERMO_PIN);
  
  // Perform the data
  Serial.println(DHT.temperature, 1);
  
  // Wait
  delay(2000);

}
