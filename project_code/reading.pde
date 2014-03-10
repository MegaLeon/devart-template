void readPixelsAnimated(int count, int currentPixelX, int currentPixelY) {
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
