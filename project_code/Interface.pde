public void ChangeVisualization(int theValue) {
  if (visMode < 1) {
    visMode = 1;
    count = 48;
  } 
  else {
    visMode = 0;
    count = 12;
  }  
  start();
}

public void ChangeImage(int theValue) {
  if (currentImg < 3) {
    currentImg += 1;
  } 
  else {
    currentImg = 0;
  }
  start();
}


