class RotatingTriangle extends Window {
  
  float rot;
  float pass = 1;
  
  public RotatingTriangle() {
    name = "RotatingTriangle";
  }
  
  public Window copy() {
    return new RotatingTriangle();
  }

  void setup() {
    rot = 0;
  }

  void draw() {
    bg(0);
    pushMatrix();
    translate(x, y);
    translate(width * 0.5, height * 0.5);
    rotate(radians(rot));
    rot = rot + pass;
    rot = (rot > 360) ? 0 : rot;
    colorMode(HSB);
    fill(rot / 360 * 255, 255, 255);
    float size = min(width, height);
    triangle( size * -.3, size * -.3, size * .0, size * .3, size * .3, size * -.3); 
    popMatrix();
  }
  
}
