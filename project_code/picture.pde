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

    println(singlePointRGB);
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

