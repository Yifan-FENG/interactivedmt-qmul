Segment[] snake;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
int count = 144;
int active = 2;
float segLength;
float tick = 8;
Apple apple;
boolean eaten = true;
PFont myFont;
String scoreText;
int score = 1;
int now = 0;
int state = 1;

import processing.serial.*; //port com initialize
Serial myPort;

float xVal=0 ; //
void setup() {
  size(600, 600);

  myFont = createFont("Anonymous-48", 34);
  textFont(myFont);
  textAlign(CENTER);

  snake = new Segment[count];
  //snake[0] = new Segment(0,0);

  for (int i = 0; i < count; i++) {
    snake[i] = new Segment(-10000, -10000);
  }

  segLength = snake[0].speed;
  spawnHead();
  apple = new Apple(segLength);
  stroke(255);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 19200);
}


void draw() {

  //serial port reading
  if ( myPort.available() > 0)
  {   // If data is available,
    String val = myPort.readStringUntil('\n'); // read it and store it in val
    //println(val); //print it out in the console

    if (val != null)
    { // received a valid piece of data
      xVal= float(val); 

      //potentiometer value go to  xVal (to change a parameter with Potentiometer)
      if (val.charAt(0)== 'A') xVal = float(val.substring(1)); 
      //println(xVal);
      {

        if (val.charAt(0)== 'B')
        {
          down = true;
          up = false;
          left = false;
          right = false;
          now = 2;
        }
        if (val.charAt(0)== 'C')

        {
          down = false;
          up = true;
          left = false;
          right = false;
          now =1;
        }
        if (val.charAt(0)== 'D')
        {
          down = false;
          up = false;
          left = false;
          right = true;
          now=4;
        }
        if (val.charAt(0)== 'E') {
          down = false;
          up = false;
          left = true;
          right = false;
          now=3;
        }
      }
    }
  }
  background(#9bba5a);

  scoreText = "" + score; 

  text(scoreText, 0, 50);

  for (int i = 0; i < active; i++) {
    snake[i].display();
  }

  appleUpdate();
  eat();

  if (frameCount % tick == 0) {
    if (down == true) {
      snake[0].ypos += segLength;
    } else if (up == true) {
      snake[0].ypos -= segLength;
    } else if (right == true) {
      snake[0].xpos += segLength;
    } else if (left == true) {
      snake[0].xpos -= segLength;
    }

    if (snake[0].xpos < 20) {
      //snake[0].xpos = width;
      state =2;
    } else if (snake[0].xpos > width-20) {
      //snake[0].xpos = 0;
      state =2;
    } else if (snake[0].ypos < 20) {
      //snake[0].ypos = height;
      state =2;
    } else if (snake[0].ypos > height-20) {
      //snake[0].ypos = 0;
      state =2;
    }

    checkCollision();
    moveBody();
  }

  fill(0);
  for (int i = 0; i<width/20; i++)
  {
    rect(i*20, 0, 20, 20);  
    rect(i*20, height-20, 20, 20);  

    rect(0, i*20, 20, 20); 
    rect(width-20, i*20, 20, 20);
  }

  if (state ==2) {
    background(0);
    fill(255);
    text("YOU LOSE!", width/2, height/2);
    myPort.write('1'); //send a 1
  }
}

void keyPressed() {
  if (keyCode == 'S' ||keyCode == 's' && now!=1) {
    down = true;
    up = false;
    left = false;
    right = false;
    now = 2;
  } else if (keyCode == 'w' ||keyCode == 'W' && now!=2) {
    down = false;
    up = true;
    left = false;
    right = false;
    now =1;
  } else  if (keyCode == 'd' ||keyCode == 'D'&& now!=3) {
    down = false;
    up = false;
    left = false;
    right = true;
    now=4;
  } else  if (keyCode == 'A' ||keyCode == 'a'&& now!=4) {
    down = false;
    up = false;
    left = true;
    right = false;
    now=3;
  }
}

/*
void keyReleased(){
 if(down == true){
 snake[0].ypos += snake[0].speed;
 down = false;
 } else if(up == true){
 snake[0].ypos -= snake[0].speed;
 up = false;
 } else if(right == true){
 snake[0].xpos += snake[0].speed; 
 right = false;
 } else if(left == true){
 snake[0].xpos -= snake[0].speed; 
 left = false;
 }
 }
 */

void spawnHead() {
  snake[0].xpos = round(random(2, (width/segLength) - 2))*segLength;
  snake[0].ypos = round(random(2, (width/segLength) - 2))*segLength;
}

void moveBody() {
  snake[0].preXpos = snake[0].xpos; 
  snake[0].preYpos = snake[0].ypos;
  for (int i = 1; i < active; i++) {
    snake[i].preXpos = snake[i].xpos;
    snake[i].preYpos = snake[i].ypos;
    snake[i].xpos = snake[i - 1].preXpos; 
    snake[i].ypos = snake[i - 1].preYpos;
  }
}

void appleUpdate() {
  if (eaten == false) {
    apple.display();
  }
  if (active<4)
  {
    apple.xpos = snake[0].xpos;
    apple.ypos=snake[0].ypos;
  }
  if (eaten == true) {
    if (active>=4)
    {
      apple.xpos = round(random(2, (width/segLength) - 2))*segLength;
      apple.ypos = round(random(2, (width/segLength) - 2))*segLength;
    }
    eaten = false;
  }
}

void eat() {
  if (snake[0].xpos == apple.xpos && snake[0].ypos == apple.ypos) {
    eaten = true;
    active += 1;
    score += 1;
  }
}

void checkCollision() {
  for (int i = 2; i < active; i++) {
    if (snake[0].xpos == snake[i].xpos && snake[0].ypos == snake[i].ypos) {
      active = 2; 

      for (int j = 1; j < count; j++) {
        snake[j].xpos = -10000;
        snake[j].ypos = -10000; 

        score = 1;
      }
    }
  }
}
