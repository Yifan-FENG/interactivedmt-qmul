import processing.serial.*; //port com initialize
Serial myPort;
float xVal=0 ; //
char direction;


int speed=20; //same as grid
 
//create a window
//set up a program
int snake_size=3; //snake size
int score=0;
int[] x = new int[10000];
int[] y = new int[10000];



//Use for movement scale
int grid=20;

//Snake head
int[] snake_head ={500,500,grid,grid};//(x,y,w,h)



//Fruit random 
int[] fruit ={int (random(10, 400)),int (random(10, 400)),grid,grid};



void fruit(){
fruit[0]=int (random(10, 400));//move randomly the x of the fruit
fruit[1]=int (random(10, 400));//move randomly the y of the fruit
snake_size+=1;
score+=1;
  
} 




void gameover(){
 background(0);
 fill(255);
 textSize(50);
 delay(500);
 text("GAME OVER", 10, 150);
 delay(500);
 text("score :"+score, 50, 300);
 delay(500);
 //buzzer on Arduino
myPort.write('1'); //send a 1
delay(500);
println("sent: 1"); // debugging  buzzer on
 score=0;
 snake_head[0]=500;
 snake_head[1]=500;
 snake_size=3;
 myPort.write('2'); //send a 2 
delay(500);
println("sent: 2"); // debugging buzzer off
direction='Y'; //up initial direction
 }

void setup(){
  
  frameRate(30);
  //printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 19200);
 direction='Y'; //up initial direction
  //canvas
  size(1000,1000);//(x,y)in pixels  
 }




//keyboard
//void control(){        
//    if(keyCode == RIGHT) snake_head[0] = snake_head[0]+grid; 
//    if(keyCode == DOWN) snake_head[1] = snake_head[1]+grid;
//    if(keyCode == UP) snake_head[1] = snake_head[1]-grid;
//    if(keyCode == LEFT) snake_head[0] = snake_head[0]-grid;
//    delay(time);
//   }




//to draw things
void draw()
{  
    
  background(0); //Black  
  stroke(0,0,0);//outline R.G.B.
  fill(204,102,0);//color
  fill(255);
  textSize(20);
  text("score :"+score, 10, 50);
  speed=round((xVal/100))+20;
  //println(speed);
  //control();
    
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
    
 if (val.charAt(0)== 'B') direction='B';
 if (val.charAt(0)== 'C') direction='C';
 if (val.charAt(0)== 'D') direction='D';
 if (val.charAt(0)== 'E') direction='E';
 //delay(speed);
{
  
  //buttons control 
 switch(direction) // the first character gives type of sensor
  {
  case 'B':
  snake_head[0] = snake_head[0]-speed; //left 
  break;
  case 'C':
  snake_head[1] = snake_head[1]-speed; //UP
  break;
  case'D':
  snake_head[1] = snake_head[1]+speed;//DOWN
  break; 
  case 'E':
  snake_head[0] = snake_head[0]+speed; //right
  break;

   }
  }
  }
  
    
  //Create snake body ok
   for (int i = snake_size-1; i > 0; i--) { 
    x[i] = x[i-1];
    y[i] = y[i-1];
  }
  // Add the new values to the beginning of the array  ok
  x[0] = snake_head[0];
  y[0] = snake_head[1];

  
  // Draw the snake
  for (int i = 0; i < snake_size; i++) {
    rect(x[i], y[i], grid, grid);
    
  }
      
    //Body collision Gameover OK
   for (int i=snake_size -1; i>=4; i--) {
        if (snake_head[0] == x[i] && snake_head[1] == y[i]) {
      gameover();
    }
   }
  
  
  //Colision head with border OK 
  if  (snake_head[0]<0 || snake_head[1]<0 || snake_head[0]>width || snake_head[1]>height) {   
    gameover();
  }
  
//collision body ok
if (snake_head[0] + grid >= fruit[0] &&     // r1 right edge past r2 left
  snake_head[0] <= fruit[0]+ grid &&       // r1 left edge past r2 right
  snake_head[1] + grid >= fruit[1] &&       // r1 top edge past r2 bottom
  snake_head[1] <= fruit[1]+ grid) {       // r1 bottom edge past r2 top
 fruit();
}
  
   
//Fruit appears ok
  stroke(0,0,0);
  fill(255,0,0);
  rect(fruit[0], fruit[1], grid, grid);
}
}
}
