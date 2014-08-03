ArrayList<Window> windowPool;
ArrayList<Frame> frames;

Point dragOrigin = new Point();
Point dragEnd = new Point();

int dragged = 0;
int dragThreshold = 0; // Maximum number of drag events to consider a click event
//int dragThreshold = 10; // Set to 10 on Android
// Important: AudioPlayer will make android crash!

Point minWindowSize = new Point(10, 10);

int selectedFrame = -1;
float selectorW = 150;
float selectorBaseH = 20;

float colorSelectorW = 50;
int[][] bgcolors = {{0, 0, 0},
              {84, 41, 123},
              {69, 108, 35},
              {35, 77, 108},
              {113, 82, 33}};

int currbgcolor = 0;
Point currentColorSelecotPosition = new Point();

State state = State.NONE;

//////////////////////////////
//////////////////////////////
// SETUP
//////////////////////////////
//////////////////////////////
void setup() {
  size(600, 600);
  windowPool = new ArrayList<Window>();
  frames = new ArrayList<Frame>();
  
//  windowPool.add(new SampleWindow());
  windowPool.add(new Rainbow());
  windowPool.add(new RotatingTriangle());
  windowPool.add(new Cube3D());
  windowPool.add(new AudioPlayerWindow());
}

//////////////////////////////
//////////////////////////////
// DRAW
//////////////////////////////
//////////////////////////////
void draw() {
  background(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  stroke(255);
  colorMode(RGB);
  for (int i = 0; i < frames.size(); i++) {
    Frame f = frames.get(i);
    if (f.getWindow() != null) {
      f.getWindow().draw();
    }
    if (f.getWindow() == null) {
      fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
    } else {
      noFill();
    }
    stroke(255);
    colorMode(RGB);
    rect(f.x, f.y, f.w, f.h);
  }
  if (state == State.CREAT) {
    noFill();
    float w = mouseX - dragOrigin.x;
    float h = mouseY - dragOrigin.y; 
    rect(dragOrigin.x, dragOrigin.y, w, h);
  }
  
  if (state == State.SELECT) {
    showAppSelector();
  }
  
  if (state == State.COLOR) {
    showColorSelector();
  }
  
  showHud();
}

//////////////////////////////
//////////////////////////////
// MOUSE ACTIONS
//////////////////////////////
//////////////////////////////
void mousePressed() {
  dragged = 0;
  if (state == State.NONE) {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
         if (f.getWindow() != null) {
           frames.remove(f);
           frames.add(f);
           f.getWindow().mousePressed();
           state = State.INTERACT;
           return;
         }
      }
    }
  } else if (state == State.MOVE) {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
         frames.remove(f);
         frames.add(f);
         selectedFrame = frames.size() - 1;
         break;
      }
    }
  } else if (state == State.RESIZE) {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
         frames.remove(f);
         frames.add(f);
         selectedFrame = frames.size() - 1;
         break;
      }
    }
  }
  dragOrigin.x = mouseX;
  dragOrigin.y = mouseY;
}

void mouseDragged() {
  dragged++;
  if (dragged < dragThreshold) {
    if (dragged == dragThreshold - 1) {
      dragOrigin.x = mouseX;
      dragOrigin.y = mouseY;
    }
    return;
  }
  if (state == State.INTERACT) {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
         if (f.getWindow() != null) {
           f.getWindow().mouseDragged();
           return;
         }
      }
    }
  } else if (state == State.MOVE) {
    if (selectedFrame != -1) {
      Frame f = frames.get(selectedFrame);
      f.x += mouseX - pmouseX;
      f.y += mouseY - pmouseY;
      if (f.getWindow() != null) {
        f.getWindow().x = f.x;
        f.getWindow().y = f.y;
      }
    }
  } else if (state == State.RESIZE) {
    if (selectedFrame != -1) {
      Frame f = frames.get(selectedFrame);
      f.w += mouseX - pmouseX;
      f.w = max(f.w, 0);
      f.h += mouseY - pmouseY;
      f.h = max(f.h, 0);
      if (f.getWindow() != null) {
        f.getWindow().width = f.w;
        f.getWindow().height = f.h;
      }
    }
  } else {
    float x = dragOrigin.x;
    float y = dragOrigin.y;
    float w = mouseX - x;
    float h = mouseY - y;
    
    if ( w > minWindowSize.x && h > minWindowSize.y) { 
      state = State.CREAT;
    } else {
      state = State.NONE;
    }
  }
}

