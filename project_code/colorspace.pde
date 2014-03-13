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

void smartFill(int _intensity) {
  if (!isColorSpaceRGB) {
    fill(0, 0, map(_intensity, 0, 255, 0, 100));
  }
  else {
    fill(_intensity);
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
