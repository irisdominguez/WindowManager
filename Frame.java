class Frame {
  public int x;
  public int y;
  public int w;
  public int h;
  private Window wd;
  
  Frame(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  Frame(float x, float y, float w, float h) {
    this.x = (int) x;
    this.y = (int) y;
    this.w = (int) w;
    this.h = (int) h;
  }
  
  boolean contains(float x, float y) {
    if (x > this.x && x < this.x + this.w &&
        y > this.y && y < this.y + this.h) {
      return true;
    } else {
      return false;
    }
  }
  
  public void setWindow(Window wd) {
    this.wd = wd;
    wd.setup();
  }
  
  public Window getWindow() {
    return this.wd;
  }
}
