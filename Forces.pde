class Force { 
  boolean active = true; 
  PVector vector; 
  float x, y, w, h, friction;   

  Force(float x_, float y_, float w_, float h_) {  
    x = x_; y = y_; w = w_; h = h_;
    vector = new PVector(0, 0);
    friction = 0;
  };  
  
  Force(float x_, float y_, float w_, float h_, PVector v_) {  
    x = x_; y = y_; w = w_; h = h_;
    vector = v_;
    friction = 0;
  };  

  Force(float x_, float y_, float w_, float h_, float f_) {  
    x = x_; y = y_; w = w_; h = h_;
    vector = new PVector(0,0);
    friction = f_;
  }; 

  Force(float x_, float y_, float w_, float h_, PVector v_, float f_) {  
    x = x_; y = y_; w = w_; h = h_;    
    vector = v_;
    friction = f_;
  };  
  
  void apply(Mover m) {
    if (vector.mag() != 0) { m.applyForce(vector); };
    if (friction != 0) { m.applyFriction(friction); };
  }
  
  void display() {
    rectMode(CORNERS);
    noStroke();
    fill(100, (friction*60));
    rect(x, y, x+w, y+h);
  }
}

