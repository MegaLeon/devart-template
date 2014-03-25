/* @pjs preload="armada.png, gioconda.png, napoleon.png, stars.png, sunday.png, twilight.png"; 
 */

import processing.opengl.*;
import nervoussystem.obj.*;

boolean objRecording = false;

int guiScale = 2;            // Scale value for the interface (1 works fine with 1000*500)

int matSize = 240;           // Size of the 3D matrix
int picMapSize = 240;        // Size of the picture being mapped (bigger images takes longer and create more 3D artifacts)
int picDisplaySize = 240;    // Size of the picture being displayed (doesn't affect mapping)

boolean isLiveMode = false;
boolean isAnimated = false;      // animate the mapping process or not
int mappingSpeed = 480;         // pixel analysed per second during the animated analysis
int subdivisions = 12;
float scaleBias = 1;

String searchWord;   // word to search the picasa public feed with, when it's not loading the featured images

int[][][] colorMatrixRemap;
int[][][] colorMatrixHSV;
PVector singlePointRGB;

boolean isMapping, isMappingSingle;
boolean isColorSpaceRGB;
float hueMax, rgbMax = 0;
float brushSize = 3;

Matrix matrix;
ImageSrc picture; 
LiveCanvas pictureLive;

void setup() {
  frameRate(60);
  noSmooth();
  size(1000, 500, OPENGL);
  //ortho(0, width, 0, height); //NOTE: ortho doesn't work in JavaScript mode

  matrix = new Matrix(width/2 + width/4 - 32, height/2, matSize, 0);
  picture = new ImageSrc(width/2 - width/4, height/2, 0, picDisplaySize, picMapSize);

  setupControls();

  //fillArrayPicasaUrls(true, "");
  //picture.pickPicasaImage();    // Picasa Online Image, does not work on Android
  picture.pickImage(0);       // Cached Image (fast for debug / testing)
  initialize(true);

  if (isLiveMode) { 
    pictureLive = new LiveCanvas(width/2 - width/4, height/2, picDisplaySize);
  }
}

void initialize(boolean _isAnimated) { 
  colorMatrixRemap = new int[subdivisions][subdivisions][subdivisions];
  colorMatrixHSV = new int[subdivisions][subdivisions][subdivisions];

  isAnimated = _isAnimated;
  picture.reset();

  rgbMax = 0;
  hueMax = 0;
}

void draw() {
  // if requested, draw the matrix and export it as a coloured .obj
  if (objRecording) {
    /*OBJExport obj = (OBJExport) createGraphics(10, 10, "nervoussystem.obj.OBJExport", "colored.obj");
    obj.setColor(true);
    obj.beginDraw();
    matrix.display(obj);
    obj.endDraw();
    obj.dispose();
    objRecording = false;*/
  } 
  // if not, draw on screen
  else { 
    smartBackground(230);

    // draw the requested picture
    if (!isLiveMode) { 
      if (picture.getPic().width > 0) {
        picture.readPixels(isAnimated, mappingSpeed);
        picture.display();
      } 
      // if loading (width/height = 0), show loading box
      else { 
        picture.displayLoadingRect();
      }
    } 
    // draw the canvas for the live mode
    else {
      pictureLive.display();
      initialize(false);
      picture.readPixels(isAnimated, mappingSpeed);
      picture.display();
    }

    // draw the 3D Matrix
    //lights(); 
    matrix.display(this.g);
    //noLights();
  }
}

// save image
void keyPressed() {
  if (key == 's') {
    //save("normal.png");
    objRecording = true;
  }
}

// mouse input
void mouseDragged()
{
  // rotate camera
  if ((mouseX > width/2) && (mouseX < (width - btnSize*2))) {
    float speedX = mouseX- pmouseX;
    float speedY = mouseY - pmouseY;
    matrix.rotateMatrix(-speedX/300, -speedY/300);
  } 
  else if (!isLiveMode) {
    // TODO: Single Pixel Visualization. Refine it according to the visualization mode
    //       selected, currently works fine with cube / blobs
    /*
    isMappingSingle = true;
     int clickX = int(mouseX - picture.getPos().x + picDisplaySize/2);
     int clickY = int(mouseY - picture.getPos().y + picDisplaySize/2);
     int remapX = int(map(clickX, 0, picDisplaySize, 0, picMapSize));
     int remapY = int(map(clickY, 0, picDisplaySize, 0, picMapSize));
     
     picture.readSinglePixel(subdivisions, remapX, remapY);
     */
  }
}

void mouseReleased() {
  isMappingSingle = false;
}

void colorModeRgb(boolean _isRgb) {
  if (_isRgb) {
    colorMode(RGB, 255);
    isColorSpaceRGB = true;
  } 
  else {
    colorMode(HSB, 360, 100, 100);
    isColorSpaceRGB = false;
  }
}

