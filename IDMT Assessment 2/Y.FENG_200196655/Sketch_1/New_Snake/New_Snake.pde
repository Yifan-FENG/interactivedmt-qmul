//Snake Game with Arduino 
//Made by Yifan Feng (y.feng@se20.qmul.ac.uk) 
//resource tutorial videos: https://www.bilibili.com/video/BV1YE411T7dG
//resource tutorial website: https://www.learnjavacoding.com/definitions/snake/ 

//Background Settings 
int background_color = #9bba5a; //color palate from https://playsnake.org/ 

//snake color settings 
int snake_color = #00004B; //color palate from https://playsnake.org/  

//snake length at original: 3 units 
int snake_length = 3; 

//snake size: rect( )
int snake_size = 15;  

//snake head position 
int snake_head_x;
int snake_head_y; 

//snake length max: the snake can only take no more than 497 points 
int snake_length_max = 500; 

//snake body: after getting one point, body is one unit longer than last 
//hint: for loop to build body length; length shown on x and y axis 
int[] x =  new int[snake_length_max];
int[] y = new int[snake_length_max]; 

//animation
//direction: initial direction (to right) 
int snake_direction = 'R'; 
//speed 
int speed = 15; 

//Game start/over default
boolean game_over = false; 

//Grade/Points: have to detract snake length by default (3 units) 
int BestScore = snake_length - 3; 

//Apple and Points
int apple_x;
int apple_y;
boolean apple_given = true;  
//=============================================================
//Use Serial communication to link Processing with Arduino 
import processing.serial.*; //connect processing to Arduino via serial communication 

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
//=========================================================
void setup() { 
  size(756, 555); //size from https://playsnake.org/ 
  smooth(2); 
  frameRate(5);
  //================================================
  String portName = Serial.list()[5]; //port number (default is 5) 
  myPort = new Serial(this, portName, 19200); 
}

void draw() {
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    ked(val);
  }
  //=========================================================
  background(background_color); 

  snake();
  apple_appearence(int(random(width)), int(random(height)));
  snake_body_change(); 
  snake_apple_body(); 
  snake_movement();
  snake_die();
} 

//draw "snake" function 
void snake() {

  //basic snake head info 
  stroke(0);
  strokeWeight(1);
  fill(snake_color);
  rect(x[0], y[0], snake_size, snake_size, 7); //7 is radii or all four corners (round)

  //basic snake body info
  //body get one unit in x and y axis 
  fill(127); 
  for (int i=1; i<snake_length; i++) rect(x[i], y[i], snake_size, snake_size, 7);
}

void snake_body_change() {
  //snake body change: 
  //head position always be 0 and body follows in position 1&2 
  //head and body should be lined up (0-1-2)  
  //each time when head in food position(-1), head (0->-1), body(1->0), body(2->1) 
  for (int i= snake_length - 1; i>0; i--) {
    x[i] = x[i-1]; 
    y[i] = y[i-1];
  }
  x[0] = snake_head_x; //reset head coordinates after getting one point 
  y[0] = snake_head_y;
} 

//animation 
//snake movement (animation) 
//switch reference: https://processing.org/reference/switch.html 
//basic logic: position - speed (predefined speed = 15)
void snake_movement() {
  switch(snake_direction) {  
  case'L': //left 
    snake_head_x = snake_head_x - speed;
    break;
  case'R': //right
    snake_head_x = snake_head_x + speed;
    break;
  case'D': //down
    snake_head_y = snake_head_y + speed;
    break;
  case'U': //up
    snake_head_y = snake_head_y - speed; 
    break;
  }
}

//direction control 
//use default left keycode 
//source code: https://processing.org/reference/keyCode.html 
//void keyPressed() {
//  if (key == CODED) { 
//    if (keyCode == LEFT) {
//      snake_direction = 'L';
//    } else if (keyCode == RIGHT) {
//      snake_direction = 'R';
//    } else if (keyCode == DOWN) {
//      snake_direction = 'D';
//    } else if (keyCode == UP) {
//      snake_direction = 'U';
//    }
//  }
//}

//New Direction Control from ARDUINO 
//set an integer a to match up with arduino input value 
void ked(int a) {  
  if (a==1) {                         //serial signal 1 is for left 
    snake_direction = 'L';   
  } else if (a==2) {                  //serial signal 2 is for right
    snake_direction = 'R';
  } else if (a==3) {                  //serial signal 3 is for right
    snake_direction = 'D';
  } else if (a==4) {                  //serial signal 4 is for right
    snake_direction = 'U';
  }
} 


//snake death: boundary collision 
//basic logic: head x and y coordinates locate outside canvas size 
boolean snake_die() {
  if  (snake_head_x<0 || snake_head_y<0 || snake_head_x>width || snake_head_y>height) {
    gameover();
    return true;
  }
  return false;
}

//game over logic:if snake_length > BS-3, bestscore = BS-3 
void gameover() {
  pushMatrix();
  game_over = true;
  BestScore = BestScore > snake_length ? (BestScore -3) : (snake_length -3); 
  background(0); 
  translate(width/2, height/2-80); //translate the origin(0,0) to any position in the canvas 
  fill(255);
  textAlign(CENTER); 
  textSize(90);
  text(snake_length -3 +"/" + BestScore, 0, 0); 

  fill(137);
  textSize(50);
  text("My BestScore", 0, 230);
  popMatrix();
}

//random food(apple) appearence 
//obstacle: food could draw on snake body/head/tail
//source code: https://www.bilibili.com/video/BV1YE411T7dG 
//while statement: https://www.w3schools.com/java/java_while_loop.asp
void apple_appearence(int maxwidth, int maxheight) {

  //if apple given = false, apple outbody = true, apple coordinates randomly appear
  //if apple given = true, for every apple x/y and snake x/y clash, snake x -> apple x or snake y -> apple y
  boolean apple_outbody = true; 
  if (apple_given) {  //apple_given is true 
    while (apple_outbody) { //when apple_outbody true 
      apple_outbody = false; 
      apple_x = int (random(0, maxwidth)/snake_size)*snake_size; 
      apple_y = int (random(0, maxheight)/snake_size)*snake_size;
      for (int i=snake_length -1; i>=0; i--) {
        if (apple_x == x[i] && apple_y == y[i]) {
          apple_outbody = true;
        }
      }
    }
  } 
  //draw apple 
  stroke(0);
  strokeWeight(1);
  fill(#ED1818); 
  rect(apple_x, apple_y, snake_size, snake_size, 7); //draw apple
  apple_given = false;
}

//eat apple and modify snake length 
//basic logic: snake head cooordinates are replaced by apple coordinates, length + 1 
void snake_apple_body() {
  if (snake_head_x == apple_x && snake_head_y == apple_y) {
    apple_given = true;
    snake_length ++;
  }
}
