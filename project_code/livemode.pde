class LiveCanvas {
  PGraphics canvas;
  float xPos, yPos;
  int canvasSize;

  LiveCanvas(float _xPos, float _yPos, int _canvasSize) {
    xPos = _xPos;
    yPos = _yPos;
    canvasSize = _canvasSize;  
    canvas = createGraphics(canvasSize, canvasSize);
    canvas.beginDraw();
    canvas.background(255);
    canvas.endDraw();
  }

  void display() {
    float tpmouseX = pmouseX - xPos/2;
    float tpmouseY = pmouseY - yPos/2;
    float tmouseX = mouseX - xPos/2;
    float tmouseY = mouseY - yPos/2;

    canvas.beginDraw();

    canvas.stroke(255, 0, 0, 120);
    canvas.strokeWeight(3);

    if (mousePressed && isInside(tmouseX, tmouseY) ) {
      if ((tmouseX != tpmouseX) || (tmouseY != tpmouseY))
        canvas.line(tpmouseX, tpmouseY, tmouseX, tmouseY);      
    }
    canvas.endDraw();

    canvas.save("canvas.jpg");
    PImage temp = loadImage("canvas.jpg");
        
    picture.setImage(temp);
  }

  // manually copy pixels to image, doesn't work
  PImage getCanvas() {
    PImage temp = new PImage(canvasSize, canvasSize);
    canvas.beginDraw();
    for (int i =0; i < canvasSize; i++) {
      for (int j =0; j < canvasSize; j++) {
        temp.set(i, j, canvas.get(i, j));
      }
      canvas.endDraw();
    }
    return temp;
  }

  boolean isInside(float _x, float _y) {
    if (mouseX < (xPos + canvasSize/2) && mouseX > (xPos - canvasSize/2) && mouseY > (yPos - canvasSize/2) && mouseY < (yPos + canvasSize/2)) return true;
    else return false;
  }
}

