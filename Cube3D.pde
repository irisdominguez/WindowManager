class Cube3D extends Window {
  
  float pitch, yaw;
  Point3D[] points;
  
  public Cube3D() {
    name = "Cube3D";
  }
  
  public Window copy() {
    return new Cube3D();
  }

  void setup() {
    points = new Point3D[8];
    points[0] = new Point3D(+1, +1, +1);
    points[1] = new Point3D(+1, +1, -1);
    points[2] = new Point3D(+1, -1, +1);
    points[3] = new Point3D(+1, -1, -1);
    points[4] = new Point3D(-1, +1, +1);
    points[5] = new Point3D(-1, +1, -1);
    points[6] = new Point3D(-1, -1, +1);
    points[7] = new Point3D(-1, -1, -1);
    
    pitch = radians(45);
    yaw = radians(45);
  }

  void draw() {
    colorMode(HSB);
    bg(0);
    pushMatrix();
    translate(x + width * .5, y + height * .5);
    float size = min(width, height);
    stroke(255);
    for (int i = 0; i < 8; i++) {
      Point3D p1o = points[i];
      Point3D p1 = p1o.rotate(pitch, yaw);
      Point2D p1_ = p1.project();
      float x1 = p1_.x * size * 0.25;
      float y1 = p1_.y * size * 0.25; 
      
      for (int j = i + 1; j < 8; j++) {
        Point3D p2o = points[j]; 
        if (p1o.shareCoordinates(p2o)) {
          Point3D p2 = p2o.rotate(pitch, yaw);
          Point2D p2_ = p2.project();
          float x2 = p2_.x * size * 0.25;
          float y2 = p2_.y * size * 0.25;
          
          stroke(255 * i / 8, 255, 255);          
          line(x1, y1, x2, y2);
        }
      }
    }
    popMatrix();
  }
  
  void mouseDragged() {
    yaw = map(mouseX, x, x + width, radians(-180), radians(180));
    pitch = map(mouseY, y, y + height, radians(-180), radians(180));
  }
}

class Point3D
{
  float x;
  float y;
  float z;
    
  public Point3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  public Point3D() {
  }
  
  public Point3D rotate(float pitch, float yaw) {
    float nx, ny, nz;
   
    nx = sin(yaw) * y + cos(yaw) * x;
    ny = sin(pitch) * z + cos(pitch) * (cos(yaw) * y - sin(yaw) * x);
    nz = cos(pitch) * z - sin(pitch) * (cos(yaw) * y - sin(yaw) * x);

    return new Point3D(nx, ny, nz);
  }
  
  public Point2D project() {
    float depth = (z + 6) / 6;
    float nx = x * depth;
    float ny = y * depth;
    return new Point2D(nx, ny);
  }
  
  public boolean shareCoordinates(Point3D p2) {
    int same = 0;
    if (p2.x == x) same++;
    if (p2.y == y) same++;
    if (p2.z == z) same++;
    return same >= 2;
  }
}

class Point2D
{
  float x;
  float y;
    
  public Point2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  public Point2D() {
  }
}