void mouseReleased() {
  if (state == State.INTERACT) {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
         if (f.getWindow() != null) {
           f.getWindow().mouseReleased();
           state = State.NONE;
           selectedFrame = -1;
           return;
         }
      }
    }
  } else if (state == State.MOVE) {
    selectedFrame = -1;
  } else if (state == State.RESIZE) {
    selectedFrame = -1;
  } else {
    
    dragEnd.x = mouseX;
    dragEnd.y = mouseY;
    float x = dragOrigin.x;
    float y = dragOrigin.y;
    float w = dragEnd.x - x;
    float h = dragEnd.y - y;
    
    if ( w > minWindowSize.x && h > minWindowSize.y) { 
      Frame newFrame = new Frame(x, y, w, h);
      frames.add(newFrame);
      state = State.NONE;
    }
  }
  if (dragged < dragThreshold) {
    mouseClicked();
  }
}

void mouseClicked() {
  if (state == State.SELECT) {
    selectApp();
  } else if (state == State.COLOR) {
    selectColor();
  } else if (state == State.MOVE) {
    if (!selectHudTool()) {
      state = State.NONE;
    }
  } else if (state == State.RESIZE) {
    if (!selectHudTool()) {
      state = State.NONE;
    }
  } else if (state == State.CLOSE) {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
        if (f.getWindow() != null) {
          f.getWindow().close();
        }
        frames.remove(f);
        return;
      }
    }
    if (!selectHudTool()) {
      state = State.NONE;
    }
  } else {
    for (int i = frames.size() - 1; i >= 0 ; i--) {
      Frame f = frames.get(i);
      if (f.contains(mouseX, mouseY)) {
        if (f.getWindow() != null) {
          f.getWindow().mouseClicked();
          return;
        } else {
          selectedFrame = i;
          state = State.SELECT;
          showAppSelector();
          return;
        }
      }
    }
    if (!selectHudTool()) {
      state = State.COLOR;
      currentColorSelecotPosition.x = mouseX;
      currentColorSelecotPosition.y = mouseY;
      showColorSelector();
    }
  }
}

//////////////////////////////
//////////////////////////////
// HUD
//////////////////////////////
//////////////////////////////