boolean getCurrentColorSpace() {
  if (isColorSpaceRGB) {
    return true;
  } 
  else {
    return false;
  }
}

void restorePreviousColorSpace(boolean _wasPreviousRgb) {
  if (_wasPreviousRgb) {
    colorModeRgb(true);
  } 
  else {
    colorModeRgb(false);
  }
}

void smartBackground(int _intensity) {
  if (!isColorSpaceRGB) {
    background(0, 0, map(_intensity, 0, 255, 0, 100));
  }
  else {
    background(_intensity);
  }
}

void smartFill(int _intensity) {
  if (!isColorSpaceRGB) {
    fill(0, 0, map(_intensity, 0, 255, 0, 100));
  }
  else {
    fill(_intensity);
  }
}

void smartFillAlpha(int _intensity, int _alpha) {
  if (!isColorSpaceRGB) {
    fill(0, 0, map(_intensity, 0, 255, 0, 100), _alpha);
  }
  else {
    fill(_intensity, _alpha);
  }
}

void smartStroke(int _intensity) {
  if (!isColorSpaceRGB) {
    stroke(0, 0, map(_intensity, 0, 255, 0, 100));
  }
  else {
    stroke(_intensity);
  }
}

void drawCubesRGB(int _x, int _y, int _z, int size, int count, PGraphics pg) {
  //float scaleValue = (rgbMax) / (size);
  float sizeValue;

  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      for (int k = 0; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count), (_z - size/2) + k * (size/count));

        // get the color by mapping the current slot against the color array
        colorModeRgb(true);
        pg.fill(map(i, 0, count, 0, 255), map(j, 0, count, 0, 255), map(k, 0, count, 0, 255));
        //stroke(map(i, 0, count, 0, 200), map(j, 0, count, 0, 200), map(k, 0, count, 0, 200));
        pg.noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixRemap[i][j][k]/(count / scaleBias), 0, size/count);
        //sizeValue = map(colorMatrixRemap[i][j][k], 0, rgbMax, 0, rgbMax/scaleValue/count);
        if (sizeValue > 0) {
          pg.box(sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawVertBarsHue(int _x, int _y, int _z, int size, int count) {
  float newHue, newSat, newVal = 0;
  float sizeValue = 0;

  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      for (int k = 0; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count) + ((size/count)/2), _y, (_z - size/2) + k * (size/count) + ((size/count)/2));

        // get the color by mapping the current slot against the color array
        colorModeRgb(false);

        newHue = map(i, 0, count-1, 0, 360);        
        newSat = map(j, 0, count-1, 0, 100);
        newVal = map(k, 0, count-1, 0, 100);

        fill(newHue, newSat, newVal);
        //stroke(newHue, newSat, newVal/1.5);
        noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(size/(count * scaleBias)/2), 0, size);
        if (sizeValue > 0) {
          box(map(sizeValue, 0, size, size/count, (size/count)/2), sizeValue, map(sizeValue, 0, size, size/count, (size/count)/2));
        }

        popMatrix();
      }
    }
  }
}

