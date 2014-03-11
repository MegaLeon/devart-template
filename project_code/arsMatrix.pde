/* @pjs preload="gioconda.png, stars.png, sunday.png, twilight.png"; 
 */

import processing.opengl.*;

int[][][] colorMatrixRemap;
int[][][] colorMatrixHSV;
int[] colorMatrixHuePyramid;
int[] hueVal;

int subdivisions = 12;
int mappingSpeed = 128;                // pixel analysed per second during the animated analysis
boolean isMapping = true;
boolean isColorSpaceRGB = true;

float hueMax = 0, cubeRgbMax = 0;

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
  colorMatrixHuePyramid = new int[subdivisions];
  hueVal = new int[360];

  picture.reset();

  cubeRgbMax = 0;
  hueMax = 0;
}

void draw() {
  if (!isColorSpaceRGB) {
    background(0, 0, map(230, 0, 255, 0, 100));
  }
  else {
    background(230);
  } 

  picture.readPixels(true, mappingSpeed);

  //timeX += map(mouseX, 0, width, -0.02, 0.02);
  //timeY += map(mouseY, 0, height, -0.01, 0.01);
  //timeX -= 0.005;

  lights();

  // Image
  picture.display();

  // 3D
   matrix.display();
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
      //timeX -= 0.1; 
      break;

    case RIGHT: 
      //timeX += 0.1; 
      break;

    case UP:
      /*if (currentImg < 4) currentImg++; 
       else currentImg = 0;
       initialize();*/
      break;

    case DOWN:
      /*if (visMode < 5) visMode++; 
       else visMode = 0;
       initialize();
       break;*/
    }
  }
}

