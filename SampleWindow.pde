class SampleWindow extends Window {
  
  public SampleWindow() {
    name = "Sample Window";
  }
  
  public Window copy() {
    return new SampleWindow();
  }

  void setup() {
    println("SETUP");
    println("wh" + width + " " + height);
  }

  void draw() {

  }
  
}