void drawHorzBarsHue(int _x, int _y, int _z, int size, int count) {
  float newHue, newSat, newVal = 0;
  //float scaleValue = (hueMax) / (size/1.5);
  float sizeValue = 0;
  isColorSpaceRGB = false;

  for (int i = 0; i < count-1; i++) {
    for (int j = 0; j < count-1; j++) {
      for (int k = 0; k < count-1; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate(_x, (_y - size/2) + i * (size/count), _z);

        // get the color by mapping the current slot against the color array
        colorModeRgb(false);

        newHue = map(i, 0, count-1, 0, 360);        
        newSat = map(j, 0, count-1, 0, 100);
        newVal = map(k, 0, count-1, 0, 100);

        fill(newHue, 50, 50);
        //stroke(newHue, newSat, newVal/1.5);
        noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(size/(count * scaleBias)/2), 0, size - (size/8));
        //sizeValue = map(colorMatrixHSV[i][j][k], 0, hueMax, 0, size);
        if (sizeValue > 0) {
          box(sizeValue, map(sizeValue, 2, size, size/count, 1), sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawSinglePixelRGB(int _x, int _y, int _z, int size, int count) {
  pushMatrix();
  translate((_x - size/2), (_y - size/2), (_z - size/2) + singlePointRGB.z);
  smartStroke(255);

  float lnX = singlePointRGB.x * (size/count);
  float lnY = singlePointRGB.y * (size/count);
  float lnZ = singlePointRGB.z * (size/count);

  line(0, lnY, lnZ, size, lnY, lnZ);
  line(lnX, 0, lnZ, lnX, size, lnZ);
  line(lnX, lnY, 0, lnX, lnY, size);
  popMatrix();
}

import controlP5.*;
ControlP5 cp5;
int btnSize;
int margin;
int bigMargin;
int fontSize;
int currentImg = 0;

float contrast, brightness, kHue, kSaturation;

Knob knobHue, knobSat, knobCont, knobBrigh;

//ControlP5
void setupControls() {
  cp5 = new ControlP5(this);

  btnSize = 48 * guiScale;
  margin = 8 * guiScale;
  bigMargin = 16 * guiScale;
  fontSize = 9 * guiScale;

  // matrix controllers
  cp5.addButton("cubes")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2 - (btnSize*2 + margin*2))
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ; 
  cp5.addButton("blobs")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2 - (btnSize*1 + margin*1))
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ;  
  cp5.addButton("bars")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2)
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ;  
  cp5.addButton("steps")
    .setBroadcast(false)
      .setValue(0)
        .setPosition(width - btnSize - margin, height/2 + (btnSize*1 + margin*1))
          .setSize(btnSize, btnSize)
            .setBroadcast(true)
              .getCaptionLabel().setSize(fontSize)
                ; 

  cp5.addSlider("scaleBias")
    .setBroadcast(false)
      .setLabel("Scale Bias")
        .setColorLabel(color(120))
          .setRange(0, 20)
            .setValue(1)
              .setPosition(width - btnSize*2 - margin, margin)
                .setSize(btnSize*2, btnSize/2)
                  .setBroadcast(true)
                    .getCaptionLabel().setSize(fontSize)
                      ;                   
  cp5.getController("scaleBias").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  // image manipulation controllers
  if (!isLiveMode) {

    knobCont = cp5.addKnob("knobContrast")
      .setBroadcast(false)
        .setLabel("Contrast")
          .setColorLabel(color(120))
            .setRange(0, 5)
              .setValue(1)
                .setPosition(margin, height/2 - (btnSize*2 + bigMargin*2))
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)                       
                        ;
    knobCont.getCaptionLabel().setSize(fontSize);
    knobCont.getValueLabel().setSize(fontSize);

    knobBrigh = cp5.addKnob("knobBrightness")
      .setBroadcast(false)
        .setLabel("Brightness")
          .setColorLabel(color(120))
            .setRange(-128, 128)
              .setValue(0)
                .setPosition(margin, height/2 - (btnSize + bigMargin))
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)
                        ;
    knobBrigh.getCaptionLabel().setSize(fontSize);
    knobBrigh.getValueLabel().setSize(fontSize);

    knobHue = cp5.addKnob("knobChangeHue")
      .setBroadcast(false)
        .setLabel("Hue")
          .setColorLabel(color(120))
            .setRange(0, 360)
              .setValue(0)
                .setPosition(margin, height/2)
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)
                        ;
    knobHue.getCaptionLabel().setSize(fontSize);
    knobHue.getValueLabel().setSize(fontSize);

    knobSat = cp5.addKnob("knobChangeSat")
      .setBroadcast(false)
        .setLabel("Saturation")
          .setColorLabel(color(120))
            .setRange(-50, 50)
              .setValue(0)
                .setPosition(margin, height/2 + (btnSize + bigMargin))
                  .setRadius(btnSize/2)
                    .setDragDirection(Knob.VERTICAL)
                      .setBroadcast(true)
                        ;
    knobSat.getCaptionLabel().setSize(fontSize);
    knobSat.getValueLabel().setSize(fontSize);


    cp5.addTextfield("TxtSearchWord")
      .setLabel("")
        .setPosition(width/2  - width/4 - picDisplaySize/2, height/2 - picDisplaySize/2 - margin - btnSize/2)
          .setSize(picDisplaySize/2 - margin, btnSize/2)
            .setFocus(true)
              ;
    cp5.getController("TxtSearchWord").getValueLabel().setSize(fontSize);
    cp5.getController("TxtSearchWord").getCaptionLabel().setSize(fontSize);

      cp5.addButton("btnSearchWord")
        .setBroadcast(false)
          .setLabel("Set Image Word Search")
            .setValue(0)
              .setPosition(width/2  - width/4 + margin, height/2 - picDisplaySize/2 - margin - btnSize/2)
                .setSize(picDisplaySize/2 - margin, btnSize/2)
                  .setBroadcast(true)
                    .getCaptionLabel().setSize(fontSize)
                      ;

    cp5.addSlider("mappingSpeed")
      .setBroadcast(false)
        .setLabel("Map\nspeed")
          .setColorLabel(color(120))
            .setPosition(width/2  - width/4 + picDisplaySize/2 + margin, height/2 - picDisplaySize/2)
              .setSize(btnSize/4, picDisplaySize)
                .setRange(60, 960)
                  .setValue(2048)
                    .setNumberOfTickMarks(16)
                      .setColorValueLabel(20) 
                        .setBroadcast(true)
                          .getCaptionLabel().setSize(fontSize)
                            ;

    cp5.addButton("changePic")
      .setBroadcast(false)
        .setLabel("Get new picture")
          .setValue(0)
            .setPosition(width/2  - width/4 + picDisplaySize/2 - btnSize*3, height/2 + picDisplaySize/2 + margin)
              .setSize(btnSize*3, btnSize/2)
                .setBroadcast(true)
                  .getCaptionLabel().setSize(fontSize)

                    ;

    cp5.addButton("resetKnobs")
      .setBroadcast(false)
        .setLabel("Reset")
          .setValue(0)
            .setPosition(width/2  - width/4 - picDisplaySize/2, height/2 + picDisplaySize/2 + margin)
              .setSize(btnSize, btnSize/2)
                .setBroadcast(true)
                  .getCaptionLabel().setSize(fontSize)

                    ;
  } 
  else {

    cp5.addSlider("brushSize")
      .setLabel("Brush Size")
        .setValue(3)
          .setColorLabel(color(120))
            .setPosition(width/2  - width/4 - picDisplaySize/2 + btnSize/2 + margin, height/2 + picDisplaySize/2 + margin)
              .setSize(picDisplaySize - btnSize/2 - margin, btnSize/2)
                .setRange(0, 40)
                  .getCaptionLabel().setSize(fontSize)
                    ;
    cp5.getController("brushSize").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  }
}

