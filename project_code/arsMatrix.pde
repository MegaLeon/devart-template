/* @pjs preload="gioconda.png, stars.png, sunday.png, twilight.png"; */

import processing.opengl.*;

boolean isAnimated = false;      // animate the mapping process or not
int subdivisions = 12;           //
int mappingSpeed = 2048;          // pixel analysed per second during the animated analysis
String searchWord = "picasso"; // word to search the picasa public feed with, when it's not loading the featured images

int[][][] colorMatrixRemap;
int[][][] colorMatrixHSV;
boolean isMapping;
boolean isColorSpaceRGB;
float hueMax, rgbMax = 0;

Matrix matrix;
ImageSrc picture;

void setup() {
  frameRate(60);
  smooth(4);
  size(1000, 500, OPENGL);
  ortho(0, width, 0, height); //ortho doesn't work in JavaScript mode!

  matrix = new Matrix(width/2 + width/4 - 32, height/2, 240, 0);
  picture = new ImageSrc(width/2 - width/4, height/2, 0, 240, 240);

  fillArrayPicasaUrls(true, searchWord);
  setupControls();
  
  initialize(true);
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
  if (!isColorSpaceRGB) {
    background(0, 0, map(230, 0, 255, 0, 100));
  }
  else {
    background(230);
  } 

  lights();
  shininess(5.0); 
  //ambientLight(153, 102, 0);

  if (picture.getPic().width > 0) {
    picture.readPixels(isAnimated, mappingSpeed);
    picture.display();
  } 
  else {
    picture.displayLoadingRect();
  }

  matrix.display();
}

void keyPressed() {
  if (key == 's') {
    save("normal.png");
  }

  if (key == CODED) {
    switch (keyCode) {


    case LEFT: 
      break;

    case RIGHT: 
      break;

    case UP:
      break;

    case DOWN:
      break;
    }
  }
}

// Rotate Camera
void mouseDragged() 
{
  if (mouseX > width/2) {
    float speedX = mouseX- pmouseX;
    float speedY = mouseY - pmouseY;
    matrix.rotateMatrix(speedX/300, speedY/300);
  }
}

