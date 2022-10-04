//Snake Game with Processing: Motor Spin
//Made by Yifan Feng (y.feng@se20.qmul.ac.uk)
//resource tutorial:  https://www.bilibili.com/video/BV1YW411Z76E
//resource website: https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing/all#shaking-hands-part-1

//ButtonPin Input
int switchPin1 = 2;                       // Switch connected to 4 pins, input pins are: 2,3,4,5,
int switchPin2 = 3;
int switchPin3 = 4;
int switchPin4 = 5;

//Potentiomether Input
int sensorPin = A0; //potentiometers input pin A0
int sensorValue = 0; //set orginal sensor vaue 0

//Boolean Collision Detection
bool start = false;
int t = 0; //timer original: 0, this is used to caculate timepass

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
    Serial.write(2);               // send value 2 to Processing
  }
  if (digitalRead(switchPin3) == HIGH) {  // If switch is ON,  in processing keycase 3 == DOWN
    Serial.write(3);               // send value 3 to Processing
  }
  if (digitalRead(switchPin4) == HIGH) {  // If switch is ON,  in processing keycase 4 == UP
    Serial.write(4);               // send value 4 to Processing
  }
  delay(50);                            // Wait 50 milliseconds for response


  //distinguish two kinds of sensor value: 1-4 for directin control, 6-1023 for speed control
  sensorValue = analogRead(sensorPin) + 5; // +5 is used to distinguish input value: direction or speed
  if (sensorValue > 1023) //sensor value range: 0 - 1023， if sensor value goes beyond the range, reset sensor value to control max value
    sensorValue = 1023;
  Serial.write(sensorValue);
  delay(50);   // Wait 50 milliseconds for response

  //in the loop, when Arduino receives a signal from Processing, function begins
  if (start)  // if time caculation is triggered
  {
    t++; //time increase 1
    digitalWrite(13, HIGH); //Pin 13 connects to motor, HIGH = on, Motor spins
  }
  else
    digitalWrite(13, LOW); //Motor stops spinning
  if (t > 300)  //if time is accumulated more than 300 times
  {
    t = 0;     //reset timer to 0
    start = false;    //time caculation stops
  }
}

//connect Processing to Arduino
//External tutorials: https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing/all#shaking-hands-part-1
//when hitting the boundry, game over is TRUE, Arduino receives a signal (digit 0) to trigger timers for motor
//modification in the Processing void gameover() -> myPort.write(0); to output game over signal

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read(); //read input from Processing, if it is 0
    start = true; //timer begins, motor starts spinning
  }
}
