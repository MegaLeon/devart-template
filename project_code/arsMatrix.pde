import processing.opengl.*;
import nervoussystem.obj.*;

boolean objRecording = false;

int guiScale = 1;            // Scale value for the interface (1 works fine with 1000*500)

int matSize = 240;           // Size of the 3D matrix
int picMapSize = 240;        // Size of the picture being mapped (bigger images takes longer and create more 3D artifacts)
int picDisplaySize = 240;    // Size of the picture being displayed (doesn't affect mapping)

boolean isLiveMode = true;
boolean isAnimated = false;      // animate the mapping process or not
int mappingSpeed = 2048;         // pixel analysed per second during the animated analysis
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
  smooth(4);
  size(1000, 500, OPENGL);
  ortho(0, width, 0, height); //ortho doesn't work in JavaScript mode!

  matrix = new Matrix(width/2 + width/4 - 32, height/2, matSize, 0);
  picture = new ImageSrc(width/2 - width/4, height/2, 0, picDisplaySize, picMapSize);

  setupControls(); // initialize interface

  fillArrayPicasaUrls(true, "");
  picture.pickPicasaImage();
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
  if (!isColorSpaceRGB) {
    background(0, 0, map(230, 0, 255, 0, 100));
  }
  else {
    background(230);
  } 

  lights();
  //shininess(5.0); 

  if (!isLiveMode) {
    if (picture.getPic().width > 0) {
      picture.readPixels(isAnimated, mappingSpeed);
      picture.display();
    } 
    else {
      picture.displayLoadingRect();
    }
  } 
  else {
    pictureLive.display();
    initialize(false);
    picture.readPixels(isAnimated, mappingSpeed);
    picture.display();
  }

  matrix.display();
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
  println("Okay");
  if ((mouseX > width/2) && (mouseX < (width - btnSize*2))) {
    println("Super");
    float speedX = mouseX- pmouseX;
    float speedY = mouseY - pmouseY;
    matrix.rotateMatrix(speedX/300, speedY/300);
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

