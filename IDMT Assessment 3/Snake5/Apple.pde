class Apple {
  float xpos;
  float ypos;
  float w;

  Apple(float tempW) {
    w = tempW;
  }

  void display() {
    fill(237, 24, 24);
    rect(xpos, ypos, w, w);
  }
}
