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
    smartFill(255); //needs this or the image gets tinted red(?).
    imageMode(CENTER);
    img.resize(mapSize, mapSize);
    image(displayImg, xPos, yPos, displaySize, displaySize);
    visualizeScanning();
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

  void visualizeScanning() {
    pushMatrix();
    translate(xPos, yPos);
    stroke(255);
    if (isMapping) {
      line(-displaySize/2 + map(currentPixelX, 0, mapSize, 0, displaySize), -displaySize/2, -displaySize/2 + map(currentPixelX, 0, mapSize, 0, displaySize), displaySize/2);
      line(-displaySize/2, -displaySize/2 + map(currentPixelY, 0, mapSize, 0, displaySize), displaySize/2, -displaySize/2 + map(currentPixelY, 0, mapSize, 0, displaySize));
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
  }
  
  void pickPicasaImage(String _searchWord) {
    img = requestImage(getRandomPicasaUrl(_searchWord));
    displayImg = img;
  }

  PImage getPic() {
    return img;
  }
}

