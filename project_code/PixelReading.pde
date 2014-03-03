// read color values of the image and store them in different arrays
void readPixelsRemap(int count) {
  color currentCol;
  float r, g, b;
  int buffer = 0;
  int pxHue = 0;
  float currentValue;
  for (int i = 0; i < img.width; i++) {
    currentPixelX = i;
    for (int j = 0; j < img.height; j++) {  
      currentPixelY = i;

      currentCol = img.get(i, j);  
      r = red(currentCol);
      g = green(currentCol);
      b = blue(currentCol);
      pxHue = int(hue(currentCol));

      // RGB Cube Matrix
      if (i % count == 0 && j % count == 0) { //if both are on the countTh pixel
        colorMatrixRemap[int(map(r, 0, 255, 0, count-1))][int(map(g, 0, 255, 0, count-1))][int(map(b, 0, 255, 0, count-1))]  += buffer;
        currentValue = colorMatrixRemap[int(map(r, 0, 255, 0, count-1))][int(map(g, 0, 255, 0, count-1))][int(map(b, 0, 255, 0, count-1))];
        //Sets new max value
        cubeRgbMax = getMaxValue(cubeRgbMax, currentValue);
        buffer = 0;
      }
      else {
        buffer +=1;
      }

      // Hue Pyramid Matrix      
      colorMatrixHuePyramid[int(map(pxHue, 0, 360, 0, count))] += 1;
      currentValue = colorMatrixHuePyramid[int(map(pxHue, 0, 360, 0, count))];
      //Sets new max value
      hueMax = getMaxValue(hueMax, currentValue);

      // increase whole hue array for debug purposes
      hueVal[pxHue] ++;
    }
  }
}

void readPixelsAnimated(int count, int currentPixelX, int currentPixelY) {
  color currentCol = 0;
  float r, g, b;
  int pxHue = 0;
  float currentValue = 0;

  currentCol = img.get(currentPixelX, currentPixelY);  
  r = constrain(red(currentCol), 0, 255);
  g = constrain(green(currentCol), 0, 255);
  b = constrain(blue(currentCol), 0, 255);
  pxHue = int(hue(currentCol));
  
  colorMatrixRemap[floor(map(r, 0, 255, 0, count-1))][floor(map(g, 0, 255, 0, count-1))][floor(map(b, 0, 255, 0, count-1))]  += 1;
  currentValue = colorMatrixRemap[floor(map(r, 0, 255, 0, count-1))][floor(map(g, 0, 255, 0, count-1))][floor(map(b, 0, 255, 0, count-1))];
  //Sets new max value
  cubeRgbMax = getMaxValue(cubeRgbMax, currentValue);

  // Hue Pyramid Matrix      
  colorMatrixHuePyramid[int(map(pxHue, 0, 360, 0, count))] += 1;
  currentValue = colorMatrixHuePyramid[int(map(pxHue, 0, 360, 0, count))];
  //Sets new max value
  hueMax = getMaxValue(hueMax, currentValue);
}

float getMaxValue( float _oldValue, float _newValue) {
  if (_newValue > _oldValue) {
    return _newValue;
  }
  else return _oldValue;
}