// controllers methods
public void cubes() {
  subdivisions = 12;
  initialize(true);
  matrix.setVisMode(0);
} 
public void blobs() { 
  subdivisions = 24;
  initialize(true);
  matrix.setVisMode(1);
} 
public void bars() { 
  subdivisions = 12;
  initialize(true);
  matrix.setVisMode(2);
} 
public void steps() { 
  subdivisions = 24;
  initialize(true);
  matrix.setVisMode(3);
}

public void knobContrast(float theValue) {
  contrast = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}

public void knobBrightness(float theValue) {
  brightness = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}

public void knobChangeHue(float theValue) {
  kHue = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}

public void knobChangeSat(float theValue) {
  kSaturation = theValue;
  picture.colorCorrection(contrast, brightness, kHue, kSaturation);
  initialize(false);
}


void resetKnobs() {
  knobCont.setValue(1);  
  knobBrigh.setValue(0);
  knobHue.setValue(0);
  knobSat.setValue(0);
}

public void btnSearchWord() {
  String searchWord = cp5.get(Textfield.class, "TxtSearchWord").getText();
  //println(searchWord);
  if (searchWord.length() == 0) {
    fillArrayPicasaUrls(true, "Getting Featured Images");
  } 
  else {
    fillArrayPicasaUrls(false, searchWord);
  }
  changePic();
}

