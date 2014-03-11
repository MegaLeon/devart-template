class ImageSrc {
  float xPos, yPos;
  int displaySize, mapSize;
  PImage img, displayImg;
  int currentPixelX = 0, currentPixelY = 0, currentPixel = 0;

  ImageSrc(float _xPos, float _yPos, int _imgNumber, int _displaySize, int _mapSize) {
    xPos = _xPos;
    yPos = _yPos;
    pickImage(_imgNumber);
    displaySize = _displaySize;  
    mapSize = _mapSize;
  }

  void display() {
    pushMatrix();
    //translate(width/2 - width/4, height/2, 0);
    translate(xPos, yPos, 0);

    // Scanning Lines
    stroke(255);
     if (isMapping) {
     line(-displaySize/2 + map(currentPixelX, 0, img.width, 0, displaySize), -displaySize/2, -displaySize/2 + map(currentPixelX, 0, img.width, 0, displaySize), displaySize/2);
     line(-displaySize/2, -displaySize/2 + map(currentPixelY, 0, img.height, 0, displaySize), displaySize/2, -displaySize/2 + map(currentPixelY, 0, img.height, 0, displaySize));
     }

    fill(255); //ProcessingJS needs this or the image gets tinted red(?).

    img.resize(mapSize, mapSize);
    displayImg.resize(displaySize, displaySize);

    image(displayImg, -displaySize/2, -displaySize/2);
    popMatrix();
  }
  
  void reset() {
    currentPixel = 0;
    currentPixelX = 0;
    currentPixelY = 0;
  }
  
  void setImage(int _imgNumber) {
    pickImage(_imgNumber);
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

    colorMode(RGB, 255); 
    r = constrain(red(currentCol), 0, 255);
    g = constrain(green(currentCol), 0, 255);
    b = constrain(blue(currentCol), 0, 255);

    colorMode(HSB, 360, 100, 100);
    pxHue = int(hue(currentCol));
    pxSat = int(saturation(currentCol));
    pxVal = int(brightness(currentCol));

    // RGB Array
    colorMatrixRemap[floor(map(r, 0, 255, 0, count-1))][floor(map(g, 0, 255, 0, count-1))][floor(map(b, 0, 255, 0, count-1))]  += 1;
    currentValue = colorMatrixRemap[floor(map(r, 0, 255, 0, count-1))][floor(map(g, 0, 255, 0, count-1))][floor(map(b, 0, 255, 0, count-1))];
    //Sets new max value
    cubeRgbMax = getMaxValue(cubeRgbMax, currentValue);

    // HUe Array 
    colorMatrixHuePyramid[int(map(pxHue, 0, 360, 0, count))] += 1;
    currentValue = colorMatrixHuePyramid[int(map(pxHue, 0, 360, 0, count))];
    //Sets new max value
    hueMax = getMaxValue(hueMax, currentValue);

    //HSV Array  
    colorMatrixHSV[int(map(pxHue, 0, 360, 0, count-1))][int(map(pxSat, 0, 100, 0, count-1))][int(map(pxVal, 0, 100, 0, count-1))]  += 1;
    currentValue = colorMatrixHSV[int(map(pxHue, 0, 360, 0, count-1))][int(map(pxSat, 0, 100, 0, count-1))][int(map(pxVal, 0, 100, 0, count-1))];
    //Sets new max value
    hueMax = getMaxValue(cubeRgbMax, currentValue);
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
     case 4: 
      img = loadImage("armada.png"); 
      break;
    }
    displayImg = img;
  }
}

