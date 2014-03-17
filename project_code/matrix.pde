class Matrix {
  float xPos, yPos;
  float xRot, yRot;
  float xRotBuffer, yRotBuffer = 0;
  int dimension;
  int visMode = 0;

  Matrix(float _xPos, float _yPos, int _dimension, int _visMode) {
    xPos = _xPos;
    yPos = _yPos;
    xRot = -PI/8;
    yRot = -PI/3;
    dimension = _dimension;
    visMode = _visMode;
    initMetaballs(dimension, subdivisions);
  }

  void display() {
    pushMatrix();
    translate(xPos, yPos);

    updateRotation();

    drawPanels(dimension);
    drawStructure(visMode, subdivisions);
    popMatrix();
  }

  void drawStructure(int visualizationMode, int subdivisions) {
    switch(visualizationMode) {
    case 0: 
      drawCubesRGB(0, 0, 0, dimension, subdivisions);    
      break;
    case 1: 
      drawMetaballs(0, 0, 0, dimension, subdivisions);  
      break;
    case 2: 
      drawVertBarsHue(0, 0, 0, dimension, subdivisions);  
      break;
    case 3: 
      drawHorzBarsHue(0, 0, 0, dimension, subdivisions);  
      break;
    }
  }

  public void setVisMode(int _visMode) {
    visMode = _visMode;
  }

  void rotateMatrix(float _xRot, float _yRot) {
    xRotBuffer = _xRot;
    yRotBuffer = _yRot;
  }

  void updateRotation() {
    if (xRotBuffer !=0) {
      yRot -= xRotBuffer;
      xRotBuffer = xRotBuffer/1.1;
    }
    if (yRotBuffer !=0) {
      xRot += yRotBuffer;
      yRotBuffer = yRotBuffer/1.1;
    }
    rotateX(xRot);
    rotateY(yRot);
  }
}

void drawPanels(int size) {    
  rectMode(CENTER);
  smartStroke(100);
  noFill();  

  smartFill(220);  
  //smartFillAlpha(0, 20);
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

