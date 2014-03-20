class LiveCanvas {
  PGraphics canvas;
  float xPos, yPos;
  int canvasSize;
  color brushColor;

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
    canvas.stroke(brushColor);
    canvas.strokeWeight(brushSize);

    if (mousePressed && isInside(tmouseX, tmouseY) ) {
      if ((tmouseX != tpmouseX) || (tmouseY != tpmouseY))
        canvas.line(tpmouseX, tpmouseY, tmouseX, tmouseY);
    }
    canvas.endDraw();

    canvas.save("canvas.jpg");
    PImage temp = loadImage("canvas.jpg");

    picture.setImage(temp);

    fill(brushColor);
    rect(width/2  - width/4 - canvasSize/2 + btnSize/4, height/2 + canvasSize/2 + margin + btnSize/4, btnSize/2, btnSize/2);

    colorSelector();
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

  void colorSelector() {
    int selectorSize = 48 * guiScale;
    stroke(1, 26, 38);
    rect(xPos, yPos - canvasSize/2 - margin - selectorSize/2, canvasSize, selectorSize);
    colorMode(HSB, canvasSize, 48, 100);
    float ccX = xPos - canvasSize/2;
    float ccY = yPos - canvasSize/2 - margin - selectorSize;
    for (int i=0; i< canvasSize; i++) {
      for (int j=0; j<48; j++) {
        stroke(i, j, 100);
        point(ccX + i, ccY + j);
      }
    }

    if (mousePressed && (mouseButton == RIGHT)) {
      brushColor = get(mouseX, mouseY);
    }
  }
}

