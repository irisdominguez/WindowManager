import processing.core.*; 

abstract class Window {
  PApplet applet;
  String name;
  float x;
  float y;
  float width;
  float height;
  
  void setApplet(PApplet applet) {
    this.applet = applet;
  }
  
  String getName() {
    return this.name;
  }
  
  abstract Window copy();

  void setup() {};
  void draw() {};
  void mousePressed() {};
  void mouseDragged() {};
  void mouseReleased() {};
  void mouseClicked() {};
  void close() {};
  
  void bg(float n) {bg(n, n, n);}
  void bg(float r, float g, float b) {
    applet.fill(r, g, b);
    applet.rect(x, y, width, height);
  }
}
