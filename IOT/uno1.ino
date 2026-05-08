#include <Servo.h>
#include <SoftwareSerial.h>
SoftwareSerial relaySerial(2, 3);

Servo RightHand, LeftHand, RightLeg, LeftLeg, RightFoot, LeftFoot;  

/*
RHA = Right hand angle
LHA = Left hand angle
RLA = Right leg angle
LLA = Left leg angle
RFA = Right foot angle
LFA = Left foot angle
*/


const int RHA = 80 , LHA = 97 , RLA = 65 , LLA = 95 , RFA = 90 , LFA = 120;

/*
RHA positive -> moves the arm upward
LHA positive -> moves the arm downward
RLA positive -> moves the leg right
LLA positive -> moves the leg right
RFA positive -> lean forward
LFA positive -> lean backward
*/

const int directions[] = {1 , -1 , 1 , 1 , 1 , -1};


/*
positive -> moves the arm upward.
positive -> moves the leg right.
positive -> lean forword.
*/


void move(int angles[], int speedDelay = 15){

  Serial.println("moving");

  int target[6];
  target[0] = (angles[0] * directions[0]) + RHA;
  target[1] = (angles[1] * directions[1]) + LHA;
  target[2] = (angles[2] * directions[2]) + RLA;
  target[3] = (angles[3] * directions[3]) + LLA;
  target[4] = (angles[4] * directions[4]) + RFA;
  target[5] = (angles[5] * directions[5]) + LFA;

  int start[6];
  start[0] = RightHand.read();
  start[1] = LeftHand.read();
  start[2] = RightLeg.read();
  start[3] = LeftLeg.read();
  start[4] = RightFoot.read();
  start[5] = LeftFoot.read();


  int maxDiff = 0;
  for (int i = 0; i < 6; i++) {
    if (abs(target[i] - start[i]) > maxDiff) {
      maxDiff = abs(target[i] - start[i]);
    }
  }
  if (maxDiff == 0) return;

  for (int step = 1; step <= maxDiff; step++) {
    RightHand.write(start[0] + ((target[0] - start[0]) * step / maxDiff));
    LeftHand.write(start[1] + ((target[1] - start[1]) * step / maxDiff));
    RightLeg.write(start[2] + ((target[2] - start[2]) * step / maxDiff));
    LeftLeg.write(start[3] + ((target[3] - start[3]) * step / maxDiff));
    RightFoot.write(start[4] + ((target[4] - start[4]) * step / maxDiff));
    LeftFoot.write(start[5] + ((target[5] - start[5]) * step / maxDiff));
    delay(speedDelay);
  }
}


void intial(){
  int angles[] = {0,0,0,0,0,0};
  move(angles , 10);
  Serial.println("return to intial");
}

void moveToAbsolute(int targetAbs[]) {
  int angles[6];
  angles[0] = (targetAbs[0] - RHA) * directions[0];
  angles[1] = (targetAbs[1] - LHA) * directions[1];
  angles[2] = (targetAbs[2] - RLA) * directions[2];
  angles[3] = (targetAbs[3] - LLA) * directions[3];
  angles[4] = (targetAbs[4] - RFA) * directions[4];
  angles[5] = (targetAbs[5] - LFA) * directions[5];
  
  move(angles, 15);
}

void RH_up() {
  int absPos[6] = {RightHand.read(), LeftHand.read(), RightLeg.read(), LeftLeg.read(), RightFoot.read(), LeftFoot.read()};
  absPos[0] = min(absPos[0] + 10, 180);
  moveToAbsolute(absPos);
}

void RH_down() {
  int absPos[6] = {RightHand.read(), LeftHand.read(), RightLeg.read(), LeftLeg.read(), RightFoot.read(), LeftFoot.read()};
  absPos[0] = max(absPos[0] - 10, 0);
  moveToAbsolute(absPos);
}

void LH_up() {
  int absPos[6] = {RightHand.read(), LeftHand.read(), RightLeg.read(), LeftLeg.read(), RightFoot.read(), LeftFoot.read()};
  absPos[1] = min(absPos[1] + 10, 180);
  moveToAbsolute(absPos);
}

