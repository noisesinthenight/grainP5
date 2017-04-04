class FlowField {
  PVector[][] field;
  int cols, rows;
  int resolution;

  FlowField(int r) {
    resolution = r;
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    init(0);
  }

  //CREATE FIELD OF VECTORS
  //NOISE
  void init(float time) {
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int o = 0; o < rows; o++) {
        // field[i][o] = new PVector(1,0);  //all point right
        // field[i][o] = PVector.2D(); //random
        float theta = map(noise(xoff, yoff, time), 0, 1, 0, TWO_PI);
        field[i][o] = new PVector(cos(theta), sin(theta));
        yoff = yoff + 0.1;
      }
      xoff = xoff + 0.1;
    }
  }
  
  //SINE WAVES x and y
  void sineXY() {
    for (int i = 0; i < cols; i++) {
      for (int o = 0; o < rows; o++) {
        // field[i][o] = new PVector();
      }
    }
  }  
  //SINE WAVES cos(x) and sin(y) (CIRCLE)
  // void sineRAD() {}

  //RETURN PVECTOR AT LOCATION
  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].get();
  }

}
