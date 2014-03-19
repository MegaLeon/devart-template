void drawCubesRGB(int _x, int _y, int _z, int size, int count) {
  //float scaleValue = (rgbMax) / (size);
  float sizeValue;

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count), (_z - size/2) + k * (size/count));

        // get the color by mapping the current slot against the color array
        colorModeRgb(true);
        fill(map(i, 0, count, 0, 255), map(j, 0, count, 0, 255), map(k, 0, count, 0, 255));
        noStroke();
        //stroke(map(i, 0, count, 0, 128), map(j, 0, count, 0, 128), map(k, 0, count, 0, 128));

        // draw a cube if bigger than treshold value
        //box(map(colorMatrixRemap[i][j][k], 0, rgbMax, 0, rgbMax/scaleValue/count));
        sizeValue = constrain(colorMatrixRemap[i][j][k]/count, 0, size/count);
        //sizeValue = map(colorMatrixRemap[i][j][k], 0, rgbMax, 0, rgbMax/scaleValue/count);
        //println(i + ", " + j + ", " + k + ": " + sizeValue);
        if (sizeValue > 0) {
          box(sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawVertBarsHue(int _x, int _y, int _z, int size, int count) {
  float newHue, newSat, newVal = 0;
  float sizeValue = 0;
  isColorSpaceRGB = false;

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), _y, (_z - size/2) + k * (size/count));

        // get the color by mapping the current slot against the color array
        colorModeRgb(false);

        newHue = map(i, 0, count, 0, 360);        
        newSat = map(j, 0, count, 0, 100);
        newVal = map(k, 0, count, 0, 100);

        fill(newHue, newSat, newVal);
        //stroke(newHue, newSat, newVal/2);
        noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(size/count/2), 0, size);
        if (sizeValue > 0) {
          box(map(sizeValue, 0, size, size/count, (size/count)/2), sizeValue, map(sizeValue, 0, size, size/count, (size/count)/2));
        }

        popMatrix();
      }
    }
  }
}

void drawHorzBarsHue(int _x, int _y, int _z, int size, int count) {
  float newHue, newSat, newVal = 0;
  //float scaleValue = (hueMax) / (size/1.5);
  float sizeValue = 0;
  isColorSpaceRGB = false;

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate(_x, (_y - size/2) + i * (size/count), _z);

        // get the color by mapping the current slot against the color array
        colorModeRgb(false);

        newHue = map(i, 0, count, 0, 360);        
        newSat = map(j, 0, count, 0, 100);
        newVal = map(k, 0, count, 0, 100);

        fill(newHue, newSat, newVal);
        //stroke(newHue, newSat, newVal/2);
        noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(size/count/2), 0, size - (size/8));
        //sizeValue = map(colorMatrixHSV[i][j][k], 0, hueMax, 0, size);
        if (sizeValue > 0) {
          box(sizeValue, map(sizeValue, 2, size, size/count, 1), sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawSinglePixelRGB(int _x, int _y, int _z, int size, int count) {
  pushMatrix();
  //translate((_x - size/2) + singlePointRGB.x * (size/count), (_y - size/2) + singlePointRGB.y * (size/count), (_z - size/2) + singlePointRGB.z * (size/count));
  translate((_x - size/2), (_y - size/2), (_z - size/2) + singlePointRGB.z);
  //smartFill(255);
  smartStroke(255);
  //box(24);

  float lnX = singlePointRGB.x * (size/count);
  float lnY = singlePointRGB.y * (size/count);
  float lnZ = singlePointRGB.z * (size/count);

  line(0, lnY, lnZ, size, lnY, lnZ);
  line(lnX, 0, lnZ, lnX, size, lnZ);
  line(lnX, lnY, 0, lnX, lnY, size);
  popMatrix();
}

