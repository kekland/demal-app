#include <SimpleDHT.h>

String device_UUID = "a9252132-faec-4bcb-b911-86ed98bd7d4e";

//MQ-135 (Gas detection)
int analogGasPort = A0;

//DHT-11 (Temp., humid. sensor)
SimpleDHT11 tempHumid(2);
int _dht11_temp = -1;
int _dht11_humid = -1;

//RGB LED
int redLEDPort = 5;
int greenLEDPort = 4;
int blueLEDPort = 3;

void setup() {
  Serial.begin(9600); // sets the serial port to 9600
  pinMode(analogGasPort, INPUT);
  pinMode(redLEDPort, OUTPUT);
  pinMode(blueLEDPort, OUTPUT);
  pinMode(greenLEDPort, OUTPUT);

  //Serial.println("AT+NAME=DemAl");
}

int fetchGasPPMData() {
  return analogRead(analogGasPort);  
}

int getTemperatureData() {
  return _dht11_temp;  
}

int getHumidityData() {
  return _dht11_humid;
}

void dht11_fetch() {
  byte temperature = 0;
  byte humidity = 0;
  int err = SimpleDHTErrSuccess;
  if ((err = tempHumid.read(&temperature, &humidity, NULL)) != SimpleDHTErrSuccess) {
    Serial.print("Read DHT11 failed, err="); Serial.println(err);delay(1000);
    return;
  }
  _dht11_temp = temperature;
  _dht11_humid = humidity;
}

void debugSerial() {
  Serial.print("GAS: ");
  Serial.print(fetchGasPPMData());
  Serial.print(" | TEMP: ");
  Serial.print(getTemperatureData());
  Serial.print(" HUMID: ");
  Serial.println(getHumidityData());
}

void productionSerial() {
  Serial.print(fetchGasPPMData());
  Serial.print(",");
  Serial.print(getTemperatureData());
  Serial.print(",");
  Serial.println(getHumidityData());

  double quality = calculateQuality(fetchGasPPMData(), getHumidityData());
  if(quality < 0.5) {
    setLED(true, false);
  }
  else if(quality < 0.8) {
    setLED(true, true);
  }
  else {
    setLED(false, true);
  }
}

void setLED(bool red, bool green) {
  digitalWrite(redLEDPort, red);
  digitalWrite(greenLEDPort, green);
}

double calculateQuality(int gasPPM, int humidity) {
  double gasPercentage = gasPPM / 1024.0;
  double humidityPercentage = abs(50 - humidity) / 50.0;
  return (1.0 - gasPercentage) + (1.0 - humidityPercentage);
}

int _lastDHT11FetchTime = 0;
void loop() {
  int currentTime = millis();
  if(currentTime - _lastDHT11FetchTime > 2500) {
    _lastDHT11FetchTime = currentTime;
    dht11_fetch();
  }

  productionSerial();

  delay(1000);
}
