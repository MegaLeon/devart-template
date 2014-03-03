/* @pjs preload="flowers.png, gioconda.png, girasole.png, stars.png, sunday.png, twilight.png"; */

import processing.opengl.*;

float timeX, timeY;
PImage img;

int[][][] colorMatrixRemap;
int[] colorMatrixHuePyramid;
int[] hueVal;
int mapWidth, mapHeight;

int dimension = 240;          //dimension of the 3D Matrix
public int count = 24;        //Subdivions of the 3D Matrix
int mappingSpeed = 256;       //pixel analysed per second during the animated analysis
boolean isMapping = true;

public int currentImg = 2;
public int visMode = 0; //0: RGB Cubes, 1: HUE Steps

int currentPixelX = 0, currentPixelY = 0, currentPixel = 0;

float hueMax = 0, cubeRgbMax = 0;

void setup() {
  frameRate(60);
  setSubdivisions(24);

  size(1000, 500, OPENGL);
  perspective();
  //ortho(0, width, 0, height); //ortho doesn't work in JavaScript mode!

  startProcess();

  timeX = -PI/2;
  timeY = -PI/8;
}

void changeVisMode() {
  if (visMode == 0) {visMode = 1;}
  else {visMode = 0;}
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

void startProcess() {
  pickImage(currentImg);

  colorMatrixRemap = new int[count][count][count];
  colorMatrixHuePyramid = new int[count];
  hueVal = new int[360];

  currentPixel = 0;
  currentPixelX = 0;
  currentPixelY = 0;
  cubeRgbMax = 0;
  hueMax = 0;
}

void draw() {
  if (visMode == 1) {background(0, 0, map(230, 0, 255, 0, 100));}
  else {background(230);}
  
  noSmooth();

  readPixels(true, mappingSpeed);

  //timeX += map(mouseX, 0, width, -0.02, 0.02);
  //timeY += map(mouseY, 0, height, -0.01, 0.01);
  timeX += 0.01;

  // Image
  pushMatrix();
  translate(width/2 - width/4, height/2, 0);

  stroke(255);
  if (isMapping) {
    line(-dimension/2 + map(currentPixelX, 0, img.width, 0, dimension), -dimension/2, -dimension/2 + map(currentPixelX, 0, img.width, 0, dimension), dimension/2);
    line(-dimension/2, -dimension/2 + map(currentPixelY, 0, img.height, 0, dimension), dimension/2, -dimension/2 + map(currentPixelY, 0, img.height, 0, dimension));
  }

  fill(255); //ProcessingJS needs this or the image gets tinted red(?).
  img.resize(dimension, dimension);
  image(img, -dimension/2, -dimension/2);
  popMatrix();

  // 3D
  pushMatrix();
  translate(width/2 + width/4 - 64, height/2 - 32, 0);

  rotateX(timeY);
  rotateY(timeX);

  drawPanels(dimension); 
  drawStructure(visMode);
  popMatrix();
}

void pickImage(int imgNumber) {
  switch(imgNumber) {
  case 0: 
    img = loadImage("gioconda.png"); 
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
  }
}

public void drawStructure(int visualizationMode) {
  switch(visualizationMode) {
  case 0: 
    drawElementsRemap(0, 0, 0, dimension, count, 24);
    break;
  case 1: 
    drawElementsPyramidHue(0, 0, 0, dimension, count, 24);  
    break;
  }
}

// Saves the image when "S" is pressed
void keyPressed() {
  if (key == 's') {
    save("normal.png");
  }
  if (key == CODED) {
    switch (keyCode) {
    case LEFT: 
      timeX -= 0.1; 
      break;

    case RIGHT: 
      timeX += 0.1; 
      break;
    }
  }
}

void readPixels(boolean _animated, int _animSpeed) {
  if (currentPixel < img.width * img.height) {
    // Animated
    if (_animated) {
      isMapping = true;
      for (int i = 0; i < _animSpeed; i++) {
        readPixelsAnimated(count, currentPixelX, currentPixelY);
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
          readPixelsAnimated(count, currentPixelX, currentPixelY);
          currentPixel += 1;
          currentPixelX = currentPixel % img.width;
          currentPixelY = int(floor(currentPixel / img.height));
        }
      }
    }
  } 
  else isMapping = false;
}

