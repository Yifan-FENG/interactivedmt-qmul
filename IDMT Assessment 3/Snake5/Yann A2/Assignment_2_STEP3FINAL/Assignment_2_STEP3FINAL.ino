/*
  AnalogReadSerial

  Reads an analog input on pin 0, prints the result to the Serial Monitor.
  Graphical representation is available using Serial Plotter (Tools > Serial Plotter menu).
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

  This example code is in the public domain.

  http://www.arduino.cc/en/Tutorial/AnalogReadSerial
*/
const int buttonLEFT =2;
const int buttonUP =3;
const int buttonDOWN =4;
const int buttonRIGHT =5;

const int buzzer =  13;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(19200); //communication with Processing possible

  Serial.println("CLEARDATA"); //clears up any data left from previous projects

//  Serial.println("LABEL,Acolumn,Bcolumn,..."); //always write LABEL, so excel knows the next things will be the names of the columns (instead of Acolumn you could write Time for instance)

  Serial.println("RESETTIMER"); //resets timer to 0

  
  
  pinMode(buttonLEFT, INPUT);
  pinMode(buttonUP, INPUT);
  pinMode(buttonDOWN, INPUT);
  pinMode(buttonRIGHT, INPUT);
  
  //BUZZER initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  
}

// the loop routine runs over and over again forever:
void loop() {
  
  Serial.print("DATA,TIME,TIMER,"); //writes the time in the first column A and the time since the measurements started in column B
//buzzer from processing
char val;
if (Serial.available())
{ // If data is available to read,
val = Serial.read(); // read it and store it in val
}
if (val == '1')
{ // If 1 was received
digitalWrite(buzzer, HIGH); // turn the buzzer on
delay(50);
}else{
  if (val == '2')
digitalWrite(buzzer, LOW); // turn the buzzer off
delay(50);
} 

   
  // read the input on analog pin 0: Potentionmeter value
  int sensorValue = analogRead(A0); 
  
// read the button value //4 buttons
int buttonValueL = digitalRead(buttonLEFT);
int buttonValueU = digitalRead(buttonUP);
int buttonValueD = digitalRead(buttonDOWN);
int buttonValueR = digitalRead(buttonRIGHT);


if (buttonValueL == HIGH) {
    // turn buzzer on + serial print:
    Serial.println("B"+String(buttonValueL));//Button LEFT
 //   digitalWrite(buzzer, HIGH);
 // } else {
 //   // turn LED off:
 //   digitalWrite(buzzer, LOW);
    delay(50);
  }

if (buttonValueU == HIGH) {
    // turn buzzer on + serial print:
    Serial.println("C"+String(buttonValueU));//Button UP
 //   digitalWrite(buzzer, HIGH);
 // } else {
 //   // turn LED off:
 //   digitalWrite(buzzer, LOW);
    delay(50);
  }
if (buttonValueD == HIGH) {
    // turn buzzer on + serial print:
    Serial.println("D"+String(buttonValueD));//Button DOWN
 //   digitalWrite(buzzer, HIGH);
 // } else {
 //   // turn LED off:
 //   digitalWrite(buzzer, LOW);
    delay(50);
  }
  if (buttonValueR == HIGH) {
    // turn buzzer on + serial print:
    Serial.println("E"+String(buttonValueR));//Button RIGHT
 //   digitalWrite(buzzer, HIGH);
 // } else {
 //   // turn LED off:
 //   digitalWrite(buzzer, LOW);
    delay(50);
  }

  // print out the value you read:
  Serial.println("A"+String(sensorValue));//Potentiometer
  delay(100);        // delay in between reads for stability


  
}
