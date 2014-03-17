void colorModeRgb(boolean _isRgb) {
  if (_isRgb) {
    colorMode(RGB, 255);
    isColorSpaceRGB = true;
  } 
  else {
    colorMode(HSB, 360, 100, 100);
    isColorSpaceRGB = false;
  }
}

boolean getCurrentColorSpace() {
  if (isColorSpaceRGB) {
    return true;
  } 
  else {
    return false;
  }
}

void restorePreviousColorSpace(boolean _wasPreviousRgb) {
  if (_wasPreviousRgb) {
    colorModeRgb(true);
  } 
  else {
    colorModeRgb(false);
  }
}

void smartFill(int _intensity) {
  if (!isColorSpaceRGB) {
    fill(0, 0, map(_intensity, 0, 255, 0, 100));
  }
  else {
    fill(_intensity);
  }
}

void smartFillAlpha(int _intensity, int _alpha) {
  if (!isColorSpaceRGB) {
    fill(0, 0, map(_intensity, 0, 255, 0, 100), _alpha);
  }
  else {
    fill(_intensity, _alpha);
  }
}

void smartStroke(int _intensity) {
  if (!isColorSpaceRGB) {
    stroke(0, 0, map(_intensity, 0, 255, 0, 100));
  }
  else {
    stroke(_intensity);
  }
}

