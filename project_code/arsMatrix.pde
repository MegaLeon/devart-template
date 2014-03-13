/* @pjs preload="gioconda.png, stars.png, sunday.png, twilight.png"; */

import processing.opengl.*;

int[][][] colorMatrixRemap;
int[][][] colorMatrixHSV;

int subdivisions = 12;
int mappingSpeed = 1024; // pixel analysed per second during the animated analysis

boolean isAnimated = true;
boolean isMapping = true;
boolean isColorSpaceRGB = true;

float hueMax = 0, rgbMax = 0;

Matrix matrix;
ImageSrc picture;

void setup() {
  frameRate(60);
  smooth(4);
  size(1000, 500, OPENGL);
  ortho(0, width, 0, height); //ortho doesn't work in JavaScript mode!

  matrix = new Matrix(width/2 + width/4 - 32, height/2, 240, 0);
  picture = new ImageSrc(width/2 - width/4, height/2, 0, 240, 240);

  initialize();
  setupControls();
}

void initialize() { 
  colorMatrixRemap = new int[subdivisions][subdivisions][subdivisions];
  colorMatrixHSV = new int[subdivisions][subdivisions][subdivisions];

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

  picture.readPixels(isAnimated, mappingSpeed);

  lights();
  shininess(5.0); 
  //ambientLight(153, 102, 0);

  picture.display();
  matrix.display();
}

void keyPressed() {
  if (key == 's') {
    save("normal.png");
  }
  
  if (key == CODED) {
    switch (keyCode) {

      // Rotate Camera
    case LEFT: 
      //timeX -= 0.1; 
      break;

    case RIGHT: 
      //timeX += 0.1; 
      break;

    case UP:
      picture.getPic().filter(BLUR, 1);
      initialize();
      break;

    case DOWN:
      /*if (visMode < 5) visMode++; 
       else visMode = 0;
       initialize();
       break;*/
    }
  }
}


