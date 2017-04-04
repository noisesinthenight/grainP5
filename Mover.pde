//add attract (gravitational movement)
//clipModes


class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce; //steering response
  float size, mass = 3;
  color col;
  int alive = 1, count = 0;
  
//  PVector[] trail;
  ArrayList<PVector> trail = new ArrayList<PVector>();
ArrayList<PVector> trailVel = new ArrayList<PVector>();  
 ArrayList<Float> trailSize = new ArrayList<Float>();
 ArrayList<Integer> trailCol = new ArrayList<Integer>(); 


//  Mover(float x, float y, float z, float s) {
  Mover(PVector start, PVector f, float s) {
//    location = new PVector(x, y, z);
    location = start.get();
    acceleration = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);    
    maxSpeed = 8;
    maxForce = 0.3;
    size = s;
    col = color(int(random(255)), int(random(255)), int(random(255)));
    count = 0;
    applyForce(f);
  }

  void update() {
    //"Euler integration" motion model
    //TRY "Verlet integration" MORE CPU EFFICIENT
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
    trail.add(location.get());
    trailVel.add(velocity.get());
//    trailCol.add(col);   
   trailSize.add(size); 
    count++;
  }

  void applyForce(PVector force) {    
    force = PVector.div(force, mass); //ACCELERATION = FORCE / MASS
      acceleration.add(force);
  }

    void applyFriction(float coeff) {
      float speed = velocity.mag();
      PVector drag = velocity.get();
      drag.mult(-1);
      drag.normalize();
      drag.mult(coeff * (speed*speed));
      applyForce(drag);
    }

    //GRAVITATE TOWARDS LOCATION
    void attract(float x, float y, float z, float m) {
      PVector aLoc = new PVector(x, y, z);
      PVector aForce = PVector.sub(aLoc, location); 
      float distance = aForce.mag(); 
      distance = constrain(distance, 5.0, 25.0);
      aForce.normalize();
      float strength = (mass*m) / (distance * distance);
      aForce.mult(strength);
      applyForce(aForce);
    }

    //SEEK LOCATION
  void seek(PVector target) {    
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxSpeed);
    desired.mult(0.05);
    //steering force = desired velocity - current velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  //SEEK LOCATION (SLOW WHEN APPROACHING)
  void arrive(PVector target, int distance_) {
    PVector desired = PVector.sub(target, location);
    float d = desired.mag();
    desired.normalize();
    if (d < distance_) {
      //if within 100 pixels of target location
      float m = map(d, 0, 100, 0, maxSpeed);  //set magnitude according to distance
      desired.mult(m);      
    } else {
      desired.mult(maxSpeed);          //else magnitude == maxSpeed
      desired.mult(0.05);
    }    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  //FOLLOW FLOWFIELD
  void follow(FlowField flow) {
    PVector desired = flow.lookup(location);
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  // void spring() {}

  void display() {
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


  void wrapEdges() {    
    if (location.x < 0) {        
      location.x = width;
    } else if (location.x > width) {
      location.x *= 0;
    };

    if (location.y < 0) {
      location.y = height;
    } else if (location.y > height) {
      location.y = 0;
    };
    if (location.x < 0) {
      location.z = 1000;
    } else if (location.x > 1000) {
      location.z = 0;
    };
  }
  
  void bounceEdges() {
    if (location.x < 0) {        
      velocity.x *= -1;
      location.x = 0;
    } else if (location.x > width) {
      velocity.x *= -1;
      location.x = width;
    };

    if (location.y < 0) {
      velocity.y *= -1;
      location.y = 0;
    } else if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    };
    if (location.x < 0) {
      velocity.z = -1;
      location.z = 0;
    } else if (location.x > 1000) {
      velocity.z = -1;
      location.z = 1000;
    };
  }
  
  void clipEdges() {
    if ((location.x < 0) || (location.x > width)) {
      alive = 0;    
    }; 
    if ((location.y < 0) || (location.y > height)) {
      alive = 0;
    };
    if ((location.x < 0) || (location.z > 1000)) {
      alive = 0;
    };
  }

}