public void changePic() {
  if (currentImg < 4) currentImg++; 
  else currentImg = 0;

  picture.pickImage(currentImg);
  //picture.pickPicasaImage();
  initialize(true);
  resetKnobs();
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
class LiveCanvas {
  PGraphics canvas;
  float xPos, yPos;
  int canvasSize;
  color brushColor;

  LiveCanvas(float _xPos, float _yPos, int _canvasSize) {
    xPos = _xPos;
    yPos = _yPos;
    canvasSize = _canvasSize;  
    canvas = createGraphics(canvasSize, canvasSize);
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }

  void display() {    
    float tpmouseX = pmouseX - xPos/2;
    float tpmouseY = pmouseY - yPos/2;
    float tmouseX = mouseX - xPos/2;
    float tmouseY = mouseY - yPos/2;

    canvas.beginDraw();
    canvas.stroke(brushColor);
    canvas.strokeWeight(brushSize);

    if (mousePressed && isInside(tmouseX, tmouseY) ) {
      if ((tmouseX != tpmouseX) || (tmouseY != tpmouseY))
        canvas.line(tpmouseX, tpmouseY, tmouseX, tmouseY);
    }
    canvas.endDraw();

    canvas.save("canvas.jpg");
    PImage temp = loadImage("canvas.jpg");

    picture.setImage(temp);

    fill(brushColor);
    rect(width/2  - width/4 - canvasSize/2 + btnSize/4, height/2 + canvasSize/2 + margin + btnSize/4, btnSize/2, btnSize/2);

    colorSelector();
  }

  // manually copy pixels to image, doesn't work
  PImage getCanvas() {
    PImage temp = new PImage(canvasSize, canvasSize);
    canvas.beginDraw();
    for (int i =0; i < canvasSize; i++) {
      for (int j =0; j < canvasSize; j++) {
        temp.set(i, j, canvas.get(i, j));
      }
      canvas.endDraw();
    }
    return temp;
  }

  boolean isInside(float _x, float _y) {
    if (mouseX < (xPos + canvasSize/2) && mouseX > (xPos - canvasSize/2) && mouseY > (yPos - canvasSize/2) && mouseY < (yPos + canvasSize/2)) return true;
    else return false;
  }

  void colorSelector() {
    int selectorSize = 48 * guiScale;
    stroke(1, 26, 38);
    rect(xPos, yPos - canvasSize/2 - margin - selectorSize/2, canvasSize, selectorSize);
    colorMode(HSB, canvasSize, 48, 100);
    float ccX = xPos - canvasSize/2;
    float ccY = yPos - canvasSize/2 - margin - selectorSize;
    for (int i=0; i< canvasSize; i++) {
      for (int j=0; j<48; j++) {
        stroke(i, j, 100);
        point(ccX + i, ccY + j);
      }
    }

    /*if (mousePressed && (mouseButton == RIGHT)) {
      brushColor = get(mouseX, mouseY);
    }*/
  }
}

class Matrix {
  float xPos, yPos;
  float xRot, yRot;
  float xRotBuffer, yRotBuffer = 0;
  int dimension;
  int visMode = 0;

  Matrix(float _xPos, float _yPos, int _dimension, int _visMode) {
    xPos = _xPos;
    yPos = _yPos;
    xRot = -PI/8;
    yRot = -PI/3;
    dimension = _dimension;
    visMode = _visMode;
    initMetaballs(dimension, subdivisions);
  }

  void display(PGraphics pg) {
    pushMatrix();
    translate(xPos, yPos);

    updateRotation();
    drawPanels(dimension);

    drawStructure(visMode, subdivisions, pg);
    if (isMappingSingle) drawSinglePixelRGB(0, 0, 0, dimension, subdivisions);

    popMatrix();
  }

  void drawStructure(int visualizationMode, int subdivisions, PGraphics pg) {
    switch(visualizationMode) {
    case 0: 
      drawCubesRGB(0, 0, 0, dimension, subdivisions, pg);    
      break;
    case 1: 
      drawMetaballs(0, 0, 0, dimension, subdivisions);  
      break;
    case 2: 
      drawVertBarsHue(0, 0, 0, dimension, subdivisions);  
      break;
    case 3: 
      drawHorzBarsHue(0, 0, 0, dimension, subdivisions);  
      break;
    }
  }

  public void setVisMode(int _visMode) {
    visMode = _visMode;
  }

  void rotateMatrix(float _xRot, float _yRot) {
    xRotBuffer = _xRot;
    yRotBuffer = _yRot;
  }

  void updateRotation() {
    if (xRotBuffer !=0) {
      yRot -= xRotBuffer;
      xRotBuffer = xRotBuffer/1.1;
    }
    if (yRotBuffer !=0) {
      xRot += yRotBuffer;
      yRotBuffer = yRotBuffer/1.1;
    }
    rotateX(xRot);
    rotateY(yRot);
  }
}

void drawPanels(int size) {    
  rectMode(CENTER);
  smartStroke(100);
  noFill();  

  smartFill(220);  
  //smartFillAlpha(0, 20);
  pushMatrix();
  translate(0, size/2, 0);
  rotateX(PI/2);
  drawGrid(0, 0, size, 12);
  rect(0, 0, size, size);
  popMatrix();
  noFill();

  pushMatrix();
  translate(-size/2, 0, 0);
  rotateY(PI/2);
  drawGrid(0, 0, size, 12);
  rect(0, 0, size, size);
  popMatrix();

  pushMatrix();
  translate(0, 0, -size/2);
  rotateZ(PI/2);
  drawGrid(0, 0, size, 12);
  rect(0, 0, size, size);
  popMatrix();
}

void drawGrid(int _x, int _y, int size, int count) {
  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      point((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count));
    }
  }
}

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.math.noise.*;
import toxi.processing.*;

import processing.opengl.*;

float ISO_THRESHOLD = 0.05 * scaleBias * (matSize/240);
float NS = 0.03 * (matSize/240);
Vec3D SCALE = new Vec3D(1, 1, 1).scaleSelf(300 * (matSize/240));
float subd = 0.1 / (matSize/240);

IsoSurface surface;
TriangleMesh mesh;
VolumetricSpaceArray volume;
ToxiclibsSupport gfx;

void initMetaballs(int size, int count) {
  gfx = new ToxiclibsSupport(this);
  volume = new VolumetricSpaceArray(SCALE, int(size*subd), int(size*subd), int(size*subd));
  surface = new ArrayIsoSurface(volume);
}

