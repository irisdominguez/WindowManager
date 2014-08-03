class Rainbow extends Window {
  
  float h;
  float pass = 1;
  
  public Rainbow() {
    name = "Rainbow";
  }
  
  public Window copy() {
    return new Rainbow();
  }

  void setup() {
    h = 0;
  }

  void draw() {
    colorMode(HSB);
    bg(h, 255, 255);
    h = h + pass;
    h = (h > 255) ? 0 : h;
  }
  
}
