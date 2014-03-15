import controlP5.*;
ControlP5 cp5;
int btnSize = 48;
int margin = 8;
int currentImg = 0;

//ControlP5
void setupControls() {
  cp5 = new ControlP5(this);

  // create change visualization buttons
  cp5.addButton("cubes")
    .setValue(0)
      .setPosition(width - btnSize - margin, height/2 - (btnSize*2 + margin*2))
        .setSize(btnSize, btnSize)
          ; 
  cp5.addButton("blobs")
    .setValue(0)
      .setPosition(width - btnSize - margin, height/2 - (btnSize*1 + margin*1))
        .setSize(btnSize, btnSize)
          ;  
  cp5.addButton("bars")
    .setValue(0)
      .setPosition(width - btnSize - margin, height/2)
        .setSize(btnSize, btnSize)
          ;  
  cp5.addButton("steps")
    .setValue(0)
      .setPosition(width - btnSize - margin, height/2 + (btnSize*1 + margin*1))
        .setSize(btnSize, btnSize)
          ;  

  cp5.addButton("changePic")
    .setValue(0)
      .setPosition(width/2  - width/4 - btnSize*2, height/2 + 120 + margin)
        .setSize(btnSize*4, btnSize/2)
          ;
}

public void cubes() {
  subdivisions = 12;
  initialize();
  matrix.setVisMode(0);
} 
public void blobs() { 
  subdivisions = 24;
  initialize();
  matrix.setVisMode(1);
} 
public void bars() { 
  subdivisions = 12;
  initialize();
  matrix.setVisMode(2);
} 
public void steps() { 
  subdivisions = 24;
  initialize();
  matrix.setVisMode(3);
}

public void changePic() {
  if (currentImg < 4) currentImg++; 
  else currentImg = 0;

  //picture.pickImage(currentImg);
  picture.pickPicasaImage(searchWord);
  initialize();
}


//************************************************************************************
//old dat-gui stuff
/*void changeVisMode() {
 if (visMode == 0) {
 visMode = 1;
 }
 else {
 visMode = 0;
 }
 }
 
 void setCurrentImg(int theimg) {
 currentImg = theimg;
 }
 
 void setSubdivisions(int subds) {
 if (visMode == 0) {
 count = subds / 2;
 } 
 else {
 count = subds * 2;
 }
 }
 */