void LH_down() {
  int absPos[6] = {RightHand.read(), LeftHand.read(), RightLeg.read(), LeftLeg.read(), RightFoot.read(), LeftFoot.read()};
  absPos[1] = max(absPos[1] - 10, 0);
  moveToAbsolute(absPos);
}
void greeting() {
  int absPos[6] = {RightHand.read(), LeftHand.read(), RightLeg.read(), LeftLeg.read(), RightFoot.read(), LeftFoot.read()};
  
  absPos[0] = 180; 
  moveToAbsolute(absPos);  
  delay(3500);
  
  intial();
}

void Dance() {

  int swingRight[] = {25, -25, 20, 20, 0, 0}; 
  int swingLeft[]  = {-25, 25, -20, -20, 0, 0};
   
  for (int i = 0; i < 2; i++) {
    move(swingRight, 15);
    delay(100);
    move(swingLeft, 15);
    delay(100);
  }

  int pumpUp[]   = {40, 40, 0, 0, 0, 0};     
  int pumpDown[] = {-15, -15, 0, 0, 0, 0}; 
  for (int i = 0; i < 2; i++) {
    move(pumpUp, 10);
    delay(100);
    move(pumpDown, 10);
    delay(100);
  }
  int neutral[] = {0, 0, 0, 0, 0, 0};
  move(neutral, 20);
}


void move_forward() {
  int ra = dis(0); 
  int la = dis(1); 

  int step1[] = {ra, la, 10, 10, 0, 0}; 
  move(step1, 10);
  delay(50);

  int step2[] = {ra, la, 10, 10, 15, -15}; 
  move(step2, 10);
  delay(50);

  int step3[] = {ra, la, -10, -10, 15, -15};
  move(step3, 10);
  delay(50);

  int step4[] = {ra, la, -10, -10, -15, 15};
  move(step4, 10);
  delay(50);
}

void move_backward() {
  int ra = dis(0);
  int la = dis(1);

  int step1[] = {ra, la, 10, 10, 0, 0}; 
  move(step1, 10);
  delay(50);

  int step2[] = {ra, la, 10, 10, -15, 15};
  move(step2, 10);
  delay(50);

  int step3[] = {ra, la, -10, -10, -15, 15};
  move(step3, 10);
  delay(50);

  int step4[] = {ra, la, -10, -10, 15, -15};
  move(step4, 10);
  delay(50);
}

int dis(int side) {
  if (side == 0) return (RightHand.read() - RHA) * directions[0];
  if (side == 1) return (LeftHand.read() - LHA) * directions[1];
  return 0;
}

void stop_legs() {
  int ra = dis(0);
  int la = dis(1);
  int neutralLegs[] = {ra, la, 0, 0, 0, 0};
  move(neutralLegs, 15);
}

void setup() {
  Serial.begin(9600);
  relaySerial.begin(9600);
  RightHand.attach(11);
  LeftHand.attach(10);
  RightLeg.attach(9);
  LeftLeg.attach(8);
  RightFoot.attach(7);
  LeftFoot.attach(6);

  intial();
  Serial.println("Mini Robot is Ready");
  delay(1000);

}

/*
D -> dance
S -> stop
// ON -> manual movment
// OFF -> stop manual movment
LU -> left hand up
LD -> left  hand down
RU -> ......
RD -> ......
// MF -> move forward
// MB -> move backward
// O -> object detection
// F -> face id/greeting
H -> greeting
*/

bool manual = false;
String cur = "";
void loop() {
  if (relaySerial.available()) {
    String rec = relaySerial.readStringUntil('\n');
    rec.trim();
    Serial.print("ESP32 says: ");
    Serial.println(rec);

    if (rec == "ON") {
      manual = true;
      cur = "";
      Serial.println("Entered Manual Mode");
    } 
    else if (rec == "OFF") {
      manual = false;
      cur = "";
      Serial.println("Exited Manual Mode. Resetting posture.");
      intial(); 
    }
    else if (rec == "S") {
      
      if (cur == "MF" || cur == "MB") {
        stop_legs(); 
      }
      
      cur = "";
      
      if (!manual) {
         intial(); 
        }
    }else {
      cur = rec; 
    }
  }

  if (manual) {
    if (cur == "RD") {
      RH_down();
    } else if (cur == "RU") {
      RH_up();
    } else if (cur == "LD") {
      LH_up();
    } else if (cur == "LU") {
      LH_down();
    }else if (cur == "MF"){
      move_forward();
    }else if (cur == "MB"){
      move_backward();
    }
  }
  else {
    if (cur == "H") {
      greeting();
      cur = "";
    } else if (cur == "D") {
      Dance(); 
    }
  }
}