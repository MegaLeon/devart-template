void drawElementsRemap(int _x, int _y, int _z, int size, int count) {
  //float scaleValue = (cubeRgbMax) / (size);
  float sizeValue;

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count), (_z - size/2) + k* (size/count));

        // get the color by mapping the current slot against the color array
        colorMode(RGB, 255);
        fill(map(i, 0, count, 0, 255), map(j, 0, count, 0, 255), map(k, 0, count, 0, 255));
        stroke(map(i, 0, count, 0, 128), map(j, 0, count, 0, 128), map(k, 0, count, 0, 128));

        // draw a cube if bigger than treshold value
        //box(map(colorMatrixRemap[i][j][k], 0, cubeRgbMax, 0, cubeRgbMax/scaleValue/count));
        sizeValue = constrain(colorMatrixRemap[i][j][k]/count, 0, size/count);
        //println(i + ", " + j + ", " + k + ": " + sizeValue);
        if (sizeValue > 0) {
          box(sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawElementsPyramidHue(int _x, int _y, int _z, int size, int count) {
  float stepSize;
  float scaleValue = (hueMax) / (size/1.5);
  for (int i = 0; i < count; i++) {
    pushMatrix();

    // move to center of each "slot"
    translate(_x, (_y - size/2) + i * (size/count), _z);

    // get the color by mapping the current slot against the color array
    colorMode(HSB, 360, 100, 100);
    fill(map(i, 0, count, 0, 360), 90, 75);
    stroke(map(i, 0, count, 0, 360), 90, 25);

    // draw a cube if bigger than treshold value
    //stepSize = constrain(map(colorMatrixHuePyramid[i], 0, size*size, 0, size/2), 0, size);
    stepSize = map(colorMatrixHuePyramid[i], 0, hueMax, 0, hueMax/scaleValue);
    if (stepSize > 0) {
      box(stepSize, size/count, stepSize);
    }

    popMatrix();
  }
}

void drawCubesHue(int _x, int _y, int _z, int size, int count) {
  float newHue, newSat, newVal;
  float sizeValue;

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count), (_z - size/2) + k* (size/count));

        // get the color by mapping the current slot against the color array        
        newHue = map(i, 0, count, 0, 360);
        //newSat = abs(abs(map(j, 0, count, -100, 100)) -100); //from absolute(-100 to 100), minues 100 to make it (0 to -100 to 0) with another abs()
        //newVal = abs(abs(map(k, 0, count, -100, 100)) -100);        
        newSat = map(j, 0, count, 0, 100);
        newVal = map(k, 0, count, 0, 100);

        colorMode(HSB, 360, 100, 100);
        fill(newHue, newSat, newVal);
        stroke(newHue, newSat, newVal/2);

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/count, 0, size/count);
        //sizeValue = 16;
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

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), _y, (_z - size/2) + k * (size/count));

        // get the color by mapping the current slot against the color array
        colorMode(HSB, 360, 100, 100);

        newHue = map(i, 0, count, 0, 360);        
        newSat = map(j, 0, count, 0, 100);
        newVal = map(k, 0, count, 0, 100);

        fill(newHue, newSat, newVal);
        stroke(newHue, newSat, newVal/2);

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/count, 0, size);
        if (sizeValue > 0) {
          box(map(sizeValue, 0, size, size/count, 1), sizeValue, map(sizeValue, 0, size, size/count, 1));
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

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate(_x, (_y - size/2) + i * (size/count), _z);

        // get the color by mapping the current slot against the color array
        colorMode(HSB, 360, 100, 100);

        newHue = map(i, 0, count, 0, 360);        
        newSat = map(j, 0, count, 0, 100);
        newVal = map(k, 0, count, 0, 100);

        fill(newHue, newSat, newVal);
        //stroke(newHue, newSat, newVal/2);
        noStroke();

        // draw a cube if bigger than treshold value
        sizeValue = constrain(colorMatrixHSV[i][j][k]/(count / (size/count)), 0, size);
        //sizeValue = map(colorMatrixHSV[i][j][k], 0, hueMax, 0, size);
        if (sizeValue > 0) {
          box(sizeValue, map(sizeValue, 2, size, size/count, 1), sizeValue);
        }
        popMatrix();
      }
    }
  }
}

void drawPanels(int size) {    
  rectMode(CENTER);
  stroke(100);
  noFill();  

  fill(220);  
  pushMatrix();
  translate(0, size/2, 0);
  rotateX(PI/2);
  drawGrid(0, 0, size, 12);
  rect(0, 0, size, size);
  popMatrix();
  noFill();

  pushMatrix();
  translate(-size/2, 0, 0);
  rotateY(PI/2);
  drawGrid(0, 0, size, 12);
  rect(0, 0, size, size);
  popMatrix();

  pushMatrix();
  translate(0, 0, -size/2);
  rotateZ(PI/2);
  drawGrid(0, 0, size, 12);
  rect(0, 0, size, size);
  popMatrix();
}

void drawGrid(int _x, int _y, int size, int count) {
  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      point((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count));
    }
  }
}

