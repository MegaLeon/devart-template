/* @pjs preload="gioconda.png, stars.png, sunday.png, twilight.png"; 
 */

import processing.opengl.*;

float timeX, timeY;
PImage img, displayImg;

int[][][] colorMatrixRemap;
int[][][] colorMatrixHSV;
int[] colorMatrixHuePyramid;
int[] hueVal;

int mapWidth, mapHeight;

int imgDimension = 240;                // dimension of the Image being displayed
int mapDimension = 240;                // dimension of the Image being mapped
int dimension = 240;                   // dimension of the 3D Matrix
public int count = 24;                 // subdivions of the 3D Matrix
int mappingSpeed = 128;                // pixel analysed per second during the animated analysis
boolean isMapping = true;

public int currentImg = 0;
public int visMode = 0; //0: RGB Cubes, 1: HUE Steps

int currentPixelX = 0, currentPixelY = 0, currentPixel = 0;

float hueMax = 0, cubeRgbMax = 0;

void setup() {
  frameRate(60);
  //setSubdivisions(24);
  noSmooth();

  timeX = PI/3;
  timeY = -PI/8;

  size(1000, 500, OPENGL);
  perspective();
  ortho(0, width, 0, height); //ortho doesn't work in JavaScript mode!

  initialize();
  initMetaballs(dimension, count);
}

void initialize() {
  pickImage(currentImg);

  colorMatrixRemap = new int[count][count][count];
  colorMatrixHSV = new int[count][count][count];
  colorMatrixHuePyramid = new int[count];
  hueVal = new int[360];

  currentPixel = 0;
  currentPixelX = 0;
  currentPixelY = 0;

  cubeRgbMax = 0;
  hueMax = 0;
}

void draw() {
  if (visMode != 0) {
    background(0, 0, map(230, 0, 255, 0, 100));
  }
  else {
    background(230);
  } 

  readPixels(true, mappingSpeed);

  //timeX += map(mouseX, 0, width, -0.02, 0.02);
  //timeY += map(mouseY, 0, height, -0.01, 0.01);
  //timeX += 0.01;

  lights();

  // Image
  pushMatrix();
  translate(width/2 - width/4, height/2, 0);

  // Scanning Lines
  stroke(255);
  if (isMapping) {
    line(-imgDimension/2 + map(currentPixelX, 0, img.width, 0, imgDimension), -imgDimension/2, -imgDimension/2 + map(currentPixelX, 0, img.width, 0, imgDimension), imgDimension/2);
    line(-imgDimension/2, -imgDimension/2 + map(currentPixelY, 0, img.height, 0, imgDimension), imgDimension/2, -imgDimension/2 + map(currentPixelY, 0, img.height, 0, imgDimension));
  }

  fill(255); //ProcessingJS needs this or the image gets tinted red(?).
  img.resize(mapDimension, mapDimension);
  displayImg.resize(imgDimension, imgDimension);
  image(displayImg, -imgDimension/2, -imgDimension/2);
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
  displayImg = img;
}

public void drawStructure(int visualizationMode) {
  switch(visualizationMode) {
  case 0: 
    //drawElementsRemap(0, 0, 0, dimension, count);
    drawMetaballs(0, 0, 0, dimension, count);
    break;
  case 1: 
    drawElementsPyramidHue(0, 0, 0, dimension, count);  
    break;
  case 2: 
    drawCubesHue(0, 0, 0, dimension, count);  
    break;
  case 3: 
    drawVertBarsHue(0, 0, 0, dimension, count);  
    break;
  case 4: 
    drawHorzBarsHue(0, 0, 0, dimension, count);  
    break;
  }
}


void keyPressed() {
  if (key == 's') {
    // Saves the image when "S" is pressed
    save("normal.png");
  }
  if (key == CODED) {
    switch (keyCode) {
      // Rotate Camera
    case LEFT: 
      timeX -= 0.1; 
      break;

    case RIGHT: 
      timeX += 0.1; 
      break;

    case UP:
      if (currentImg < 4) currentImg++; 
      else currentImg = 0;
      initialize();
      break;

    case DOWN:
      if (visMode < 5) visMode++; 
      else visMode = 0;
      initialize();
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

