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

void drawElementsRemap(int _x, int _y, int _z, int size, int count, int scale) {
  int snap = size/count;
  float scaleValue = (cubeRgbMax) / (size);

  for (int i = 1; i < count; i++) {
    for (int j = 1; j < count; j++) {
      for (int k = 1; k < count; k++) {
        pushMatrix();

        // move to center of each "slot"
        translate((_x - size/2) + i * (size/count), (_y - size/2) + j * (size/count), (_z - size/2) + k* (size/count));

        // get the color by mapping the current slot against the color array
        fill(map(i, 0, count, 0, 255), map(j, 0, count, 0, 255), map(k, 0, count, 0, 255));
        stroke(map(i, 0, count, 0, 128), map(j, 0, count, 0, 128), map(k, 0, count, 0, 128));

        // draw a cube if bigger than treshold value
        //box(map(colorMatrixRemap[i][j][k], 0, cubeRgbMax, 0, cubeRgbMax/scaleValue/count));
        box(constrain(colorMatrixRemap[i][j][k]/count, 0, size/count));

        popMatrix();
      }
    }
  }
}

void drawElementsPyramidHue(int _x, int _y, int _z, int size, int count, int scale) {
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
    box(stepSize, size/count, stepSize);

    popMatrix();
  }
}

void drawHueLines(int _x, int _y) {
  for (int i = 0; i < 360; i++) { 
    colorMode(HSB, 360, 100, 100);
    stroke(i, 100, 100);
    line(_x - i, _y - (360/2), _x - i, _y - (360/2) + hueVal[i]/10);
  }
}

