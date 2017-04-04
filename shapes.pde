void pyramid(float size_) {
  beginShape();
  vertex(-size_, -size_, -size_);
  vertex( size_, -size_, -size_);
  vertex(   0, 0, size_);

  vertex( size_, -size_, -size_);
  vertex( size_, size_, -size_);
  vertex(   0, 0, size_);

  vertex( size_, size_, -size_);
  vertex(-size_, size_, -size_);
  vertex(   0, 0, size_);

  vertex(-size_, size_, -size_);
  vertex(-size_, -size_, -size_);
  vertex(   0, 0, size_);
  endShape();
  //  endShape(CLOSE);
}


void polygonFill(float xs, float ys, int s) { 
  if (s == 1) {
    ellipse(0, 0, xs, ys);
  } else {
    PShape p;
    p = createShape();
    p.beginShape();
    for (int i = 0; i < s+1; i++) {
      float angle = radians((360/s) % 360) * i;
      float x = cos(angle);
      float y = sin(angle);
      p.vertex(x, y);
    };
    p.endShape();

    shape(p, 0, 0, xs, ys);
  }
}

void polygon(float x, float y, float xs, float ys, float sides) {
  float lastX = x, lastY = y;
  float firstX = x, firstY = y;  
  for (int i = 0; i < sides; i++) {
    float angle = (TWO_PI / sides) * i;
    float x2 = x + (cos(angle) * (xs/2));
    float y2 = y + (sin(angle) * (ys/2));
    if (i == 0) { 
      firstX = x2; 
      firstY = y2;
    } else { 
      line(lastX, lastY, x2, y2);
    }
    lastX = x2;
    lastY = y2;
  };
  line(lastX, lastY, firstX, firstY);
}


void arrow(PVector location, PVector velocity, float size) {
    float theta = velocity.heading() + PI/2;
    pushMatrix();
    translate(location.x, location.y, location.z);
    rotate(theta);
    // sphere(size);
    beginShape();
    vertex(0, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    endShape(CLOSE);
    popMatrix();
}
