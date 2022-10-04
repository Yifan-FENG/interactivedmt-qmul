//snake_test 
//snake: length, direction, speed, color
//apple: random position, color, yes/no
//background, game begin/over 

//background color 
int background_color =255;

//snake length 
int snake_length = 3; 

// snake head 
int snake_head_x;
int snake_head_y; 

//snake length
int snake_length_max = 500; 

//snake body 
int[] x = new int[snake_length_max]; 
int[] y = new int[snake_length_max];

//grid (snake_size) 
int grid = 20;

//direction 
int snake_direction = 'R'; 
int snake_direction_temp; 

//speed 
int speed = 5; // five grids per sec 
int time_saved;
int time_passed; 
int time_interval; 

//time_saved = mills(); 
//time_interval - 1000/speed;
//time_passed = mills() - time_saved; 

//apple
int food_x;
int food_y; 
boolean food_key = true; // true = food not given 

//grade
int BestScore = snake_length-3;

//pause
int game_pause =0;

//game over
boolean game_over = false; 
boolean game_begin = false;


void setup() {
  size(600, 600);
  frameRate(30);
  time_saved = millis(); //system tim, unit milliseconds
}

void draw() {

  if (keyPressed && (key=='r' || key == 'R')) {
    game_begin = true;
  }
  //if statement for restarting game (3 conditions) 
  if (game_again()) {
    return;
  }

  time_interval = 1000/speed; //time interval between movements 
  time_passed = millis() - time_saved; //passing time 
  if (snake_direction != 'P' && time_passed > time_interval) {

    background(background_color);
    switch(snake_direction) {  //direction 
    case'L':
      snake_head_x = snake_head_x - grid;
      break;
    case'R':
      snake_head_x = snake_head_x + grid;
      break;
    case'D':
      snake_head_y = snake_head_y + grid;
      break;
    case'U':
      snake_head_y = snake_head_y - grid; 
      break;
    } 
    
    food_new(width, height);

    //eat apple and modify length 
    if (snake_head_x == food_x && snake_head_y == food_y) {
      food_key = true;
      snake_length ++;
      if (snake_length%5 == 1);
      {
        speed++;
      }
    }
    speed = min(10, speed); //control the speed

//basic snake info   
    stroke(0);
    strokeWeight(1);

    fill(127); //head
    rect(x[0], y[0], grid, grid,7); 

    fill(#00004B);
    for (int i=1; i<snake_length; i++) rect(x[i], y[i], grid, grid,7);
      
    //understand the position change of each part!!!!!
    for (int i=snake_length -1; i>0; i--) { //body length change
      x[i] = x[i-1]; //head takes over the position of food 
      y[i] = y[i-1];
    }
    x[0] = snake_head_x; //reorganize head position
    y[0] = snake_head_y; 

    
    if (snake_die()) { 
      return; //if true, break the loop and restart
    }

    time_saved = millis();
  }
}

void keyPressed() {
  if (key == 'p' || key == 'P') {
    game_pause++;
    if (game_pause%2 == 1) { //one press, pause; two, continue
      snake_direction_temp = snake_direction; //save direction at that time 
      snake_direction = 'P';
    } else {
      snake_direction = snake_direction_temp;
    }
  }
  if (snake_direction != 'P' && key ==CODED) { 
    switch(keyCode) {  //read system-predefined keyboard code
    case LEFT :
      snake_direction = 'L';
      break;
    case RIGHT :
      snake_direction = 'R';
      break;
    case DOWN:
      snake_direction = 'D';
      break;
    case UP:
      snake_direction = 'U'; 
      break;
    }
  } else if  (snake_direction != 'P') { //read defined keyboard code 
    switch (key) {
    case 'A':
    case 'a':
      snake_direction = 'L';
      break; 
    case 'D':
    case 'd':
      snake_direction = 'R';
      break; 
    case 'S':
    case 's':
      snake_direction = 'D';
      break;
    case 'W':
    case 'w': 
      snake_direction = 'U';
      break;
    }
  }
}


//random food appearence
//question: food could appear in snake body/head/tail 
void food_new(int maxwidth, int maxheight) {
  fill(#ED1818);
  int food_outbody = 0; //if food outbody = false 
  if (food_key) {
    while (food_outbody == 0) {
      food_outbody = 1; 
      food_x = int (random(0, maxwidth)/grid) * grid;
      food_y = int (random(0, maxheight)/grid) * grid;
      for (int i=snake_length -1; i>=0; i--) {
        if (food_x == x[i] && food_y == y[i]) {
          food_outbody = 0;
        }
      }
    }
  }
  rect(food_x, food_y, grid, grid);
  food_key = false;
}


//snake death  body/boundary  collision 
boolean snake_die() {
  if (snake_length>=3) {
    for (int i=1; i<snake_length; i++) {  
      if (snake_head_x == x[i] && snake_head_y == y[i]) { //head and body collison  
        show_gameover();
        return true;
      }
    }
    if  (snake_head_x<0 || snake_head_y<0 || snake_head_x>width || snake_head_y>height) {
      show_gameover(); 
      return true;
    }
  }
  return false;
}

void show_gameover() {
  pushMatrix();
  game_over = true;
  BestScore = BestScore > snake_length ? (BestScore -3) : (snake_length -3); // if snake_length > BS-2, bestscore = BS-2 

  background(0); 
  translate(width/2, height/2-50);
  fill(255);
  textAlign(CENTER); 
  textSize(84);
  text(snake_length -3 +"/" + BestScore, 0, 0); 

  fill(120);
  textSize(40);
  text("Score/Best", 0, 230);
  text("Game over, Press 'R' to restart.", 0, 260);
  popMatrix();
}

//if game continues, game_again -> false
//if game ends, press r: restart -> true 
//              not press r:  game_again -> false

boolean game_again() {
  if (game_over && keyPressed && (key=='r' || key=='R')) {
    snake_start();
  }
  return game_over;
} 

void snake_start() {
  background(background_color);
  snake_length =3;
  game_over = false;
  snake_head_x = 0;
  snake_head_y = 0; 
  snake_direction = 'R';
  speed =5;
} 
