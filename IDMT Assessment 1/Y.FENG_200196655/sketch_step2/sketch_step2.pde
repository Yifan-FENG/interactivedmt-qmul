//Snake Game Step 2: add direction control
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


void setup() { 
  size(756, 555); //size from https://playsnake.org/ 
  smooth(2); 
  frameRate(5); 
}

void draw() {
  background(background_color);  
  snake();
  snake_body_change(); 
  snake_movement();
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
void keyPressed() {
  if (key == CODED) { 
    if (keyCode == LEFT) {
      snake_direction = 'L';
    } else if (keyCode == RIGHT) {
      snake_direction = 'R';
    } else if (keyCode == DOWN) {
      snake_direction = 'D';
    } else if (keyCode == UP) {
      snake_direction = 'U';
    }
  }
}
