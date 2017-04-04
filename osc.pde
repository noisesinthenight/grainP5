import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress addr;

//keysData
int voice = 0, state = 0;
int note, octave;


int[][] keysData = new int[25][175];
int[][] keysChanged = new int[25][175];
int[][] startFrame = new int[25][175];
int[] voiceColor = new int[25];
//int[][] keysColor = new int[25][175];

//padsData
int pad;
float[][] padData = new float[16][4];  //[pad] = [gate, x, y, z]


//mover spawn position
float xStart_, yStart_, xDev_ = 0, yDev_ = 0;
float[][] limits = {{0, 1}, {0, 1}, {0,1}};


void osc() {
  oscP5 = new OscP5(this, 9001);
  addr = new NetAddress("127.0.0.1", 9001);
}  

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/keys")) {
    voice = msg.get(0).intValue();
    note = msg.get(1).intValue();
    state = msg.get(2).intValue();

    keysData[voice][note] = state;
    keysChanged[voice][note] = 1;
//    keysColor[voice][note] = color((255*float(voice)/25), 255, 255);
    startFrame[voice][note] = frameCount;
    
    print(voice);
    print(" ");
    print(note);
    print(" ");
    println(state);
  };

  if (msg.checkAddrPattern("/pads")) {
    pad = msg.get(0).intValue();
    padData[pad][0] = msg.get(1).intValue();     //gate
    padData[pad][1] = msg.get(2).floatValue();   //x
    padData[pad][2] = msg.get(3).floatValue();   //y    
    padData[pad][3] = msg.get(4).floatValue();   //z

    //    println(padData[pad]);
  };
  
  
  
  
  //MOVERS
  
    if (msg.checkAddrPattern("/clr")) {
    clearFlag = 1;
  }  
      if (msg.checkAddrPattern("/kill")) {
    resetMovers();
  }  
  if (msg.checkAddrPattern("/trig")) {    
//    num = msg.get(0).intValue();
    addMover(
     constrain(random(limits[0][0], limits[0][1]) * (keysBounds[2] - keysBounds[0]), 0, (keysBounds[2] - keysBounds[0])),
     constrain(random(limits[1][0], limits[1][1]) * (keysBounds[3] - keysBounds[1]), 0, (keysBounds[3] - keysBounds[1])),
     constrain(random(limits[2][0], limits[2][1]) * 100, 0, 100),
     color(voiceColor[voice])
      );
  };
  
    if (msg.checkAddrPattern("/xStart")) {
    xStart_ = msg.get(0).floatValue();
    limits[0][0] = xStart_ - (xStart_ * xDev_);
    limits[0][1] = xStart_ - (xStart_ * xDev_);
  }
  if (msg.checkAddrPattern("/yStart")) {
    yStart_ = msg.get(0).floatValue();
    limits[1][0] = yStart_ - (yStart_ * yDev_);
    limits[1][1] = yStart_ - (yStart_ * yDev_);
  }

  if (msg.checkAddrPattern("/xDev")) {
    xDev_ = msg.get(0).floatValue();

  }
  if (msg.checkAddrPattern("/yDev")) {
    yDev_ = msg.get(0).floatValue();
  }
  
    if (msg.checkAddrPattern("/num")) {
    num = msg.get(0).intValue();
  }
    if (msg.checkAddrPattern("/maxVoices")) {
    maxVoices = msg.get(0).intValue();
  }
  if (msg.checkAddrPattern("/maxSteps")) {
    maxSteps = msg.get(0).intValue();
  }
  if (msg.checkAddrPattern("/maxSpeed")) {
    maxSpeed = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/maxSteer")) {
    maxSteer = msg.get(0).floatValue();
  }
  
  
  
  
    if (msg.checkAddrPattern("/xGravity")) {
    gravity[0] = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/yGravity")) {
    gravity[1] = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/zGravity")) {
    gravity[2] = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/friction")) {
    friction = msg.get(0).floatValue();
  }
  
  
  if (msg.checkAddrPattern("/xNoise")) {
    noise[0] = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/yNoise")) {
    noise[1] = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/zNoise")) {
    noise[2] = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/noiseScale")) {
    noiseScale = msg.get(0).floatValue();
  }  
  if (msg.checkAddrPattern("/noise")) {
    noiseMod = msg.get(0).floatValue();
  }  
  
  
  
    if (msg.checkAddrPattern("/size")) {
    size = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/sizeVelMod")) {
    sizeVelMod = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/fillMode")) {
    fillMode = msg.get(0).intValue();
  }
  if (msg.checkAddrPattern("/fgOpacity")) {
    fgOp = int(msg.get(0).floatValue() * 255);
  }
  
  if (msg.checkAddrPattern("/bgOpacity")) {
    bgOp = int(msg.get(0).floatValue() * 255);
  }
  if (msg.checkAddrPattern("/bgColor")) {
    bgCol = int(msg.get(0).floatValue() * 255);
  }
  
  if (msg.checkAddrPattern("/hue")) {
    hue = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/sat")) {
    sat = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/bright")) {
    bright = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/hueVelMod")) {
    hueVelMod = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/satVelMod")) {
    satVelMod = msg.get(0).floatValue();
  }
  if (msg.checkAddrPattern("/brightVelMod")) {
    brightVelMod = msg.get(0).floatValue();
  }
  //edgeMode
  if (msg.checkAddrPattern("/edgeMode")) {
    edgeMode = msg.get(0).intValue();
  }
  
  
  
}

