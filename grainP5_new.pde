//oneshot and sustain modes for drawing movers
//particles attract or repel each other
//particles attract or repel key positions  
//--osc inputs (max patch)

//draw line connecting points
//create mesh  --increase /decrease z values when particle colllides

//branching when repeated note

//size of points increases as pressed more times
//leaky integrators

//attack and decay times
//fade object in and out   opacity

//create vectors/trajectories with qn pads
//FORCES!!!

//MAPPINGS FOR tfreq, speed, distortion, filtering etc
//OR USE MATRIX IN MAX CONTROLLED BY PATCHBAY

ArrayList<Mover> mover = new ArrayList<Mover>();
int resetFlag = 0;
int maxVoices = 0, maxSteps = 100, stepSize = 0;
float maxSpeed = 4, maxSteer = 0.1;
int num = 1, edgeMode = 1;  //0 == clip, 1 == bounce, 2 == wrap
float size = 1, sizeVelMod = 0.1; 

float[] gravity = {0, 0.8, 0};
float[] noise = {1, 1, 0};
float noiseScale = 100, noiseMod = 0;
float friction = 0.0;  //map to grain player speed?

FlowField flow;
float time = 0, xForce = 1, yForce = 1;

float bgCol = 40, bgOp = 120;
int clearFlag = 0, clearCount = 0;

float fgOp = 100, fillMode = 0;
float hue = 1, sat = 1, bright = 1;
float hueVelMod = 0, satVelMod = 0, brightVelMod = 0;

int[] keysBounds = new int[4];
int[] padsBounds = new int[4];



void setup() {
  size(800, 400, P3D);
  frameRate(20);
  smooth();
  osc(); 

  bg(color(bgCol, bgOp));
  colorMode(HSB);
  for (int c = 0; c < 25; c++) {
    voiceColor[c] = color((255*float(c)/25), 255, 255);
  };

  keysBounds[0] = 10;
  keysBounds[1] = 10;
  keysBounds[2] = (width/2)-10;
  keysBounds[3] = height-10;
  padsBounds[0] = width/2;
  padsBounds[1] = 10;
  padsBounds[2] = width-10;
  padsBounds[3] = height-10; 

  flow = new FlowField(25);
  //   hint(DISABLE_DEPTH_TEST); //2D ????
}


