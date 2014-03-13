class Matrix {
  float xPos, yPos;
  int dimension;
  int visMode = 0;  

  float timeX = -PI/3;
  float timeY = -PI/8;

  Matrix(float _xPos, float _yPos, int _dimension, int _visMode) {
    xPos = _xPos;
    yPos = _yPos;
    dimension = _dimension;
    visMode = _visMode;
    initMetaballs(dimension, subdivisions);
  }

  void display() {
    pushMatrix();
    translate(xPos, yPos);

    rotateX(timeY);
    rotateY(timeX);

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
}

void drawPanels(int size) {    
  rectMode(CENTER);
  smartStroke(100);
  noFill();  

  smartFill(220);  
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