void drawMetaballs(int _x, int _y, int _z, int size, int count) {
  float sizeValue;
  int subdSize = int(size*subd);

  float[] volumeData = volume.getData();
  int i, j, k;

  for (int z = 0, index = 0; z < subdSize; z++) {
    for (int y = 0; y < subdSize; y++) {
      for (int x = 0; x < subdSize; x++) {
        i = int(map(x, 0, subdSize, 0, count));
        j = int(map(y, 0, subdSize, 0, count));
        k = int(map(z, 0, subdSize, 0, count));

        sizeValue = colorMatrixRemap[i][j][k];
        volumeData[index++] = map(sizeValue, 0, size, 0, 1);
      }
    }
  }

  volume.closeSides();
  // store in IsoSurface and compute surface mesh for the given threshold value
  surface.reset();
  mesh = (TriangleMesh)surface.computeSurfaceMesh(mesh, ISO_THRESHOLD);
  float[] vertexList = mesh.getMeshAsVertexArray();

  // move to center
  pushMatrix();
  translate(_x, _y, _z);
  scale(0.75);
  fill(255);
  noStroke();

  beginShape(TRIANGLES);
  mesh.computeVertexNormals();
  colorModeRgb(true);
  // advance by 12 slots in the vertexList array, since it's structured like this:
  // (first face)[vertex1x][vertex1y][vertex1z][vertex1stride][vertex2x]...
  // http://toxiclibs.org/docs/core/toxi/geom/mesh/TriangleMesh.html#getMeshAsVertexArray(float[], int, int)
  for (int currentVert = 0; currentVert < vertexList.length ; currentVert += 12) {
    //map position of the first vertex of the the face to the red color range
    fill(map(vertexList[currentVert], -size/2, size/2, 0, 255), map(vertexList[currentVert+1], -size/2, size/2, 0, 255), map(vertexList[currentVert+2], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert], vertexList[currentVert+1], vertexList[currentVert+2] );
    
    //map position of the second vertex of the the face to the green color range
    fill(map(vertexList[currentVert+4], -size/2, size/2, 0, 255), map(vertexList[currentVert+5], -size/2, size/2, 0, 255), map(vertexList[currentVert+6], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert+4], vertexList[currentVert+5], vertexList[currentVert+6] );
    
    //map position of the third vertex of the the face to the blue color range
    fill(map(vertexList[currentVert+8], -size/2, size/2, 0, 255), map(vertexList[currentVert+9], -size/2, size/2, 0, 255), map(vertexList[currentVert+10], -size/2, size/2, 0, 255));
    vertex( vertexList[currentVert+8], vertexList[currentVert+9], vertexList[currentVert+10] );
  }
  endShape();

  //gfx.mesh(mesh, true);

  popMatrix();
}

import java.io.File;
import java.net.URL;

// needs Google Data library, get it here: https://developers.google.com/gdata/articles/java_client_lib
// To install a .jar in Processing, simply drag the .jar to the sketch - it will be added to the "code" folder of the project
import com.google.gdata.client.*;
import com.google.gdata.client.photos.*;
import com.google.gdata.data.*;
import com.google.gdata.data.media.*;
import com.google.gdata.data.photos.*;

URL baseSearchUrl;
AlbumFeed searchResultsFeed;
String[] imageUrls;
int picNumber = 0;

void fillArrayPicasaUrls(boolean getFeatured, String _searchWord) {
  PicasawebService myService = new PicasawebService("leon-picasaTest-1");
  // Needs JavaMail.jar dependecy, get it here: http://www.oracle.com/technetwork/java/index-138643.html
  // Needs Guava.jar (Formerly Google Collection) dependency, get it here: https://code.google.com/p/guava-libraries/

  try {
    if (getFeatured) baseSearchUrl = new URL("https://picasaweb.google.com/data/feed/api/featured?feat=featured_all");
    else baseSearchUrl = new URL("https://picasaweb.google.com/data/feed/api/all");
  } 
  catch (Exception e) {
    println("Problem with the URL:" + e);
  }

  Query myQuery = new Query(baseSearchUrl);
  myQuery.setStringCustomParameter("kind", "photo");
  // max results to be returned
  //myQuery.setMaxResults(8);
  if (!getFeatured) myQuery.setFullTextQuery(_searchWord);

  try {
    searchResultsFeed = myService.query(myQuery, AlbumFeed.class);
  } 
  catch (Exception e) {
    println("Problem with the AlbumFeed: " + e);
  }

  imageUrls = new String[searchResultsFeed.getPhotoEntries().size()];

  for (int i = 0; i < searchResultsFeed.getPhotoEntries().size(); i++) {
    
    PhotoEntry photo = searchResultsFeed.getPhotoEntries().get(i);
    String imageUrl = photo.getMediaThumbnails().get(0).getUrl();
    String croppedUrl = imageUrl.replace("s72", "s512-c");
    imageUrls[i] = croppedUrl;
  }
}

