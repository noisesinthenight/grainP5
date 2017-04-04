void keyPressed() {
  //fullscreen
  //store and recall states
  
  //clear
  if (key == 'c' || key == 'C') {
//    clearFlag = 1;
    bg(color(bgCol, bgOp));//clear
  }
  if (key == 'f' || key == 'F') {
    fillMode = 1 - fillMode;
  }
  
  if (key == 'k' || key == 'K') {
    for (int i = 0; i < mover.size(); i++) {  
      mover.remove(i);//kill all agents
    }
  }
  
  if (key == 's' || key == 'S') {    
      saveFrame("image_" + hour() +"_"+ minute() +"_"+ second() + ".png");
      println("image exported");
    }    
}
