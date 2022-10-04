class Segment {
  float xpos;
  float ypos;
  float preXpos;
  float preYpos;
  color cAlive = color(#00004B);
  color cDead = color(0, 0, 0);
  boolean alive = true;
  float speed = 20;

  Segment(float tempX, float tempY) {
    xpos = tempX;
    ypos = tempY;
  }

  void display() {
    if (alive == true) {
      fill(cAlive);
    } else if (alive == false) {
      fill(cDead);
    }
    rect(xpos, ypos, speed, speed);
  }
}
