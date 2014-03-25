void drawCubesRGB(int _x, int _y, int _z, int size, int count, PGraphics pg) {
  //float scaleValue = (rgbMax) / (size);
  float sizeValue;

  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      for (int k = 0; k < count; k++) {
        pg.pushMatrix();

        // move to center of each "slot"
        pg.translate((_x - size/2) + i * (size/count) + ((size/count)/2), (_y - size/2) + j * (size/count) + ((size/count)/2), (_z - size/2) + k * (size/count) + ((size/count)/2));

        // get the color by mapping the current slot against the color array
        colorModeRgbPG(true, pg);
        pg.fill(map(i, 0, count, 0, 255), map(j, 0, count, 0, 255), map(k, 0, count, 0, 255));
        //pg.stroke(map(i, 0, count, 0, 200), map(j, 0, count, 0, 200), map(k, 0, count, 0, 200));
        pg.noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixRemap[i][j][k]/(count / scaleBias), 0, size/count);
        //sizeValue = map(colorMatrixRemap[i][j][k], 0, rgbMax, 0, rgbMax/scaleValue/count);
        if (sizeValue > 0) {
          pg.box(sizeValue);
        }
        pg.popMatrix();
      }
    }
  }
}

void drawVertBarsHue(int _x, int _y, int _z, int size, int count, PGraphics pg) {
  float newHue, newSat, newVal = 0;
  float sizeValue = 0;

  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      for (int k = 0; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count) + ((size/count)/2), _y, (_z - size/2) + k * (size/count) + ((size/count)/2));

        // get the color by mapping the current slot against the color array
        colorModeRgb(false);

        newHue = map(i, 0, count-1, 0, 360);        
        newSat = map(j, 0, count-1, 0, 100);
        newVal = map(k, 0, count-1, 0, 100);

        pg.fill(newHue, newSat, newVal);
        //pg.stroke(newHue, newSat, newVal/1.5);
        pg.noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(size/(count * scaleBias)/2), 0, size);
        if (sizeValue > 0) {
          pg.box(map(sizeValue, 0, size, size/count, (size/count)/2), sizeValue, map(sizeValue, 0, size, size/count, (size/count)/2));
        }

        popMatrix();
      }
    }
  }
}

void drawHorzBarsHue(int _x, int _y, int _z, int size, int count, PGraphics pg) {
  float newHue, newSat, newVal = 0;
  //float scaleValue = (hueMax) / (size/1.5);
  float sizeValue = 0;
  isColorSpaceRGB = false;

  for (int i = 0; i < count-1; i++) {
    for (int j = 0; j < count-1; j++) {
      for (int k = 0; k < count-1; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate(_x, (_y - size/2) + i * (size/count), _z);

        // get the color by mapping the current slot against the color array
        colorModeRgb(false);

        newHue = map(i, 0, count-1, 0, 360);        
        newSat = map(j, 0, count-1, 0, 100);
        newVal = map(k, 0, count-1, 0, 100);

        pg.fill(newHue, 50, 50);
        //pg.stroke(newHue, newSat, newVal/1.5);
        pg.noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(size/(count * scaleBias)/2), 0, size - (size/8));
        //sizeValue = map(colorMatrixHSV[i][j][k], 0, hueMax, 0, size);
        if (sizeValue > 0) {
          pg.box(sizeValue, map(sizeValue, 2, size, size/count, 1), sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawSinglePixelRGB(int _x, int _y, int _z, int size, int count) {
  pushMatrix();
  translate((_x - size/2), (_y - size/2), (_z - size/2) + singlePointRGB.z);
  smartStroke(255);

  float lnX = singlePointRGB.x * (size/count);
  float lnY = singlePointRGB.y * (size/count);
  float lnZ = singlePointRGB.z * (size/count);

  line(0, lnY, lnZ, size, lnY, lnZ);
  line(lnX, 0, lnZ, lnX, size, lnZ);
  line(lnX, lnY, 0, lnX, lnY, size);
  popMatrix();
}