void draw() {  
  float fov = PI/3.0;   
  float cameraZ = (height/2.0) / tan(fov/2.0); 
  perspective(fov, float(width)/float(height), cameraZ/2.0, cameraZ*2.0);

  //  ortho(-width/2, width/2, -height/2, height/2);    

  //MOVE CAMERA 
    camera(mouseX, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  //  camera(mouseX, height/2, (height/2) / tan(PI/6), mouseX, height/2, 0, 0, 1, 0);

  //  lights();
  //  spotLight(255, 0, 0, width/2, height/2, 400, 0, 0, -1, PI/4, 2);


  //DRAW BACKGROUND
  //  clearFlag = 1;
  if (clearFlag > 0) { 
    bg(color(bgCol, bgOp)); 
    clearFlag = 0;
  };

  //UPDATE FLOW FIELD
  time = time + 0.01;
  flow.init(time);
  PVector mouse = new PVector(mouseX, mouseY);    


  //ITERATE THROUGH KEYS
  for (int v = 0; v < 25; v++) {
    for (int i = 0; i < 175; i++) {
            if ((keysChanged[v][i] > 0) && (keysData[v][i] > 0)) {
//      if (keysData[v][i] > 0) {       
         keysChanged[v][i] = 0;
        //calculate x, y, z 
        float x = i % 5;
        float y = i / 5;
        float z = i / 25;
        x = x / 5;         //scale to 0.. 1
        y = (y%5) / 5;
        y = 1 - y;         //invert y axis

        //scale to bounds
        float tempx = (x * ((keysBounds[2] - keysBounds[0])/4)) + keysBounds[0];
        float tempy = (y * ((keysBounds[3] - keysBounds[1])/4)) + keysBounds[1];
        float tempz = (z * 30) - 240; 

        //calculate polar
        float id = float(i)/25 ;       
        float angle = radians(((1-id)*360)%360);
       float rad = (1-(float(i)/175)) * 100; 
        float xpolar = (sin(angle) * rad) + ((keysBounds[0] + keysBounds[2])/2);
        float ypolar = (cos(angle) * rad) + ((keysBounds[1] + keysBounds[3])/2);

        //          if (keysChanged[v][i] > 0) {
        //            if (keysData[v])
        //        addMover(tempx, tempy, tempz, voiceColor[v]);
        for (int n = 0; n < num; n++) {
          addMover(xpolar, ypolar, tempz, voiceColor[v]);
        };

        //            keysChanged[v][i] = 0;
        //          };


        stroke(voiceColor[v]);
        //        drawFunc(tempx, tempy, tempz, 10);        //array
        drawFunc(xpolar, ypolar, tempz, 10);        //circles
      }
    }
  };

  updateMovers();
  
  if (resetFlag > 0) {
  resetMovers();
  resetFlag = 0;
};

}




void bg(color bgcol) {
  //  rectMode(CORNERS);
  //  noStroke();
  //  fill(bgcol);
  //  rect(0, 0, width, height);
  background(bgcol);
}

void fg(color fgcol) {
  if (fillMode == 0) {
    noFill(); 
    stroke(fgcol);
  } else { 
    noStroke(); 
    fill(fgcol);
  };
}


void drawFunc(float x_, float y_, float z_, float s_) {
  pushMatrix();
  translate(x_, y_, z_);  
  rotate(radians(frameCount%360));  
  pyramid(s_);   
  popMatrix();
}


void addMover(float x, float y, float z, color col_) {
  clearCount = clearCount + 1;
  //REMOVE OLD VOICES
  if ((maxVoices > 0) && (mover.size() >= maxVoices)) {
    if (maxVoices == 1) {
      for (int r = mover.size () - 1; r >= 0; r--) {
        mover.remove(r);
      };
    } else {
      for (int r = 0; r < abs (mover.size () - maxVoices); r++) {
        mover.remove(r);
      };
    };
  };

  //CREATE NEW VOICES
  for (int i = 0; i < num; i++) {
    PVector initPos = new PVector(x, y, z);
    PVector initForce = new PVector(random(-1, 1), random(-1, 1), 0);
    //    initForce.mult(0.1);
    mover.add(new Mover(initPos, initForce, size));
    //    mover.add(new Mover(x, y, z, random(1, 6)));    
    Mover m = mover.get(mover.size() - 1);
    m.col = col_;
    m.mass = random(3, 6);
  };
}

void updateMovers() {
  PVector g = new PVector(gravity[0], gravity[1], gravity[2]);     

  //ITERATE THROUGH MOVERS
  for (int id = mover.size () - 1; id >= 0; id--) {
    Mover m = mover.get(id);

    if (((maxSteps != 0) && (m.count > maxSteps)) || (m.alive == 0)) {
      mover.remove(id);
    } else {
      m.maxSpeed = maxSpeed;
      m.maxForce = maxSteer;

      //APPLY FORCES TO MOVER
      PVector wind = new PVector(random(-noise[0], noise[0]), random(-noise[1], noise[1]), random(-noise[2], noise[2]));
      wind.mult(noise(m.location.x*noiseScale, m.location.y*noiseScale, m.location.z* noiseScale));
      wind.mult(noiseMod);
      m.applyForce(wind);

      if (mousePressed) {      
//        PVector mForce = new PVector(mouseX, mouseY, m.location.z);
//        m.arrive(mForce, 100);
        // m.arrive(mForce); //with distance adjust speed
        // m.applyFriction(-0.03);
                m.follow(flow);
      };
      
     
//      m.attract(m.location.x, m.location.y, m.location.z, m.mass);

if (m.trail.size() > 0) {
        PVector st = m.trail.get(0);  //startlocation
     m.seek(st) ;
};
      
      m.applyForce(g);
      m.applyFriction(friction);

      //UPDATE MOVER POSITION
      m.update();
      if (edgeMode == 0) {
        m.clipEdges();
      } else if (edgeMode == 1) {
        m.bounceEdges();
      } else if (edgeMode == 2) {
        m.wrapEdges();
      };


      //UPDATE MOVER COLOR
      //      if (abs(m.velocity.mag()) != 0) {        
      color tempColor = color(
      constrain(hue(m.col) * (hue +(hue * (m.velocity.mag() * hueVelMod))), 0, 255), 
      constrain(saturation(m.col) * (sat +(sat * (m.velocity.mag() * satVelMod))), 0, 255), 
      constrain(brightness(m.col) * (bright +(bright * (m.velocity.mag() * brightVelMod))), 0, 255), 
      fgOp
        );
m.trailCol.add(tempColor);

      m.size = constrain(size + (size * (m.velocity.mag() * sizeVelMod)), 0.0001, 30);            
      //        strokeWeight(m.size);       
      fg(tempColor);
       

      //DRAW
      //        point(m.location.x, m.location.y, m.location.z);
       drawFunc(m.location.x, m.location.y, m.location.z, m.size);
//      m.display();
      for (int t = m.trail.size ()-1; t >=0; t--) {
        //          stroke(255);
        PVector tt = m.trail.get(t);  //location
        PVector tv = m.trailVel.get(t);   //velocity
        color tc = m.trailCol.get(t);     //color
        float ts = m.trailSize.get(t);
        stroke(tc);
//        point(tt.x, tt.y, tt.z);
//          arrow(tt, tv, ts);
          drawFunc(tt.x, tt.y, tt.z, ts);
      }

      //      }
    };
  };
}



void resetMovers() {
  for (int i = mover.size () - 1; i >= 0; i--) { 
    mover.remove(i);
  };
}

