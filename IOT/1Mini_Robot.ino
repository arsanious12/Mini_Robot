#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH110X.h>
#include <FluxGarage_RoboEyes.h>
#define i2c_Address 0x3c
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1

Adafruit_SH1106G display = Adafruit_SH1106G(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
RoboEyes<Adafruit_SH1106G> roboEyes(display);

const int TOUCH_PIN = 5;
int cnt = 0;
unsigned long ttime = 0;
const int window = 800; 

bool cur = LOW;
bool prev = LOW;
bool waiting = false;

void setup() {
  Serial.begin(9600);
  pinMode(TOUCH_PIN, INPUT);
  roboEyes.begin(SCREEN_WIDTH, SCREEN_HEIGHT, 100);
  roboEyes.setAutoblinker(ON);
  roboEyes.setIdleMode(ON);    
  roboEyes.setMood(DEFAULT);
  Serial.println("System Ready.");
}

void loop() {
  roboEyes.update();
  cur = digitalRead(TOUCH_PIN);

  if (cur == HIGH && prev == LOW) {
    cnt++;
    ttime = millis();
    waiting = true;
    delay(50);
  }
  prev = cur;

  if (waiting && (millis() - ttime > window)) {
    
    if (cnt == 1) {
      Greeting();
    } 
    else if (cnt == 2) {
      Normal();
    } 
    else if (cnt >= 3) {
      Angry();
    }
    cnt = 0;
    waiting = false;
  }
}

void Greeting() {
  Serial.println("Action: Greeting Mode Activated! (Happy)");
  roboEyes.setMood(HAPPY);
}

void Normal() {
  Serial.println("Action: Normal Mode Activated! (Default)");
  roboEyes.setMood(DEFAULT);
}

void Angry() {
  Serial.println("Action: Angry Mode Activated! (Angry)");
  roboEyes.setMood(ANGRY);
}