String getRandomPicasaUrl() {
  return imageUrls[floor(random(imageUrls.length))];
}

class ImageSrc {
  float xPos, yPos;
  int displaySize, mapSize;
  PImage img, originalImg, displayImg, bufferImg;
  // originalImg:   original, untouched image used as a base for color modifications
  // img:           image used for mapping
  // displayImg:    image displayed to the user
  // bufferImg:     empty image used as a buffer when doing color modifications
  int currentPixelX = 0, currentPixelY = 0, currentPixel = 0;

  ImageSrc(float _xPos, float _yPos, int _imgNumber, int _displaySize, int _mapSize) {
    xPos = _xPos;
    yPos = _yPos;
    pickImage(_imgNumber);
    displaySize = _displaySize;  
    mapSize = _mapSize;
  }

  void display() {    
    smartFill(255); //needs this or the image gets tinted red(?).
    imageMode(CENTER);
    img.resize(mapSize, mapSize);
    originalImg.resize(mapSize, mapSize);
    image(displayImg, xPos, yPos, displaySize, displaySize);

    visualizeScanning();

    //debug mode: displays all the images
    /*image(displayImg, xPos - displaySize/4, yPos - displaySize/4, displaySize/2, displaySize/2);
     image(img, xPos + displaySize/4, yPos - displaySize/4, displaySize/2, displaySize/2);
     image(originalImg, xPos - displaySize/4, yPos + displaySize/4, displaySize/2, displaySize/2);*/
  }

  void displayLoadingRect() {
    smartFill(120);
    rect(xPos, yPos, displaySize, displaySize);
    textAlign(CENTER, CENTER);
    text("loading...", xPos, yPos);
  }

  void reset() {
    currentPixel = 0;
    currentPixelX = 0;
    currentPixelY = 0;
  }

  void setImage(int _imgNumber) {
    pickImage(_imgNumber);
  }

  void colorCorrection(float cont, float bright, float hue, float sat)
  {
    // store previous colorspace
    boolean previousColorSpace = getCurrentColorSpace();
    // temporarily switch to RGB to execute the color operations
    int w = originalImg.width;
    int h = originalImg.height;
    bufferImg = new PImage(w, h);  

    originalImg.loadPixels();
    bufferImg.loadPixels();

    for (int i = 0; i < w*h; i++)
    {    
      colorModeRgb(true);   
      color inColor = originalImg.pixels[i];      
      // bitshift operations to get the colors, faster than method alternatives
      int r = (inColor >> 16) & 0xFF;
      int g = (inColor >> 8) & 0xFF;
      int b = inColor & 0xFF;     

      //apply contrast (multiplcation) and brightness (addition)
      r = (int)(r * cont + bright);
      g = (int)(g * cont + bright);
      b = (int)(b * cont + bright);

      //slow but absolutely essential - check that we don't overflow (i.e. r,g and b must be in the range of 0 to 255)
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;

      // bitshift operations to set the colors, faster than method alternatives
      color newColor = 0xff000000 | (r << 16) | (g << 8) | b;

      colorModeRgb(false); 
      float hu = hue(newColor);
      float sa = saturation(newColor);
      float va = brightness(newColor);

      //apply hue and saturation
      hu = (int)(hu + hue) % 360;
      sa = (int)(sa + sat);

      // bitshift operations to set the colors, faster than method alternatives
      bufferImg.pixels[i] = color(hu, sa, va);
    }

    originalImg.updatePixels();
    bufferImg.updatePixels();

    // switch back to the previous colorspace once done
    restorePreviousColorSpace(previousColorSpace);

    // update all the images
    img = bufferImg;
    displayImg = img;
  }

  void visualizeScanning() {
    pushMatrix();
    translate(xPos, yPos);
    smartStroke(255);
    noFill();
    if (isMapping) {
      line(-displaySize/2 + map(currentPixelX, 0, mapSize, 0, displaySize), -displaySize/2, -displaySize/2 + map(currentPixelX, 0, mapSize, 0, displaySize), displaySize/2);
      line(-displaySize/2, -displaySize/2 + map(currentPixelY, 0, mapSize, 0, displaySize), displaySize/2, -displaySize/2 + map(currentPixelY, 0, mapSize, 0, displaySize));
      ellipse(-displaySize/2 + map(currentPixelX, 0, mapSize, 0, displaySize), -displaySize/2 + map(currentPixelY, 0, mapSize, 0, displaySize), 16, 16);
    }
    popMatrix();
  }

