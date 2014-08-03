class AudioPlayerWindow extends Window {
  
  Maxim maxim;
  AudioPlayer player;
  
  boolean playing = false;
  
  public AudioPlayerWindow() {
    name = "AudioPlayer";
  }
  
  public Window copy() {
    return new AudioPlayerWindow();
  }

  void setup() {
    maxim = new Maxim(applet);
    player = maxim.loadFile("mybeat.wav");
    player.setLooping(true);
  }

  void draw() {
    if (!playing) {
      player.stop();
    } else {
      player.play();
    }
    fill(255);
    pushMatrix();
    translate(x + width * .5, y + height * .5);
    float size = min(width, height);
    if (!playing) {
      triangle(size * -.3, size * -.3, size * -.3, size * .3, size * .3, size * .0); 
    } else {
      rect(size * -.3, size * -.3, size * .2, size * .6);
      rect(size * .1, size * -.3, size * .2, size * .6);
    }
    popMatrix();
  }
  
  void mouseClicked() {
    playing = !playing;
  }
  
  void close() {
    player.stop();
  }
  
}
