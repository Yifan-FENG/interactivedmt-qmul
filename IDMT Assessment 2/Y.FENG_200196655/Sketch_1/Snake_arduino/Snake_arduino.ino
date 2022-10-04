//Snake Game with Processing: button event 
//Made by Yifan Feng (y.feng@se20.qmul.ac.uk) 
//resource tutorial:  https://www.bilibili.com/video/BV1YW411Z76E 

int switchPin1 = 2;                       // Switch connected to 4 pins, input pins are: 2,3,4,5,
int switchPin2 = 3;
int switchPin3 = 4;
int switchPin4 = 5;

void setup() {
  pinMode(switchPin1, INPUT);             // Set pin 0 as an input
  pinMode(switchPin2, INPUT);
  pinMode(switchPin3, INPUT);
  pinMode(switchPin4, INPUT);

  Serial.begin(19200);                    // Start serial communication at 19200 bps
}

//check on processing Direction Control (void ked(int a)) 
//int a aims to match input value 
// a == 1, key event = 'L' 
// a == 2, key event = 'R' 
// a == 3, key event = 'D'
// a == 4, key event = 'U' 
void loop() {
  if (digitalRead(switchPin1) == HIGH) {  // If switch is ON,  in processing keycase 1 == LEFT
    Serial.write(1);               // send a byte with the value 1 to Processing, later match up with processing int a value
  }
  if (digitalRead(switchPin2) == HIGH) {  // If switch is ON,  in processing keycase 2 == RIGHT
    Serial.write(2);               // send 2 to Processing
  }
  if (digitalRead(switchPin3) == HIGH) {  // If switch is ON,  in processing keycase 3 == DOWN
    Serial.write(3);               // send 3 to Processing
  }
  if (digitalRead(switchPin4) == HIGH) {  // If switch is ON,  in processing keycase 4 == UP
    Serial.write(4);               // send 4 to Processing
  }
  delay(50);                            // Wait 50 milliseconds
}