  void readPixels(boolean _animated, int _animSpeed) {
    if (currentPixel < img.width * img.height) {

      // Animated
      if (_animated) {
        isMapping = true;
        for (int i = 0; i < _animSpeed; i++) {
          readPixelsAnimated(subdivisions, currentPixelX, currentPixelY);
          currentPixel += 1;
          currentPixelX = currentPixel % img.width;
          currentPixelY = int(floor(currentPixel / img.height));
          //print("Total: " + currentPixel + ", X: " + currentPixelX + ", Y: " + currentPixelY + "\n");
        }
      }

      // Instant
      else {
        for (int i = 0; i < img.width * img.height; i++) {
          if (currentPixel < img.width * img.height) {
            readPixelsAnimated(subdivisions, currentPixelX, currentPixelY);
            currentPixel += 1;
            currentPixelX = currentPixel % img.width;
            currentPixelY = int(floor(currentPixel / img.height));
          }
        }
      }
    } 

    else isMapping = false;
  }

  public void readPixelsAnimated(int count, int currentPixelX, int currentPixelY) {
    color currentCol = 0;         // Color of the current pixel
    float r, g, b;                //Red, Green, Blue
    int pxHue, pxSat, pxVal = 0;  //Hue, Saturation, Value
    float currentValue = 0;       // Current value (r/g/b/h/s/v) being tested

    currentCol = img.get(currentPixelX, currentPixelY); 

    colorModeRgb(true);
    r = constrain(red(currentCol), 0, 255);
    g = constrain(green(currentCol), 0, 255);
    b = constrain(blue(currentCol), 0, 255);

    // RGB Array
    colorMatrixRemap[floor(map(r, 0, 255, 0, count-1))][floor(map(g, 0, 255, 0, count-1))][floor(map(b, 0, 255, 0, count-1))]  += 1;
    currentValue = colorMatrixRemap[floor(map(r, 0, 255, 0, count-1))][floor(map(g, 0, 255, 0, count-1))][floor(map(b, 0, 255, 0, count-1))];
    //Sets new max value
    rgbMax = getMaxValue(rgbMax, currentValue);

    colorModeRgb(false);
    pxHue = int(hue(currentCol));
    pxSat = int(saturation(currentCol));
    pxVal = int(brightness(currentCol));

    //HSV Array  
    colorMatrixHSV[int(map(pxHue, 0, 360, 0, count-1))][int(map(pxSat, 0, 100, 0, count-1))][int(map(pxVal, 0, 100, 0, count-1))]  += 1;
    currentValue = colorMatrixHSV[int(map(pxHue, 0, 360, 0, count-1))][int(map(pxSat, 0, 100, 0, count-1))][int(map(pxVal, 0, 100, 0, count-1))];
    //Sets new max value
    hueMax = getMaxValue(rgbMax, currentValue);
  }

  void readSinglePixel( int count, int pxX, int pxY) {
    color col = img.get(pxX, pxY);  

    float pxR = constrain(red(col), 0, 255);
    float pxG = constrain(green(col), 0, 255);  
    float pxB = constrain(blue(col), 0, 255);  

    int posX = floor(map(pxR, 0, 255, 0, count-1));
    int posY = floor(map(pxG, 0, 255, 0, count-1));
    int posZ = floor(map(pxB, 0, 255, 0, count-1));

    singlePointRGB = new PVector(posX, posY, posZ);

    //println(singlePointRGB);
  }

  float getMaxValue( float _oldValue, float _newValue) {
    if (_newValue > _oldValue) {
      return _newValue;
    }
    else return _oldValue;
  }

  void pickImage(int imgNumber) {
    switch(imgNumber) {
    case 0: 
      img = loadImage("napoleon.png");
      break;  
    case 1: 
      img = loadImage("stars.png"); 
      break;  
    case 2: 
      img = loadImage("twilight.png");    
      break;  
    case 3: 
      img = loadImage("sunday.png"); 
      break;
    case 4: 
      img = loadImage("armada.png"); 
      break;
    }
    displayImg = img;
    originalImg = img;
  }

  void pickPicasaImage() {
    img = requestImage(getRandomPicasaUrl());
    originalImg = img;
    displayImg = img;
  }

  boolean isInsidePicture(int coordX, int coordY) {
    int testX = int(xPos - displaySize/2);
    int testY = int(yPos - displaySize/2);
    if ( coordX >= testX  &&  coordX <= testX+displaySize &&
      coordY >=yPos  &&  coordY <= yPos+displaySize) {
      return true;
    }
    else return false;
  }
  
  void setImage(PImage _img) {
    img = _img;
    displayImg = img;
    originalImg = img;
  }

  PImage getPic() {
    return img;
  }

  PImage getOriginalPic() {
    return originalImg;
  }

  PVector getPos() {
    return new PVector(xPos, yPos);
  }
}


