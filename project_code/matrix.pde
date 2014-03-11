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
      drawElementsRemap(0, 0, 0, dimension, subdivisions);    
      isColorSpaceRGB = true;  
      break;
    case 1: 
      drawMetaballs(0, 0, 0, dimension, subdivisions);  
      isColorSpaceRGB = true;  
      break;
    case 2: 
      drawCubesHue(0, 0, 0, dimension, subdivisions);  
      isColorSpaceRGB = false;  
      break;
    case 3: 
      drawVertBarsHue(0, 0, 0, dimension, subdivisions);  
      isColorSpaceRGB = false;  
      break;
    case 4: 
      //drawHorzBarsHue(0, 0, 0, dimension, subdivisions);  
      isColorSpaceRGB = false;  
      break;
    }
  }

  public void setVisMode(int _visMode) {
    visMode = _visMode;
  }
}

