float timeX, timeY;
PImage img;

int[][][] colorMatrixRemap;
int[] colorMatrixHuePyramid;
int[] hueVal;

int size = 240;               //Size of the 3D Matrix
int count = 12;               //Subdivions of the 3D Matrix
  int mappingSpeed = 512;     //pixel analysed per second during the animated analysis

int currentPixelX = 0, currentPixelY = 0, currentPixel = 0;

float hueMax = 0, cubeRgbMax = 0;

void setup() {
  frameRate(60);

  size(1000, 500, P3D); 
  ortho(0, width, 0, height); 
  img = loadImage("twilight.png");

  colorMatrixRemap = new int[count][count][count];
  colorMatrixHuePyramid = new int[count];
  hueVal = new int[360];

  timeX =  -PI/3;
  timeY = -PI/6;
}

void draw() {
  background(230);
  smooth(4);
  
  readPixels(true, mappingSpeed);

  timeX += map(mouseX, 0, width, -0.02, 0.02);
  timeY += map(mouseY, 0, height, -0.01, 0.01);

  pushMatrix();
  translate(width/2 - width/4, height/2, 0);

  stroke(255);
  line(-size/2 + map(currentPixelX, 0, img.width, 0, size), -size/2, -size/2 + map(currentPixelX, 0, img.width, 0, size), size/2);
  line(-size/2, -size/2 + map(currentPixelY, 0, img.height, 0, size), size/2, -size/2 + map(currentPixelY, 0, img.height, 0, size));

  image(img, -size/2, -size/2, size, size);
  popMatrix();

  pushMatrix();
  translate(width/2 + width/4, height/2, 0);

  rotateX(timeY);
  rotateY(timeX);

  drawPanels(size); 

  drawElementsRemap(0, 0, 0, size, count, 24);
  //drawElementsPyramidHue(0, 0, 0, size, count, 24);

  popMatrix();
}

// Saves the image when "S" is pressed
void keyPressed() {
  if (key == 's') {
    save("normal.png");
  }
}

void readPixels(boolean _animated, int _animSpeed) {
  if (currentPixel < img.width * img.height) {
    // Animated
    if (_animated) {
      for (int i = 0; i < _animSpeed; i++) {
        readPixelsAnimated(count, currentPixelX, currentPixelY);
        currentPixel += 1;
        currentPixelX = currentPixel % img.width;
        currentPixelY = int(floor(currentPixel / img.height));
        print("Total: " + currentPixel + ", X: " + currentPixelX + ", Y: " + currentPixelY + "\n");
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
}