void showHud() {
  float iconSize = 20;
 
  // Close icon
  if (state == State.CLOSE) {
    fill(255);
    noStroke();
    rect(width - iconSize * 0.9, iconSize * .1, iconSize * .8, iconSize * .8);
    stroke(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  } else {
    fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
    stroke(255);
  }
  line(width - iconSize * .8, iconSize * .2, width - iconSize * .2, iconSize * .8);
  line(width - iconSize * .2, iconSize * .2, width - iconSize * .8, iconSize * .8);
  
  // Resize icon
  if (state == State.RESIZE) {
    fill(255);
    noStroke();
    rect(width - iconSize * 1.9, iconSize * .1, iconSize * .8, iconSize * .8);
    stroke(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  } else {
    fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
    stroke(255);
  }
  line(width - iconSize * 1.8, iconSize * .2, width - iconSize * 1.2, iconSize * .8);
  line(width - iconSize * 1.4, iconSize * .8, width - iconSize * 1.2, iconSize * .8);
  line(width - iconSize * 1.2, iconSize * .8, width - iconSize * 1.2, iconSize * .6);
  
  // Move icon
  if (state == State.MOVE) {
    fill(255);
    noStroke();
    rect(width - iconSize * 2.9, iconSize * .1, iconSize * .8, iconSize * .8);
    stroke(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  } else {
    fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
    stroke(255);
  }
  line(width - iconSize * 2.5, iconSize * .2, width - iconSize * 2.5, iconSize * .8);
  line(width - iconSize * 2.2, iconSize * .5, width - iconSize * 2.8, iconSize * .5);
  
  line(width - iconSize * 2.2, iconSize * .5, width - iconSize * 2.3, iconSize * .4);
  line(width - iconSize * 2.2, iconSize * .5, width - iconSize * 2.3, iconSize * .6);
  line(width - iconSize * 2.8, iconSize * .5, width - iconSize * 2.7, iconSize * .4);
  line(width - iconSize * 2.8, iconSize * .5, width - iconSize * 2.7, iconSize * .6);
  
  line(width - iconSize * 2.5, iconSize * .2, width - iconSize * 2.4, iconSize * .3);
  line(width - iconSize * 2.5, iconSize * .2, width - iconSize * 2.6, iconSize * .3);
  line(width - iconSize * 2.5, iconSize * .8, width - iconSize * 2.4, iconSize * .7);
  line(width - iconSize * 2.5, iconSize * .8, width - iconSize * 2.6, iconSize * .7);
  
}

boolean selectHudTool() {
  float iconSize = 20;
  
  if (mouseY > 0 && mouseY < iconSize) {
    if (mouseX < width - iconSize * 0 && mouseX > width - iconSize * 1) {
      state = State.CLOSE;
      return true;
    } else if (mouseX < width - iconSize * 1 && mouseX > width - iconSize * 2) {
      state = State.RESIZE;
      return true;
    } else if (mouseX < width - iconSize * 2 && mouseX > width - iconSize * 3) {
      state = State.MOVE;
      return true;
    }
  }
  return false;
}

//////////////////////////////
//////////////////////////////
// APP SELECTOR
//////////////////////////////
//////////////////////////////

void showAppSelector() {
  Frame f = frames.get(selectedFrame);
  fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  stroke(255);
  float h = selectorBaseH * windowPool.size();
  rect(f.x, f.y, selectorW, h);
  
  PFont font = createFont("Arial", 16, true); // Arial, 16 point, anti-aliasing on
  textFont(font);
  textAlign(LEFT);
  fill(255);
  
  for (int i = 0; i < windowPool.size(); i++) {
    line(f.x, f.y + selectorBaseH * (i + 1),
    f.x + selectorW, f.y + selectorBaseH * (i + 1));
    Window wd = windowPool.get(i);
    text(wd.getName(), f.x + 4, f.y + selectorBaseH * (i + 1) - 4);
  }
}

void selectApp() {
  float h = selectorBaseH * windowPool.size();
  Frame f = frames.get(selectedFrame);
  if ( mouseX > f.x && mouseX < f.x + selectorW &&
       mouseY > f.y && mouseY < f.y + h) {
    int selectedApp = -1;
    float diffY = mouseY - f.y;
    selectedApp = floor(diffY / selectorBaseH);
    if (selectedApp < 0) selectedApp = 0;
    if (selectedApp >= windowPool.size()) selectedApp = windowPool.size() - 1 ;
    
    Window wd = windowPool.get(selectedApp).copy();
    wd.x = f.x;
    wd.y = f.y;
    wd.width = f.w;
    wd.height = f.h;
    wd.applet = this;
    f.setWindow(wd);
    
    state = State.NONE;
  } else {
    state = State.NONE;
  }
}

//////////////////////////////
//////////////////////////////
// COLOR SELECTOR
//////////////////////////////
//////////////////////////////

void showColorSelector() {
  int margin = 4;
  int numColors = bgcolors.length;
  int x = currentColorSelecotPosition.x;
  int y = currentColorSelecotPosition.y;
  
  stroke(255);
  fill(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
  rect(x, y, colorSelectorW, (colorSelectorW - margin) * numColors + margin);
  
  for (int i = 0; i < 5; i++) {
    stroke(bgcolors[currbgcolor][0],bgcolors[currbgcolor][1],bgcolors[currbgcolor][2]);
    fill(bgcolors[i][0],bgcolors[i][1],bgcolors[i][2]);
    rect(x + margin, y + margin + (colorSelectorW - margin) * i, colorSelectorW - margin * 2, colorSelectorW - margin * 2);
  }
}

void selectColor() {
  int margin = 4;
  int numColors = bgcolors.length;
  int x = currentColorSelecotPosition.x;
  int y = currentColorSelecotPosition.y;
  float h = (colorSelectorW - margin) * numColors + margin;
  
  if ( mouseX > x && mouseX < x + colorSelectorW &&
       mouseY > y && mouseY < y + h) {
    int selectedColor = -1;
    float diffY = mouseY - y - margin / 2;
    selectedColor = floor(diffY / (colorSelectorW - margin));
    if (selectedColor < 0) selectedColor = 0;
    if (selectedColor >= numColors) selectedColor = numColors - 1 ;
    
    currbgcolor = selectedColor;
    
//    state = State.NONE;
  } else {
    state = State.NONE;
  }
}

//////////////////////////////
//////////////////////////////
// AUXILIAR
//////////////////////////////
//////////////////////////////

class Point
{
  int x;
  int y;
    
  public Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  public Point() {
  }
}



